package com.dif.foodsearch.utill;

import org.apache.commons.lang3.StringUtils;

import com.github.scribejava.apis.GoogleApi20;
import com.github.scribejava.core.builder.api.DefaultApi20;

import lombok.Data;

@Data
public class SnsValue implements SnsUrls {
	private String service;
	private String clientId;
	private String clientSecret;
	private String redirectUrl;
	private DefaultApi20 api20Instance;
	private String profileUrl;
	
	public SnsValue(String service, String clienId, String clientSecret, String redirectUrl) {
		this.service = service;
		this.clientId = clienId;
		this.clientSecret = clientSecret;
		this.redirectUrl = redirectUrl;
	
		if (StringUtils.equalsIgnoreCase(service, "naver")) {
			System.out.println("==========================service" + service);
			this.api20Instance = NaverAPI20.instance();
			System.out.println("=======================api20Instance"+api20Instance);
			this.profileUrl = N_PROFILE_URL;
		
		} else if (StringUtils.equalsIgnoreCase(service, "google")) {
			this.api20Instance = GoogleApi20.instance();
			this.profileUrl = G_PROFILE_URL;
		} 
	}
}
