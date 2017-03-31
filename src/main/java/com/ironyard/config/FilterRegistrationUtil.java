package com.ironyard.config;

import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Created by wailm.yousif on 2/7/17.
 */
@Configuration
public class FilterRegistrationUtil {
    @Bean
    public FilterRegistrationBean mvcSecutiryFilter()
    {
        FilterRegistrationBean registration = new FilterRegistrationBean(new AuthFilter());

        //registration.addUrlPatterns("/*");

        registration.addUrlPatterns("/mvc/prop/add");
        registration.addUrlPatterns("/mvc/prop/edit");

        registration.addUrlPatterns("/mvc/user/edit");

        registration.addUrlPatterns("/rest/prop/add");
        registration.addUrlPatterns("/rest/prop/list");
        //registration.addUrlPatterns("/rest/prop/fetch");
        registration.addUrlPatterns("/rest/prop/delete");
        registration.addUrlPatterns("/rest/prop/edit");
        registration.addUrlPatterns("/rest/prop/savesearch");

        registration.addUrlPatterns("/rest/user/fetch");
        registration.addUrlPatterns("/rest/user/edit");

        return registration;
    }
}