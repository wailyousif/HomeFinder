package com.ironyard.data;

import javax.persistence.*;
import java.util.Date;

/**
 * Created by wailm.yousif on 3/28/17.
 */

@Entity
public class UpdatedProperty
{
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "global_seq")
    @SequenceGenerator(name="global_seq", sequenceName = "global_seq", allocationSize = 100, initialValue = 100)
    private long id;

    @OneToOne
    private Property property;
    private Date updateTime;

    public UpdatedProperty() { }

    public UpdatedProperty(Property property, Date updateTime) {
        this.property = property;
        this.updateTime = updateTime;
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

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }
}
