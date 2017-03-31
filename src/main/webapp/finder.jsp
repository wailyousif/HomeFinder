<%@ page import="com.ironyard.data.AppUser" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>

<!DOCTYPE HTML>
<html style="font-family: Arial, sans-serif; height: 100%; margin: 0; padding: 0;">
<head>
    <title>Find Property</title>

    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" />

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

    <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAuwBHyQj98YaM0fFhdlJma1Zp2XUayFRk&v=3"></script>
    <script type="text/javascript" src="GMapOverlay.js"></script>
    <script type="text/javascript" src="utils.js"></script>

    <link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css" />
    <!--<link rel="stylesheet" href="/resources/demos/style.css" />-->
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

    <script type="text/javascript" src="bootstrap-select.min.js"></script>

    <link rel="stylesheet" href="css/layout.css" />
    <link rel="stylesheet" href="css/bootstrap-select.min.css" />

    <script>
        $(document).ready(function(){
            $('[data-toggle="tooltip"]').tooltip();
        });
    </script>
    <script>
        $( function() {
            $( ".jqDatePicker" ).datepicker({
                changeMonth: true,
                changeYear: true,
                minDate: 0,
                showButtonPanel: true,
                showWeek: true
            });
        } );
    </script>
    <script type="text/javascript">
        function setCookie(cname, cvalue, exdays) {
            var d = new Date();
            d.setTime(d.getTime() + (exdays * 24 * 60 * 60 * 1000));
            var expires = "expires="+d.toUTCString();
            document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
        }

        function setCookieForMinutes(cname, cvalue, exmin) {
            var d = new Date();
            d.setTime(d.getTime() + (exmin * 60 * 1000));
            var expires = "expires="+d.toUTCString();
            document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
        }

        function getCookie(cname) {
            var name = cname + "=";
            var ca = document.cookie.split(';');
            for(var i = 0; i < ca.length; i++) {
                var c = ca[i];
                while (c.charAt(0) == ' ') {
                    c = c.substring(1);
                }
                if (c.indexOf(name) == 0) {
                    return c.substring(name.length, c.length);
                }
            }
            return "";
        }
    </script>
    <script type="text/javascript">
        function createFakeUUID()
        {
            function s4() {
                return Math.floor((1 + Math.random()) * 0x10000)
                    .toString(16)
                    .substring(1);
            }
            return s4() + s4() + '-' + s4() + '-' + s4() + '-' +
                s4() + '-' + s4() + s4() + s4();
        }
    </script>
    <script type="text/javascript">
        $(document).ready(function() {
            $(".jqDatePicker").keydown(function (e) {
                e.preventDefault();
            });
        });
    </script>
    <script type="text/javascript">
        $(document).ready(function() {
            $("#customerScope").on('change', function() {
                var toDate = document.getElementById('toDate');
                if (this.value == 'BUY') {
                    toDate.disabled = true;
                    toDate.value = '';
                }
                else {
                    toDate.disabled = false;
                }
            });
        });
    </script>
    <script type="text/javascript">
        $(document).ready(function() {
            $("#propType").on('change', function() {
                var options = this.options;
                var onlyStudioSelected = 0;
                if ($("#propType :selected").length == 1)
                {
                    if (options[0].selected == true && options[0].value == 'STUDIO')
                    {
                        onlyStudioSelected = 1;
                    }
                }
                if (onlyStudioSelected == 1)
                {
                    var mainSpecsPanel = document.getElementById('mainSpecsPanel');
                    mainSpecsPanel.style.display = 'none';
                }
                else
                {
                    var mainSpecsPanel = document.getElementById('mainSpecsPanel');
                    mainSpecsPanel.style.display = 'inline';
                }
            });
        });
    </script>
    <script type="text/javascript">
        function getMultiSelectValues(controlId)
        {
            var ctrl = document.getElementById(controlId);
            var options = ctrl.options;
            var selPropTypes = '';
            for (var i=0; i < options.length; i++)
            {
                if (options[i].selected)
                {
                    selPropTypes = selPropTypes + options[i].value + ',';
                }
            }
            return selPropTypes;
        }
    </script>
    <script type="text/javascript">
        function getServiceMeters(ckbControlId, txtControlId)
        {
            var ckb = document.getElementById(ckbControlId);
            if (!ckb.checked)
            {
                return -1;
            }
            else
            {
                var meters = document.getElementById(txtControlId).value;
                if (meters == '')
                    meters = -2;

                return meters;
            }
        }
    </script>
    <script type="text/javascript">
        $(document).ready(function() {
            $("#popupClose").on('click', function() {
                hidePopup(0, 0);
            });
        });
    </script>
    <script type="text/javascript">
        function simulateShortSleep(delaySecs)
        {
            var now = new Date();
            var desiredTime = new Date().setSeconds(now.getSeconds() + delaySecs);
            while (now < desiredTime)
            {
                now = new Date();
            }
        }
    </script>
    <script type="text/javascript">
        $(document).ready
        (
            function()
            {
                $("#frmFindHomes").submit
                (
                    function(ev)
                    {
                        ev.preventDefault();

                        var okMsgBoxHtml = '<br /><br /><button id="popupOKButton" type="button" class="btn btn-warning" onclick="hidePopup(0,0);">OK</button>';

                        if ($("#propType :selected").length == 0)
                        {
                            showPopup('', 'Please select a Property Type.' + okMsgBoxHtml);
                            return;
                        }

                        var convenienceStoreMeters = getServiceMeters('ckbConvenienceStore', 'txtConvenienceStore');
                        if (convenienceStoreMeters == -2) { showPopup('', 'Please set a max distance for Convenience Stores, or uncheck it' + okMsgBoxHtml); return; }

                        var bakeryMeters = getServiceMeters('ckbBakery','txtBakery');
                        if (bakeryMeters == -2) { showPopup('', 'Please set a max distance for Bakeries, or uncheck it' + okMsgBoxHtml); return; }

                        var laundryMeters = getServiceMeters('ckbLaundry','txtLaundry');
                        if (laundryMeters == -2) { showPopup('', 'Please set a max distance for Laundries, or uncheck it' + okMsgBoxHtml); return; }

                        var restaurantMeters = getServiceMeters('ckbRestaurant','txtRestaurant');
                        if (restaurantMeters == -2) { showPopup('', 'Please set a max distance for Restaurants, or uncheck it' + okMsgBoxHtml); return; }

                        var pharmacyMeters = getServiceMeters('ckbPharmacy','txtPharmacy');
                        if (pharmacyMeters == -2) { showPopup('', 'Please set a max distance for Pharmacies, or uncheck it' + okMsgBoxHtml); return; }

                        var trainStationMeters = getServiceMeters('ckbTrainStation','txtTrainStation');
                        if (trainStationMeters == -2) { showPopup('', 'Please set a max distance for Train Station, or uncheck it' + okMsgBoxHtml); return; }

                        var busStationMeters = getServiceMeters('ckbBusStation','txtBusStation');
                        if (busStationMeters == -2) { showPopup('', 'Please set a max distance for Bus Station, or uncheck it' + okMsgBoxHtml); return; }

                        var objFormData = new FormData();
                        objFormData.append('northBound', map.getBounds().getNorthEast().lat());
                        objFormData.append('eastBound', map.getBounds().getNorthEast().lng());
                        objFormData.append('southBound', map.getBounds().getSouthWest().lat());
                        objFormData.append('westBound', map.getBounds().getSouthWest().lng());

                        objFormData.append('customerScope', document.getElementById('customerScope').value);
                        objFormData.append('propType', getPropTypeBinary());
                        objFormData.append('fromDate', document.getElementById('fromDate').value);
                        objFormData.append('toDate', document.getElementById('toDate').value);
                        objFormData.append('txtMinPrice', document.getElementById('txtMinPrice').value);
                        objFormData.append('txtMaxPrice', document.getElementById('txtMaxPrice').value);

                        objFormData.append('minRooms', document.getElementById('minRooms').value);
                        objFormData.append('maxRooms', document.getElementById('maxRooms').value);
                        objFormData.append('minBaths', document.getElementById('minBaths').value);
                        objFormData.append('maxBaths', document.getElementById('maxBaths').value);

                        objFormData.append('txtConvenienceStore', convenienceStoreMeters);
                        objFormData.append('txtBakery', bakeryMeters);
                        objFormData.append('txtLaundry', laundryMeters);
                        objFormData.append('txtRestaurant', restaurantMeters);
                        objFormData.append('txtPharmacy', pharmacyMeters);
                        objFormData.append('txtTrainStation', trainStationMeters);
                        objFormData.append('txtBusStation', busStationMeters);

                        objFormData.append('ckbParking', checked('ckbParking'));
                        objFormData.append('ckbGarage', checked('ckbGarage'));
                        objFormData.append('ckbWasher', checked('ckbWasher'));
                        objFormData.append('ckbAC', checked('ckbAC'));
                        objFormData.append('ckbGym', checked('ckbGym'));

                        var minWaitPopupShowDuration = 2000;    //milliseconds
                        var waitPopupShown = 0;
                        var waitPopupShownAt;
                        var longWaitTimer = setTimeout(function () {
                            showPopup('', '<img src="/images/plzWait.gif" />');
                            waitPopupShown = 1;
                            waitPopupShownAt = (new Date).getTime();
                        }, 200);
                        var execAfterMS = 0;

                        clearPlaces();
                        clearProperties();

                        $.ajax
                        (
                            {
                                cache: false,
                                type: "POST",
                                contentType: false,
                                url: "/rest/prop/find",
                                data: objFormData,
                                processData: false,
                                success: function(respObj)
                                {
                                    clearTimeout(longWaitTimer);
                                    if (waitPopupShown == 1)
                                    {
                                        var waitPopupShownDuration =  ((new Date).getTime()) - waitPopupShownAt;
                                        if (waitPopupShownDuration < minWaitPopupShowDuration)
                                            execAfterMS = minWaitPopupShowDuration - waitPopupShownDuration;
                                    }
                                    setTimeout(function() {
                                        hidePopup(0, 0);
                                        //alert(respObj.responseString);
                                        if (respObj.success == 1 && respObj.responseCode == 0)
                                        {
                                            window.jsonObj = $.parseJSON(respObj.responseString);
                                            showProperties();
                                        }
                                        else
                                        {
                                            showPopup('', respObj.responseString + okMsgBoxHtml);
                                        }
                                    }, execAfterMS);
                                },
                                error: function(XMLHttpRequest, textStatus, errorThrown)
                                {
                                    clearTimeout(longWaitTimer);
                                    if (waitPopupShown == 1)
                                    {
                                        var waitPopupShownDuration =  ((new Date).getTime()) - waitPopupShownAt;
                                        if (waitPopupShownDuration < minWaitPopupShowDuration)
                                            execAfterMS = minWaitPopupShowDuration - waitPopupShownDuration;
                                    }
                                    setTimeout(function () {
                                        hidePopup(0, 0);
                                        showPopup('', 'Failed to get homes. Error: ' + textStatus + okMsgBoxHtml);
                                    }, execAfterMS);
                                }
                            }
                        )
                    }
                );
            }
        );
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
        function getURLParameter(sParam)
        {
            var sPageURL = window.location.search.substring(1);
            var sURLVariables = sPageURL.split('&');
            for (var i = 0; i < sURLVariables.length; i++)
            {
                var sParameter = sURLVariables[i].split('=');
                if (sParameter[0] === sParam)
                {
                    return sParameter[1];
                }
            }
            return '';
        }
    </script>
    <script type="text/javascript">
        function findCertainProperty(propId)
        {
            var objFormData = new FormData();
            objFormData.append('propId', propId);
            $.ajax
            (
                {
                    cache: false,
                    type: "POST",
                    contentType: false,
                    url: "/rest/prop/fetch",
                    data: objFormData,
                    processData: false,
                    success: function(respObj)
                    {
                        if (respObj.success == 1 && respObj.responseCode == 0)
                        {
                            var jsonObject = $.parseJSON(respObj.responseString);
                            var loc = {lat: jsonObject.location.lat, lng: jsonObject.location.lng};

                            map.setZoom(DEFAULT_ZOOM_LEVEL);
                            setLocation(loc, '');

                            var arr = [];
                            arr.push(jsonObject);
                            window.jsonObj = arr;

                            showProperties();
                        }
                    },
                    error: function(XMLHttpRequest, textStatus, errorThrown)
                    {
                    }
                }
            )
        }
    </script>
    <script type="text/javascript">
        function deleteSavedSearch(emailunsub)
        {
            var okMsgBoxHtml = '<br /><br /><button id="popupOKButton" type="button" class="btn btn-warning" onclick="hidePopup(0,0);">OK</button>';
            var objFormData = new FormData();
            objFormData.append('id', emailunsub);
            $.ajax
            (
                {
                    cache: false,
                    type: "POST",
                    contentType: false,
                    url: "/rest/prop/delsavedsearch",
                    data: objFormData,
                    processData: false,
                    success: function(respObj)
                    {
                        showPopup('', respObj.responseString + okMsgBoxHtml);
                    },
                    error: function(XMLHttpRequest, textStatus, errorThrown)
                    {
                        showPopup('', 'Failed to delete your saved search' + okMsgBoxHtml);
                    }
                }
            )
        }
    </script>
    <script type="text/javascript">
        var map;
        var markers = [];
        var places = [];
        var defaultIcon;
        var highlightedIcon;
        var currentLoc;
        var highlightedProperty;
        var zoomInText = null;

        var DEFAULT_ZOOM_LEVEL = 14;
        var MAX_ZOOM_LEVEL = 18;
        var MIN_ZOOM_LEVEL = 2;
        var MIN_SEARCH_ZOOM_LEVEL = 11;

        var okMsgBoxHtml = '<br /><br /><button id="popupOKButton" type="button" class="btn btn-warning" onclick="hidePopup(0,0);">OK</button>';

        //window.initMap = function()
        function initMap()
        {
            currentLoc = {lat: 30.0, lng: 0.0};

            var mapStyles =[
                {
                    featureType: "poi",
                    elementType: "labels",
                    stylers: [
                        { visibility: "off" }
                    ]
                }
            ];

            map = new google.maps.Map(document.getElementById('map'), {
                center: currentLoc,
                zoom: MIN_ZOOM_LEVEL,
                mapTypeControl: false,
                clickableIcons: false
                //mapTypeId: google.maps.MapTypeId.HYBRID
                //styles: mapStyles
            });

            var relocateButton = create_Relocate_Button(map);
            relocateButton.addEventListener('click', function() {
                getCurrentLocation(1);
            });
            //map.setTilt(45);

            var latLngDiv = create_LatLng_Div(map);

            google.maps.event.addListener(map, "click", function (e) {
                var latLng = e.latLng;
                var clickedLoc = {lat: latLng.lat(), lng: latLng.lng()};
            });

            google.maps.event.addListenerOnce(map, 'idle', function() {
                var propId = getURLParameter('id');
                if (propId.length > 0)
                {
                    findCertainProperty(propId);
                }
                else
                {
                    var emailunsub = getURLParameter('emailunsub');
                    if (emailunsub !== '')
                    {
                        deleteSavedSearch(emailunsub);
                    }
                    getCurrentLocation(0);
                }
            });

            google.maps.event.addListener(map, 'tilesloaded', function() {
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

                var btnFind = document.getElementById('btnFind');
                var btnSave = document.getElementById('btnSave');
                if (MIN_SEARCH_ZOOM_LEVEL <= this.getZoom() && this.getZoom() <= MAX_ZOOM_LEVEL)
                {
                    btnFind.disabled = false;
                    btnSave.disabled = false;

                    if (zoomInText != null)
                    {
                        zoomInText.style.fontSize = '0px';
                        zoomInText.style.zIndex = -500;
                        zoomInText.innerHTML = '';
                        map.controls[google.maps.ControlPosition.TOP_RIGHT].push(zoomInText);
                        zoomInText = null;
                    }
                }
                else
                {
                    btnFind.disabled = true;
                    btnSave.disabled = true;

                    if (zoomInText == null)
                    {
                        zoomInText = document.createElement('div');
                        zoomInText.style.backgroundColor = 'rgb(240,240,240)';
                        zoomInText.style.color = 'rgb(25,25,25)';
                        zoomInText.style.fontFamily = 'Roboto,Arial,sans-serif';
                        zoomInText.style.fontSize = '32px';
                        zoomInText.style.zIndex = 500;
                        zoomInText.innerHTML = 'Zoom-in to Find Properties';
                        map.controls[google.maps.ControlPosition.CENTER].push(zoomInText);
                    }
                }
            });
        }


        function showPopup(title, text)
        {
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

        function getCurrentLocation(manualUserCall)
        {
            var previousLocLat = getCookie("currentLocLat");
            if (previousLocLat === '' || manualUserCall == 1)
            {
                showPopup("", "Fetching your current location...<br />Please wait");

                if (navigator.geolocation)
                {
                    navigator.geolocation.getCurrentPosition(
                        function(position)
                        {
                            currentLoc = {lat: position.coords.latitude, lng: position.coords.longitude};
                            setCookieForMinutes("currentLocLat", currentLoc.lat, 15);
                            setCookieForMinutes("currentLocLng", currentLoc.lng, 15);

                            var guideUser = '';
                            var uuid = getCookie("uuid");
                            if (uuid === "")
                            {
                                setCookie("uuid", createFakeUUID(), 1);
                                guideUser = 'Use the map to specify your search bounds';
                            }

                            map.setZoom(DEFAULT_ZOOM_LEVEL);
                            setLocation(currentLoc, guideUser);
                        },
                        function()
                        {
                            map.setZoom(MIN_ZOOM_LEVEL);
                            //hidePopup(0, 0);
                            showPopup('', 'Failed to get your location. Please zoom to your location manually using the map. The map bounds will be your search area.' + okMsgBoxHtml);
                        },
                        { maximumAge: 3000, timeout: 5000 }
                    );
                }
                else
                {
                    map.setZoom(MIN_ZOOM_LEVEL);
                    //hidePopup(0, 0);
                    showPopup('', 'Your browser does not support geolocation. Please zoom to your location manually using the map. The map bounds will be your search area.' + okMsgBoxHtml);
                }
            }
            else    //current location is still in cookies, use it.
            {
                currentLoc = {lat: previousLocLat, lng: getCookie("currentLocLng")};
                map.setZoom(DEFAULT_ZOOM_LEVEL);
                setLocation(currentLoc, '');
            }
        }


        function setLocation(cLoc, notificationMsg)
        {
            map.setCenter(new google.maps.LatLng(cLoc.lat, cLoc.lng));
            if (notificationMsg.length > 0)
            {
                //hidePopup(0, 0);
                showPopup("", notificationMsg);
                hidePopup(3000, 2000);
            }
            else
            {
                hidePopup(1000, 2000);
            }
        }


        function clearProperties()
        {
            for (var i=0; i < markers.length; i++) {
                //markers[i].setMap(null);
                //markers[i].parentNode.removeChild();
                //map.removeChild(markers[i]);
                //map.removeChild();
                try {
                    markers[i].setMap(null);
                }
                catch(err) {
                    //alert(err.message);
                }
            }
            markers = [];
            highlightedProperty = null;

            var propPicsDiv = document.getElementById('propPicsDiv');
            while (propPicsDiv.hasChildNodes())
            {
                propPicsDiv.removeChild(propPicsDiv.lastChild);
            }
        }


        function clearPlaces()
        {
            for (var i=0; i < places.length; i++)
            {
                try {
                    places[i].setMap(null);
                }
                catch(err) {
                    //alert(err.message);
                }
            }
            places = [];
        }


        function getColorByPlaceType(placesType)
        {
            if (placesType === 'convenience_store')
                return 'rgb(0, 153, 153)';
            else if (placesType === 'bakery')
                return 'rgb(0, 102, 255)';
            else if (placesType === 'laundry')
                return 'rgb(204, 51, 0)';
            else if (placesType === 'restaurant')
                return 'rgb(0, 136, 204)';
            else if (placesType === 'pharmacy')
                return 'rgb(133, 133, 173)';
            else if (placesType === 'train_station')
                return 'rgb(57, 115, 172)';
            else if (placesType === 'bus_station')
                return 'rgb(153, 153, 102)';
            else
                return 'rgb(255, 153, 0)';  //default
        }

        function getPlaceTypeAbbr(placesType)
        {
            if (placesType === 'convenience_store')
                return 'CS';
            else if (placesType === 'bakery')
                return 'BK';
            else if (placesType === 'laundry')
                return 'LD';
            else if (placesType === 'restaurant')
                return 'RS';
            else if (placesType === 'pharmacy')
                return 'PH';
            else if (placesType === 'train_station')
                return 'TS';
            else if (placesType === 'bus_station')
                return 'BS';
            else
                return '?';
        }

        function showPlaces(idx)
        {
            clearPlaces();
            var propList = window.jsonObj;

            var placesList = propList[idx].placesList;

            if (placesList.length != 0)
            {
                for (var i=0; i < placesList.length; i++)  //looping through googlePlaces types
                {
                    var placesType = placesList[i].placesType;

                    for (var j=0; j < placesList[i].results.length; j++) //looping through places of certain type
                    {
                        var location = placesList[i].results[j].geometry.location;
                        var placeName = placesList[i].results[j].name;
                        var placeRating = placesList[i].results[j].rating;
                        var placeLatlng = new google.maps.LatLng(location.lat, location.lng);

                        var overlayMarker = new GMapOverlay(
                            placeLatlng,
                            map,
                            {
                                object_id: 'place_' + i,
                                object_index: i,
                                class_name: 'place',
                                cursor_type: 'pointer',
                                background_color: getColorByPlaceType(placesType),
                                font_color: 'white',
                                font_size: '100%',
                                border_style: '3px solid #fff',
                                place_name: placeName,
                                place_type: placesType,
                                place_rating: placeRating,
                                place_type_abbr: getPlaceTypeAbbr(placesType)
                            }
                        );
                        places.push(overlayMarker);
                    }
                }
            }
        }



        function showProperties()
        {
            var propList = window.jsonObj;
            //var bounds = new google.maps.LatLngBounds();

            //preparing for right pane
            var propPicsDiv = document.getElementById('propPicsDiv');
            while (propPicsDiv.hasChildNodes())
            {
                propPicsDiv.removeChild(propPicsDiv.lastChild);
            }

            for (var i=0; i < propList.length; i++)
            {
                var location = propList[i].location;
                var propertyLatlng = new google.maps.LatLng(location.lat, location.lng);
                var price = 0;

                var custScope = document.getElementById('customerScope').value;
                if (custScope === 'RENT')
                {
                    price = propList[i].rentPrice;
                }
                else if (custScope === 'BUY')
                {
                    price = propList[i].sellingPrice;
                }

                var pName = propList[i].propertyName;
                var pAddr = propList[i].address.street + ', ' + propList[i].address.city +
                    ', ' +  propList[i].address.zipCode;
                var picFile = '/uploadLoc/u' + propList[i].appUser.id + '/' + propList[i].pic;
                var oName = propList[i].appUser.name;
                var oPhone = propList[i].appUser.contactInfo.phone;
                var oEmail = propList[i].appUser.contactInfo.email;

                var overlayMarker = new GMapOverlay(
                    propertyLatlng,
                    map,
                    {
                        object_id: 'property_' + i,
                        object_index: i,
                        class_name: 'property',
                        price: '$' + price,
                        cursor_type: 'pointer',
                        background_color: 'rgb(153, 0, 204)',
                        font_color: 'white',
                        font_size: '130%',
                        border_style: '3px solid #fff',
                        property_name: pName,
                        address: pAddr,
                        rooms: propList[i].rooms,
                        baths: propList[i].baths,
                        pic: picFile,
                        contactName: oName,
                        contactPhone: oPhone,
                        contactEmail: oEmail
                    }
                );

                markers.push(overlayMarker);
                //bounds.extend(propertyLatlng);

                //show pic on the right pane
                var picDiv = document.createElement('div');
                picDiv.style.paddingTop = '2px';
                picDiv.style.paddingBottom = '2px';
                picDiv.setAttribute('data-markerid', i);
                picDiv.onmouseover = function() {
                    if (highlightedProperty != null)
                    {
                        var h = highlightedProperty;
                        markers[h].args.background_color = 'rgb(153, 0, 204)';
                        markers[h].args.font_color = 'white';
                        markers[h].div.style.zIndex = '5';
                        markers[h].draw();
                    }
                    var i = this.getAttribute('data-markerid');
                    markers[i].args.background_color = 'rgb(255, 140, 26)';
                    markers[i].args.font_color = 'white';
                    markers[i].div.style.zIndex = '10';
                    markers[i].draw();
                    highlightedProperty = i;
                };

                var picImg = document.createElement('img');
                picImg.src = picFile;
                picImg.style.maxWidth = '100%';
                picImg.style.maxHeight = '100%';
                picDiv.appendChild(picImg);

                var infoDiv = document.createElement('div');
                infoDiv.style.backgroundColor = 'rgb(230, 230, 230)';
                infoDiv.style.fontSize = 'small';
                infoDiv.innerHTML = '<div class="row" style="text-align: center;"><div class="col-xs-12">' +
                    pName + '</div></div>' +
                    '<div class="row"><div class="col-xs-6" style="text-align: left;">Rooms:' +
                    propList[i].rooms + '</div><div class="col-xs-6" style="text-align: right;">Baths:' +
                    propList[i].baths + '&nbsp;&nbsp;</div></div><div class="row" style="text-align: center;">' +
                    '<div class="col-xs-12">' + oName + '<br />' + oPhone + '</div></div>';
                picDiv.appendChild(infoDiv);

                propPicsDiv.appendChild(picDiv);
            }
            //map.fitBounds(bounds);
        }

        google.maps.event.addDomListener(window, 'load', initMap);
    </script>
    <script type="text/javascript">
        function propImgMouseOver()
        {

        }

        function propImgMouseOut()
        {

        }
    </script>
    <script type="text/javascript">
        function disableEnable(controlId)
        {
            var ctrl = document.getElementById(controlId);
            if (ctrl.disabled == false)
            {
                ctrl.disabled = true;
                ctrl.value = '';
                //ctrl.placeholder = 'meters';
            }
            else
            {
                ctrl.disabled = false;
            }
        }
    </script>
    <script type="text/javascript">
        function saveSearch()
        {
            //var appUser = '<%= ((AppUser)session.getAttribute("appUser")) %>';
            var appUser = '<%= ((AppUser)request.getSession().getAttribute("appUser")) %>';

            if (appUser !== 'null')
            {
                var okMsgBoxHtml = '<br /><br /><button id="popupOKButton" type="button" class="btn btn-warning" onclick="hidePopup(0,0);">OK</button>';

                if ($("#propType :selected").length == 0)
                {
                    showPopup('', 'Please select a Property Type.' + okMsgBoxHtml);
                    return;
                }

                var convenienceStoreMeters = getServiceMeters('ckbConvenienceStore', 'txtConvenienceStore');
                if (convenienceStoreMeters == -2) { showPopup('', 'Please set a max distance for Convenience Stores, or uncheck it' + okMsgBoxHtml); return; }

                var bakeryMeters = getServiceMeters('ckbBakery','txtBakery');
                if (bakeryMeters == -2) { showPopup('', 'Please set a max distance for Bakeries, or uncheck it' + okMsgBoxHtml); return; }

                var laundryMeters = getServiceMeters('ckbLaundry','txtLaundry');
                if (laundryMeters == -2) { showPopup('', 'Please set a max distance for Laundries, or uncheck it' + okMsgBoxHtml); return; }

                var restaurantMeters = getServiceMeters('ckbRestaurant','txtRestaurant');
                if (restaurantMeters == -2) { showPopup('', 'Please set a max distance for Restaurants, or uncheck it' + okMsgBoxHtml); return; }

                var pharmacyMeters = getServiceMeters('ckbPharmacy','txtPharmacy');
                if (pharmacyMeters == -2) { showPopup('', 'Please set a max distance for Pharmacies, or uncheck it' + okMsgBoxHtml); return; }

                var trainStationMeters = getServiceMeters('ckbTrainStation','txtTrainStation');
                if (trainStationMeters == -2) { showPopup('', 'Please set a max distance for Train Station, or uncheck it' + okMsgBoxHtml); return; }

                var busStationMeters = getServiceMeters('ckbBusStation','txtBusStation');
                if (busStationMeters == -2) { showPopup('', 'Please set a max distance for Bus Station, or uncheck it' + okMsgBoxHtml); return; }

                var objFormData = new FormData();
                objFormData.append('northBound', map.getBounds().getNorthEast().lat());
                objFormData.append('eastBound', map.getBounds().getNorthEast().lng());
                objFormData.append('southBound', map.getBounds().getSouthWest().lat());
                objFormData.append('westBound', map.getBounds().getSouthWest().lng());

                objFormData.append('customerScope', document.getElementById('customerScope').value);
                objFormData.append('propType', getPropTypeBinary());
                objFormData.append('fromDate', document.getElementById('fromDate').value);
                objFormData.append('toDate', document.getElementById('toDate').value);
                objFormData.append('txtMinPrice', document.getElementById('txtMinPrice').value);
                objFormData.append('txtMaxPrice', document.getElementById('txtMaxPrice').value);

                objFormData.append('minRooms', document.getElementById('minRooms').value);
                objFormData.append('maxRooms', document.getElementById('maxRooms').value);
                objFormData.append('minBaths', document.getElementById('minBaths').value);
                objFormData.append('maxBaths', document.getElementById('maxBaths').value);

                objFormData.append('txtConvenienceStore', convenienceStoreMeters);
                objFormData.append('txtBakery', bakeryMeters);
                objFormData.append('txtLaundry', laundryMeters);
                objFormData.append('txtRestaurant', restaurantMeters);
                objFormData.append('txtPharmacy', pharmacyMeters);
                objFormData.append('txtTrainStation', trainStationMeters);
                objFormData.append('txtBusStation', busStationMeters);

                objFormData.append('ckbParking', checked('ckbParking'));
                objFormData.append('ckbGarage', checked('ckbGarage'));
                objFormData.append('ckbWasher', checked('ckbWasher'));
                objFormData.append('ckbAC', checked('ckbAC'));
                objFormData.append('ckbGym', checked('ckbGym'));

                $.ajax
                (
                    {
                        cache: false,
                        type: "POST",
                        contentType: false,
                        url: "/rest/prop/savesearch",
                        data: objFormData,
                        processData: false,
                        success: function(respObj)
                        {
                            showPopup('', respObj.responseString + okMsgBoxHtml);
                        },
                        error: function(XMLHttpRequest, textStatus, errorThrown)
                        {
                            showPopup('', 'Failed to save your search' + okMsgBoxHtml);
                        }
                    }
                )
            }
            else
            {
                var confirmMsgBoxHtml = '<br /><br />' +
                    '<button type="button" class="btn btn-info" onclick="redirectToLoginPage();">&nbsp;&nbsp;&nbsp;Login&nbsp;&nbsp;&nbsp;</button> ' +
                    '<button type="button" class="btn btn-warning" onclick="hidePopup(0,0);">Cancel</button> ';

                showPopup('', 'You need to be logged-in to save your search. Do you want to login?' + confirmMsgBoxHtml);
            }
        }
    </script>
    <script type="text/javascript">
        function redirectToLoginPage()
        {
            window.location.href = '/mvc/user/login';
        }
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
                <li class="active"><a href="#"><span class="glyphicon glyphicon-search"></span> Find Property</a></li>
                <li><a href="/mvc/prop/add"><span class="glyphicon glyphicon-plus-sign"></span> Add Property</a></li>
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


<div class="text-center h100" style="margin-top: 50px; position: relative; overflow: auto;">
    <!--<div id="showNotification" class="alert alert-warning" style="text-align: center;"></div>-->
    <div class="h100">
        <div class="row h100">
            <div class="col-xs-3">
                <div class="options-box-1">
                    <form id="frmFindHomes">
                        <div class="row" style="line-height: 15px;"><p style="line-height:1px;"></p></div>
                        <div class="row">
                            <div class="col-xs-6" style="padding-right: 1px;">
                                <button id="btnSave" class="btn" style="width: 100%; background-color: darkmagenta; color: white;" onclick="saveSearch(); return false;">Save Search</button>
                            </div>
                            <div class="col-xs-6" style="padding-left: 1px;">
                                <input id="btnFind" type="submit" class="btn btn-primary" style="width: 100%;" value="Search"/>
                            </div>
                        </div>
                        <hr />
                        <div class="options-box-3">
                            <div class="panel-group" id="accordion">
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        <h4 class="panel-title">
                                            <a data-toggle="collapse" data-parent="#accordion" href="#collapse1">Scope</a>
                                        </h4>
                                    </div>
                                    <div id="collapse1" class="panel-collapse collapse in">
                                        <div class="panel-body">
                                            <div class="row">
                                                <div class="col-xs-3"><p style="line-height:35px;">For:</p></div>
                                                <div class="col-xs-9">
                                                    <select class="form-control" id="customerScope">
                                                        <option value="RENT" selected>Rent</option>
                                                        <option value="BUY">Buy</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-xs-3"><p style="line-height:35px;">Type:</p></div>
                                                <div class="col-xs-9">
                                                    <select id="propType" class="form-control selectpicker" multiple data-selected-text-format="count > 2">
                                                        <option value="STUDIO">Studio</option>
                                                        <option value="APARTMENT" selected>Apartment</option>
                                                        <option value="HOUSE">House</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-xs-3"><p style="line-height:35px;">From:</p></div>
                                                <div class="col-xs-9">
                                                    <input type="text" class="form-control jqDatePicker" id="fromDate">
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-xs-3"><p style="line-height:35px;">To:</p></div>
                                                <div class="col-xs-9">
                                                    <input type="text" class="form-control jqDatePicker" id="toDate">
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-xs-3"><p style="line-height:35px;">Price($):</p></div>
                                                <div class="col-xs-4" style="padding-right: 0px;">
                                                    <input id="txtMinPrice" class="form-control positiveInt nopadding" style="width: 100%;" type="text" placeholder="From $" style="width: 100%;" value="10" data-toggle="tooltip" data-placement="auto right" title="Minimum price in US Dollars."/>
                                                </div>

                                                <div class="col-xs-5" style="padding-left: 3px;">
                                                    <input id="txtMaxPrice" class="form-control positiveInt nopadding" style="width: 100%;" type="text" placeholder="To $" style="width: 100%;" value="1000" data-toggle="tooltip" data-placement="auto right" title="Max affordable price in US Dollars."/>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="panel panel-default" id="mainSpecsPanel">
                                    <div class="panel-heading">
                                        <h4 class="panel-title">
                                            <a data-toggle="collapse" data-parent="#accordion" href="#collapse2">Main Specifications</a>
                                        </h4>
                                    </div>
                                    <div id="collapse2" class="panel-collapse collapse">
                                        <div class="panel-body">
                                            <div class="row">
                                                <div class="col-xs-4"><p style="line-height:35px;">Rooms:</p></div>
                                                <div class="col-xs-4">
                                                    <select class="form-control" id="minRooms">
                                                        <option value="0" selected disabled>Min</option>
                                                        <option value="1">1</option>
                                                        <option value="2">2</option>
                                                        <option value="3">3</option>
                                                        <option value="4">4</option>
                                                    </select>
                                                </div>
                                                <div class="col-xs-4">
                                                    <select class="form-control" id="maxRooms">
                                                        <option value="500" selected disabled>Max</option>
                                                        <option value="1">1</option>
                                                        <option value="2">2</option>
                                                        <option value="3">3</option>
                                                        <option value="4">4</option>
                                                        <option value="5+">5+</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="row"><p style="line-height:5px;"></p></div>
                                            <div class="row">
                                                <div class="col-xs-4"><p style="line-height:35px;">Baths:</p></div>
                                                <div class="col-xs-4">
                                                    <select class="form-control" id="minBaths">
                                                        <option value="0" selected disabled>Min</option>
                                                        <option value="1">1</option>
                                                        <option value="2">2</option>
                                                        <option value="3">3</option>
                                                    </select>
                                                </div>
                                                <div class="col-xs-4">
                                                    <select class="form-control" id="maxBaths">
                                                        <option value="500" selected disabled>Max</option>
                                                        <option value="1">1</option>
                                                        <option value="2">2</option>
                                                        <option value="3">3</option>
                                                        <option value="4+">4+</option>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        <h4 class="panel-title">
                                            <a data-toggle="collapse" data-parent="#accordion" href="#collapse3">Close To:</a>
                                        </h4>
                                    </div>
                                    <div id="collapse3" class="panel-collapse collapse">
                                        <div class="panel-body">
                                            <div class="row">
                                                <div class="col-xs-8 checkbox" style="padding-right: 0px;">
                                                    <label><input id="ckbConvenienceStore" type="checkbox" value="" onclick="disableEnable('txtConvenienceStore');" />Convenience Store</label>
                                                </div>
                                                <div class="col-xs-4" style="padding-left: 0px;">
                                                    <input id="txtConvenienceStore" class="form-control positiveInt" type="text" placeholder="meters" style="width: 100%;" value="" data-toggle="tooltip" data-placement="auto right" title="Max acceptable distance in meters" disabled/>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-xs-8 checkbox" style="padding-right: 0px;">
                                                    <label><input id="ckbBakery" type="checkbox" value="" onclick="disableEnable('txtBakery');" />Bakery</label>
                                                </div>
                                                <div class="col-xs-4" style="padding-left: 0px;">
                                                    <p style="margin-top: 3px;"><input id="txtBakery" class="form-control positiveInt" type="text" placeholder="meters" style="width: 100%;" value="" data-toggle="tooltip" data-placement="auto right" title="Max acceptable distance in meters" disabled/></p>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-xs-8 checkbox" style="padding-right: 0px;">
                                                    <label><input id="ckbLaundry" type="checkbox" value="" onclick="disableEnable('txtLaundry');" />Laundry</label>
                                                </div>
                                                <div class="col-xs-4" style="padding-left: 0px;">
                                                    <p style="margin-top: 3px;"><input id="txtLaundry" class="form-control positiveInt" type="text" placeholder="meters" style="width: 100%;" value="" data-toggle="tooltip" data-placement="auto right" title="Max acceptable distance in meters" disabled/></p>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-xs-8 checkbox" style="padding-right: 0px;">
                                                    <label><input id="ckbRestaurant" type="checkbox" value="" onclick="disableEnable('txtRestaurant');" />Restaurant</label>
                                                </div>
                                                <div class="col-xs-4" style="padding-left: 0px;">
                                                    <p style="margin-top: 3px;"><input id="txtRestaurant" class="form-control positiveInt" type="text" placeholder="meters" style="width: 100%;" value="" data-toggle="tooltip" data-placement="auto right" title="Max acceptable distance in meters" disabled/></p>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-xs-8 checkbox" style="padding-right: 0px;">
                                                    <label><input id="ckbPharmacy" type="checkbox" value="" onclick="disableEnable('txtPharmacy');" />Pharmacy</label>
                                                </div>
                                                <div class="col-xs-4" style="padding-left: 0px;">
                                                    <p style="margin-top: 3px;"><input id="txtPharmacy" class="form-control positiveInt" type="text" placeholder="meters" style="width: 100%;" value="" data-toggle="tooltip" data-placement="auto right" title="Max acceptable distance in meters" disabled/></p>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-xs-8 checkbox" style="padding-right: 0px;">
                                                    <label><input id="ckbTrainStation" type="checkbox" value="" onclick="disableEnable('txtTrainStation');" />Train Station</label>
                                                </div>
                                                <div class="col-xs-4" style="padding-left: 0px;">
                                                    <p style="margin-top: 3px;"><input id="txtTrainStation" class="form-control positiveInt" type="text" placeholder="meters" style="width: 100%;" value="" data-toggle="tooltip" data-placement="auto right" title="Max acceptable distance in meters" disabled/></p>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-xs-8 checkbox" style="padding-right: 0px;">
                                                    <label><input id="ckbBusStation" type="checkbox" value="" onclick="disableEnable('txtBusStation');" />Bus Station</label>
                                                </div>
                                                <div class="col-xs-4" style="padding-left: 0px;">
                                                    <p style="margin-top: 3px;"><input id="txtBusStation" class="form-control positiveInt" type="text" placeholder="meters" style="width: 100%;" value="" data-toggle="tooltip" data-placement="auto right" title="Max acceptable distance in meters" disabled/></p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        <h4 class="panel-title">
                                            <a data-toggle="collapse" data-parent="#accordion" href="#collapse4">Amenities:</a>
                                        </h4>
                                    </div>
                                    <div id="collapse4" class="panel-collapse collapse">
                                        <div class="panel-body">
                                            <div class="row">
                                                <div class="col-xs-12 checkbox">
                                                    <label><input id="ckbParking" type="checkbox" value="PARKING" />Parking</label>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-xs-12 checkbox">
                                                    <label><input id="ckbGarage" type="checkbox" value="GARAGE" />Garage</label>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-xs-12 checkbox">
                                                    <label><input id="ckbWasher" type="checkbox" value="WASHER" />Washer/Dryer</label>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-xs-12 checkbox">
                                                    <label><input id="ckbAC" type="checkbox" value="AC" />Air Conditioning</label>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-xs-12 checkbox">
                                                    <label><input id="ckbGym" type="checkbox" value="GYM" />Gym</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </form>

                    <br />

                </div>
            </div>
            <div class="col-xs-6 h100" id="map"></div>
            <div class="col-xs-3" style="padding-right: 2%; padding-left: 1%;">
                <div style="font-size: smaller; color: darkcyan;">
                    <br />
                    <%
                        if (request.getSession().getAttribute("appUser") != null)
                        {
                            out.println("Welcome " + ((AppUser)request.getSession().getAttribute("appUser")).getDisplayName());
                        }
                    %>
                </div>
                <div class="props-pane-exterior">
                    <div class="props-pane-interior">
                        <div id="propPicsDiv">

                        </div>
                    </div>
                </div>
            </div>
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