<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>CryptoUpdate Login</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-eOJMYsd53ii+scO/bJGFsiCZc+5NDVN2yr8+0RDqr0Ql0h+rP48ckxlpbzKgwra6" crossorigin="anonymous">
<script src="https://apis.google.com/js/platform.js" async defer></script>
<meta name="google-signin-client_id" content="445803876111-rjfijspv0l2rj6ck95tjfkj3n4ifpd2l.apps.googleusercontent.com">
</head>
<body class="p-5 bg-secondary">
<script>
  function signOut() {
    var auth2 = gapi.auth2.getAuthInstance();
    auth2.signOut().then(function () {
      console.log('User signed out.');
    });
  }
</script>
<script>
	function onSignIn(googleUser) {
    // Useful data for your client-side scripts:
        var profile = googleUser.getBasicProfile();
        console.log("ID: " + profile.getId()); // Don't send this directly to your server!
        console.log('Full Name: ' + profile.getName());
        console.log('Given Name: ' + profile.getGivenName());
        console.log('Family Name: ' + profile.getFamilyName());
        console.log("Image URL: " + profile.getImageUrl());
        console.log("Email: " + profile.getEmail());
        
        var givenName = profile.getGivenName();
        var familyName = profile.getFamilyName();
        var gmail = profile.getEmail();

    // The ID token you need to pass to your backend:
        var id_token = googleUser.getAuthResponse().id_token;
        console.log("ID Token: " + id_token);
	// Pass the data on to a controller
        var xhr = new XMLHttpRequest();
        xhr.open('POST', 'http://localhost:8080/tokensignin');
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        xhr.onload = function() {
          console.log('Signed in as: ' + xhr.responseText);
        };
        xhr.send('idtoken=' + id_token);
	}
</script>
<h1 class="container text-center bg-light rounded p-1 text-warning">Welcome to CryptoUpdate</h1>

<a href="#" onclick="signOut();" class="bg-light rounded text-danger p-1">Sign out</a>

<div class="container d-flex justify-content-evenly bg-light rounded">
	<div class="d-flex flex-column mt-5 justify-content-center">
		<div class="g-signin2" data-width="230" data-height="50" data-longtitle="true" data-onsuccess="onSignIn"></div>
	</div>
	
	<div class="d-flex flex-column">
		<div class="container pt-5 pb-3 text-center">
	    <h2 class="mb-3">Register</h2>
	    
	    <p class="text-danger"><form:errors path="user.*"/></p>
	    <p class="text-danger">${warning}</p>
	    
	    <form:form method="POST" action="/registration" modelAttribute="user" class="form-group">
	    	<p>
	            <form:label path="firstName">First Name:</form:label>
	            <form:input type="text" path="firstName"/>
	        </p>
	    	<p>
	            <form:label path="lastName">Last Name:</form:label>
	            <form:input type="text" path="lastName"/>
	        </p>
	    	<p>
	            <form:label path="email">Email:</form:label>
	            <form:input type="email" path="email"/>
	        </p>
	        <p>
	            <form:label path="password">Password:</form:label>
	            <form:password path="password"/>
	        </p>
	        <p>
	            <form:label path="passwordConfirmation">Password Confirmation:</form:label>
	            <form:password path="passwordConfirmation"/>
	        </p>
	        <input type="submit" value="Register" class="btn btn-primary mt-4"/>
	    </form:form>
	    </div>
	    
		<div class="container pt-5 pb-3 text-center">
	    <h2 class="mb-3">Login</h2>
	    <p class="text-danger"><c:out value="${error}" /></p>
	    <form method="post" action="/login" class="form-group">
	        <p>
	            <label for="email">Email</label>
	            <input type="text" id="email" name="email"/>
	        </p>
	        <p>
	            <label for="password">Password</label>
	            <input type="password" id="password" name="password"/>
	        </p>
	        <input type="submit" value="Login" class="btn btn-warning mt-4"/>
	    </form>
	    </div>
	    
	</div>
</div>
</body>
</html>