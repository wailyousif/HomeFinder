package com.ironyard;

import com.google.gson.Gson;
import com.ironyard.data.AuthToken;
import com.ironyard.data.Property;
import com.ironyard.dto.ResponseObject;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

@RunWith(SpringRunner.class)
@SpringBootTest
public class SpringJpaWebApplicationTests {

	@Test
	public void contextLoads() { }

	@Test
	public void walkThroughTest()
	{
		//users can find properties, no need for sign-in
		httpFind();

		//create user
		String email = "wail@gmail.com";
		String pass = "wailwail";
		String displayName = "Wail";
		httpCreateUser(email, pass, displayName);

		//get authorization key to be used as a header for further secured requests
		String authKey = httpLogin(email, pass, displayName);

		//add new property
		String propertyName = "Church Street Lodge";
		httpAddProperty(authKey, propertyName);

		//find again after adding new property
		httpFind();

		//owner lists his/her properties
		Property[] properties = httpListProperties(authKey);

		//Owner of Apartment-3 decided to remove the AC because the price is low
		//He will find his property by its name
		for (Property pp: properties)
		{
			if (pp.getPropertyName().equals(propertyName))
			{
				httpUpdateProperty(authKey, pp.getId());
				break;
			}
		}

		//find again. Our customer wants AC
		httpFind();
	}


	private Property[] httpListProperties(String authKey)
	{
		String url = "http://localhost:8080/rest/prop/list";
		MultiValueMap<String, Object> map= new LinkedMultiValueMap<String, Object>();

		HashMap<String, String> customHeaders = new HashMap<>();
		customHeaders.put("x-authorization-key", authKey);

		ResponseObject responseObject = doHttp(url, map, MediaType.APPLICATION_FORM_URLENCODED, customHeaders);
		Assert.assertNotNull(responseObject);
		Assert.assertEquals("Error while listing properties", 1, responseObject.getSuccess());
		Assert.assertEquals(responseObject.getResponseString(), 0, responseObject.getResponseCode());

		Property[] properties = (new Gson()).fromJson(responseObject.getResponseString(), Property[].class);
		return properties;
	}



	private void httpCreateUser(String email, String pass, String displayName)
	{
		String url = "http://localhost:8080/rest/user/add";
		MultiValueMap<String, Object> map= new LinkedMultiValueMap<String, Object>();

		//map.add("", );
		map.add("userType", "O");
		map.add("firstName", "Wail");
		map.add("middleName", "M");
		map.add("lastName", "Yousif");
		map.add("gender", "M");
		map.add("personalId", "96310");
		map.add("email", email);
		map.add("pass", getSHA512(pass));
		map.add("displayName", displayName);
		map.add("street", "Garland Avenue");
		map.add("city", "Orlando");
		map.add("country", "USA");
		map.add("zipCode", "32801");
		map.add("phone", "+15128179553");
		map.add("contactEmail", email);

		ResponseObject responseObject = doHttp(url, map, MediaType.APPLICATION_FORM_URLENCODED, null);
		Assert.assertNotNull(responseObject);
		Assert.assertEquals("Error while creating user", 1, responseObject.getSuccess());
		Assert.assertEquals(responseObject.getResponseString(), 0, responseObject.getResponseCode());

		System.out.println(responseObject.getResponseString());
		//AppUser appUser = (new Gson()).fromJson(responseObject.getResponseString(), AppUser.class);
	}


	private String httpLogin(String email, String pass, String displayName)
	{
		String url = "http://localhost:8080/rest/user/login";
		MultiValueMap<String, Object> map= new LinkedMultiValueMap<String, Object>();

		map.add("email", email);
		//password must be sent secured from client using SHA-512
		map.add("pass",  getSHA512(pass));

		ResponseObject responseObject = doHttp(url, map, MediaType.APPLICATION_FORM_URLENCODED, null);
		Assert.assertNotNull(responseObject);
		Assert.assertEquals("Error in Login Process", 1, responseObject.getSuccess());
		Assert.assertEquals("Login failed", 0, responseObject.getResponseCode());

		AuthToken authToken = (new Gson()).fromJson(responseObject.getResponseString(), AuthToken.class);
		System.out.println("User (" + displayName + ") logged-in successfully. Authorization Key = " + authToken.getTokenString());

		return authToken.getTokenString();
	}


	public String getSHA512(String pass)
	{
		String sha512 = null;
		try
		{
			MessageDigest md = MessageDigest.getInstance("SHA-512");
			//md.update(salt.getBytes("UTF-8"));
			byte[] bytes = md.digest(pass.getBytes("UTF-8"));
			//StringBuilder sb = new StringBuilder();
//			for(int i=0; i< bytes.length ;i++)
//			{
//				sb.append(Integer.toString((bytes[i] & 0xff) + 0x100, 16).substring(1));
//			}
//			generatedPassword = sb.toString();
			sha512 = Base64.getEncoder().encodeToString(bytes);
			//System.out.println("hashed password=" + sha512);
		}
		catch (NoSuchAlgorithmException e)
		{
			e.printStackTrace();
		}
		catch (Exception ex)
		{
			ex.printStackTrace();
		}
		return sha512;
	}


	private void httpUpdateProperty(String authKey, Long propertyId)
	{
		Property p = httpFetchProperty(authKey, propertyId);

		String url = "http://localhost:8080/rest/prop/edit";
		MultiValueMap<String, Object> map= new LinkedMultiValueMap<String, Object>();

		map.add("propId", propertyId.toString());
		map.add("propName", p.getPropertyName());
		map.add("street", p.getAddress().getStreet());
		map.add("city", p.getAddress().getCity());
		map.add("country", p.getAddress().getCountry());
		map.add("zipCode", p.getAddress().getZipCode());
		map.add("lat", String.valueOf(p.getLocation().getLat()));
		map.add("lng", String.valueOf(p.getLocation().getLng()));
		map.add("rooms", String.valueOf(p.getRooms()));
		map.add("baths", String.valueOf(p.getBaths()));
		map.add("storeys", String.valueOf(p.getStoreys()));
		map.add("ckbAC", "false");
		map.add("ckbWasher", String.valueOf(p.isWasher()));
		map.add("ckbGym", String.valueOf(p.isGym()));
		map.add("ckbGarage", String.valueOf(p.isGarage()));
		map.add("ckbParking", String.valueOf(p.isParking()));
		map.add("ckbNewMainPic", "false");

		/*
		Resource resource = new FileSystemResource("/var/www/propFinder/collection/pexels-photo-323775.jpeg");
		//map.add("Content-Type", "image/jpeg");
		map.add("mainPic", resource);
		*/

		map.add("rentPrice", String.valueOf((int)p.getRentPrice()));
		map.add("sellingPrice", String.valueOf((int)p.getSellingPrice()));
		map.add("ckbAvailable", String.valueOf(p.isAvailable()));

		HashMap<String, String> customHeaders = new HashMap<>();
		customHeaders.put("x-authorization-key", authKey);

		System.out.println("Removing AC from " + p.getPropertyName());

		ResponseObject responseObject = doHttp(url, map, MediaType.MULTIPART_FORM_DATA, customHeaders);
		Assert.assertNotNull(responseObject);
		Assert.assertEquals("Error while updating property", 1, responseObject.getSuccess());
		Assert.assertEquals(responseObject.getResponseString(), 0, responseObject.getResponseCode());

		System.out.println(responseObject.getResponseString());
	}


	private Property httpFetchProperty(String authKey, Long propertyId)
	{
		String url = "http://localhost:8080/rest/prop/fetch";
		MultiValueMap<String, Object> map= new LinkedMultiValueMap<String, Object>();

		map.add("propId", propertyId.toString());
		HashMap<String, String> customHeaders = new HashMap<>();
		customHeaders.put("x-authorization-key", authKey);

		ResponseObject responseObject = doHttp(url, map, MediaType.APPLICATION_FORM_URLENCODED, customHeaders);
		Assert.assertNotNull(responseObject);
		Assert.assertEquals("Error while fetching property", 1, responseObject.getSuccess());
		Assert.assertEquals(responseObject.getResponseString(), 0, responseObject.getResponseCode());

		Property property = (new Gson()).fromJson(responseObject.getResponseString(), Property.class);
		return  property;
	}


	private void httpAddProperty(String authKey, String propertyName)
	{
		String url = "http://localhost:8080/rest/prop/add";
		MultiValueMap<String, Object> map= new LinkedMultiValueMap<String, Object>();

		map.add("propName", propertyName);
		map.add("propType", "4");
		map.add("street", "Church St.");
		map.add("city", "Orlando");
		map.add("country", "USA");
		map.add("zipCode", "32801");
		map.add("lat", "28.53955735608056");
		map.add("lng", "-81.40510114337201");
		map.add("rooms", "5");
		map.add("baths", "3");
		map.add("storeys", "2");
		map.add("ckbAC", "true");
		map.add("ckbWasher", "true");
		map.add("ckbGym", "false");
		map.add("ckbGarage", "true");
		map.add("ckbParking", "false");

		Resource resource = new FileSystemResource("/var/www/propFinder/collection/pexels-photo-323775.jpeg");
		//map.add("Content-Type", "image/jpeg");
		map.add("mainPic", resource);

		map.add("rentPrice", "1400");
		map.add("sellingPrice", "0");
		map.add("ckbAvailable", "true");

		HashMap<String, String> customHeaders = new HashMap<>();
		customHeaders.put("x-authorization-key", authKey);

//		HttpHeaders headers = new HttpHeaders();
//		headers.setContentType(MediaType.MULTIPART_FORM_DATA);
//		headers.add("x-authorization-key", authKey);
//		HttpEntity<MultiValueMap<String, Object>> requestEntity = new HttpEntity<MultiValueMap<String, Object>>(map, headers);
//		ResponseObject responseObject = (new RestTemplate()).exchange(url, HttpMethod.POST, requestEntity, ResponseObject.class).getBody();

		ResponseObject responseObject = doHttp(url, map, MediaType.MULTIPART_FORM_DATA, customHeaders);
		Assert.assertNotNull(responseObject);
		Assert.assertEquals("Error while adding property", 1, responseObject.getSuccess());
		Assert.assertEquals(responseObject.getResponseString(), 0, responseObject.getResponseCode());
		System.out.println(responseObject.getResponseString());
	}



	private void httpFind()
	{
		String url = "http://localhost:8080/rest/prop/find";
		MultiValueMap<String, Object> map= new LinkedMultiValueMap<String, Object>();

		map.add("northBound", "29.0");
		map.add("eastBound", "-80.0");
		map.add("southBound", "27.0");
		map.add("westBound", "-82.0");
		map.add("customerScope", "RENT");
		map.add("propType", "7");
		map.add("fromDate", "");
		map.add("toDate", "");
		map.add("txtMinPrice", "0");
		map.add("txtMaxPrice", "1500");
		map.add("minRooms", "2");
		map.add("maxRooms", "5+");
		map.add("minBaths", "1");
		map.add("maxBaths", "3");
		map.add("ckbParking", "false");
		map.add("ckbGarage", "false");
		map.add("ckbWasher", "false");
		map.add("ckbAC", "true");
		map.add("ckbGym", "false");

		ResponseObject responseObject = doHttp(url, map, MediaType.APPLICATION_FORM_URLENCODED, null);

		Assert.assertNotNull(responseObject);
		Assert.assertEquals("Success should be 1 even if no properties found", 1, responseObject.getSuccess());

		Property[] properties = (new Gson()).fromJson(responseObject.getResponseString(), Property[].class);

		if (properties.length != 0)
			System.out.println("Finding properties...");
		else
			System.out.println("No result for your search filters");

		for (Property p: properties)
		{
			System.out.println("Found " + p.getPropertyName() + ", price = $" + p.getRentPrice());
		}

		System.out.println("--------------------------------------");
	}


	private ResponseObject doHttp(String url, MultiValueMap<String, Object> map, MediaType mediaType,
								  HashMap<String, String> customHeaders)
	{
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(mediaType);
		if (customHeaders != null)
		{
			Iterator it = customHeaders.entrySet().iterator();
			while (it.hasNext())
			{
				Map.Entry pair = (Map.Entry)it.next();
				headers.add(pair.getKey().toString(), pair.getValue().toString());
			}
		}

		HttpEntity<MultiValueMap<String, Object>> requestEntity = new HttpEntity<MultiValueMap<String, Object>>(map, headers);

		//ResponseObject responseObject = (new RestTemplate()).postForEntity(url, requestEntity, ResponseObject.class).getBody();
		ResponseObject responseObject = (new RestTemplate()).exchange(url, HttpMethod.POST, requestEntity, ResponseObject.class).getBody();
		return responseObject;
	}
}
