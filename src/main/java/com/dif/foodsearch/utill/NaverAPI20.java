package com.dif.foodsearch.utill;

import com.github.scribejava.core.builder.api.DefaultApi20;

public class NaverAPI20 extends DefaultApi20 implements SnsUrls {
	private NaverAPI20() {
	}
	
	private static class InstanceHolder {
		private static final NaverAPI20 INSTANCE = new NaverAPI20();
	}
	
	public static NaverAPI20 instance() {
		return InstanceHolder.INSTANCE;
	}

	@Override
	public String getAccessTokenEndpoint() {
		return N_ACCESS_TOKEN;
	}

	@Override
	protected String getAuthorizationBaseUrl() {
		return N_AUTH;
	}
}
