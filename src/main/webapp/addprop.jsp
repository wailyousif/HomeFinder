<%@ page import="com.ironyard.data.AppUser" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>

<!DOCTYPE HTML>
<html style="font-family: Arial, sans-serif; height: 100%; margin: 0; padding: 0;">
<head>
    <title>Add Property</title>

    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" />

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

    <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAuwBHyQj98YaM0fFhdlJma1Zp2XUayFRk&v=3"></script>
    <script type="text/javascript" src="GMapOverlay.js"></script>
    <script type="text/javascript" src="utils.js"></script>

    <script type="text/javascript" src="bootstrap-select.min.js"></script>

    <link rel="stylesheet" href="css/layout.css" />
    <link rel="stylesheet" href="css/bootstrap-select.min.css" />

    <script type="text/javascript">
        $(document).ready
        (
            function()
            {
                $("#frmAddProp").submit
                (
                    function(ev)
                    {
                        ev.preventDefault();

                        var okMsgBoxHtml = '<br /><br /><button id="popupOKButton" type="button" class="btn btn-warning" onclick="hidePopup(0,0);">OK</button>';

                        var propName = document.getElementById('propName').value;
                        if (propName.length < 2)
                        {
                            showPopup('', 'Property name is anonymous.' + okMsgBoxHtml);
                            return;
                        }

                        var lat = document.getElementById('lat').value;
                        if (lat > 90 || lat < -90)
                        {
                            showPopup('', 'Latitude ranges between -90 and 90. Please select your location accurately.' + okMsgBoxHtml);
                            return;
                        }
                        var lng = document.getElementById('lng').value;
                        if (lng > 180 || lng < -180)
                        {
                            showPopup('', 'Longitude ranges between -180 and 180. Please select your location accurately.' + okMsgBoxHtml);
                            return;
                        }

                        var rooms = document.getElementById('rooms').value;
                        if (rooms == null)
                            rooms = 0;
                        if (rooms < 1)
                        {
                            showPopup('', 'Number of rooms must be at least 1.' + okMsgBoxHtml);
                            return;
                        }
                        var baths = document.getElementById('baths').value;
                        if (baths == null)
                            baths = 0;
                        if (baths < 1)
                        {
                            showPopup('', 'Number of baths must be at least 1.' + okMsgBoxHtml);
                            return;
                        }
                        var storeys = document.getElementById('storeys').value;
                        if (storeys == null)
                            storeys = 0;
                        if (storeys < 1)
                        {
                            showPopup('', 'Number of storeys must be at least 1.' + okMsgBoxHtml);
                            return;
                        }

                        var mainPic = document.getElementById('mainPic').value;
                        if (mainPic === '')
                        {
                            showPopup('', 'You must upload the main picture of your property.' + okMsgBoxHtml);
                            return;
                        }

                        var rentPrice = moneyToNumber(document.getElementById('txtRentPrice').value);
                        var sellingPrice = moneyToNumber(document.getElementById('txtSellingPrice').value);
                        if (rentPrice == 0 && sellingPrice == 0)
                        {
                            showPopup('', 'Rent price and Sale price can\'t be both zeros.' + okMsgBoxHtml);
                            return;
                        }

                        var available = checked('ckbAvailable');
                        if (available == false)
                        {
                            showPopup('', 'The property is marked unavailable. To make it available for seekers, you can update its availability from the (Manage Property) tab.' + okMsgBoxHtml);
                        }


                        var objFormData = new FormData();
                        objFormData.append('propName', propName.trim());
                        objFormData.append('propType', getPropTypeBinary());

                        objFormData.append('street', (document.getElementById('street').value).trim());
                        objFormData.append('city', (document.getElementById('city').value).trim());
                        objFormData.append('country', (document.getElementById('country').value).trim());
                        objFormData.append('zipCode', (document.getElementById('zipCode').value).trim());

                        objFormData.append('lat', lat);
                        objFormData.append('lng', lng);

                        objFormData.append('rooms', rooms);
                        objFormData.append('baths', baths);
                        objFormData.append('storeys', storeys);

                        objFormData.append('ckbAC', checked('ckbAC'));
                        objFormData.append('ckbWasher', checked('ckbWasher'));
                        objFormData.append('ckbGym', checked('ckbGym'));
                        objFormData.append('ckbGarage', checked('ckbGarage'));
                        objFormData.append('ckbParking', checked('ckbParking'));

                        jQuery.each(jQuery('#mainPic')[0].files, function(i, file) {
                            objFormData.append('mainPic', file);
                        });

                        objFormData.append('rentPrice', rentPrice);
                        objFormData.append('sellingPrice', sellingPrice);

                        objFormData.append('ckbAvailable', available);

                        $.ajax
                        (
                            {
                                cache: false,
                                type: "POST",
                                contentType: false,
                                url: "/rest/prop/add",
                                data: objFormData,
                                processData: false,
                                success: function(respObj)
                                {
                                    if (respObj.success == 1 && respObj.responseCode == 0)
                                    {
                                        showPopup('', respObj.responseString + okMsgBoxHtml);
                                    }
                                    else
                                    {
                                        showPopup('', respObj.responseString + okMsgBoxHtml);
                                    }
                                },
                                error: function(XMLHttpRequest, textStatus, errorThrown)
                                {
                                    showPopup('', 'Could not add your property. Error: ' + textStatus + okMsgBoxHtml);
                                }
                            }
                        )
                    }
                );
            }
        );
    </script>
    <script type="text/javascript">
        var map;
        var currentLoc;
        var propMarker = null;
        var dblClickTimer;
        var dblClickTimeout = 300;

        var MAX_ZOOM_LEVEL = 21;
        var MIN_ZOOM_LEVEL = 1;
        var FETCH_LOCATION_ZOOM_LEVEL = 18;

        function initMap()
        {
            currentLoc = {lat: 20.0, lng: 10.0};

            map = new google.maps.Map(document.getElementById('sizedmap'), {
                center: currentLoc,
                zoom: MIN_ZOOM_LEVEL,
                mapTypeControl: false,
                clickableIcons: false,
                streetViewControl: false
                //mapTypeId: google.maps.MapTypeId.HYBRID
                //styles: mapStyles
            });


            var relocateButton = create_Relocate_Button(map);
            relocateButton.addEventListener('click', function() {
                getCurrentLocation();
            });
            //map.setTilt(45);

            var latLngDiv = create_LatLng_Div(map);

            google.maps.event.addListener(map, "click", function (e) {
                var latLng = e.latLng;
                document.getElementById('lat').value = latLng.lat();
                document.getElementById('lng').value = latLng.lng();

                //place marker if not double-click using timeout
                dblClickTimer = setTimeout(function () {
                    if (propMarker != null)
                        propMarker.setMap(null);
                    propMarker = new google.maps.Marker({
                        position: latLng,
                        map: map
                    });
                }, dblClickTimeout);
            });


            google.maps.event.addListener(map, "dblclick", function (e) {
                clearTimeout(dblClickTimer);
            });


            google.maps.event.addListenerOnce(map, 'idle', function() {
                //getCurrentLocation();
            });

            google.maps.event.addListener(map, 'tilesloaded', function() {
                //document.getElementById('sizedmap').style.position = 'static';
                //document.getElementById('sizedmap').style.background = 'none';
            });

            google.maps.event.addListener(map, 'bounds_changed', function() {
                var lat = map.getCenter().lat();
                lat = Number(lat.toFixed(4));
                var lng = map.getCenter().lng();
                lng = Number(lng.toFixed(4));
                latLngDiv.innerHTML = 'Lat:' + lat + '<br />Lon:' + lng;
            });

            google.maps.event.addListener(map, 'zoom_changed', function() {
                if (this.getZoom() > MAX_ZOOM_LEVEL)
                {
                    this.setZoom(MAX_ZOOM_LEVEL);
                }
                else if (this.getZoom() < MIN_ZOOM_LEVEL)
                {
                    this.setZoom(MIN_ZOOM_LEVEL);
                }
            });

            google.maps.event.trigger(map, 'resize');
        }

        function showPopup(title, text)
        {
            //hidePopup(0, 0);
            $('#myPopup #pTitle').html(title);
            $('#myPopup #pText').html(text);
            $('#myPopup').fadeIn(350);

            var popupOKButton = document.getElementById('popupOKButton');
            if (popupOKButton != null)
            {
                popupOKButton.focus();
            }
        }

        function hidePopup(delayTime, fadeoutTime)
        {
            $('#myPopup').delay(delayTime).fadeOut(fadeoutTime);
        }

        function getCurrentLocation()
        {
            showPopup("", "Fetching your current location...<br />Please wait");

            if (navigator.geolocation)
            {
                navigator.geolocation.getCurrentPosition(
                    function(position)
                    {
                        currentLoc = {lat: position.coords.latitude, lng: position.coords.longitude};
                        map.setZoom(FETCH_LOCATION_ZOOM_LEVEL);
                        setLocation(currentLoc, '');
                    },
                    function()
                    {
                        hidePopup(0, 0);
                        showPopup('', 'Failed to get your location. Please zoom to your location manually using the map.' + okMsgBoxHtml);
                    },
                    { maximumAge: 3000, timeout: 5000 }
                );
            }
            else
            {
                hidePopup(0, 0);
                showPopup('', 'Your browser does not support geolocation. Please zoom to your location manually using the map.' + okMsgBoxHtml);
            }
        }


        function setLocation(currentLoc, notificationMsg)
        {
            map.setCenter(new google.maps.LatLng(currentLoc.lat, currentLoc.lng));
            //map.setCenter(currentLoc);
            if (notificationMsg.length > 0)
            {
                hidePopup(0, 0);
                showPopup("", notificationMsg);
                hidePopup(3000, 2000);
            }
            else
            {
                hidePopup(1000, 2000);
            }
            document.getElementById('lat').value = currentLoc.lat;
            document.getElementById('lng').value = currentLoc.lng;
        }


        google.maps.event.addDomListener(window, 'load', initMap);
    </script>
    <script type="text/javascript">
        $(document).ready(function() {
            var okMsgBoxHtml = '<br /><br /><button id="popupOKButton" type="button" class="btn btn-warning" onclick="hidePopup(0,0);">OK</button>';
            var userType = '<%= ((AppUser)session.getAttribute("appUser")).getUserType() %>';
            if (userType !== 'O')
            {
                document.getElementById('btnAdd').disabled = true;
                showPopup('', 'You need to be registered as properties\' owner to add properties. Go to (Manage Account) tab to change your account type.' + okMsgBoxHtml);
            }
            $("#propName").focus();
        });
    </script>
    <script type="text/javascript">
        $(document).ready(function() {
            $(".positiveInt").keydown(function (e) {
                // Allow: backspace, delete, tab, escape and enter
                if ($.inArray(e.keyCode, [46, 8, 9, 27, 13]) !== -1 ||
                    // Allow: home, end, left, right, down, up
                    (e.keyCode >= 35 && e.keyCode <= 40)) {
                    // let it happen, don't do anything
                    return;
                }
                // Ensure that it is a number and stop the keypress
                if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
                    e.preventDefault();
                }
            });
        });
    </script>
    <script type="text/javascript">
        $(document).ready(function() {
            $(".signedDecimal").keydown(function (e) {
                // Allow: backspace, delete, tab, escape, enter
                if ($.inArray(e.keyCode, [46, 8, 9, 27, 13]) !== -1 ||
                    // Allow: home, end, left, right, down, up
                    (e.keyCode >= 35 && e.keyCode <= 40)) {
                    // let it happen, don't do anything
                    return;
                }

                var val = ($(this)).val();

                //Allow one period
                if (e.keyCode == 190) {
                    var count = (val.match(/\./g) || []).length;
                    if (count == 0)
                        return;
                    else
                        e.preventDefault();
                }

                //Allow one negative sign
                if (e.keyCode == 189) {
                    var count = (val.match(/-/g) || []).length;
                    if (count == 0)
                        return;
                    else
                        e.preventDefault();
                }

                // Ensure that it is a number and stop the keypress
                if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
                    e.preventDefault();
                }
            });
        });
    </script>
    <script type="text/javascript">
        function getSelectValue(controlId)
        {
            var ctrl = document.getElementById(controlId);
            var selectedValue = ctrl.options[ctrl.selectedIndex].value;
            return selectedValue;
        }
    </script>
    <script type="text/javascript">
        $(document).ready(function() {
            $("#propType").on('change', function() {

                //var propType = document.getElementById('propType');
                //var selectedValue = propType.options[propType.selectedIndex].value;
                var selectedValue = getSelectValue('propType');

                var txtRooms = document.getElementById('rooms');
                var txtBaths = document.getElementById('baths');
                if (selectedValue === 'STUDIO')
                {
                    txtRooms.value = '1';
                    txtRooms.disabled = true;
                    txtBaths.value = '1';
                    txtBaths.disabled = true;
                }
                else
                {
                    txtRooms.value = '';
                    txtRooms.disabled = false;
                    txtBaths.value = '';
                    txtBaths.disabled = false;
                }

                var txtStoreys = document.getElementById('storeys');
                if (selectedValue === 'HOUSE')
                {
                    txtStoreys.value = '';
                    txtStoreys.disabled = false;
                }
                else
                {
                    txtStoreys.value = '1';
                    txtStoreys.disabled = true;
                }
            });
        });
    </script>
    <script type="text/javascript">
        function disableEnable(controlId)
        {
            var ctrl = document.getElementById(controlId);
            if (ctrl.disabled == false)
            {
                ctrl.disabled = true;
                if (controlId === 'txtRentPrice' || controlId === 'txtSellingPrice')
                    ctrl.value = '$0';
                else
                    ctrl.value = '';
            }
            else
            {
                ctrl.disabled = false;
                if (controlId === 'txtRentPrice' || controlId === 'txtSellingPrice')
                    ctrl.value = '$';
            }
        }
    </script>
    <script type="text/javascript">
        $(document).ready(function(){
            $(".money").keyup(function(event){

                var currentValue = ($(this)).val();

                /*
                var currentValueWoDollarSign = currentValue.replace('$', '');
                var strNumericValue = currentValueWoDollarSign.replace(/,/gi, '');

                var digitGrouped = '$';
                if (strNumericValue !== '')
                {
                    var numericValue = Number(strNumericValue);
                    digitGrouped = digitGrouped + numericValue.toLocaleString();
                }
                */

                ($(this)).val(numberToMoney(currentValue));
            });
        });
    </script>
</head>
<body style="font-family: Arial, sans-serif; height: 100%; margin: 0; padding: 0;">

<nav class="navbar navbar-inverse navbar-fixed-top">
    <div class="container-fluid">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="#">
                <img style="max-width: 100%; max-height: 100%;" src="/images/tiy-logo.png" alt="The Iron Yard - Orlando" />
            </a>
        </div>
        <div class="collapse navbar-collapse" id="myNavbar">
            <ul class="nav navbar-nav">
                <li><a href="/mvc/prop/find"><span class="glyphicon glyphicon-search"></span> Find Property</a></li>
                <li class="active"><a href="#"><span class="glyphicon glyphicon-plus-sign"></span> Add Property</a></li>
                <li><a href="/mvc/prop/edit"><span class="glyphicon glyphicon-home"></span> Manage Property</a></li>
            </ul>
            <ul class="nav navbar-nav navbar-right">
                <% if (request.getSession().getAttribute("appUser") == null) { %>
                <li style="display: inline;"><a href="/mvc/user/add"><span class="glyphicon glyphicon-user"></span> Sign Up</a></li>
                <li style="display: inline;"><a href="/mvc/user/login"><span class="glyphicon glyphicon-log-in"></span> Login</a></li>
                <% } else { %>
                <li style="display: inline;"><a href="/mvc/user/edit"><span class="glyphicon glyphicon-th"></span> Manage Account</a></li>
                <li style="display: inline;"><a href="/mvc/user/logout"><span class="glyphicon glyphicon-log-out"></span> Logout</a></li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>


<div id="myPopup" class="popup" data-popup="popup-1">
    <div class="popup-inner">
        <div id="pTitle" style="text-align: center;"></div>
        <div id="pText" style="text-align: center;">
        </div>
        <a id="popupClose" onclick="hidePopup(0,0);" class="popup-close" data-popup-close="popup-1" href="#">x</a>
    </div>
</div>

<div class="row h100" style="margin-top: 50px; position: relative; overflow: auto;">
    <div class="col-xs-offset-1 col-xs-8 h100">
        <h2>Add New Property</h2>
        <hr />

        <form id="frmAddProp" class="h100">
            <fieldset>
                <legend><h3>Basic Info</h3></legend>
                <div class="row">
                    <div class="col-xs-12">
                        <label for="propName">Property Name:</label>
                        <input type="text" id="propName" name="propName" placeholder="Just any name of your choice. This name appears to property seekers." class="form-control" value="" maxlength="32" />
                    </div>
                </div>
                <br />
                <div class="row">
                    <div class="col-xs-12">
                        <label for="propType">Type:</label>
                        <select id="propType" name="propType" class="form-control selectpicker">
                            <option value="APARTMENT" selected>Apartment</option>
                            <option value="HOUSE">House</option>
                            <option value="STUDIO">Studio</option>
                        </select>
                    </div>
                </div>
                <br />
            </fieldset>
            <br />
            <fieldset class="h100">
                <legend><h3>Address and Location</h3></legend>
                <div class="row">
                    <div class="col-xs-12">
                        <label for="street">Street:</label>
                        <input type="text" id="street" name="street" placeholder="Street" class="form-control" value="" maxlength="64" />
                    </div>
                </div>
                <br />
                <div class="row">
                    <div class="col-xs-4">
                        <label for="city">City:</label>
                        <input type="text" id="city" name="city" placeholder="City" class="form-control" value="" maxlength="32" />
                    </div>
                    <div class="col-xs-4">
                        <label for="country">Country:</label>
                        <input type="text" id="country" name="country" placeholder="Country" class="form-control" value="" maxlength="32" />
                    </div>
                    <div class="col-xs-4">
                        <label for="zipCode">Zip/Postal Code:</label>
                        <input type="text" id="zipCode" name="zipCode" placeholder="Zip/Postal Code" class="form-control" value="" maxlength="6" />
                    </div>
                </div>
                <br /><br />
                <div class="row h100">
                    <div class="col-xs-5">
                        <p>Click on the exact location of your property on the map to specify
                            the latitude and longitude of your property. You can also click on
                            (Relocate) button to approximately fetch your current location.
                            Double-click and right-click can be used to zoom-in and zoom-out.</p>
                        <p><b>Note:</b> (Relocate) button may not be very accurate in fetching
                            your current location.</p>

                        <br />
                        <label for="lat">Latitude:</label>
                        <input type="text" id="lat" name="lat" placeholder="Latitude" class="form-control signedDecimal" value="" />
                        <br />
                        <label for="lng">Longitude:</label>
                        <input type="text" id="lng" name="lng" placeholder="Longitude" class="form-control signedDecimal" value="" />
                    </div>
                    <div class="col-xs-7 h100">
                        <div style="height: 62%;" id="sizedmap"></div>
                    </div>
                </div>
                <br />
            </fieldset>
            <br /><br /><br /><br />
            <fieldset>
                <legend><h3>Main Specifications</h3></legend>
                <div class="row">
                    <div class="col-xs-12">
                        <label for="rooms">Rooms:</label>
                        <input type="text" id="rooms" name="rooms" placeholder="Number of rooms" class="form-control positiveInt" value="1" maxlength="3" />
                    </div>
                </div>
                <br />
                <div class="row">
                    <div class="col-xs-12">
                        <label for="baths">Baths:</label>
                        <input type="text" id="baths" name="baths" placeholder="Number of Baths" class="form-control positiveInt" value="1" maxlength="3" />
                    </div>
                </div>
                <br />
                <div class="row">
                    <div class="col-xs-12">
                        <label for="storeys">Storeys:</label>
                        <input type="text" id="storeys" name="storeys" placeholder="Number of Storeys" class="form-control positiveInt" value="1" maxlength="3" disabled/>
                    </div>
                </div>
                <br />
            </fieldset>
            <br />
            <fieldset>
                <legend><h3>Amenities</h3></legend>
                <div class="row">
                    <div class="col-xs-4"><label><input id="ckbAC" type="checkbox" value="" />Air Conditioning</label></div>
                    <div class="col-xs-4"><label><input id="ckbWasher" type="checkbox" value="" />Washer</label></div>
                    <div class="col-xs-4"><label><input id="ckbGym" type="checkbox" value="" />Gym</label></div>
                </div>
                <br />
                <div class="row">
                    <div class="col-xs-4"><label><input id="ckbGarage" type="checkbox" value="" />Garage</label></div>
                    <div class="col-xs-4"><label><input id="ckbParking" type="checkbox" value="" />Parking</label></div>
                </div>
                <br />
            </fieldset>
            <br />
            <fieldset>
                <legend><h3>Pictures</h3></legend>
                <div class="row">
                    <div class="col-xs-12">
                        <label for="mainPic">Main Pic:</label> (This will be the main pic that users see while searching)
                        <input type="file" class="form-control" id="mainPic" name="mainPic" />
                    </div>
                </div>
                <br />
            </fieldset>
            <br />
            <fieldset>
                <legend><h3>Pricing</h3></legend>
                <p>Home Finder gives you the ability to offer your property for rent and sale
                    simultaenously.<br />The prices you set will be visible to home seekers.
                    Prices are in US Dollar.</p>
                <br />
                <div class="row">
                    <div class="col-xs-12">
                        <label><input id="ckbRentPrice" type="checkbox" value="" onclick="disableEnable('txtRentPrice');" checked/>For Rent</label>
                        <input id="txtRentPrice" class="form-control positiveInt money" type="text" placeholder="Rent Price" value="$" maxlength="9" />
                    </div>
                </div>
                <br />
                <div class="row">
                    <div class="col-xs-12">
                        <label><input id="ckbSellingPrice" type="checkbox" value="" onclick="disableEnable('txtSellingPrice');" />For Sale</label>
                        <input id="txtSellingPrice" class="form-control positiveInt money" type="text" placeholder="Sale Price" value="$0" maxlength="14" disabled/>
                    </div>
                </div>
                <br />
            </fieldset>
            <hr />
            <label><input id="ckbAvailable" type="checkbox" value="" checked/>Currently available</label>

            <hr />
            <br />
            <div class="row">
                <div class="col-xs-12">
                    <input id="btnAdd" type="submit" class="btn btn-info" value="Add Property" />
                </div>
            </div>
            <br />
        </form>
    </div>
    <div class="col-xs-3">
        <div style="font-size: smaller; color: darkcyan; text-align: center;">
            <br />
            <%
                if (request.getSession().getAttribute("appUser") != null)
                {
                    out.println("Welcome " + ((AppUser)request.getSession().getAttribute("appUser")).getDisplayName());
                }
            %>
        </div>
    </div>
</div>

<br /><br />
<footer>
    <div class="col-xs-12 text-center">
        <b>Home Finder</b>
    </div>
</footer>

</body>
</html>