package com.ironyard.config;

import com.ironyard.data.AppUser;
import com.ironyard.security.TokenMaster;
import com.ironyard.services.Utils;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Created by wailm.yousif on 2/7/17.
 */
@WebFilter(filterName = "AuthFilter")
public class AuthFilter implements Filter
{
    public void destroy() {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws ServletException, IOException
    {
        HttpServletRequest req = ((HttpServletRequest) request);
        HttpServletResponse resp = ((HttpServletResponse) response);

        System.out.println("Passed through the config for URL=" +
            req.getRequestURI());

        AppUser appUser = (AppUser) req.getSession().getAttribute("appUser");
        boolean loggedIn = (appUser != null);

        boolean restAuthorized = false;
        Long userId = 0L;
        if (!loggedIn)              //if Not logged in, check REST authorization key
        {
            String xAuthKey = req.getHeader("x-authorization-key");
            if (xAuthKey != null)
            {
                TokenMaster tm = new TokenMaster();
                userId = tm.validateTokenAndGetUserId(xAuthKey);
                if (userId != null)
                {
                    restAuthorized = true;
                    /*
                    This will be used by REST method to fetch appUser and update token uses in DB
                     */
                    req.setAttribute("userId", userId);
                    req.setAttribute("tokenString", xAuthKey);
                }
            }
        }


        if (loggedIn || restAuthorized)
        {
            //System.out.println("Inside the filter before handling the request");

            //chain.doFilter(request, response);
            chain.doFilter(req, resp);

            //System.out.println("Inside the filter after handling the request");
        }
        else
        {
            if (Utils.isBrowser(req))
            {
                String reqURI = req.getRequestURI();
                int previousPageId = 0;

                if (reqURI.contains(Utils.propAddPath))
                    previousPageId = 1;
                else if (reqURI.contains(Utils.propEditPath))
                    previousPageId = 2;

                resp.sendRedirect("/login.jsp?pp=" + previousPageId);
            }
            else
            {
                resp.addHeader("x-invalid-auth", "1");
                resp.getWriter().write("Invalid Authorization.");
            }
        }
    }

    public void init(FilterConfig config) throws ServletException {

    }

}