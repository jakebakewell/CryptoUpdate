package com.cryptoupdate.models;

import java.util.Map;

import com.fasterxml.jackson.annotation.JsonProperty;

public class Coin {
	private String id;
	private String symbol;
	private String name;
	@JsonProperty("image")
	private Map<String, String> imageurl;
	@JsonProperty("market_data")
	private Map<String, Object> marketdata;
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getSymbol() {
		return symbol;
	}
	public void setSymbol(String symbol) {
		this.symbol = symbol;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public Map<String, String> getImageurl() {
		return imageurl;
	}
	public void setImageurl(Map<String, String> imageurl) {
		this.imageurl = imageurl;
	}
	public Map<String, Object> getMarketdata() {
		return marketdata;
	}
	public void setMarketdata(Map<String, Object> marketdata) {
		this.marketdata = marketdata;
	}
	@Override
	public String toString() {
		return "Coin [imageurl=" + imageurl + ", currentprice=" + marketdata + "]";
	}
}
