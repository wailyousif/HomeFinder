package com.ironyard.data;

import javax.persistence.*;
import java.util.Date;

/**
 * Created by wailm.yousif on 3/18/17.
 */

@Entity
public class PropertyHist
{
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "global_seq")
    @SequenceGenerator(name="global_seq", sequenceName = "global_seq", allocationSize = 100, initialValue = 100)
    private long id;

    @ManyToOne
    Property property;

    @ManyToOne
    AppUser owner;

    private String actionType;  //Rent, Buy, etc.

    @ManyToOne
    private Finder finder;

    private Date actionTime;
    private Date checkinDate;
    private Date checkoutDate;
    private double price;

    public PropertyHist() { }

    public PropertyHist(Property property, AppUser owner, String actionType, Finder finder, Date actionTime, Date checkinDate, Date checkoutDate, double price) {
        this.property = property;
        this.owner = owner;
        this.actionType = actionType;
        this.finder = finder;
        this.actionTime = actionTime;
        this.checkinDate = checkinDate;
        this.checkoutDate = checkoutDate;
        this.price = price;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public Property getProperty() {
        return property;
    }

    public void setProperty(Property property) {
        this.property = property;
    }

    public AppUser getOwner() {
        return owner;
    }

    public void setOwner(AppUser owner) {
        this.owner = owner;
    }

    public String getActionType() {
        return actionType;
    }

    public void setActionType(String actionType) {
        this.actionType = actionType;
    }

    public Finder getFinder() {
        return finder;
    }

    public void setFinder(Finder finder) {
        this.finder = finder;
    }

    public Date getActionTime() {
        return actionTime;
    }

    public void setActionTime(Date actionTime) {
        this.actionTime = actionTime;
    }

    public Date getCheckinDate() {
        return checkinDate;
    }

    public void setCheckinDate(Date checkinDate) {
        this.checkinDate = checkinDate;
    }

    public Date getCheckoutDate() {
        return checkoutDate;
    }

    public void setCheckoutDate(Date checkoutDate) {
        this.checkoutDate = checkoutDate;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }
}
