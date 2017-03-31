package com.ironyard.dto;

/**
 * Created by wailm.yousif on 3/6/17.
 */

public class ResponseObject
{
    private int success;
    private int responseCode;
    private String responseString;

    public ResponseObject() { }

    public ResponseObject(int success, int responseCode, String responseString) {
        this.success = success;
        this.responseCode = responseCode;
        this.responseString = responseString;
    }

    public int getSuccess() {
        return success;
    }

    public void setSuccess(int success) {
        this.success = success;
    }

    public int getResponseCode() {
        return responseCode;
    }

    public void setResponseCode(int responseCode) {
        this.responseCode = responseCode;
    }

    public String getResponseString() {
        return responseString;
    }

    public void setResponseString(String responseString) {
        this.responseString = responseString;
    }
}
