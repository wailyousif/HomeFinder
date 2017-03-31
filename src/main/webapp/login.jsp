<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>

<!DOCTYPE HTML>
<html style="font-family: Arial, sans-serif; margin: 0; padding: 0;">
<head>
    <title>Login</title>

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
        $(document).ready
        (
            function()
            {
                $("#frmSignIn").submit
                (
                    function(ev)
                    {
                        ev.preventDefault();

                        var okMsgBoxHtml = '<br /><br /><button id="popupOKButton" type="button" class="btn btn-warning" onclick="hidePopup(0,0);">OK</button>';

                        var emailReg = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
                        var email = document.getElementById('email').value;
                        var validEmail = emailReg.test(email);
                        if (validEmail == false)
                        {
                            showPopup('', 'Invalid email address' + okMsgBoxHtml);
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

                        var objFormData = new FormData();

                        objFormData.append('email', email.trim());
                        objFormData.append('pass', passHash);

                        var previousPage = getURLParameter('pp');

                        $.ajax
                        (
                            {
                                cache: false,
                                type: "POST",
                                contentType: false,
                                url: "/rest/user/login",
                                data: objFormData,
                                processData: false,
                                success: function(respObj)
                                {
                                    if (respObj.success == 1 && respObj.responseCode == 0)
                                    {
                                        if (previousPage === '1')
                                        {
                                            window.location.replace("/addprop.jsp");
                                        }
                                        else if (previousPage === '2')
                                        {
                                            window.location.replace("/editprop.jsp");
                                        }
                                        else if (previousPage === '3')
                                        {
                                            var emailUnsubId = getURLParameter('emailunsub');
                                            window.location.replace("/finder.jsp?emailunsub=" + emailUnsubId);
                                        }
                                        else
                                        {
                                            window.location.replace("/finder.jsp");
                                        }
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
            $("#email").focus();
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
                <li style="display: inline;"><a href="/mvc/user/add"><span class="glyphicon glyphicon-user"></span> Sign Up</a></li>
                <li class="active" style="display: inline;"><a href="#"><span class="glyphicon glyphicon-log-in"></span> Login</a></li>
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
    <div class="col-xs-4"></div>
    <div class="col-xs-4">
        <h2>Login</h2>
        <hr />

        <form id="frmSignIn">
            <div class="row" style="text-align: right;">
                <div class="col-xs-12">
                    <a href="/mvc/user/add">New User? Sign Up</a>
                </div>
            </div>
            <div class="row">
                <div class="col-xs-12">
                    <label for="email">Email:</label>
                    <input type="text" id="email" name="email" placeholder="john@gmail.com" class="form-control" value="" maxlength="128" />
                </div>
            </div>
            <br />
            <div class="row">
                <div class="col-xs-12">
                    <label for="pass">Password:</label>
                    <input type="password" id="pass" name="pass" class="form-control" value="" maxlength="16" />
                </div>
            </div>
            <br />
            <hr />
            <div class="row">
                <div class="col-xs-12">
                    <input type="submit" class="btn btn-info" value="Sign In" />
                </div>
            </div>
            <br />
        </form>
    </div>
    <div class="col-xs-4"></div>
</div>

<br /><br />
<footer>
    <div class="col-xs-12 text-center">
        <b>Home Finder</b>
    </div>
</footer>

</body>
</html>