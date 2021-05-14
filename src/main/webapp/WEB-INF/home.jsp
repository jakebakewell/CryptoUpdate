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
<title>CryptoUpdate Home</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-eOJMYsd53ii+scO/bJGFsiCZc+5NDVN2yr8+0RDqr0Ql0h+rP48ckxlpbzKgwra6" crossorigin="anonymous">
<link rel="stylesheet" type="text/css" href="css/home.css">
<script src="https://apis.google.com/js/platform.js" async defer></script>
<meta name="google-signin-client_id" content="445803876111-rjfijspv0l2rj6ck95tjfkj3n4ifpd2l.apps.googleusercontent.com">
</head>
<body class="p-3 bg-secondary">
<script>
  function signOut() {
    var auth2 = gapi.auth2.getAuthInstance();
    auth2.signOut().then(function () {
      console.log('User signed out.');
    });
  }
</script>
	<div class="bg-info rounded p-5">
		<div class="float-end">
			<a href="/logout" onclick="signOut();" class="btn btn-danger mt-3">Log Out</a>
		</div>
		<h1 class="text-center mb-3">CryptoUpdate</h1>
		<h3 class="text-start mb-4">Welcome <c:out value="${user.firstName}" /> <c:out value="${user.lastName}" /></h3>
		<p class="text-success text-center"><c:out value="${success}" /></p>
		<div class="container bg-light rounded text-center p-5" id="all_cryptos">
			<c:forEach items="${cryptocurrencies}" var="crypto">
				<h4>Cryptocurrency Name: <span class="fw-bold">${crypto.name}</span></h4>
				<p>CoinGecko ID: <span class="fw-bold">${crypto.id}</span></p>
				<p>Market Symbol: <span class="fw-bold">${crypto.symbol}</span></p>
				<a href="/coin/${crypto.id}" class="btn btn-primary p-1">More Info</a>
				<p>***********************************</p>
			</c:forEach>
		</div>
	</div>
</body>
</html>