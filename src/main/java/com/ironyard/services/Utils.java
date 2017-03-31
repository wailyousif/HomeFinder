package com.ironyard.services;

import javax.servlet.http.HttpServletRequest;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Created by wailm.yousif on 3/5/17.
 */
public class Utils
{
    public static final String propertyOwnerCode = "O";
    public static final String propertySeekerCode = "S";

    public static final String emptyString = "";
    public static final Double maxPropertyValue = 999999999999999.99;

    public static final String convenienceStore = "convenience_store";
    public static final String bakery = "bakery";
    public static final String laundry = "laundry";
    public static final String restaurant = "restaurant";
    public static final String pharmacy = "pharmacy";
    public static final String trainStation = "train_station";
    public static final String busStation = "bus_station";
    public static final String googlePlacesApiOkResponse = "OK";

    public static final String propAddPath = "/mvc/prop/add";
    public static final String propEditPath = "/mvc/prop/edit";



    public static DateFormat df = new SimpleDateFormat("MM/dd/yyyy");


    public static boolean isBrowser(HttpServletRequest request)
    {
        String userAgent = request.getHeader("User-Agent");
        if (userAgent.contains("MSIE") || userAgent.contains("Firefox") || userAgent.contains("Chrome") ||
                userAgent.contains("Opera") || userAgent.contains("Safari"))
        {
            return true;
        }
        return false;
    }


    public static String ConvertEpochToDateString(Long epochTime)
    {
        Date currentTime = new Date(epochTime * 1000);
        return currentTime.toString();
    }

    public static String ConvertToWeekDay(Long epochTime)
    {
        Date currentTime = new Date(epochTime * 1000);
        DateFormat dateFormat = new SimpleDateFormat("EEEE");
        String weekDay = dateFormat.format(currentTime);
        return weekDay;
    }
}
