package com.ironyard.api;

import com.ironyard.data.Location;
import com.ironyard.dto.GooglePlaces;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.web.client.RestTemplate;

/**
 * Created by wailm.yousif on 2/28/17.
 */


public class ApiHelper
{
    //private static final String KEY = "10c23bb63ff974a0ca00cf3db995e9f2";

    private static final String GOOGLE_PLACES_URL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?" +
            "location=%f,%f&radius=%d&types=%s&key=%s";

    private static final String GOOGLE_MAPS_KEY = "AIzaSyAuwBHyQj98YaM0fFhdlJma1Zp2XUayFRk";    //use property file

    private RestTemplate restTemplate;

    public ApiHelper()
    {
        restTemplate = new RestTemplate();
    }

    private HttpEntity getHeaders()
    {
        HttpHeaders headers = new HttpHeaders();
        headers.add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.99 Safari/537.36");
        HttpEntity headersEntity = new HttpEntity(headers);
        return headersEntity;
    }

    public GooglePlaces getGooglePlaces(Location location, Integer meters, String placeType)
    {
        String url = String.format(GOOGLE_PLACES_URL, location.getLat(), location.getLng(),
                meters, placeType, GOOGLE_MAPS_KEY);
        return (GooglePlaces) (restTemplate.exchange(url, HttpMethod.GET, getHeaders(), GooglePlaces.class)).getBody();
    }
}
