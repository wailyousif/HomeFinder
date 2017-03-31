package com.ironyard.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;

/**
 * Created by wailm.yousif on 3/24/17.
 */

@Configuration
public class ResourcesConfigurator extends WebMvcConfigurerAdapter
{
    @Value("${upload.location}")
    private String uploadLocation;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry)
    {
        registry.addResourceHandler("/uploadLoc/**").addResourceLocations("file:" + uploadLocation);
    }
}
