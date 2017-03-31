package com.ironyard.controller.rest;

import com.google.common.collect.Iterables;
import com.google.gson.Gson;
import com.ironyard.api.ApiHelper;
import com.ironyard.data.*;
import com.ironyard.dto.GooglePlaces;
import com.ironyard.dto.GooglePlacesResult;
import com.ironyard.dto.ResponseObject;
import com.ironyard.repo.*;
import com.ironyard.services.Utils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Created by wailm.yousif on 3/5/17.
 */

@RestController
@RequestMapping(path = "/rest/prop")
public class RestPropertiesController
{
    final static Logger logger = Logger.getLogger(RestPropertiesController.class);

    @Value("${upload.location}")
    private String uploadLocation;

    @Autowired
    private PropertyRepo propertyRepo;

    @Autowired
    private SearchSaveRepo searchSaveRepo;

    @Autowired
    AppUserRepo appUserRepo;

    @Autowired
    AuthTokenRepo authTokenRepo;

    @Autowired
    UpdatedPropertyRepo updatedPropertyRepo;


    private AppUser fetchAppUser(HttpServletRequest request)
    {
        AppUser appUser = (AppUser)(request.getSession().getAttribute("appUser"));
        if (appUser == null)
        {
            Long userId = (Long)(request.getAttribute("userId"));
            if (userId != null)
            {
                appUser = appUserRepo.findOne(userId);
                String tokenString = (String)(request.getAttribute("tokenString"));
                AuthToken authToken = authTokenRepo.findByTokenString(tokenString);
                authToken.setNumOfCalls(authToken.getNumOfCalls()+1);
                authTokenRepo.save(authToken);
            }
        }
        return appUser;
    }



    /**
     * Find properties within a rectangular geographical area.
     * @param northBound    The north latitude of the geographical area.
     * @param eastBound     The eastern longitude of the geographical area.
     * @param southBound    The southern latitude of the geographical area.
     * @param westBound     The western longitude of the geographical area.
     * @param customerScope     RENT or BUY value.
     * @param propType          1 for Studio, 2 for Apartment, 4 for House.
     * @param fromDate          Check-in date or purchase date in MM/DD/YYYY format.
     * @param toDate            Check-out date in MM/DD/YYYY format.
     * @param txtMinPrice       Positive Integer that represent the minimum price in US dollars.
     * @param txtMaxPrice       Positive Integer that represent the max affordable price in US dollars.
     * @param minRooms      String for minimum number of rooms. Possible values are '1', '2', '3', '4'.
     * @param maxRooms      String for max number of rooms. Possible values are '1', '2', '3', '4', '5+'.
     * @param minBaths      String for minimum number of baths. Possible values are '1', '2', '3'.
     * @param maxBaths      String for max number of baths. Possible values are '1', '2', '3', '4+'.
     * @param txtConvenienceStore   Positive Integer for max affordable distance in meters to Convenience Stores. Max value is 9999.
     * @param txtBakery     Positive Integer for max affordable distance in meters to Bakeries. Max value is 9999.
     * @param txtLaundry    Positive Integer for max affordable distance in meters to Laundries. Max value is 9999.
     * @param txtRestaurant     Positive Integer for max affordable distance in meters to Restaurants. Max value is 9999.
     * @param txtPharmacy   Positive Integer for max affordable distance in meters to Pharmacies. Max value is 9999.
     * @param txtTrainStation   Positive Integer for max affordable distance in meters to Train Stations. Max value is 9999.
     * @param txtBusStation     Positive Integer for max affordable distance in meters to Bus Stations. Max value is 9999.
     * @param ckbParking    Boolean value. True means Parking is required.
     * @param ckbGarage     Boolean value. True means Garage is required.
     * @param ckbWasher     Boolean value. True means Washer is required.
     * @param ckbAC     Boolean value. True means AC is required.
     * @param ckbGym    Boolean value. True means Gym is required.
     * @return  Response Object
     *          {
     *              Integer success         (1 for success, 0 for failure)
     *              Integer responseCode    (0 for successful response, Non-zero for error-codes)
     *              String responseString   (Json response in case of success, Error message in case of failure)
     *          }
     */
    /*
    @RequestMapping(path = "/find", method = RequestMethod.GET)
    public ResponseObject gfind(
            @RequestParam(value = "northBound", required = true) double northBound,
            @RequestParam(value = "eastBound", required = true) double eastBound,
            @RequestParam(value = "southBound", required = true) double southBound,
            @RequestParam(value = "westBound", required = true) double westBound,
            @RequestParam(value = "customerScope", required = true) String customerScope,
            @RequestParam(value = "propType", required = true) Integer propType,
            @RequestParam(value = "fromDate", required = false) String fromDate,
            @RequestParam(value = "toDate", required = false) String toDate,
            @RequestParam(value = "txtMinPrice", required = true) Integer txtMinPrice,
            @RequestParam(value = "txtMaxPrice", required = true) Integer txtMaxPrice,
            @RequestParam(value = "minRooms", required = true) String minRooms,
            @RequestParam(value = "maxRooms", required = true) String maxRooms,
            @RequestParam(value = "minBaths", required = true) String minBaths,
            @RequestParam(value = "maxBaths", required = true) String maxBaths,
            @RequestParam(value = "txtConvenienceStore", required = false) Integer txtConvenienceStore,
            @RequestParam(value = "txtBakery", required = false) Integer txtBakery,
            @RequestParam(value = "txtLaundry", required = false) Integer txtLaundry,
            @RequestParam(value = "txtRestaurant", required = false) Integer txtRestaurant,
            @RequestParam(value = "txtPharmacy", required = false) Integer txtPharmacy,
            @RequestParam(value = "txtTrainStation", required = false) Integer txtTrainStation,
            @RequestParam(value = "txtBusStation", required = false) Integer txtBusStation,
            @RequestParam(value = "ckbParking", required = true) Boolean ckbParking,
            @RequestParam(value = "ckbGarage", required = true) Boolean ckbGarage,
            @RequestParam(value = "ckbWasher", required = true) Boolean ckbWasher,
            @RequestParam(value = "ckbAC", required = true) Boolean ckbAC,
            @RequestParam(value = "ckbGym", required = true) Boolean ckbGym,
            @RequestParam(value = "afterDate", required = false) String afterDate,
            @RequestParam(value = "fromId", required = false) Long fromId,
            @RequestParam(value = "toId", required = false) Long toId
    )
    {
        ResponseObject responseObject = find(
                northBound, eastBound, southBound, westBound,
                customerScope, propType, fromDate, toDate,
                txtMinPrice, txtMaxPrice,
                minRooms, maxRooms, minBaths, maxBaths,
                txtConvenienceStore, txtBakery, txtLaundry, txtRestaurant, txtPharmacy, txtTrainStation, txtBusStation,
                ckbParking, ckbGarage, ckbWasher, ckbAC, ckbGym,
                afterDate, fromId, toId);

        return  responseObject;
    }
    */


    /**
     * Find properties within a rectangular geographical area.
     * @param northBound    The north latitude of the geographical area.
     * @param eastBound     The eastern longitude of the geographical area.
     * @param southBound    The southern latitude of the geographical area.
     * @param westBound     The western longitude of the geographical area.
     * @param customerScope     RENT or BUY value.
     * @param propType          1 for Studio, 2 for Apartment, 4 for House.
     * @param fromDate          Check-in date or purchase date in MM/DD/YYYY format.
     * @param toDate            Check-out date in MM/DD/YYYY format.
     * @param txtMinPrice       Positive Integer that represent the minimum price in US dollars.
     * @param txtMaxPrice       Positive Integer that represent the max affordable price in US dollars.
     * @param minRooms      String for minimum number of rooms. Possible values are '1', '2', '3', '4'.
     * @param maxRooms      String for max number of rooms. Possible values are '1', '2', '3', '4', '5+'.
     * @param minBaths      String for minimum number of baths. Possible values are '1', '2', '3'.
     * @param maxBaths      String for max number of baths. Possible values are '1', '2', '3', '4+'.
     * @param txtConvenienceStore   Positive Integer for max affordable distance in meters to Convenience Stores. Max value is 9999.
     * @param txtBakery     Positive Integer for max affordable distance in meters to Bakeries. Max value is 9999.
     * @param txtLaundry    Positive Integer for max affordable distance in meters to Laundries. Max value is 9999.
     * @param txtRestaurant     Positive Integer for max affordable distance in meters to Restaurants. Max value is 9999.
     * @param txtPharmacy   Positive Integer for max affordable distance in meters to Pharmacies. Max value is 9999.
     * @param txtTrainStation   Positive Integer for max affordable distance in meters to Train Stations. Max value is 9999.
     * @param txtBusStation     Positive Integer for max affordable distance in meters to Bus Stations. Max value is 9999.
     * @param ckbParking    Boolean value. True means Parking is required.
     * @param ckbGarage     Boolean value. True means Garage is required.
     * @param ckbWasher     Boolean value. True means Washer is required.
     * @param ckbAC     Boolean value. True means AC is required.
     * @param ckbGym    Boolean value. True means Gym is required.
     * @param afterDate get properties that are created or updated after a certain date
     * @param fromId    limit the search for properties whose IDs >= fromId
     * @param toId  limit the search for properties whose IDs <= toId. Make fromId = toId to check if a certain property matches other conditions
     * @return  Response Object
     *          {
     *              Integer success         (1 for success, 0 for failure)
     *              Integer responseCode    (0 for successful response, Non-zero for error-codes)
     *              String responseString   (Json response in case of success, Error message in case of failure)
     *          }
     */
    @RequestMapping(path = "/find", method = RequestMethod.POST)
    public ResponseObject find(
                               @RequestParam(value = "northBound", required = true) double northBound,
                               @RequestParam(value = "eastBound", required = true) double eastBound,
                               @RequestParam(value = "southBound", required = true) double southBound,
                               @RequestParam(value = "westBound", required = true) double westBound,
                               @RequestParam(value = "customerScope", required = true) String customerScope,
                               @RequestParam(value = "propType", required = true) Integer propType,
                               @RequestParam(value = "fromDate", required = false) String fromDate,
                               @RequestParam(value = "toDate", required = false) String toDate,
                               @RequestParam(value = "txtMinPrice", required = true) Integer txtMinPrice,
                               @RequestParam(value = "txtMaxPrice", required = true) Integer txtMaxPrice,
                               @RequestParam(value = "minRooms", required = true) String minRooms,
                               @RequestParam(value = "maxRooms", required = true) String maxRooms,
                               @RequestParam(value = "minBaths", required = true) String minBaths,
                               @RequestParam(value = "maxBaths", required = true) String maxBaths,
                               @RequestParam(value = "txtConvenienceStore", required = false) Integer txtConvenienceStore,
                               @RequestParam(value = "txtBakery", required = false) Integer txtBakery,
                               @RequestParam(value = "txtLaundry", required = false) Integer txtLaundry,
                               @RequestParam(value = "txtRestaurant", required = false) Integer txtRestaurant,
                               @RequestParam(value = "txtPharmacy", required = false) Integer txtPharmacy,
                               @RequestParam(value = "txtTrainStation", required = false) Integer txtTrainStation,
                               @RequestParam(value = "txtBusStation", required = false) Integer txtBusStation,
                               @RequestParam(value = "ckbParking", required = true) Boolean ckbParking,
                               @RequestParam(value = "ckbGarage", required = true) Boolean ckbGarage,
                               @RequestParam(value = "ckbWasher", required = true) Boolean ckbWasher,
                               @RequestParam(value = "ckbAC", required = true) Boolean ckbAC,
                               @RequestParam(value = "ckbGym", required = true) Boolean ckbGym,
                               @RequestParam(value = "afterDate", required = false) String afterDate,
                               @RequestParam(value = "fromId", required = false) Long fromId,
                               @RequestParam(value = "toId", required = false) Long toId
    )
    {
        //boolean dataErrorOccurred = false;
        System.out.println("/rest/homes/find: " + northBound + "," + eastBound + "," + southBound + "," + westBound +
            "," + customerScope + ",gym=" + ckbGym + ",propType=" + propType + "#");

        ResponseObject responseObject = new ResponseObject();
        responseObject.setSuccess(0);
        responseObject.setResponseCode(-1);
        responseObject.setResponseString("Unexpected error occurred.");

        try
        {
            Double minRent, maxRent, minBuy, maxBuy;
            minRent = minBuy = 0.0;
            maxRent = maxBuy = Utils.maxPropertyValue;
            if (customerScope.equalsIgnoreCase("RENT"))
            {
                minRent = txtMinPrice.doubleValue();
                maxRent = txtMaxPrice.doubleValue();
            }
            else if (customerScope.equalsIgnoreCase("BUY"))
            {
                minBuy = txtMinPrice.doubleValue();
                maxBuy = txtMaxPrice.doubleValue();
            }

            Date fDate = new Date();
            Date tDate = new Date();

            if (fromDate == null)
                fromDate = Utils.emptyString;
            if (!fromDate.equals(Utils.emptyString))
                fDate = Utils.df.parse(fromDate);

            if (toDate == null)
                toDate = Utils.emptyString;
            if (toDate.equals(Utils.emptyString))
                toDate = "12/31/9999";

            tDate = Utils.df.parse(toDate);

            //System.out.println(fDate + "," + tDate);

            Integer iMinRooms = Integer.parseInt(minRooms);
            Integer iMaxRooms = 500;
            if (!maxRooms.contains("+"))
                iMaxRooms = Integer.parseInt(maxRooms);

            Integer iMinBaths = Integer.parseInt(minBaths);
            Integer iMaxBaths = 500;
            if (!maxBaths.contains("+"))
                iMaxBaths = Integer.parseInt(maxBaths);

            //properties updated or created after a certain date
            if (afterDate == null)
                afterDate = "01/01/1970";
            else if (afterDate.equals(Utils.emptyString))
                afterDate = "01/01/1970";

            Date aDate = Utils.df.parse(afterDate);

            if (fromId == null)
                fromId = Long.MIN_VALUE;
            if (toId == null)
                toId = Long.MAX_VALUE;

            Iterable<Property> foundHomes = propertyRepo.findWithinBounds2(
                    northBound, eastBound, southBound, westBound,
                    propType, fDate, tDate,
                    minRent, maxRent, minBuy, maxBuy,
                    iMinRooms, iMaxRooms, iMinBaths, iMaxBaths,
                    ckbParking, ckbGarage, ckbWasher, ckbAC, ckbGym,
                    aDate, fromId, toId);

            responseObject.setResponseCode(1);
            responseObject.setResponseString("No results found for your search criteria.");

            if (Iterables.size(foundHomes) != 0)
            {
                List<Property> filteredProperties = new ArrayList<>();
                for (Property fprop: foundHomes)
                {
                    boolean willbeAdded = true;    //property will be added to result set
                    List<GooglePlaces> emptyPlacesList = new ArrayList<>();
                    fprop.setPlacesList(emptyPlacesList);

                    willbeAdded = findPlaces(fprop, txtConvenienceStore, Utils.convenienceStore);
                    if (willbeAdded == false)
                        continue;
                    willbeAdded = findPlaces(fprop, txtBakery, Utils.bakery);
                    if (willbeAdded == false)
                        continue;
                    willbeAdded = findPlaces(fprop, txtLaundry, Utils.laundry);
                    if (willbeAdded == false)
                        continue;
                    willbeAdded = findPlaces(fprop, txtRestaurant, Utils.restaurant);
                    if (willbeAdded == false)
                        continue;
                    willbeAdded = findPlaces(fprop, txtPharmacy, Utils.pharmacy);
                    if (willbeAdded == false)
                        continue;
                    willbeAdded = findPlaces(fprop, txtTrainStation, Utils.trainStation);
                    if (willbeAdded == false)
                        continue;
                    willbeAdded = findPlaces(fprop, txtBusStation, Utils.busStation);
                    if (willbeAdded == false)
                        continue;

                    filteredProperties.add(fprop);
                }

                if (filteredProperties.size() != 0)
                {
                    responseObject.setResponseCode(0);
                    responseObject.setResponseString((new Gson()).toJson(filteredProperties));
                }
            }
            responseObject.setSuccess(1);
        }
        catch (Exception ex)
        {
            logger.error("Handled Exception", ex);
        }

        return responseObject;
    }



    private boolean findPlaces(Property foundProperty, Integer meters, String placesType)
    {
        //List<GooglePlaces> placesList = new ArrayList<>();
        List<GooglePlaces> placesList = foundProperty.getPlacesList();
        boolean placesExist = false;

        if (meters == null)
        {
            placesExist = true; //consider this property in the result set as this config has no effect
        }
        else if (meters == -1)
        {
            placesExist = true; //consider this property in the result set as this config has no effect
        }
        else
        {
            GooglePlaces googlePlaces = (new ApiHelper()).getGooglePlaces(foundProperty.getLocation(),
                    meters, placesType);

            if (googlePlaces.getStatus().equalsIgnoreCase(Utils.googlePlacesApiOkResponse))
            {
                List<GooglePlacesResult> filteredResult = new ArrayList<>();

                for (GooglePlacesResult res: googlePlaces.getResults())
                {
                    String firstType = res.getTypes().get(0);
                    /*
                    Check the first type, because each place in Google has one type or more.
                    The first type will be the primary one.
                     */
                    if (firstType.equalsIgnoreCase(placesType))
                    {
                        filteredResult.add(res);
                        placesExist = true;
                    }
                }

                googlePlaces.setResults(filteredResult);
                googlePlaces.setPlacesType(placesType);
                placesList.add(googlePlaces);
            }
            else
            {
                logger.error("failure of google places API (" + placesType + ")");
            }
        }

        foundProperty.setPlacesList(placesList);
        return placesExist;
    }




    /**
     * Add a new property
     * @param propName  Property Name
     * @param propType  Property Type (1 for Studio, 2 for Apartment, 4 for House)
     * @param street    Street
     * @param city      City
     * @param country   Country
     * @param zipCode   Zip Code
     * @param lat       Latitude of the Property
     * @param lng       Longitude of the Property
     * @param rooms     Integer representing number of Rooms
     * @param baths     Integer representing number of Baths
     * @param storeys   Integer representing number of Storeys (Always 1 in case of Studio or Apartment)
     * @param ckbAC     Boolean: true means the property has AC
     * @param ckbWasher Boolean: true means the property has Washer
     * @param ckbGym    Boolean: true means the property has Gym
     * @param ckbGarage Boolean: true means the property has Garage
     * @param ckbParking    Boolean: true means the property has Parking
     * @param mainPic   Multipart file representing the main pic of the property
     * @param rentPrice Rent price if the property is offered for rent. If not, price must be zero.
     * @param sellingPrice  Selling price if the property is offered for sale. If not, price must be zero.
     * @param ckbAvailable  Boolean to indicate the availability once the property is created.
     * @return  Response Object
     *          {
     *              Integer success         (1 for success, 0 for failure)
     *              Integer responseCode    (0 for successful response, Non-zero for error-codes)
     *              String responseString   (response message)
     *          }
     */
    @RequestMapping(path = "/add", method = RequestMethod.POST)
    public ResponseObject add(HttpServletRequest request,
                              @RequestParam(value = "propName", required = true) String propName,
                              @RequestParam(value = "propType", required = true) Integer propType,
                              @RequestParam(value = "street", required = true) String street,
                              @RequestParam(value = "city", required = true) String city,
                              @RequestParam(value = "country", required = true) String country,
                              @RequestParam(value = "zipCode", required = true) String zipCode,
                              @RequestParam(value = "lat", required = true) Double lat,
                              @RequestParam(value = "lng", required = true) Double lng,
                              @RequestParam(value = "rooms", required = true) Integer rooms,
                              @RequestParam(value = "baths", required = true) Integer baths,
                              @RequestParam(value = "storeys", required = true) Integer storeys,
                              @RequestParam(value = "ckbAC", required = true) Boolean ckbAC,
                              @RequestParam(value = "ckbWasher", required = true) Boolean ckbWasher,
                              @RequestParam(value = "ckbGym", required = true) Boolean ckbGym,
                              @RequestParam(value = "ckbGarage", required = true) Boolean ckbGarage,
                              @RequestParam(value = "ckbParking", required = true) Boolean ckbParking,
                              @RequestParam(value = "mainPic", required = true) MultipartFile mainPic,
                      @RequestParam(value = "rentPrice", required = true) Integer rentPrice,
                      @RequestParam(value = "sellingPrice", required = true) Integer sellingPrice,
                      @RequestParam(value = "ckbAvailable", required = true) Boolean ckbAvailable
    )
    {
        /*
        System.out.println("/rest/homes/add: " + lat + "," + lng + "," + propName + "," +
                propType + "," + rentPrice + "," + ckbAvailable);
                */
        System.out.println("/rest/prop/add: " + propName + "," + propType);


        ResponseObject responseObject = new ResponseObject();
        responseObject.setSuccess(0);
        responseObject.setResponseCode(-1);
        responseObject.setResponseString("Unexpected error occurred. Failed to add property (" +
            propName + ").");

        try
        {
            //AppUser appUser = (AppUser)(request.getSession().getAttribute("appUser"));
            AppUser appUser = fetchAppUser(request);

            if (mainPic == null)
            {
                responseObject.setSuccess(1);
                responseObject.setResponseCode(-20);
                responseObject.setResponseString("Main pic has not been uploaded correctly.");
                return responseObject;
            }

            String mainPicFileName = "";
            mainPicFileName = mainPic.getOriginalFilename();

            Location location = new Location(lat, lng);
            Address address = new Address(street, city, country, zipCode);
            Property property = new Property(location, propName, address, mainPicFileName, storeys,
                    rentPrice, sellingPrice, propType, ckbAvailable, (new Date()), rooms, baths,
                    ckbParking, ckbGarage, ckbWasher, ckbAC, ckbGym, (new Date()), (new Date()), appUser);

            propertyRepo.save(property);

            if (property.getId() != 0)
            {
                responseObject.setSuccess(1);
                responseObject.setResponseCode(0);
                responseObject.setResponseString("Property (" + propName + ") has been added successfully.");

                String userUploadLocation = uploadLocation + "u" +
                        String.valueOf(appUser.getId()) + "/";

                System.out.println("userUploadLocation=" + userUploadLocation + "#");
                Path path = Paths.get(userUploadLocation);
                if (!Files.exists(path))
                {
                    System.out.println("Path doesn't exist");
                    Files.createDirectories(path);
                    System.out.println("Created the path");
                }

                Files.copy(mainPic.getInputStream(), Paths.get(userUploadLocation + mainPicFileName));

                addToUpdatedProperties(property);   //useful for saved search
            }
        }
        catch (Exception ex)
        {
            logger.error("Handled Exception", ex);
        }

        return responseObject;
    }




    /**
     * List all properties that belong to a certain user
     * @return  Response Object
     *          {
     *              Integer success         (1 for success, 0 for failure)
     *              Integer responseCode    (0 for successful response, Non-zero for error-codes)
     *              String responseString   (Json response in case of success, Error message in case of failure)
     *          }
     */
    @RequestMapping(path = "/list", method = RequestMethod.POST)
    public ResponseObject list(HttpServletRequest request)
    {
        System.out.println("/rest/prop/list");

        ResponseObject responseObject = new ResponseObject();
        responseObject.setSuccess(0);
        responseObject.setResponseCode(-1);
        responseObject.setResponseString("Unexpected error occurred. Failed to list your properties.");

        try
        {
            //AppUser appUser = (AppUser)(request.getSession().getAttribute("appUser"));
            AppUser appUser = fetchAppUser(request);

            if (!(appUser.getUserType()).equalsIgnoreCase(Utils.propertyOwnerCode))
            {
                responseObject.setSuccess(1);
                responseObject.setResponseCode(-20);
                responseObject.setResponseString("You need to be registered as properties' owner to manage properties. " +
                    "Go to (Manage Account) tab to change your account type.");
                return responseObject;
            }

            Iterable<Property> userProperties = propertyRepo.findByAppUser(appUser);

            if (Iterables.size(userProperties) == 0)
            {
                responseObject.setSuccess(1);
                responseObject.setResponseCode(-30);
                responseObject.setResponseString("You don't have properties to manage.<br /> Go to (Add Property) tab to create a new property.");
                return  responseObject;
            }

            responseObject.setSuccess(1);
            responseObject.setResponseCode(0);
            responseObject.setResponseString((new Gson()).toJson(userProperties));
        }
        catch (Exception ex)
        {
            logger.error("Handled Exception", ex);
        }

        return responseObject;
    }




    /**
     * Fetch property's information
     * @param propId    Property ID as retrieved by /rest/prop/list API
     * @return  Response Object
     *          {
     *              Integer success         (1 for success, 0 for failure)
     *              Integer responseCode    (0 for successful response, Non-zero for error-codes)
     *              String responseString   (Json response in case of success, Error message in case of failure)
     *          }
     */
    @RequestMapping(path = "/fetch", method = RequestMethod.POST)
    public ResponseObject fetch(Long propId)
    {
        System.out.println("/rest/prop/fetch: " + propId);

        ResponseObject responseObject = new ResponseObject();
        responseObject.setSuccess(0);
        responseObject.setResponseCode(-1);
        responseObject.setResponseString("Unexpected error occurred. Failed to fetch your property's data.");

        try
        {
            Property userProperty = propertyRepo.findOne(propId);
            if (userProperty == null)
            {
                responseObject.setSuccess(1);
                responseObject.setResponseCode(-20);
                responseObject.setResponseString("Failed to fetch property information.");
                return responseObject;
            }
            responseObject.setSuccess(1);
            responseObject.setResponseCode(0);
            responseObject.setResponseString((new Gson()).toJson(userProperty));
        }
        catch (Exception ex)
        {
            logger.error("Handled Exception", ex);
        }

        return responseObject;
    }




    /**
     * Delete a property
     * @param propId    Property ID as fetched by /rest/prop/list
     * @param propName  Property Name as fetched by /rest/prop/list
     * @return  Response Object
     *          {
     *              Integer success         (1 for success, 0 for failure)
     *              Integer responseCode    (0 for successful response, Non-zero for error-codes)
     *              String responseString   (response message)
     *          }
     */
    @RequestMapping(path = "/delete", method = RequestMethod.POST)
    public ResponseObject delete(Long propId, String propName)
    {
        System.out.println("/rest/prop/delete: " + propId);

        ResponseObject responseObject = new ResponseObject();
        responseObject.setSuccess(0);
        responseObject.setResponseCode(-1);
        responseObject.setResponseString("Unexpected error occurred. Failed to delete property (" + propName + ")");

        try
        {
            propertyRepo.delete(propId);
            //ensure deletion
            Property userProperty = propertyRepo.findOne(propId);
            if (userProperty != null)
            {
                if (userProperty.getId() != 0)
                {
                    responseObject.setSuccess(1);
                    responseObject.setResponseCode(-20);
                    responseObject.setResponseString("Failed to delete property (" + userProperty.getPropertyName() + ")");
                    return responseObject;
                }
            }

            responseObject.setSuccess(1);
            responseObject.setResponseCode(0);
            responseObject.setResponseString("Property (" + propName + ") has been deleted.");
        }
        catch (Exception ex)
        {
            logger.error("Handled Exception", ex);
        }

        return responseObject;
    }




    /**
     * Update property information
     * @param propId    Property ID
     * @param propName  New Property's Name
     * @param street    New Property's Street
     * @param city  New Property's City
     * @param country   New Property's Country
     * @param zipCode   New Property's Zip Code
     * @param lat   New Property's Latitude
     * @param lng   New Property's Longitude
     * @param rooms New number of rooms
     * @param baths New number of baths
     * @param storeys   New number of storeys (remains 1 in case of Studio or Apartment)
     * @param ckbAC New status of AC. True for available, False for not available
     * @param ckbWasher New status of Washer. True for available, False for not available
     * @param ckbGym    New status of Gym. True for available, False for not available
     * @param ckbGarage New status of Garage. True for available, False for not available
     * @param ckbParking    New status of parking. True for available, False for not available
     * @param ckbNewMainPic Boolean to specify whether a new pic is uploaded
     * @param mainPic   The new pic in multipart format, if ckbNewMainPic is true.
     * @param rentPrice Zero if not offered for rent
     * @param sellingPrice  Zero if not offered for sale
     * @param ckbAvailable  True: the property will be available.
     * @return  Response Object
     *          {
     *              Integer success         (1 for success, 0 for failure)
     *              Integer responseCode    (0 for successful response, Non-zero for error-codes)
     *              String responseString   (response message)
     *          }
     */
    @RequestMapping(path = "/edit", method = RequestMethod.POST)
    public ResponseObject edit(HttpServletRequest request,
                               @RequestParam(value = "propId", required = true) Long propId,
                              @RequestParam(value = "propName", required = true) String propName,
                              @RequestParam(value = "street", required = true) String street,
                              @RequestParam(value = "city", required = true) String city,
                              @RequestParam(value = "country", required = true) String country,
                              @RequestParam(value = "zipCode", required = true) String zipCode,
                              @RequestParam(value = "lat", required = true) Double lat,
                              @RequestParam(value = "lng", required = true) Double lng,
                              @RequestParam(value = "rooms", required = true) Integer rooms,
                              @RequestParam(value = "baths", required = true) Integer baths,
                              @RequestParam(value = "storeys", required = true) Integer storeys,
                              @RequestParam(value = "ckbAC", required = true) Boolean ckbAC,
                              @RequestParam(value = "ckbWasher", required = true) Boolean ckbWasher,
                              @RequestParam(value = "ckbGym", required = true) Boolean ckbGym,
                              @RequestParam(value = "ckbGarage", required = true) Boolean ckbGarage,
                              @RequestParam(value = "ckbParking", required = true) Boolean ckbParking,
                               @RequestParam(value = "ckbNewMainPic", required = true) Boolean ckbNewMainPic,
                              @RequestParam(value = "mainPic", required = false) MultipartFile mainPic,
                              @RequestParam(value = "rentPrice", required = true) Integer rentPrice,
                              @RequestParam(value = "sellingPrice", required = true) Integer sellingPrice,
                              @RequestParam(value = "ckbAvailable", required = true) Boolean ckbAvailable
    )
    {
        System.out.println("/rest/prop/edit: " + propName);

        ResponseObject responseObject = new ResponseObject();
        responseObject.setSuccess(0);
        responseObject.setResponseCode(-1);
        responseObject.setResponseString("Unexpected error occurred. Failed to edit property (" +
                propName + ").");

        try
        {
            //AppUser appUser = (AppUser)(request.getSession().getAttribute("appUser"));
            AppUser appUser = fetchAppUser(request);

            Property prop = propertyRepo.findOne(propId);
            if (prop == null)
            {
                return responseObject;
            }


            if (ckbNewMainPic == true)
            {
                if (mainPic == null)
                {
                    responseObject.setSuccess(1);
                    responseObject.setResponseCode(-20);
                    responseObject.setResponseString("Main pic has not been uploaded correctly.");
                    return responseObject;
                }
                else
                {
                    prop.setPic(mainPic.getOriginalFilename());
                }
            }

            Location location = new Location(lat, lng);
            Address address = new Address(street, city, country, zipCode);

            prop.setLocation(location);
            prop.setPropertyName(propName);
            prop.setAddress(address);
            prop.setStoreys(storeys);
            prop.setRentPrice(rentPrice);
            prop.setSellingPrice(sellingPrice);
            prop.setAvailable(ckbAvailable);
            prop.setRooms(rooms);
            prop.setBaths(baths);
            prop.setParking(ckbParking);
            prop.setGarage(ckbGarage);
            prop.setWasher(ckbWasher);
            prop.setAc(ckbAC);
            prop.setGym(ckbGym);
            prop.setUpdateTime(new Date());

            propertyRepo.save(prop);

            responseObject.setSuccess(1);
            responseObject.setResponseCode(0);
            responseObject.setResponseString("Property (" + propName + ") has been updated successfully.");

            if (ckbNewMainPic == true)
            {
                String userUploadLocation = uploadLocation + "u" + String.valueOf(appUser.getId()) + "/";
                Path path = Paths.get(userUploadLocation);
                if (!Files.exists(path))
                {
                    Files.createDirectories(path);
                }
                Files.copy(mainPic.getInputStream(), Paths.get(userUploadLocation + mainPic.getOriginalFilename()));
            }

            addToUpdatedProperties(prop);   //useful for saved search
        }
        catch (Exception ex)
        {
            logger.error("Handled Exception", ex);
        }

        return responseObject;
    }



    private void addToUpdatedProperties(Property prop)
    {
        UpdatedProperty updatedProperty = updatedPropertyRepo.findByProperty(prop);
        if (updatedProperty != null)
        {
            updatedProperty.setUpdateTime(new Date());
        }
        else
        {
            updatedProperty = new UpdatedProperty(prop, new Date());
        }
        updatedPropertyRepo.save(updatedProperty);
    }



    /**
     * Save Search to receive regular email updates
     * @param northBound    The north latitude of the geographical area.
     * @param eastBound     The eastern longitude of the geographical area.
     * @param southBound    The southern latitude of the geographical area.
     * @param westBound     The western longitude of the geographical area.
     * @param customerScope     RENT or BUY value.
     * @param propType          1 for Studio, 2 for Apartment, 4 for House.
     * @param fromDate          Check-in date or purchase date in MM/DD/YYYY format.
     * @param toDate            Check-out date in MM/DD/YYYY format.
     * @param txtMinPrice       Positive Integer that represent the minimum price in US dollars.
     * @param txtMaxPrice       Positive Integer that represent the max affordable price in US dollars.
     * @param minRooms      String for minimum number of rooms. Possible values are '1', '2', '3', '4'.
     * @param maxRooms      String for max number of rooms. Possible values are '1', '2', '3', '4', '5+'.
     * @param minBaths      String for minimum number of baths. Possible values are '1', '2', '3'.
     * @param maxBaths      String for max number of baths. Possible values are '1', '2', '3', '4+'.
     * @param txtConvenienceStore   Positive Integer for max affordable distance in meters to Convenience Stores. Max value is 9999.
     * @param txtBakery     Positive Integer for max affordable distance in meters to Bakeries. Max value is 9999.
     * @param txtLaundry    Positive Integer for max affordable distance in meters to Laundries. Max value is 9999.
     * @param txtRestaurant     Positive Integer for max affordable distance in meters to Restaurants. Max value is 9999.
     * @param txtPharmacy   Positive Integer for max affordable distance in meters to Pharmacies. Max value is 9999.
     * @param txtTrainStation   Positive Integer for max affordable distance in meters to Train Stations. Max value is 9999.
     * @param txtBusStation     Positive Integer for max affordable distance in meters to Bus Stations. Max value is 9999.
     * @param ckbParking    Boolean value. True means Parking is required.
     * @param ckbGarage     Boolean value. True means Garage is required.
     * @param ckbWasher     Boolean value. True means Washer is required.
     * @param ckbAC     Boolean value. True means AC is required.
     * @param ckbGym    Boolean value. True means Gym is required.
     * @return  Response Object
     *          {
     *              Integer success         (1 for success, 0 for failure)
     *              Integer responseCode    (0 for successful response, Non-zero for error-codes)
     *              String responseString   (Json response in case of success, Error message in case of failure)
     *          }
     */
    @RequestMapping(path = "/savesearch", method = RequestMethod.POST)
    public ResponseObject saveSearch(HttpServletRequest request,
            @RequestParam(value = "northBound", required = true) double northBound,
            @RequestParam(value = "eastBound", required = true) double eastBound,
            @RequestParam(value = "southBound", required = true) double southBound,
            @RequestParam(value = "westBound", required = true) double westBound,
            @RequestParam(value = "customerScope", required = true) String customerScope,
            @RequestParam(value = "propType", required = true) Integer propType,
            @RequestParam(value = "fromDate", required = false) String fromDate,
            @RequestParam(value = "toDate", required = false) String toDate,
            @RequestParam(value = "txtMinPrice", required = true) Integer txtMinPrice,
            @RequestParam(value = "txtMaxPrice", required = true) Integer txtMaxPrice,
            @RequestParam(value = "minRooms", required = true) String minRooms,
            @RequestParam(value = "maxRooms", required = true) String maxRooms,
            @RequestParam(value = "minBaths", required = true) String minBaths,
            @RequestParam(value = "maxBaths", required = true) String maxBaths,
            @RequestParam(value = "txtConvenienceStore", required = false) Integer txtConvenienceStore,
            @RequestParam(value = "txtBakery", required = false) Integer txtBakery,
            @RequestParam(value = "txtLaundry", required = false) Integer txtLaundry,
            @RequestParam(value = "txtRestaurant", required = false) Integer txtRestaurant,
            @RequestParam(value = "txtPharmacy", required = false) Integer txtPharmacy,
            @RequestParam(value = "txtTrainStation", required = false) Integer txtTrainStation,
            @RequestParam(value = "txtBusStation", required = false) Integer txtBusStation,
            @RequestParam(value = "ckbParking", required = true) Boolean ckbParking,
            @RequestParam(value = "ckbGarage", required = true) Boolean ckbGarage,
            @RequestParam(value = "ckbWasher", required = true) Boolean ckbWasher,
            @RequestParam(value = "ckbAC", required = true) Boolean ckbAC,
            @RequestParam(value = "ckbGym", required = true) Boolean ckbGym
    )
    {
        ResponseObject responseObject = new ResponseObject();
        responseObject.setSuccess(0);
        responseObject.setResponseCode(-1);
        responseObject.setResponseString("Unexpected error occurred.");

        try
        {
            AppUser appUser = fetchAppUser(request);
            SearchSave searchSave = searchSaveRepo.findByAppUser(appUser);

            if (searchSave != null)
            {
                searchSave.setNorthBound(northBound);
                searchSave.setEastBound(eastBound);
                searchSave.setSouthBound(southBound);
                searchSave.setWestBound(westBound);
                searchSave.setCustomerScope(customerScope);
                searchSave.setPropType(propType);
                searchSave.setFromDate(fromDate);
                searchSave.setToDate(toDate);
                searchSave.setTxtMinPrice(txtMinPrice);
                searchSave.setTxtMaxPrice(txtMaxPrice);
                searchSave.setMinRooms(minRooms);
                searchSave.setMaxRooms(maxRooms);
                searchSave.setMinBaths(minBaths);
                searchSave.setMaxBaths(maxBaths);
                searchSave.setTxtConvenienceStore(txtConvenienceStore);
                searchSave.setTxtBakery(txtBakery);
                searchSave.setTxtLaundry(txtLaundry);
                searchSave.setTxtRestaurant(txtRestaurant);
                searchSave.setTxtPharmacy(txtPharmacy);
                searchSave.setTxtTrainStation(txtTrainStation);
                searchSave.setTxtBusStation(txtBusStation);
                searchSave.setSaveTime(new Date());
            }
            else
            {
                searchSave = new SearchSave(northBound, eastBound, southBound, westBound,
                        customerScope, propType,
                        fromDate, toDate,
                        txtMinPrice, txtMaxPrice,
                        minRooms, maxRooms, minBaths, maxBaths,
                        txtConvenienceStore, txtBakery, txtLaundry, txtRestaurant, txtPharmacy, txtTrainStation, txtBusStation,
                        ckbParking, ckbGarage, ckbWasher, ckbAC, ckbGym,
                        new Date(), appUser);

            }

            searchSaveRepo.save(searchSave);

            responseObject.setSuccess(1);
            responseObject.setResponseCode(0);
            responseObject.setResponseString("Your search has been saved. We will send you the updates on your email.");
        }
        catch (Exception ex)
        {
            logger.error("Handled Exception", ex);
        }

        return responseObject;
    }


    /**
     * Delete user's saved search
     * @return  Response Object
     *          {
     *              Integer success         (1 for success, 0 for failure)
     *              Integer responseCode    (0 for successful response, Non-zero for error-codes)
     *              String responseString   (Json response in case of success, Error message in case of failure)
     *          }
     */
    @RequestMapping(path = "/delsavedsearch", method = RequestMethod.POST)
    public ResponseObject saveSearch(HttpServletRequest request, Long id)
    {
        ResponseObject responseObject = new ResponseObject();
        responseObject.setSuccess(0);
        responseObject.setResponseCode(-1);
        responseObject.setResponseString("Unexpected error occurred while removing your saved search.");

        try
        {
            AppUser appUser = fetchAppUser(request);
            SearchSave searchSave = searchSaveRepo.findByIdAndAppUser(id, appUser);
            if (searchSave != null)
            {
                searchSaveRepo.delete(id);
                responseObject.setSuccess(1);
                responseObject.setResponseCode(0);
                responseObject.setResponseString("You have unsubscribed from HomeFinder email service successfully.");
            }
            else
            {
                responseObject.setResponseCode(-10);
                responseObject.setResponseString("The search that you tried to delete was not found.");
            }
        }
        catch (Exception ex)
        {
            logger.error("Handled Exception", ex);
        }

        return responseObject;
    }

}
