package com.ironyard.data;

import com.ironyard.dto.GooglePlaces;

import javax.persistence.*;
import java.util.Date;
import java.util.List;

/**
 * Created by wailm.yousif on 3/5/17.
 */

@Entity
public class Property
{
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "global_seq")
    @SequenceGenerator(name="global_seq", sequenceName = "global_seq", allocationSize = 100, initialValue = 100)
    private long id;

    @OneToOne(cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    private Location location;

    private String propertyName;

    @OneToOne(cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    private Address address;

    private String pic;
    private int storeys;
    private double rentPrice;
    private double sellingPrice;
    private int propertyType;
    private boolean available;
    private Date availableBy;
    private int rooms;
    private int baths;
    private boolean parking;
    private boolean garage;
    private boolean washer;
    private boolean ac;
    private boolean gym;
    private Date creationTime;
    private Date updateTime;

    @Transient
    private List<GooglePlaces> placesList;

    @ManyToOne
    private AppUser appUser;

    public Property() { }

    public Property(Location location, String propertyName, Address address, String pic, int storeys, double rentPrice, double sellingPrice, int propertyType, boolean available, Date availableBy, int rooms, int baths, boolean parking, boolean garage, boolean washer, boolean ac, boolean gym, Date creationTime, Date updateTime, AppUser appUser) {
        this.location = location;
        this.propertyName = propertyName;
        this.address = address;
        this.pic = pic;
        this.storeys = storeys;
        this.rentPrice = rentPrice;
        this.sellingPrice = sellingPrice;
        this.propertyType = propertyType;
        this.available = available;
        this.availableBy = availableBy;
        this.rooms = rooms;
        this.baths = baths;
        this.parking = parking;
        this.garage = garage;
        this.washer = washer;
        this.ac = ac;
        this.gym = gym;
        this.creationTime = creationTime;
        this.updateTime = updateTime;
        this.appUser = appUser;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public Location getLocation() {
        return location;
    }

    public void setLocation(Location location) {
        this.location = location;
    }

    public String getPropertyName() {
        return propertyName;
    }

    public void setPropertyName(String propertyName) {
        this.propertyName = propertyName;
    }

    public Address getAddress() {
        return address;
    }

    public void setAddress(Address address) {
        this.address = address;
    }

    public int getStoreys() {
        return storeys;
    }

    public void setStoreys(int storeys) {
        this.storeys = storeys;
    }

    public double getRentPrice() {
        return rentPrice;
    }

    public void setRentPrice(double rentPrice) {
        this.rentPrice = rentPrice;
    }

    public double getSellingPrice() {
        return sellingPrice;
    }

    public void setSellingPrice(double sellingPrice) {
        this.sellingPrice = sellingPrice;
    }

    public AppUser getAppUser() {
        return appUser;
    }

    public void setAppUser(AppUser appUser) {
        this.appUser = appUser;
    }

    public int getPropertyType() {
        return propertyType;
    }

    public void setPropertyType(int propertyType) {
        this.propertyType = propertyType;
    }

    public String getPic() {
        return pic;
    }

    public void setPic(String pic) {
        this.pic = pic;
    }

    public boolean isAvailable() {
        return available;
    }

    public void setAvailable(boolean available) {
        this.available = available;
    }

    public Date getAvailableBy() {
        return availableBy;
    }

    public void setAvailableBy(Date availableBy) {
        this.availableBy = availableBy;
    }

    public int getRooms() {
        return rooms;
    }

    public void setRooms(int rooms) {
        this.rooms = rooms;
    }

    public int getBaths() {
        return baths;
    }

    public void setBaths(int baths) {
        this.baths = baths;
    }

    public boolean isParking() {
        return parking;
    }

    public void setParking(boolean parking) {
        this.parking = parking;
    }

    public boolean isGarage() {
        return garage;
    }

    public void setGarage(boolean garage) {
        this.garage = garage;
    }

    public boolean isGym() {
        return gym;
    }

    public void setGym(boolean gym) {
        this.gym = gym;
    }

    public boolean isWasher() {
        return washer;
    }

    public void setWasher(boolean washer) {
        this.washer = washer;
    }

    public boolean isAc() {
        return ac;
    }

    public void setAc(boolean ac) {
        this.ac = ac;
    }

    public List<GooglePlaces> getPlacesList() {
        return placesList;
    }

    public void setPlacesList(List<GooglePlaces> placesList) {
        this.placesList = placesList;
    }

    public Date getCreationTime() {
        return creationTime;
    }

    public void setCreationTime(Date creationTime) {
        this.creationTime = creationTime;
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }
}
