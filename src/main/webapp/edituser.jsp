<%@ page import="com.ironyard.data.AppUser" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>

<!DOCTYPE HTML>
<html style="font-family: Arial, sans-serif; margin: 0; padding: 0;">
<head>
    <title>Manage Account</title>

    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" />

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

    <script type="text/javascript" src="utils.js"></script>
    <script type="text/javascript" src="bootstrap-select.min.js"></script>

    <link rel="stylesheet" href="css/layout.css" />
    <link rel="stylesheet" href="css/bootstrap-select.min.css" />

    <script type="text/javascript">
        $(document).ready
        (
            function()
            {
                $("#frmEditUser").submit
                (
                    function(ev)
                    {
                        ev.preventDefault();

                        var okMsgBoxHtml = '<br /><br /><button id="popupOKButton" type="button" class="btn btn-warning" onclick="hidePopup(0,0);">OK</button>';

                        var userType = getSelectValue('userType');

                        var personalId = '';
                        if (userType !== 'S')
                        {
                            personalId = document.getElementById('personalId').value;
                            if (personalId.length < 4) { showPopup('', 'Personal ID must be greater than 3 digits' + okMsgBoxHtml); return; }
                        }

                        var displayName = document.getElementById('displayName').value;
                        if (displayName.length < 2)
                        {
                            showPopup('', 'Display name must be at least 2 characters' + okMsgBoxHtml);
                            return;
                        }

                        var emailReg = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
                        var contactEmail = '';
                        if (userType !== 'S')
                        {
                            contactEmail = document.getElementById('contactEmail').value;
                            var validEmail = emailReg.test(contactEmail);
                            if (validEmail == false)
                            {
                                showPopup('', 'Invalid contact email' + okMsgBoxHtml);
                                return;
                            }
                        }

                        var objFormData = new FormData();

                        objFormData.append('userType', userType);
                        objFormData.append('personalId', personalId.trim());

                        objFormData.append('displayName', displayName.trim());

                        objFormData.append('street', (document.getElementById('street').value).trim());
                        objFormData.append('city', (document.getElementById('city').value).trim());
                        objFormData.append('country', (document.getElementById('country').value).trim());
                        objFormData.append('zipCode', (document.getElementById('zipCode').value).trim());

                        objFormData.append('phone', (document.getElementById('phone').value).trim());
                        objFormData.append('contactEmail', contactEmail.trim());

                        $.ajax
                        (
                            {
                                cache: false,
                                type: "POST",
                                contentType: false,
                                url: "/rest/user/edit",
                                data: objFormData,
                                processData: false,
                                success: function(respObj)
                                {
                                    if (respObj.success == 1 && respObj.responseCode == 0)
                                    {
                                        if (getSelectValue('userType') === 'O')
                                        {
                                            document.getElementById('userType').disabled = true;
                                        }
                                        showPopup('', respObj.responseString + okMsgBoxHtml);
                                    }
                                    else
                                    {
                                        showPopup('', respObj.responseString + okMsgBoxHtml);
                                    }
                                },
                                error: function(XMLHttpRequest, textStatus, errorThrown)
                                {
                                    showPopup('', 'Could not create your account. Error: ' + textStatus + okMsgBoxHtml);
                                }
                            }
                        )
                    }
                );
            }
        );
    </script>
    <script type="text/javascript">
        function showPopup(title, text)
        {
            //hidePopup(0, 0);
            $('#myPopup #pTitle').html(title);
            $('#myPopup #pText').html(text);
            $('#myPopup').fadeIn(350);
            //document.getElementById('topNavBar').disabled = true;

            var popupOKButton = document.getElementById('popupOKButton');
            if (popupOKButton != null)
            {
                popupOKButton.focus();
            }
        }

        function hidePopup(delayTime, fadeoutTime)
        {
            $('#myPopup').delay(delayTime).fadeOut(fadeoutTime);
            //document.getElementById('topNavBar').disabled = false;
        }
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
        function getSelectValue(controlId)
        {
            var ctrl = document.getElementById(controlId);
            var selectedValue = ctrl.options[ctrl.selectedIndex].value;
            return selectedValue;
        }
    </script>
    <script type="text/javascript">
        $(document).ready(function(){
            $(".phoneNumber").keyup(function(event){

                var currentValue = ($(this)).val();
                var strNumericValue = currentValue.replace('+', '');

                var phoneNum = '+';
                if (strNumericValue !== '')
                {
                    phoneNum = phoneNum + strNumericValue;
                }

                ($(this)).val(phoneNum);
            });
        });
    </script>
    <script type="text/javascript">
        $(document).ready(function() {
            $("#userType").on('change', function() {

                var selectedValue = getSelectValue('userType');

                var personalIdDiv = document.getElementById('personalIdDiv');
                var addrAndContactDiv = document.getElementById('addrAndContactDiv');

                if (selectedValue === 'S')
                {
                    personalIdDiv.style.display = 'none';
                    addrAndContactDiv.style.display = 'none';
                }
                else
                {
                    personalIdDiv.style.display = 'inline';
                    addrAndContactDiv.style.display = 'inline';
                }
            });
        });
    </script>
    <script type="text/javascript">
        $(document).ready(function() {
            var okMsgBoxHtml = '<br /><br /><button id="popupOKButton" type="button" class="btn btn-warning" onclick="hidePopup(0,0);">OK</button>';
            $.ajax
            (
                {
                    cache: false,
                    type: "POST",
                    contentType: false,
                    url: "/rest/user/fetch",
                    data: null,
                    processData: false,
                    success: function(respObj)
                    {
                        if (respObj.success == 1 && respObj.responseCode == 0)
                        {
                            //showPopup('', respObj.responseString + okMsgBoxHtml);
                            var jsonObj = $.parseJSON(respObj.responseString);
                            setUserDetails(jsonObj);
                        }
                        else
                        {
                            showPopup('', respObj.responseString + okMsgBoxHtml);
                            document.getElementById('btnUpdate').disabled = true;
                        }
                    },
                    error: function(XMLHttpRequest, textStatus, errorThrown)
                    {
                        showPopup('', 'Could not fetch your information. Error: ' + textStatus + okMsgBoxHtml);
                        document.getElementById('btnUpdate').disabled = true;
                    }
                }
            )
            $("#userType").focus();
        });
    </script>
    <script type="text/javascript">
        function setUserDetails(jsonObj)
        {
            document.getElementById('userType').value = jsonObj.userType;
            document.getElementById('displayName').value = jsonObj.displayName;

            var personalIdDiv = document.getElementById('personalIdDiv');
            var addrAndContactDiv = document.getElementById('addrAndContactDiv');

            if (jsonObj.userType === 'S')
            {
                personalIdDiv.style.display = 'none';
                addrAndContactDiv.style.display = 'none';
            }
            else
            {
                document.getElementById('userType').disabled = true;

                personalIdDiv.style.display = 'inline';
                addrAndContactDiv.style.display = 'inline';

                document.getElementById('personalId').value = jsonObj.personalId;
                document.getElementById('street').value = jsonObj.contactInfo.address.street;
                document.getElementById('city').value = jsonObj.contactInfo.address.city;
                document.getElementById('country').value = jsonObj.contactInfo.address.country;
                document.getElementById('zipCode').value = jsonObj.contactInfo.address.zipCode;
                document.getElementById('phone').value = jsonObj.contactInfo.phone;
                document.getElementById('contactEmail').value = jsonObj.contactInfo.email;
            }
        }
    </script>
</head>
<body style="font-family: Arial, sans-serif; margin: 0; padding: 0;">

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
                <li><a href="/mvc/prop/add"><span class="glyphicon glyphicon-plus-sign"></span> Add Property</a></li>
                <li><a href="/mvc/prop/edit"><span class="glyphicon glyphicon-home"></span> Manage Property</a></li>
            </ul>
            <ul class="nav navbar-nav navbar-right">
                <% if (request.getSession().getAttribute("appUser") == null) { %>
                <li style="display: inline;"><a href="/mvc/user/add"><span class="glyphicon glyphicon-user"></span> Sign Up</a></li>
                <li style="display: inline;"><a href="/mvc/user/login"><span class="glyphicon glyphicon-log-in"></span> Login</a></li>
                <% } else { %>
                <li class="active" style="display: inline;"><a href="#"><span class="glyphicon glyphicon-th"></span> Manage Account</a></li>
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

<div class="row" style="margin-top: 50px; position: relative; overflow: auto;">

    <div class="col-xs-offset-1 col-xs-8">
        <h2>Manage Your Account</h2>
        <hr />

        <form id="frmEditUser">
            <fieldset>
                <legend><h3>Basic Info</h3></legend>
                <div class="row">
                    <div class="col-xs-12">
                        <label for="userType">As:</label>
                        <select id="userType" name="userType" class="form-control">
                            <option value="O" selected>Seeker and Properties Owner</option>
                            <option value="S">Seeker Only</option>
                        </select>
                    </div>
                </div>
                <br />
                <div class="row">
                    <div class="col-xs-6" id="personalIdDiv">
                        <label for="personalId">Personal ID:</label>
                        <input type="text" id="personalId" name="personalId" class="form-control" value="" maxlength="32" />
                    </div>
                    <div class="col-xs-6">
                        <label for="displayName">Display Name:</label>
                        <input type="text" id="displayName" name="displayName" placeholder="Display name when logged-in" class="form-control" value="" maxlength="16" />
                    </div>
                </div>
                <br />
            </fieldset>
            <br />
            <div id="addrAndContactDiv">
                <fieldset>
                    <legend><h3>Address & Contact</h3></legend>
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
                    <br />
                    <div class="row">
                        <div class="col-xs-12">
                            <label for="phone">Phone:</label> (including country code)
                            <input type="text" id="phone" name="phone" placeholder="" class="form-control positiveInt phoneNumber" value="+" maxlength="20" />
                        </div>
                    </div>
                    <br />
                    <div class="row">
                        <div class="col-xs-12">
                            <label for="contactEmail">Contact Email:</label> (This will be visible to other users as your contact email)
                            <input type="text" id="contactEmail" name="contactEmail" placeholder="john_real_estate@gmail.com" class="form-control" value="" maxlength="128" />
                        </div>
                    </div>
                    <br />
                </fieldset>
            </div>

            <hr />
            <div class="row">
                <div class="col-xs-12">
                    <input id="btnUpdate" type="submit" class="btn btn-info" value="Update" />
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