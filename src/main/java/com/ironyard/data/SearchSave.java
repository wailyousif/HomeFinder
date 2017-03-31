package com.ironyard.data;

import javax.persistence.*;
import java.util.Date;

/**
 * Created by wailm.yousif on 3/28/17.
 */

@Entity
public class SearchSave
{
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "global_seq")
    @SequenceGenerator(name="global_seq", sequenceName = "global_seq", allocationSize = 100, initialValue = 100)
    private long id;

    private double northBound;
    private double eastBound;
    private double southBound;
    private double westBound;
    private String customerScope;
    private Integer propType;
    private String fromDate;
    private String toDate;
    private Integer txtMinPrice;
    private Integer txtMaxPrice;
    private String minRooms;
    private String maxRooms;
    private String minBaths;
    private String maxBaths;
    private Integer txtConvenienceStore;
    private Integer txtBakery;
    private Integer txtLaundry;
    private Integer txtRestaurant;
    private Integer txtPharmacy;
    private Integer txtTrainStation;
    private Integer txtBusStation;
    private Boolean ckbParking;
    private Boolean ckbGarage;
    private Boolean ckbWasher;
    private Boolean ckbAC;
    private Boolean ckbGym;
    private Date saveTime;

    @ManyToOne
    private AppUser appUser;

    public SearchSave() { }

    public SearchSave(double northBound, double eastBound, double southBound, double westBound, String customerScope, Integer propType, String fromDate, String toDate, Integer txtMinPrice, Integer txtMaxPrice, String minRooms, String maxRooms, String minBaths, String maxBaths, Integer txtConvenienceStore, Integer txtBakery, Integer txtLaundry, Integer txtRestaurant, Integer txtPharmacy, Integer txtTrainStation, Integer txtBusStation, Boolean ckbParking, Boolean ckbGarage, Boolean ckbWasher, Boolean ckbAC, Boolean ckbGym, Date saveTime, AppUser appUser) {
        this.northBound = northBound;
        this.eastBound = eastBound;
        this.southBound = southBound;
        this.westBound = westBound;
        this.customerScope = customerScope;
        this.propType = propType;
        this.fromDate = fromDate;
        this.toDate = toDate;
        this.txtMinPrice = txtMinPrice;
        this.txtMaxPrice = txtMaxPrice;
        this.minRooms = minRooms;
        this.maxRooms = maxRooms;
        this.minBaths = minBaths;
        this.maxBaths = maxBaths;
        this.txtConvenienceStore = txtConvenienceStore;
        this.txtBakery = txtBakery;
        this.txtLaundry = txtLaundry;
        this.txtRestaurant = txtRestaurant;
        this.txtPharmacy = txtPharmacy;
        this.txtTrainStation = txtTrainStation;
        this.txtBusStation = txtBusStation;
        this.ckbParking = ckbParking;
        this.ckbGarage = ckbGarage;
        this.ckbWasher = ckbWasher;
        this.ckbAC = ckbAC;
        this.ckbGym = ckbGym;
        this.saveTime = saveTime;
        this.appUser = appUser;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public double getNorthBound() {
        return northBound;
    }

    public void setNorthBound(double northBound) {
        this.northBound = northBound;
    }

    public double getEastBound() {
        return eastBound;
    }

    public void setEastBound(double eastBound) {
        this.eastBound = eastBound;
    }

    public double getSouthBound() {
        return southBound;
    }

    public void setSouthBound(double southBound) {
        this.southBound = southBound;
    }

    public double getWestBound() {
        return westBound;
    }

    public void setWestBound(double westBound) {
        this.westBound = westBound;
    }

    public String getCustomerScope() {
        return customerScope;
    }

    public void setCustomerScope(String customerScope) {
        this.customerScope = customerScope;
    }

    public Integer getPropType() {
        return propType;
    }

    public void setPropType(Integer propType) {
        this.propType = propType;
    }

    public String getFromDate() {
        return fromDate;
    }

    public void setFromDate(String fromDate) {
        this.fromDate = fromDate;
    }

    public String getToDate() {
        return toDate;
    }

    public void setToDate(String toDate) {
        this.toDate = toDate;
    }

    public Integer getTxtMinPrice() {
        return txtMinPrice;
    }

    public void setTxtMinPrice(Integer txtMinPrice) {
        this.txtMinPrice = txtMinPrice;
    }

    public Integer getTxtMaxPrice() {
        return txtMaxPrice;
    }

    public void setTxtMaxPrice(Integer txtMaxPrice) {
        this.txtMaxPrice = txtMaxPrice;
    }

    public String getMinRooms() {
        return minRooms;
    }

    public void setMinRooms(String minRooms) {
        this.minRooms = minRooms;
    }

    public String getMaxRooms() {
        return maxRooms;
    }

    public void setMaxRooms(String maxRooms) {
        this.maxRooms = maxRooms;
    }

    public String getMinBaths() {
        return minBaths;
    }

    public void setMinBaths(String minBaths) {
        this.minBaths = minBaths;
    }

    public String getMaxBaths() {
        return maxBaths;
    }

    public void setMaxBaths(String maxBaths) {
        this.maxBaths = maxBaths;
    }

    public Integer getTxtConvenienceStore() {
        return txtConvenienceStore;
    }

    public void setTxtConvenienceStore(Integer txtConvenienceStore) {
        this.txtConvenienceStore = txtConvenienceStore;
    }

    public Integer getTxtBakery() {
        return txtBakery;
    }

    public void setTxtBakery(Integer txtBakery) {
        this.txtBakery = txtBakery;
    }

    public Integer getTxtLaundry() {
        return txtLaundry;
    }

    public void setTxtLaundry(Integer txtLaundry) {
        this.txtLaundry = txtLaundry;
    }

    public Integer getTxtRestaurant() {
        return txtRestaurant;
    }

    public void setTxtRestaurant(Integer txtRestaurant) {
        this.txtRestaurant = txtRestaurant;
    }

    public Integer getTxtPharmacy() {
        return txtPharmacy;
    }

    public void setTxtPharmacy(Integer txtPharmacy) {
        this.txtPharmacy = txtPharmacy;
    }

    public Integer getTxtTrainStation() {
        return txtTrainStation;
    }

    public void setTxtTrainStation(Integer txtTrainStation) {
        this.txtTrainStation = txtTrainStation;
    }

    public Integer getTxtBusStation() {
        return txtBusStation;
    }

    public void setTxtBusStation(Integer txtBusStation) {
        this.txtBusStation = txtBusStation;
    }

    public Boolean getCkbParking() {
        return ckbParking;
    }

    public void setCkbParking(Boolean ckbParking) {
        this.ckbParking = ckbParking;
    }

    public Boolean getCkbGarage() {
        return ckbGarage;
    }

    public void setCkbGarage(Boolean ckbGarage) {
        this.ckbGarage = ckbGarage;
    }

    public Boolean getCkbWasher() {
        return ckbWasher;
    }

    public void setCkbWasher(Boolean ckbWasher) {
        this.ckbWasher = ckbWasher;
    }

    public Boolean getCkbAC() {
        return ckbAC;
    }

    public void setCkbAC(Boolean ckbAC) {
        this.ckbAC = ckbAC;
    }

    public Boolean getCkbGym() {
        return ckbGym;
    }

    public void setCkbGym(Boolean ckbGym) {
        this.ckbGym = ckbGym;
    }

    public Date getSaveTime() {
        return saveTime;
    }

    public void setSaveTime(Date saveTime) {
        this.saveTime = saveTime;
    }

    public AppUser getAppUser() {
        return appUser;
    }

    public void setAppUser(AppUser appUser) {
        this.appUser = appUser;
    }
}
