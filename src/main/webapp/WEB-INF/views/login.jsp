<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="google-signin-scope" content="profile email">
<meta name="google-signin-client_id"
	content="53828679659-h0m4th5u7oop341guu0nb7uinkm282t8.apps.googleusercontent.com">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://apis.google.com/js/platform.js" async defer></script>
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<link rel="stylesheet" type="text/javascript"
	href="/resources/css/LoginBT.css">
</head>
<script>
	 var csrfToken = $("meta[name='_csrf']").attr("content");
	$.ajaxPrefilter(function(options, originalOptions, jqXHR){
	  if (options['type'].toLowerCase() === "post") {
	      jqXHR.setRequestHeader('X-CSRF-TOKEN', csrfToken);
	  }
	}); 

      function onSignIn(googleUser) {
    	  // Useful data for your client-side scripts:
        var profile = googleUser.getBasicProfile();
        var id_token = googleUser.getAuthResponse().id_token;
        
        $("#googleBtn").click(function() {
	        console.log("ID: " + profile.getId()); // Don't send this directly to your server!
	        console.log('Full Name: ' + profile.getName());
	        console.log('Given Name: ' + profile.getGivenName());
	        console.log('Family Name: ' + profile.getFamilyName());
	        console.log("Image URL: " + profile.getImageUrl());
	        console.log("Email: " + profile.getEmail());
        	$.ajax({
        		 url: 'https://gu-ni.com/login/google/callback'
        		,type: 'POST'
        		,data: 'idtoken=' + id_token
        		,dataType: 'JSON'
        		,beforeSend : function(xhr){
        			 xhr.setRequestHeader("Content-type","application/x-www-form-urlencoded"); }
        		,success: function(json){
        			if (json.login_result == "success"){
        				location.href = "https://gu-ni.com/login";
        			}
        		}
        	});	
        });
      }
      function logout() {
    	  var auth2 = gapi.auth2.getAuthInstance();
    	  auth2.signOut().then(function () {
    		  console.log("User signed out.")
    	  });
    	  auth2.disconnect();
      }
      
      
    </script>
<body>
	<c:choose>
		<c:when test="${kname != null}">
			<h2>카카오 아이디 로그인 성공하셨습니다!!</h2>
			<h3>'${kname}' 님 환영합니다!</h3>
			<a href="/logout">로그아웃</a>
		</c:when>
		<c:when test="${nickname != null}">
			<h2>네이버 아이디 로그인 성공하셨습니다!!</h2>
			<h3>'${nickname}' 님 환영합니다!</h3>
			<a href="/logout">로그아웃</a>
		</c:when>
		<c:when test="${id != null}">
			<h2>구글 아이디 로그인 성공하셨습니다!!</h2>
			<h3>'${id}' 님 환영합니다!</h3>
			<a href="/logout">로그아웃</a>
		</c:when>
		<c:otherwise>
			<form action="login.userdo" method="post" name="frm"
				style="width: 470px;">
				<h2>로그인</h2>
				<input type="text" name="id" id="id" class="w3-input w3-border"
					placeholder="아이디" value="${id}"> <br> <input
					type="password" id="pwd" name="pwd" class="w3-input w3-border"
					placeholder="비밀번호"> <br> <input type="submit"
					value="로그인" onclick="#"> <br>
			</form>
			<br>
			<div class="text-center">
				<a href="${n_url }"><img width="50" src="/resources/images/naver.png" alt="Naver Login"></a>
				<a class="g-signin2" id=googleBtn data-onsuccess="onSignIn"><img width="50" src="/resources/images/google.png" alt="Google Login"></a>
				<a href="${k_url }"><img width="50" src="/resources/images/kakao.png" alt="Kakao Login"></a>
				<a href="${facebook_url}"><img width="50" src="/resources/images/kakao.png" alt="facebook Login"></a>
				
			</div>
		</c:otherwise>
	</c:choose>
</body>
</html>