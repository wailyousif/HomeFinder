package com.ironyard.security;

import com.ironyard.data.AppUser;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Random;
import java.util.StringTokenizer;

/**
 * Created by wailm.yousif on 3/27/17.
 */
public class TokenMaster
{
    private static final String SECRET = "OurSecretWord";

    private String generateNonce()
    {
        Random rand = new Random();
        int min = 1001;
        int max = 9999;
        int randomNum = rand.nextInt((max - min) + 1) + min;
        return String.valueOf(randomNum);
    }


    public String genreateToken(AppUser appUser)
    {
        DateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
        Calendar cal = Calendar.getInstance();
        String dateString = dateFormat.format(cal.getTime());
        String clearToken = String.format("%s:%s:%s:%s", dateString, SECRET, generateNonce(), appUser.getId());

        AES aes = new AES();
        return aes.aes128Encrypt(clearToken);
    }


    /**
     * Returns null if token is invalid
     */
    public Long validateTokenAndGetUserId(String encryptedToken)
    {
        Long userId = null;
        try
        {
            AES aes = new AES();
            String decrypted = aes.aes128Decrypt(encryptedToken);

            StringTokenizer st = new StringTokenizer(decrypted, ":");
            String dateString = st.nextToken();
            String secret = st.nextToken();

            if(secret.equals(SECRET))
            {
                DateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
                Date dateFromToken = dateFormat.parse(dateString);

                Calendar OneHourAgo = Calendar.getInstance();
                OneHourAgo.add(Calendar.HOUR, -1);

                if(dateFromToken.after(OneHourAgo.getTime()))
                {
                    st.nextToken();
                    userId = Long.parseLong(st.nextToken());
                }
                else
                {
                    throw new Exception("ChatToken has expired");
                }
            }
        }
        catch(Exception e)
        {
            System.out.println("ChatToken validation exception: " + e.getMessage());
        }

        return userId;
    }

}
