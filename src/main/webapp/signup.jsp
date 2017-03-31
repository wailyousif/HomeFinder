<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>

<!DOCTYPE HTML>
<html style="font-family: Arial, sans-serif; margin: 0; padding: 0;">
<head>
    <title>Signup</title>

    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" />

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

    <script type="text/javascript" src="utils.js"></script>
    <script type="text/javascript" src="bootstrap-select.min.js"></script>

    <script type="text/javascript" src="sha512.js"></script>

    <link rel="stylesheet" href="css/layout.css" />
    <link rel="stylesheet" href="css/bootstrap-select.min.css" />

    <script type="text/javascript">
        $(document).ready
        (
            function()
            {
                $("#frmAddOwner").submit
                (
                    function(ev)
                    {
                        ev.preventDefault();

                        var okMsgBoxHtml = '<br /><br /><button id="popupOKButton" type="button" class="btn btn-warning" onclick="hidePopup(0,0);">OK</button>';

                        var userType = getSelectValue('userType');

                        var firstName = document.getElementById('firstName').value;
                        if (firstName.indexOf(' ') > -1) { showPopup('', 'First name cannot contain white spaces' + okMsgBoxHtml); return; }
                        if (firstName.length < 1) { showPopup('', 'First name is mandatory' + okMsgBoxHtml); return; }

                        var middleName = document.getElementById('middleName').value;
                        if (middleName.indexOf(' ') > -1) { showPopup('', 'Middle name cannot contain white spaces' + okMsgBoxHtml); return; }
                        if (middleName.length < 1) { showPopup('', 'Middle name is mandatory' + okMsgBoxHtml); return; }

                        var lastName = document.getElementById('lastName').value;
                        if (lastName.indexOf(' ') > -1) { showPopup('', 'Last name cannot contain white spaces' + okMsgBoxHtml); return; }
                        if (lastName.length < 1) { showPopup('', 'Last name is mandatory' + okMsgBoxHtml); return; }

                        var personalId = '';
                        if (userType !== 'S')
                        {
                            personalId = document.getElementById('personalId').value;
                            if (personalId.length < 4) { showPopup('', 'Personal ID must be greater than 3 digits' + okMsgBoxHtml); return; }
                        }

                        var emailReg = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
                        var email = document.getElementById('email').value;
                        var validEmail = emailReg.test(email);
                        if (validEmail == false)
                        {
                            showPopup('', 'Invalid email address' + okMsgBoxHtml);
                            return;
                        }

                        //showPopup('', 'Valid email address!' + okMsgBoxHtml);
                        //return;

                        var displayName = document.getElementById('displayName').value;
                        if (displayName.length < 2)
                        {
                            showPopup('', 'Display name must be at least 2 characters' + okMsgBoxHtml);
                            return;
                        }

                        var pass = document.getElementById('pass').value;
                        if (pass.length < 7)
                        {
                            showPopup('', 'Password must be at least 7 characters' + okMsgBoxHtml);
                            return;
                        }
                        var shaObj = new jsSHA("SHA-512", "TEXT");
                        shaObj.update(pass);
                        var passHash = shaObj.getHash("B64");

                        var passConfirm = document.getElementById('passConfirm').value;
                        if (passConfirm !== pass)
                        {
                            showPopup('', 'Your password has not been confirmed correctly' + okMsgBoxHtml);
                            return;
                        }

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

                        if (!checked('ckbLicenseTerms'))
                        {
                            showPopup('', 'In order to sign-up, you must agree on the license terms' + okMsgBoxHtml);
                            return;
                        }

                        var objFormData = new FormData();

                        objFormData.append('userType', userType);
                        objFormData.append('firstName', firstName.trim());
                        objFormData.append('middleName', middleName.trim());
                        objFormData.append('lastName', lastName.trim());
                        objFormData.append('gender', getSelectValue('gender'));
                        objFormData.append('personalId', personalId.trim());

                        objFormData.append('email', email.trim());
                        objFormData.append('pass', passHash);
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
                                url: "/rest/user/add",
                                data: objFormData,
                                processData: false,
                                success: function(respObj)
                                {
                                    if (respObj.success == 1 && respObj.responseCode == 0)
                                    {
                                        if (userType === 'O')
                                            window.location.replace("/addprop.jsp");
                                        else
                                            window.location.replace("/finder.jsp");
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
        function disableEnable(controlId)
        {
            var ctrl = document.getElementById(controlId);
            if (ctrl.disabled == false)
            {
                ctrl.disabled = true;
                ctrl.value = '';
            }
            else
            {
                ctrl.disabled = false;
            }
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
        function showWhyPersonalId()
        {
            var okMsgBoxHtml = '<br /><br /><button id="popupOKButton" type="button" class="btn btn-warning" onclick="hidePopup(0,0);">OK</button>';
            var whyMsg = 'Personal ID is used to maintain the ownership of a property. When you sell a property, you need to update it with the ID of the buyer from (Manage Property) tab. Your personal ID will not be visible to buyers or seekers.';
            showPopup('', whyMsg + okMsgBoxHtml);
        }
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
                    document.getElementById('personalId').value = '';

                    addrAndContactDiv.style.display = 'none';
                    document.getElementById('street').value = '';
                    document.getElementById('city').value = '';
                    document.getElementById('country').value = '';
                    document.getElementById('zipCode').value = '';
                    document.getElementById('phone').value = '';
                    document.getElementById('contactEmail').value = '';
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
            $("#userType").focus();
        });
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
                <li class="active" style="display: inline;"><a href="#"><span class="glyphicon glyphicon-user"></span> Sign Up</a></li>
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

<div class="row" style="margin-top: 50px; position: relative; overflow: auto;">

    <div class="col-xs-offset-1 col-xs-9">
        <h2>Sign Up</h2>
        <hr />

        <form id="frmAddOwner">
            <fieldset>
                <legend><h3>Basic Info</h3></legend>
                <div class="row">
                    <div class="col-xs-12">
                        <label for="userType">As:</label>
                        <select id="userType" name="userType" class="form-control selectpicker">
                            <option value="O" selected>Seeker and Properties Owner</option>
                            <option value="S">Seeker Only</option>
                        </select>
                    </div>
                </div>
                <br />
                <div class="row">
                    <div class="col-xs-4">
                        <label for="firstName">First Name:</label>
                        <input type="text" id="firstName" name="firstName" class="form-control" value="" maxlength="32" />
                    </div>
                    <div class="col-xs-4">
                        <label for="middleName">Middle Name:</label>
                        <input type="text" id="middleName" name="middleName" class="form-control" value="" maxlength="32" />
                    </div>
                    <div class="col-xs-4">
                        <label for="lastName">Last Name:</label>
                        <input type="text" id="lastName" name="lastName" class="form-control" value="" maxlength="32" />
                    </div>
                </div>
                <br />
                <div class="row">
                    <div class="col-xs-6">
                        <label for="gender">Gender:</label>
                        <select id="gender" name="gender" class="form-control selectpicker">
                            <option value="M" selected>Male</option>
                            <option value="F">Female</option>
                            <option value="NS">Don't want to specify</option>
                        </select>
                    </div>
                    <div class="col-xs-6" id="personalIdDiv">
                        <label for="personalId">Personal ID:</label>
                        <a href="#" onclick="showWhyPersonalId();">(Why Personal ID?)</a>
                        <input type="text" id="personalId" name="personalId" class="form-control" value="" maxlength="32" />
                    </div>
                </div>
                <br />
            </fieldset>
            <br />
            <fieldset>
                <legend><h3>Credentials</h3></legend>
                <div class="row">
                    <div class="col-xs-6">
                        <label for="email">Email:</label> (Used for login, not visible to other users)
                        <input type="text" id="email" name="email" placeholder="john@gmail.com" class="form-control" value="" maxlength="128" />
                    </div>
                    <div class="col-xs-6">
                        <label for="displayName">Display Name:</label>
                        <input type="text" id="displayName" name="displayName" placeholder="Display name when logged-in" class="form-control" value="" maxlength="16" />
                    </div>
                </div>
                <br />
                <div class="row">
                    <div class="col-xs-6">
                        <label for="pass">Password:</label>
                        <input type="password" id="pass" name="pass" class="form-control" value="" maxlength="16" />
                    </div>
                    <div class="col-xs-6">
                        <label for="passConfirm">Confirm Password:</label>
                        <input type="password" id="passConfirm" name="passConfirm" class="form-control" value="" maxlength="16" />
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
            <label><input id="ckbLicenseTerms" type="checkbox" value="" /> Agree on Home Finder License Terms. <a href="/mvc/license/terms" target="_blank">(See License Terms)</a> </label>

            <hr />
            <br />
            <div class="row">
                <div class="col-xs-12">
                    <input type="submit" class="btn btn-info" value="Sign Up" />
                </div>
            </div>
            <br />
        </form>
    </div>
    <div class="col-xs-2"></div>
</div>

<br /><br />
<footer>
    <div class="col-xs-12 text-center">
        <b>Home Finder</b>
    </div>
</footer>

</body>
</html>