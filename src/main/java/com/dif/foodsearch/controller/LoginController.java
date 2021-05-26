package com.dif.foodsearch.controller;

import java.io.IOException;
import java.security.GeneralSecurityException;
import java.util.Collections;

import javax.inject.Inject;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.social.MissingAuthorizationException;
import org.springframework.social.connect.Connection;
import org.springframework.social.facebook.api.Facebook;
import org.springframework.social.facebook.api.User;
import org.springframework.social.facebook.api.UserOperations;
import org.springframework.social.facebook.api.impl.FacebookTemplate;
import org.springframework.social.facebook.connect.FacebookConnectionFactory;
import org.springframework.social.oauth2.AccessGrant;
import org.springframework.social.oauth2.GrantType;
import org.springframework.social.oauth2.OAuth2Operations;
import org.springframework.social.oauth2.OAuth2Parameters;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import com.fasterxml.jackson.databind.JsonNode;
import com.github.scribejava.core.model.OAuth2AccessToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken.Payload;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.googleapis.util.Utils;
import com.google.api.client.http.HttpTransport;
import com.google.api.client.json.JsonFactory;
import com.dif.foodsearch.com.service.SnsService;
import com.dif.foodsearch.utill.SNSLogin;
import com.dif.foodsearch.utill.SnsValue;
import com.dif.foodsearch.vo.UserVO;

@Controller
public class LoginController {
	private static final Logger logger = LoggerFactory.getLogger(LoginController.class);

	@Inject
	private SnsValue nSns;

	@Inject
	private SnsValue gSns;
	
	@Autowired
	private SnsService service;
	
	@Autowired
	private FacebookConnectionFactory connectionFactory;
	@Autowired
	private OAuth2Parameters oAuth2Parameters;

	private String apiResult = null;

	@RequestMapping(value = "/login", method = RequestMethod.GET)
	public String login(HttpServletResponse response, Model model, HttpSession session) throws Exception {
		SNSLogin snsLogin = new SNSLogin(nSns, session);
		model.addAttribute("n_url", snsLogin.getNaverAuthURL());
		System.out.println("naver" + snsLogin.getNaverAuthURL());
		String kakaoUrl = SNSLogin.kgetAuthorizationUrl(session);
		System.out.println("kakaoUrl" + kakaoUrl);
		model.addAttribute("k_url", kakaoUrl);

		OAuth2Operations oauthOperations = connectionFactory.getOAuthOperations();
		String facebook_url = oauthOperations.buildAuthorizeUrl(GrantType.AUTHORIZATION_CODE, oAuth2Parameters);

		model.addAttribute("facebook_url", facebook_url);
		System.out.println("/facebook" + facebook_url);

		return "/login";
	}

	@RequestMapping(value = "/login/{snsService}/callback", method = { RequestMethod.POST, RequestMethod.GET })
	public String snsLoginCallback(Model model, @PathVariable String snsService, @RequestParam String code,
			HttpSession session, String idtoken) throws Exception {
		logger.info("snsLoginCallback: service={}", snsService);
		SnsValue sns = null;
		if (StringUtils.equals("naver", snsService)) {
			System.out.println("여기는 naver callback");
			sns = nSns;
			OAuth2AccessToken oauthToken;
			oauthToken = SNSLogin.getAccessToken(session, code, sns);
			apiResult = SNSLogin.getUserProfile(oauthToken, sns);
			System.out.println("oauthToken" + oauthToken);
			System.out.println("apiResult" + apiResult);
			JSONParser parser = new JSONParser();
			Object obj = parser.parse(apiResult);
			JSONObject jsonObj = (JSONObject) obj;

			JSONObject response_obj = (JSONObject) jsonObj.get("response");

			String nickname = (String) response_obj.get("nickname");
			String email = (String) response_obj.get("email");
			System.out.println(nickname);
			
			UserVO vo = service.socialLogin(nickname, email, "na");
			
			if(vo != null) {
				session.setAttribute("user", vo);
			}else {
				model.addAttribute("result", 1);
				return "login";
			}
			
			return "redirect:/";

		} else if (StringUtils.equals("kakao", snsService)) {
			logger.info("여기는 kakao callback");
			JsonNode node = SNSLogin.getAccessToken(code);
			// accessToken에 사용자의 로그인한 모든 정보가 들어있음
			JsonNode accessToken = node.get("access_token");
			// 사용자의 정보
			JsonNode userInfo = SNSLogin.getKakaoUserInfo(accessToken);
			String kemail = null;
			String kname = null;
			String kgender = null;
			String kbirthday = null;
			String kage = null;
			String kimage = null;
			// 유저정보 카카오에서 가져오기 Get properties
			JsonNode properties = userInfo.path("properties");
			JsonNode kakao_account = userInfo.path("kakao_account");
			kemail = kakao_account.path("email").asText();
			kname = properties.path("nickname").asText();
			kimage = properties.path("profile_image").asText();
			kgender = kakao_account.path("gender").asText();
			kbirthday = kakao_account.path("birthday").asText();
			kage = kakao_account.path("age_range").asText();
			
			UserVO vo = service.socialLogin(kname, kemail, "ka");
			
			if(vo != null) {
				session.setAttribute("user", vo);
			}else {
				model.addAttribute("result", 1);
				return "login";
			}
		}
			return "redirect:/";
	}

	/* Google */
	@ResponseBody
	@RequestMapping(value = "/login/google/callback", method = RequestMethod.POST)
	public String googleLogin(String idtoken, Model model, HttpSession session)
			throws GeneralSecurityException, IOException {
		// 구글 토큰 값
		HttpTransport transport = Utils.getDefaultTransport();
		JsonFactory jsonFactory = Utils.getDefaultJsonFactory();
		logger.info("여기는 callback");
		// 구글 토큰값을 이용해 유저정보 얻기
		GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(transport, jsonFactory)
				.setAudience(Collections
				.singletonList("53828679659-h0m4th5u7oop341guu0nb7uinkm282t8.apps.googleusercontent.com"))
				.build(); // 백엔드에 액세스하는 앱의 CLIENT_ID지정
		verifier.getIssuer();
		GoogleIdToken idToken = verifier.verify(idtoken);
		JSONObject json = new JSONObject();
	
		// ID 토큰 확인
		if (idToken != null) {
			Payload payload = idToken.getPayload();
			// Print user identifier
			String userId = payload.getSubject();
			System.out.println("User ID: " + userId);

			// 왜 string 으로?? json인가?
			// Get profile information from payload
			String email = payload.getEmail();
			boolean emailVerified = Boolean.valueOf(payload.getEmailVerified());
			String name = (String) payload.get("name");
			String pictureUrl = (String) payload.get("picture");
			String locale = (String) payload.get("locale");
			String familyName = (String) payload.get("family_name");
			String givenName = (String) payload.get("given_name");

			json.put("login_result", "success");
			
			UserVO vo = service.socialLogin(name, email, "go");
			if(vo != null) {
				session.setAttribute("user", vo);
			}else {
				model.addAttribute("result", 1);
				return "login";
			}
		} else { // 유효하지 않은 토큰
			json.put("login_result", "fail");
		} // end else
		
		return json.toString();

	}// googleLogin

	@RequestMapping(value = "/login/facebook/callback", method = { RequestMethod.GET, RequestMethod.POST })
	public String facebookSignInCallback(HttpSession session,Model model, @RequestParam String code) throws Exception {
		System.out.println("여기는 callback");
		try {
			String redirectUri = oAuth2Parameters.getRedirectUri();
			System.out.println("Redirect URI : " + redirectUri);
			System.out.println("Code : " + code);

			OAuth2Operations oauthOperations = connectionFactory.getOAuthOperations();
			AccessGrant accessGrant = oauthOperations.exchangeForAccess(code, redirectUri, null);
			String accessToken = accessGrant.getAccessToken();
			System.out.println("AccessToken: " + accessToken);
			Long expireTime = accessGrant.getExpireTime();

			if (expireTime != null && expireTime < System.currentTimeMillis()) {
				accessToken = accessGrant.getRefreshToken();
				logger.info("accessToken is expired. refresh token = {}", accessToken);
			}
			;

			Connection<Facebook> connection = connectionFactory.createConnection(accessGrant);
			Facebook facebook = connection == null ? new FacebookTemplate(accessToken) : connection.getApi();
			UserOperations userOperations = facebook.userOperations();

			try

			{
				String[] fields = { "id", "email", "name" };
				User userProfile = facebook.fetchObject("me", User.class, fields);
				System.out.println("유저이메일 : " + userProfile.getEmail());
				System.out.println("유저 id : " + userProfile.getId());
				System.out.println("유저 name : " + userProfile.getName());
				session.setAttribute("name", userProfile.getName());
				
				UserVO vo = service.socialLogin(userProfile.getName(), userProfile.getEmail(), "fa");
				if(vo != null) {
					session.setAttribute("user", vo);
				}else {
					model.addAttribute("result", 1);
					return "login";
				}
				
			} catch (MissingAuthorizationException e) {
				e.printStackTrace();
			}

		} catch (Exception e) {

			e.printStackTrace();

		}
		
		
		
		return "home";
	}

	@RequestMapping(value = "/logout", method = { RequestMethod.GET, RequestMethod.POST })
	public String logout(HttpSession session) throws IOException {
		System.out.println("여기는 logout");
		session.invalidate();
		
		return "redirect:/";
	}
	
	@RequestMapping(value = "/localSignIn", method = RequestMethod.POST)
	public String localSignIn(HttpSession session, String id, String pwd, Model model){
		System.out.println("local login");
		UserVO vo = service.localSignIn(id, pwd);
		//로그인 실패시 id는 n리턴
		if(vo != null && vo.getUser_ID().equals("n")==false) {
			/*
			 * session.setAttribute("name", vo.getUser_NickName());
			 * session.setAttribute("userid", vo.getUser_ID());
			 */
			session.setAttribute("user", vo);
			return "redirect:/";
		}else {
			model.addAttribute("result", 1);
			return "login";
		}
		
		
	}
	
} // LoginController
