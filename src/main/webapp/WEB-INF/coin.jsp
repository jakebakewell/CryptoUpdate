<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Coin</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-eOJMYsd53ii+scO/bJGFsiCZc+5NDVN2yr8+0RDqr0Ql0h+rP48ckxlpbzKgwra6" crossorigin="anonymous">
</head>
<body class="p-3 bg-secondary">
<div class="container d-flex justify-content-evenly bg-info rounded p-4">
	<div class="text-center bg-light rounded p-4">
		<h1><c:out value="${coin.name}"/></h1>
		<p>CoinGecko ID - <span class="fw-bold"><c:out value="${coin.id}"/></span></p>
		<p>Market Symbol - <span class="fw-bold"><c:out value="${coin.symbol}"/></span></p>
		<p>Market Price - <span class="fw-bold">$<c:out value="${coin.marketdata.current_price.usd}"/></span></p>
		<c:if test="${coin.marketdata.price_change_percentage_24h < 0}">
			<p>Price Change % 24H - <span class="text-danger fw-bold">% <c:out value="${coin.marketdata.price_change_percentage_24h}"/></span></p>
		</c:if>
		<c:if test="${coin.marketdata.price_change_percentage_24h > 0}">
			<p>Price Change % 24H - <span class="text-success fw-bold">% <c:out value="${coin.marketdata.price_change_percentage_24h}"/></span></p>
		</c:if>
		<c:if test="${coin.marketdata.price_change_percentage_7d > 0}">
			<p>Price Change % 7D - <span class="text-success fw-bold">% <c:out value="${coin.marketdata.price_change_percentage_7d}"/></span></p>
		</c:if>
		<c:if test="${coin.marketdata.price_change_percentage_7d < 0}">
			<p>Price Change % 7D - <span class="text-danger fw-bold">% <c:out value="${coin.marketdata.price_change_percentage_7d}"/></span></p>
		</c:if>
		<c:if test="${coin.marketdata.price_change_percentage_30d > 0}">
			<p>Price Change % 30D - <span class="text-success fw-bold">% <c:out value="${coin.marketdata.price_change_percentage_30d}"/></span></p>
		</c:if>
		<c:if test="${coin.marketdata.price_change_percentage_30d < 0}">
			<p>Price Change % 30D - <span class="text-danger fw-bold">% <c:out value="${coin.marketdata.price_change_percentage_30d}"/></span></p>
		</c:if>
		<p>Market Cap - <span class="fw-bold">$<c:out value="${coin.marketdata.market_cap.usd}"/></span></p>
	</div>
	<div>
		<img alt="${coin.name}" src="${coin.imageurl.large}">
	</div>
</div>
</body>
</html>