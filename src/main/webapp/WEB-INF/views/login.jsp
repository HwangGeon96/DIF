<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
<%-- <meta name="_csrf" content="${_csrf.token}"/> --%>
<meta name="google-signin-scope" content="profile email">
<meta name="google-signin-client_id"
	content="53828679659-h0m4th5u7oop341guu0nb7uinkm282t8.apps.googleusercontent.com">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://apis.google.com/js/platform.js?onload=init" async defer></script>
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<link href="https://fonts.googleapis.com/css?family=Roboto" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="/resources/css/btn.css">

	
<script>
	/*  var csrfToken = $("meta[name='_csrf']").attr("content");

	$.ajaxPrefilter(function(options, originalOptions, jqXHR){
	  if (options['type'].toLowerCase() === "post") {
	      jqXHR.setRequestHeader('X-CSRF-TOKEN', csrfToken);
	  }
	});  */
    
      function onSignIn(googleUser) {
    	  // Useful data for your client-side scripts:
        var profile = googleUser.getBasicProfile();
        var id_token = googleUser.getAuthResponse().id_token;
        
        $("#gSignInWrapper").click(function() {
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
        				location.href = "https://gu-ni.com";
        			}
        		}
        	});	
        });
      }

</script>
</head>
<body>	

		<br>
		<h2 style="text-align: center;">로그인</h2>
		<form action="login.userdo" method="post" name="frm">
			<table style="width: 1em; margin: auto;">
				<tr>
					<td>
						<input type="text" name="id" id="id" 
						class="w3-input w3-border" placeholder="아이디">
					</td>
					<td rowspan="2">
						<input type="submit" style="height: 48px;" value="로그인" onclick="#">
					</td>
				</tr>
				<tr>
					<td>
						<input type="password" id="pwd" name="pwd" 
						class="w3-input w3-border" placeholder="비밀번호"> 
					</td>
				</tr>
			</table>	
		</form>
		<table style="width: 1em; margin: auto;">
			<tr>
				<td>
					<a href="${n_url }">
						<div id="nSignInWrapper">
						    <div id="customBtn2" class="customnPlusSignIn">
						      <span class="icon"><img class="logo1" src="/resources/icons/btnG_아이콘사각.png"></span>
						      <span class="buttonText">네이버 로그인</span>
						    </div>
						</div>
					</a>
				</td>
			</tr>
			<tr>
				<td>
					<div class="g-signin2" data-onsuccess="onSignIn" hidden="true"></div>
					<div id="gSignInWrapper">
						  <div id="customBtn" class="customgPlusSignIn">
						     <span class="icon"><img class="logo" src="/resources/icons/g-logo.png"> </span>
						     <span class="buttonText">구글 로그인</span>
						  </div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<a href="${k_url }">
						<img src="/resources/icons/kakao_login_medium_narrow.png">
					</a>
				</td>
			</tr>
			<tr>	
				<td>
					<a href="${facebook_url}">
						<div id="fSignInWrapper">
						    <div id="customBtn1" class="customfPlusSignIn">
						      <span class="icon"><img class="logo" src="/resources/icons/f_logo.png"></span>
						      <span class="buttonText">페이스북 로그인</span>
						    </div>
						</div>
					</a>
				</td>
			</tr>
		</table>
		<div class="text-center" style="text-align: center;">
			
			
		</div>
		<div style="text-align: center;">
			
		</div>
</body>
</html>