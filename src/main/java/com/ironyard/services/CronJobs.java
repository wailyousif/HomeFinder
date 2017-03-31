package com.ironyard.services;

import com.ironyard.controller.rest.RestPropertiesController;
import com.ironyard.controller.rest.RestUserController;
import com.ironyard.data.SearchSave;
import com.ironyard.data.UpdatedProperty;
import com.ironyard.dto.ResponseObject;
import com.ironyard.repo.SearchSaveRepo;
import com.ironyard.repo.UpdatedPropertyRepo;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

/**
 * Created by wailm.yousif on 3/28/17.
 */

@Service
public class CronJobs
{
    final static Logger logger = Logger.getLogger(RestUserController.class);

    @Autowired
    UpdatedPropertyRepo updatedPropertyRepo;

    @Autowired
    SearchSaveRepo searchSaveRepo;

    @Autowired
    RestPropertiesController restPropertiesController;

    //@Autowired
    //private JavaMailSender javaMailSender;

    @Autowired
    JMail jMail;

    private static final String mailBodyFormat = "Hello %s," + "" +
            "<br />" + "" +
            "<br />" +
            "HomeFinder found the home of your dream. " +
            "<a href=\"http://localhost:8080/finder.jsp?%s\">%s</a> " +
            "is one gorgeous property that matches your saved search with us. " +
            "Please, click on <a href=\"http://localhost:8080/finder.jsp?%s\">here</a> to have more information." +
            "<br />" +
            "<br />" +
            "<div style=\"text-align:center\"><img src=\"cid:image\" /></div>" +
            "<br />" +
            "<br />" +
            "<br />" +
            "To stop receiving emails from HomeFinder, you can click <a href=\"http://localhost:8080/mvc/user/emailunsub?id=%d\">here</a>." +
            "<br />" +
            "<br />" +
            "You can save your search again at any time from our home page." + "" +
            "<br />" +
            "Thanks!";



    @Scheduled(initialDelay = 7000, fixedRate = 15000)
    public void checkSavedSearches()
    {
        System.out.println("Scheduled Task (Saved Search)");

        try
        {
            Iterable<UpdatedProperty> updatedProperties = updatedPropertyRepo.findAll();

            for (UpdatedProperty updatedProperty: updatedProperties)
            {
                Iterable<SearchSave> searchSaves = searchSaveRepo.findAll();
                for (SearchSave ss: searchSaves)
                {
                    //RestPropertiesController restPropertiesController = new RestPropertiesController();

                    ResponseObject responseObject = restPropertiesController.find(
                            ss.getNorthBound(), ss.getEastBound(), ss.getSouthBound(), ss.getWestBound(),
                            ss.getCustomerScope(), ss.getPropType(), ss.getFromDate(), ss.getToDate(),
                            ss.getTxtMinPrice(), ss.getTxtMaxPrice(),
                            ss.getMinRooms(), ss.getMaxRooms(), ss.getMinBaths(), ss.getMaxBaths(),
                            ss.getTxtConvenienceStore(), ss.getTxtBakery(), ss.getTxtLaundry(), ss.getTxtRestaurant(), ss.getTxtPharmacy(), ss.getTxtTrainStation(), ss.getTxtBusStation(),
                            ss.getCkbParking(), ss.getCkbGarage(), ss.getCkbWasher(), ss.getCkbAC(), ss.getCkbGym(),
                            Utils.df.format(ss.getSaveTime()),
                            updatedProperty.getProperty().getId(),
                            updatedProperty.getProperty().getId());

                    if (responseObject.getSuccess() == 1 && responseObject.getResponseCode() == 0)
                    {
                        System.out.println("Properties Found = " + responseObject.getResponseString());

                        String mailSubject = "HomeFinder found " + updatedProperty.getProperty().getPropertyName() + " for You";

                        String customerName = ss.getAppUser().getName();
                        String propId = String.valueOf(updatedProperty.getProperty().getId());
                        String queryString = "id=" + propId;
                        String propName = updatedProperty.getProperty().getPropertyName();

                        String mailBody = String.format(mailBodyFormat, customerName,
                                queryString, propName, queryString, ss.getId());

                        //String userId = String.valueOf(ss.getAppUser().getId());
                        String imgPath = "u" + updatedProperty.getProperty().getAppUser().getId() +
                                "/" + updatedProperty.getProperty().getPic();

                        System.out.println("imgPath=" + imgPath + "#");

                        jMail.sendMail(ss.getAppUser().getEmail(), mailSubject, mailBody, imgPath);
                    }
                    else
                    {
                        System.out.println("No properties found for the saved search");
                    }
                }

                updatedPropertyRepo.delete(updatedProperty.getId());
            }
        }
        catch (Exception ex)
        {
            logger.error("Handled Exception", ex);
        }
    }
}
