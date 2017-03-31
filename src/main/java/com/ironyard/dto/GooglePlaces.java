package com.ironyard.dto;

import java.util.List;

/**
 * Created by wailm.yousif on 3/13/17.
 */

public class GooglePlaces
{
    String status;
    List<GooglePlacesResult> results;

    String placesType;

    public GooglePlaces() { }

    public GooglePlaces(String status, List<GooglePlacesResult> results) {
        this.status = status;
        this.results = results;
    }

    public GooglePlaces(String status, List<GooglePlacesResult> results, String placesType) {
        this.status = status;
        this.results = results;
        this.placesType = placesType;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public List<GooglePlacesResult> getResults() {
        return results;
    }

    public void setResults(List<GooglePlacesResult> results) {
        this.results = results;
    }

    public String getPlacesType() {
        return placesType;
    }

    public void setPlacesType(String placesType) {
        this.placesType = placesType;
    }
}
