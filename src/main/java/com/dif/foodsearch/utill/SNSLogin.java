package com.dif.foodsearch.utill;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.ExecutionException;

import javax.servlet.http.HttpSession;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;
import org.springframework.util.StringUtils;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.scribejava.core.builder.ServiceBuilder;
import com.github.scribejava.core.model.OAuth2AccessToken;
import com.github.scribejava.core.model.OAuthRequest;
import com.github.scribejava.core.model.Response;
import com.github.scribejava.core.model.Verb;
import com.github.scribejava.core.oauth.OAuth20Service;

public class SNSLogin {
	private OAuth20Service oauthService;
	private SnsValue sns;
	private String profileUrl;
	private final static String NSESSION_STATE = "noauth_state";
	private final static String GSESSION_STATE = "goauth_state";
	private final static String KSESSION_STATE = "koauth_state";
	private final static String K_CLIENT_ID = "77a384ce23391d311107bbf45179532f";
	private final static String K_REDIRECT_URI = "https://gu-ni.com/login/kakao/callback";
	/* 로그인 인증 URL 생성 */
	public SNSLogin(SnsValue sns, HttpSession session) {

		if (StringUtils.pathEquals(sns.getService(), "naver")) {
			String nstate = generateRandomString();
			nsetSession(session, nstate);
			System.out.println("naver state" + nstate);
			session.setAttribute("nstate", nstate);
			this.oauthService = new ServiceBuilder().apiKey(sns.getClientId()).apiSecret(sns.getClientSecret())
					.callback(sns.getRedirectUrl()).scope("profile").state(nstate).build(sns.getApi20Instance());
			this.profileUrl = sns.getProfileUrl();
		}
		
		System.out.println("sns>>>>" + sns);
		
	}
	
	public static String kgetAuthorizationUrl(HttpSession session) {
		String kakaoUrl = "https://kauth.kakao.com/oauth/authorize?" + "client_id=" + K_CLIENT_ID + "&redirect_uri="
				+ K_REDIRECT_URI + "&response_type=code";

		return kakaoUrl;
	}

	public String getNaverAuthURL() {
		return this.oauthService.getAuthorizationUrl();
	}

	/* Callback 처리 및 AccessToken 획득 Method */
	public static OAuth2AccessToken getAccessToken(HttpSession session, String code, SnsValue sns)throws IOException, InterruptedException, ExecutionException {
		String nsessionState = ngetSession(session);
		
		System.out.println("nsessionState" + nsessionState);
		if (StringUtils.pathEquals(nsessionState, (String) session.getAttribute("nstate"))) {
			OAuth20Service oauthService = new ServiceBuilder().apiKey(sns.getClientId()).apiSecret(sns.getClientSecret())
					.callback(sns.getRedirectUrl()).state(NSESSION_STATE).build(sns.getApi20Instance());
			OAuth2AccessToken accessToken = oauthService.getAccessToken(code);
			return accessToken;
		}

		 
		
		return null;
	}

	public static JsonNode getAccessToken(String autorize_code) {
		final String RequestUrl = "https://kauth.kakao.com/oauth/token";
		final List<NameValuePair> postParams = new ArrayList<NameValuePair>();
		postParams.add(new BasicNameValuePair("grant_type", "authorization_code"));
		postParams.add(new BasicNameValuePair("client_id", "77a384ce23391d311107bbf45179532f")); // REST API KEY
		postParams.add(new BasicNameValuePair("redirect_uri", "http://localhost:8800/login/kakao/callback")); // 리다이렉트
																												// URI
		postParams.add(new BasicNameValuePair("code", autorize_code)); // 로그인 과정중 얻은 code 값
		final HttpClient client = HttpClientBuilder.create().build();
		final HttpPost post = new HttpPost(RequestUrl);
		JsonNode returnNode = null;
		try {
			post.setEntity(new UrlEncodedFormEntity(postParams));
			final HttpResponse response = client.execute(post); // JSON 형태 반환값 처리
			ObjectMapper mapper = new ObjectMapper();
			returnNode = mapper.readTree(response.getEntity().getContent());
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		} catch (ClientProtocolException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			// clear resources
		}
		return returnNode;
	}
	
	public static JsonNode getKakaoUserInfo(JsonNode accessToken) {
		final String RequestUrl = "https://kapi.kakao.com/v2/user/me";
		final HttpClient client = HttpClientBuilder.create().build();
		final HttpPost post = new HttpPost(RequestUrl);
		// add header
		post.addHeader("Authorization", "Bearer " + accessToken);
		JsonNode returnNode = null;
		try {
			final HttpResponse response = client.execute(post);
			// JSON 형태 반환값 처리
			ObjectMapper mapper = new ObjectMapper();
			returnNode = mapper.readTree(response.getEntity().getContent());
		} catch (ClientProtocolException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			// clear resources
		}
		return returnNode;
	}
	
	/* 세션 유효성 검증을 위한 난수 생성기 */
	private String generateRandomString() {
		return UUID.randomUUID().toString();
	}

	/* http session에 데이터 저장 */
	private void nsetSession(HttpSession session, String nstate) {
		session.setAttribute(NSESSION_STATE, nstate);
		System.out.println("nstate" + nstate);
	}

	/* http session에서 데이터 가져오기 */
	static private String ngetSession(HttpSession session) {
		return (String) session.getAttribute(NSESSION_STATE);
	}

	 
	/* Access Token을 이용하여 네이버 사용자 프로필 API를 호출 */
	public static String getUserProfile(OAuth2AccessToken oauthToken, SnsValue sns ) throws IOException {
		
		String profile = sns.getProfileUrl();
		
		OAuth20Service oauthService = new ServiceBuilder().apiKey(sns.getClientId()).apiSecret(sns.getClientSecret())
				.callback(sns.getRedirectUrl()).build(sns.getApi20Instance());
		OAuthRequest request = new OAuthRequest(Verb.GET, profile, oauthService);
		oauthService.signRequest(oauthToken, request);
		Response response = request.send();
		return response.getBody();
	}
}
