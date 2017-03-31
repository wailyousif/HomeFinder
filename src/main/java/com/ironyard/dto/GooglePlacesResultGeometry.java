package com.ironyard.dto;

import com.ironyard.data.Location;

/**
 * Created by wailm.yousif on 3/14/17.
 */
public class GooglePlacesResultGeometry
{
    Location location;

    public GooglePlacesResultGeometry() { }

    public GooglePlacesResultGeometry(Location location) {
        this.location = location;
    }

    public Location getLocation() {
        return location;
    }

    public void setLocation(Location location) {
        this.location = location;
    }
}
