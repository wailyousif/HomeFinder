package com.ironyard.dto;

import java.util.List;

/**
 * Created by wailm.yousif on 3/14/17.
 */
public class GooglePlacesResult
{
    GooglePlacesResultGeometry geometry;
    String icon;
    String name;
    double rating;
    List<String> types;

    public GooglePlacesResult() { }

    /*
    public GooglePlacesResult(GooglePlacesResultGeometry geometry, String icon, String name, double rating) {
        this.geometry = geometry;
        this.icon = icon;
        this.name = name;
        this.rating = rating;
    }
    */

    public GooglePlacesResult(GooglePlacesResultGeometry geometry, String icon, String name, double rating, List<String> types) {
        this.geometry = geometry;
        this.icon = icon;
        this.name = name;
        this.rating = rating;
        this.types = types;
    }

    public GooglePlacesResultGeometry getGeometry() {
        return geometry;
    }

    public void setGeometry(GooglePlacesResultGeometry geometry) {
        this.geometry = geometry;
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }

    public List<String> getTypes() {
        return types;
    }

    public void setTypes(List<String> types) {
        this.types = types;
    }
}
