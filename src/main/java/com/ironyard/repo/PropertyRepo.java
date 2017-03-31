package com.ironyard.repo;

import com.ironyard.data.AppUser;
import com.ironyard.data.Property;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.repository.query.Param;

import java.util.Date;

/**
 * Created by wailm.yousif on 3/5/17.
 */
public interface PropertyRepo extends PagingAndSortingRepository<Property, Long> {

    public Property findByPropertyNameAndAppUser(String propertyName, AppUser appUser);

    public Iterable<Property> findByAppUser(AppUser appUser);

    @Query(value = "SELECT p FROM Property p where " +
            "(p.location.lng-:posX)*(p.location.lng-:posX) + " +
            "(p.location.lat-:posY)*(p.location.lat-:posY) <= " +
            ":radius*:radius/(69.047*69.047)")
    public Iterable<Property> findWithinRadius(@Param("radius") double radius,
                                               @Param("posX") double posX,
                                               @Param("posY") double posY);


    @Query(value = "SELECT p FROM Property p where " +
            "p.location.lat between :southBound and :northBound and " +
            "p.location.lng between :westBound and :eastBound")
    public Iterable<Property> findWithinBounds(
            @Param("northBound") double northBound,
            @Param("eastBound") double eastBound,
            @Param("southBound") double southBound,
            @Param("westBound") double westBound
            );



    @Query(value = "SELECT p.* FROM Property p, Location l where p.location_id = l.id and " +
            "l.lat between :southBound and :northBound and l.lng between :westBound and :eastBound and " +
            "p.available = true and " +
            "p.property_type & :propType != 0 and NOT EXISTS (" +
            "   select 'X' from Property_Hist h where " +
            "   (:fDate between h.checkin_date and (h.checkout_date - interval '1 day')) or " +
            "   (:tDate between h.checkin_date and (h.checkout_date - interval '1 day'))" +
            ") and " +
            " p.rent_price between :minRent and :maxRent and " +
            " p.selling_price between :minBuy and :maxBuy and " +
            " p.rooms between :iMinRooms and :iMaxRooms and " +
            " p.baths between :iMinBaths and :iMaxBaths and " +
            " (case :ckbParking when false then p.parking else true end) = p.parking and " +
            " (case :ckbGarage when false then p.garage else true end) = p.garage and " +
            " (case :ckbWasher when false then p.washer else true end) = p.washer and " +
            " (case :ckbAC when false then p.ac else true end) = p.ac and " +
            " (case :ckbGym when false then p.gym else true end) = p.gym and " +
            " p.update_time >= :afterDate and " +
            " p.id between :fromId and :toId " +
            " order by (abs(l.lat - (:northBound+:southBound)/2) + abs(l.lng - (:eastBound+:westBound)/2)) "
            , nativeQuery = true)
    public Iterable<Property> findWithinBounds2(
            @Param("northBound") double northBound,
            @Param("eastBound") double eastBound,
            @Param("southBound") double southBound,
            @Param("westBound") double westBound,
            @Param("propType") int propType,
            @Param("fDate") Date fDate,
            @Param("tDate") Date tDate,
            @Param("minRent") Double minRent,
            @Param("maxRent") Double maxRent,
            @Param("minBuy") Double minBuy,
            @Param("maxBuy") Double maxBuy,
            @Param("iMinRooms") Integer iMinRooms,
            @Param("iMaxRooms") Integer iMaxRooms,
            @Param("iMinBaths") Integer iMinBaths,
            @Param("iMaxBaths") Integer iMaxBaths,
            @Param("ckbParking") Boolean ckbParking,
            @Param("ckbGarage") Boolean ckbGarage,
            @Param("ckbWasher") Boolean ckbWasher,
            @Param("ckbAC") Boolean ckbAC,
            @Param("ckbGym") Boolean ckbGym,
            @Param("afterDate") Date afterDate,
            @Param("fromId") Long fromId,
            @Param("toId") Long toId
    );
}
