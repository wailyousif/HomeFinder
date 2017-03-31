package com.ironyard.controller.rest;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.ironyard.data.Address;
import com.ironyard.data.AppUser;
import com.ironyard.data.AuthToken;
import com.ironyard.data.ContactInfo;
import com.ironyard.dto.ResponseObject;
import com.ironyard.repo.AppUserRepo;
import com.ironyard.repo.AuthTokenRepo;
import com.ironyard.security.TokenMaster;
import com.ironyard.services.Utils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;

/**
 * Created by wailm.yousif on 3/22/17.
 */

@RestController
@RequestMapping(path = "/rest/user")
public class RestUserController
{
    final static Logger logger = Logger.getLogger(RestUserController.class);

    @Autowired
    private AppUserRepo appUserRepo;

    @Autowired
    AuthTokenRepo authTokenRepo;


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
     * Web-based Login
     * @param email used as a username
     * @param pass  password (minimum 8 characters)
     * @return Response Object
     *          {
     *              Integer success         (1 for success, 0 for failure)
     *              Integer responseCode    (0 for successful response, Non-zero for error-codes)
     *              String responseString   (Json response in case of success, Error message in case of failure)
     *          }
     */
    @RequestMapping(path = "/login", method = RequestMethod.POST)
    public ResponseObject userLogin(HttpServletRequest request,
                                  @RequestParam(value = "email", required = true) String email,
                                  @RequestParam(value = "pass", required = true) String pass)
    {
        System.out.print("#" + email + "," + pass + "#");

        ResponseObject responseObject = new ResponseObject();
        responseObject.setSuccess(0);
        responseObject.setResponseCode(-1);
        responseObject.setResponseString("Unexpected error occurred. Failed to sign in.");

        try
        {
            AppUser appUser = appUserRepo.findByEmailAndPassword(email, pass);
            if (appUser != null)
            {
                responseObject.setSuccess(1);
                responseObject.setResponseCode(0);

                TokenMaster tm = new TokenMaster();
                String tokenString = tm.genreateToken(appUser);
                AuthToken authToken = new AuthToken(tokenString, new Date(), 0, appUser);
                //responseObject.setResponseString((new ObjectMapper()).writeValueAsString(authToken));
                responseObject.setResponseString((new Gson()).toJson(authToken));

                if (Utils.isBrowser(request))
                {
                    request.getSession().setAttribute("appUser", appUser);
                    authTokenRepo.save(authToken);
                }
                else
                {
                    authTokenRepo.save(authToken);
                }
            }
            else
            {
                responseObject.setSuccess(1);
                responseObject.setResponseCode(-10);
                responseObject.setResponseString("Incorrect credentials!");
            }
        }
        catch (Exception ex)
        {
            logger.error("Handled Exception", ex);
        }

        return responseObject;
    }




    /**
     * Create new user
     * @param userType  O: for property's owner, S: for seeker
     * @param firstName First name
     * @param middleName    Middle name
     * @param lastName  Last name
     * @param gender    M: Male, F: Female, NS: Not Specified
     * @param personalId    String of 32 chars length
     * @param email     Email will be used for login
     * @param pass      Password for login (minimum 8 characters)
     * @param displayName   Display Name while logged-in
     * @param street    Address of user (Street)
     * @param city  Address of user (City)
     * @param country   Address of user (Country)
     * @param zipCode   Address of user (Zip Code)
     * @param phone     User's phone including country code. It must start with + sign.
     * @param contactEmail  Email that seekers will see for contacting the property's owner
     * @return Response Object
     *          {
     *              Integer success         (1 for success, 0 for failure)
     *              Integer responseCode    (0 for successful response, Non-zero for error-codes)
     *              String responseString   (Json response in case of success, Error message in case of failure)
     *          }
     */
    @RequestMapping(path = "/add", method = RequestMethod.POST)
    public ResponseObject userAdd(HttpServletRequest request,
                                  @RequestParam(value = "userType", required = true) String userType,
                              @RequestParam(value = "firstName", required = true) String firstName,
                              @RequestParam(value = "middleName", required = true) String middleName,
                              @RequestParam(value = "lastName", required = true) String lastName,
                              @RequestParam(value = "gender", required = true) String gender,
                              @RequestParam(value = "personalId", required = true) String personalId,
                              @RequestParam(value = "email", required = true) String email,
                              @RequestParam(value = "pass", required = true) String pass,
                              @RequestParam(value = "displayName", required = true) String displayName,
                              @RequestParam(value = "street", required = true) String street,
                              @RequestParam(value = "city", required = true) String city,
                              @RequestParam(value = "country", required = true) String country,
                              @RequestParam(value = "zipCode", required = true) String zipCode,
                              @RequestParam(value = "phone", required = true) String phone,
                              @RequestParam(value = "contactEmail", required = true) String contactEmail
                              )
    {
        /*
        System.out.println("/rest/owner/add: " + firstName + "," + middleName + "," +
        lastName + "," + gender + "," + personalId + "," + email + "," + pass + "," +
        displayName + "," + street + "," + city + "," + country + "," + zipCode  + "," +
        phone + "," + contactEmail);
        */

        ResponseObject responseObject = new ResponseObject();
        responseObject.setSuccess(0);
        responseObject.setResponseCode(-1);
        responseObject.setResponseString("Unexpected error occurred. Failed to add user (" +
                displayName + ").");

        try
        {
            AppUser tmpAppUser = appUserRepo.findByEmail(email);
            if (tmpAppUser != null)
            {
                if (tmpAppUser.getId() != 0)
                {
                    responseObject.setSuccess(1);
                    responseObject.setResponseCode(-10);
                    responseObject.setResponseString("Email is already in use. Please try another one.");
                    return responseObject;
                }
            }

            String fullName = firstName + " " + middleName + " " + lastName;
            Address address = new Address(street, city, country, zipCode);
            //addressRepo.save(address);

            ContactInfo contactInfo = new ContactInfo(phone, contactEmail, address);
            //contactInfoRepo.save(contactInfo);

            AppUser appUser = new AppUser(userType, fullName, gender, personalId, displayName,
                    email, pass, contactInfo);
            appUserRepo.save(appUser);

            if (appUser.getId() != 0)
            {
                responseObject.setSuccess(1);
                responseObject.setResponseCode(0);
                responseObject.setResponseString("User " + displayName + " has been created successfully.");
                request.getSession().setAttribute("appUser", appUser);
            }
            else
            {
                responseObject.setSuccess(1);
                responseObject.setResponseCode(-20);
            }
        }
        catch (Exception ex)
        {
            logger.error("Handled Exception", ex);
        }

        return  responseObject;
    }


    /**
     * Fetch user's details
     * @return Response Object
     *          {
     *              Integer success         (1 for success, 0 for failure)
     *              Integer responseCode    (0 for successful response, Non-zero for error-codes)
     *              String responseString   (Json response in case of success, Error message in case of failure)
     *          }
     */
    @RequestMapping(path = "/fetch", method = RequestMethod.POST)
    public ResponseObject userFetch(HttpServletRequest request)
    {
        System.out.print("/rest/user/fetch:");

        ResponseObject responseObject = new ResponseObject();
        responseObject.setSuccess(0);
        responseObject.setResponseCode(-1);
        responseObject.setResponseString("Unexpected error occurred. Failed to fetch your information.");

        try
        {
            //AppUser appUser = (AppUser)(request.getSession().getAttribute("appUser"));
            AppUser appUser = fetchAppUser(request);
            responseObject.setSuccess(1);
            responseObject.setResponseCode(0);
            responseObject.setResponseString((new ObjectMapper()).writeValueAsString(appUser));
        }
        catch (Exception ex)
        {
            logger.error("Handled Exception", ex);
        }

        return responseObject;
    }


    /**
     * Update user's details
     * @param userType  O: for property's owner, S: for seeker
     * @param personalId    String of 32 chars length
     * @param displayName   Display Name while logged-in
     * @param street    Address of user (Street)
     * @param city  Address of user (City)
     * @param country   Address of user (Country)
     * @param zipCode   Address of user (Zip Code)
     * @param phone     User's phone including country code. It must start with + sign.
     * @param contactEmail  Email that seekers will see for contacting the property's owner
     * @return Response Object
     *          {
     *              Integer success         (1 for success, 0 for failure)
     *              Integer responseCode    (0 for successful response, Non-zero for error-codes)
     *              String responseString   (Json response in case of success, Error message in case of failure)
     *          }
     */
    @RequestMapping(path = "/edit", method = RequestMethod.POST)
    public ResponseObject userEdit(HttpServletRequest request,
                                   @RequestParam(value = "userType", required = true) String userType,
                                   @RequestParam(value = "personalId", required = true) String personalId,
                                   @RequestParam(value = "displayName", required = true) String displayName,
                                   @RequestParam(value = "street", required = true) String street,
                                   @RequestParam(value = "city", required = true) String city,
                                   @RequestParam(value = "country", required = true) String country,
                                   @RequestParam(value = "zipCode", required = true) String zipCode,
                                   @RequestParam(value = "phone", required = true) String phone,
                                   @RequestParam(value = "contactEmail", required = true) String contactEmail
                                   )
    {
        System.out.print("/rest/user/edit:");

        ResponseObject responseObject = new ResponseObject();
        responseObject.setSuccess(0);
        responseObject.setResponseCode(-1);
        responseObject.setResponseString("Unexpected error occurred. Failed to update your information.");

        try
        {
            //AppUser appUser = (AppUser)(request.getSession().getAttribute("appUser"));
            AppUser appUser = fetchAppUser(request);

            appUser.setUserType(userType);
            appUser.setPersonalId(personalId);
            appUser.setDisplayName(displayName);
            appUser.getContactInfo().getAddress().setStreet(street);
            appUser.getContactInfo().getAddress().setCity(city);
            appUser.getContactInfo().getAddress().setCountry(country);
            appUser.getContactInfo().getAddress().setZipCode(zipCode);
            appUser.getContactInfo().setPhone(phone);
            appUser.getContactInfo().setEmail(contactEmail);

            appUserRepo.save(appUser);

            request.getSession().setAttribute("appUser", appUser);

            responseObject.setSuccess(1);
            responseObject.setResponseCode(0);
            responseObject.setResponseString("Your account has been updated successfully.");
        }
        catch (Exception ex)
        {
            logger.error("Handled Exception", ex);
        }

        return responseObject;
    }
}
