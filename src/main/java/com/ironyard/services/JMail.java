package com.ironyard.services;

import com.ironyard.controller.rest.RestPropertiesController;
import org.apache.log4j.Logger;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Component;

import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import java.util.Properties;

/**
 * Created by wailm.yousif on 3/28/17.
 */

@Component
public class JMail
{
    final static Logger logger = Logger.getLogger(RestPropertiesController.class);

    private String mailHost;
    private String mailPort;
    private String mailType;
    private String username;
    private String password;
    private String uploadLocation;

    //@Autowired
    public JMail(Environment env)
    {
        mailHost = env.getRequiredProperty("mail.host");
        mailPort = env.getRequiredProperty("mail.port");
        mailType = env.getRequiredProperty("mail.type");
        username = env.getRequiredProperty("mail.username");
        password = env.getRequiredProperty("mail.password");
        uploadLocation = env.getRequiredProperty("upload.location");
    }

    public void sendMail(String to, String subject, String body, String imgPath)
    {
        Properties props = new Properties();
        props.put("mail.smtp.host", mailHost);
        props.put("mail.smtp.socketFactory.port", mailPort);
        props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.port", mailPort);


        Session session = Session.getDefaultInstance(props,
                new javax.mail.Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(username, password);
                    }
                });


        try
        {
            MimeMessage message = new MimeMessage(session);

            message.setFrom(new InternetAddress(username));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));
            message.setSubject(subject);

            MimeMultipart multipart = new MimeMultipart("related");

            BodyPart messageBodyPart = new MimeBodyPart();
            messageBodyPart.setContent(body, "text/html");
            multipart.addBodyPart(messageBodyPart);

            messageBodyPart = new MimeBodyPart();
            DataSource fds = new FileDataSource(uploadLocation + imgPath);
            messageBodyPart.setDataHandler(new DataHandler(fds));
            messageBodyPart.setHeader("Content-ID", "<image>");
            multipart.addBodyPart(messageBodyPart);

            message.setContent(multipart);
            //message.setContent(msg, mailType);

            Transport.send(message);
        }
        catch (MessagingException mex)
        {
            logger.error("Handled Mail Exception", mex);
        }
        catch (Exception ex)
        {
            logger.error("Handled Exception", ex);
        }
    }
}
