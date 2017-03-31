package com.ironyard.controller.mvc;

import com.ironyard.data.AppUser;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;

/**
 * Created by wailm.yousif on 3/5/17.
 */

@Controller
public class NavigationController
{
    private static final String homePage = "/finder";
    private static final String finderPage = "/finder.jsp";
    private static final String addPropPage = "/addprop.jsp";
    private static final String editPropPage = "/editprop.jsp";
    private static final String loginPage = "/login.jsp";
    private static final String signUpPage = "/signup.jsp";
    private static final String editUserPage = "/edituser.jsp";
    private static final String licenseTermsPage = "/license.jsp";


    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String root()
    {
        return homePage;
    }


    @RequestMapping(value = "/mvc/prop/find", method = RequestMethod.GET)
    public String showFindPropertyPage()
    {
        return "redirect:" + finderPage;
    }


    @RequestMapping(value = "/mvc/prop/add", method = RequestMethod.GET)
    public String showAddPropertyPage(HttpServletRequest request)
    {
        return "redirect:" + addPropPage;
    }


    @RequestMapping(value = "/mvc/prop/edit", method = RequestMethod.GET)
    public String showEditPropertyPage(HttpServletRequest request)
    {
        return "redirect:" + editPropPage;
    }


    @RequestMapping(value = "/mvc/user/login", method = RequestMethod.GET)
    public String showLoginPage(HttpServletRequest request)
    {
        return "redirect:" + loginPage;
    }


    @RequestMapping(value = "/mvc/user/add", method = RequestMethod.GET)
    public String showAddUserPage()
    {
        return "redirect:" + signUpPage;
    }

    @RequestMapping(value = "/mvc/user/edit", method = RequestMethod.GET)
    public String showEditUserPage()
    {
        return "redirect:" + editUserPage;
    }


    @RequestMapping(value = "/mvc/license/terms", method = RequestMethod.GET)
    public String showLicenseTermsPage()
    {
        System.out.println("Showing license terms");
        return "forward:" + licenseTermsPage;
    }


    @RequestMapping(value = "/mvc/user/emailunsub", method = RequestMethod.GET)
    public String emailUnsub(HttpServletRequest request, Long id)
    {
        AppUser appUser = (AppUser)(request.getSession().getAttribute("appUser"));
        if (appUser == null)
            return "redirect:" + loginPage + "?pp=3&emailunsub=" + id.toString();
        else
            return "redirect:" + finderPage + "?emailunsub=" + id.toString();
    }


    @RequestMapping(value = "/mvc/user/logout", method = RequestMethod.GET)
    public String logout(HttpServletRequest request)
    {
        request.getSession().invalidate();
        return "redirect:" + finderPage;
    }
}
