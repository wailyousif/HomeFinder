INSERT INTO public.address (id, city, country, street, zip_code) VALUES (3, 'Orlando', 'United States', '101 Garland Ave', '32801');
INSERT INTO public.address (id, city, country, street, zip_code) VALUES (5, 'Orlando', 'United States', '101 Garland Ave', '32801');
INSERT INTO public.address (id, city, country, street, zip_code) VALUES (9, 'Orlando', 'United States', 'Church Street', '32801');
INSERT INTO public.address (id, city, country, street, zip_code) VALUES (14, 'Orlando', 'United States', 'Orange Street', '32812');
INSERT INTO public.address (id, city, country, street, zip_code) VALUES (16, 'Orlando', 'United States', 'N Rosalind Avenue SkyHouse Apartments', '32808');
INSERT INTO public.address (id, city, country, street, zip_code) VALUES (20, 'Orlando', 'United States', 'E Orlando St', '32807');

INSERT INTO public.contact_info (id, email, phone, address_id) VALUES (2, 'wail.yousif@hotmail.com', '+15001231111', 3);
INSERT INTO public.contact_info (id, email, phone, address_id) VALUES (13, 'wailpc@hotmail.com', '+5001232222', 14);

INSERT INTO public.location (id, lat, lng) VALUES (6, 28.54092963583109, -81.38059821718343);
INSERT INTO public.location (id, lat, lng) VALUES (10, 28.539890050457164, -81.38650524590048);
INSERT INTO public.location (id, lat, lng) VALUES (17, 28.54700765914462, -81.37667709575908);
INSERT INTO public.location (id, lat, lng) VALUES (21, 28.57333636786317, -81.37395197156366);

INSERT INTO public.app_user (id, display_name, email, gender, name, password, personal_id, user_type, contact_info_id) VALUES (1, 'Owner1', 'wail.yousif@hotmail.com', 'M', 'FirstName1 MiddleName1 LastName1', '5RxZ7fFBOt0ifczFeZWxzjC/YZv3BED6YN26CwBaHPBRQwzLYy5o4MLXJgtNft8w6Q0Y/eXPnN/joNfEs1gSWg==', '13579', 'O', 2);
INSERT INTO public.app_user (id, display_name, email, gender, name, password, personal_id, user_type, contact_info_id) VALUES (12, 'Owner2', 'wailpc@hotmail.com', 'M', 'FirstName2 MiddleName2 LastName2', 'TtilE3S3edN7/qkXWpn2roEn+0IouWSF3xeneExBQe63wptxcXGszpkxNNt9wkVwYITvQupXjj6nBOkNX8uJwQ==', '86420', 'O', 13);

INSERT INTO public.property (id, ac, available, available_by, baths, creation_time, garage, gym, parking, pic, property_name, property_type, rent_price, rooms, selling_price, storeys, update_time, washer, address_id, app_user_id, location_id) VALUES (4, false, true, '2017-03-30 10:03:52.196000', 2, '2017-03-30 10:03:52.196000', false, true, true, 'apartment-1.jpeg', 'Owner1_Property1', 2, 1200, 3, 0, 1, '2017-03-30 10:03:52.196000', true, 5, 1, 6);
INSERT INTO public.property (id, ac, available, available_by, baths, creation_time, garage, gym, parking, pic, property_name, property_type, rent_price, rooms, selling_price, storeys, update_time, washer, address_id, app_user_id, location_id) VALUES (8, true, true, '2017-03-30 10:08:19.126000', 2, '2017-03-30 10:08:19.126000', true, false, false, 'pexels-photo-323780.jpeg', 'Owner1_Property2', 4, 1500, 5, 750000, 2, '2017-03-30 10:08:19.126000', true, 9, 1, 10);
INSERT INTO public.property (id, ac, available, available_by, baths, creation_time, garage, gym, parking, pic, property_name, property_type, rent_price, rooms, selling_price, storeys, update_time, washer, address_id, app_user_id, location_id) VALUES (15, true, true, '2017-03-30 10:22:41.822000', 2, '2017-03-30 10:22:41.822000', false, true, true, 'apartment-2.jpeg', 'Owner2_Property1', 2, 1000, 2, 0, 1, '2017-03-30 10:22:41.822000', true, 16, 12, 17);
INSERT INTO public.property (id, ac, available, available_by, baths, creation_time, garage, gym, parking, pic, property_name, property_type, rent_price, rooms, selling_price, storeys, update_time, washer, address_id, app_user_id, location_id) VALUES (19, true, true, '2017-03-30 10:29:37.017000', 2, '2017-03-30 10:29:37.017000', false, true, true, 'apartment-4.jpeg', 'Owner2_Property2', 2, 1100, 3, 0, 1, '2017-03-30 10:29:37.017000', true, 20, 12, 21);
