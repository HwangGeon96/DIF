<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
<meta name="google-signin-scope" content="profile email">
<meta name="google-signin-client_id"
	content="53828679659-h0m4th5u7oop341guu0nb7uinkm282t8.apps.googleusercontent.com">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://apis.google.com/js/platform.js?onload=init" async defer></script>
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<script src="https://apis.google.com/js/api:client.js"></script>
<link href="https://fonts.googleapis.com/css?family=Roboto" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="/resources/css/btn.css">

	
<script>
	
	var googleUser = {};
	var startApp = function() {
	    gapi.load('auth2', function(){
	      // Retrieve the singleton for the GoogleAuth library and set up the client.
	      auth2 = gapi.auth2.init({
	        client_id: '53828679659-h0m4th5u7oop341guu0nb7uinkm282t8.apps.googleusercontent.com',
	        cookiepolicy: 'single_host_origin',
	        // Request scopes in addition to 'profile' and 'email'
	        //scope: 'additional_scope'
	      });
	      attachSignin(document.getElementById('customBtn'));
	    });
	  };

	  function attachSignin(element) {
	    auth2.attachClickHandler(element, {},
	        function(googleUser) {
	    		var id_token = googleUser.getAuthResponse().id_token;

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
	        }, function(error) {
	          alert(JSON.stringify(error, undefined, 2));
	        });
	  }
</script>
</head>
<body>	
		<c:if test="${result eq 1}">
			<script type="text/javascript">
				alert("아이디 혹은 비밀번호를 다시 확인해주세요.");
				location.href = "https://gu-ni.com/login";
			</script>
		</c:if>
		<br>
		<h2 style="text-align: center;">로그인</h2>
		<form action="/localSignIn" method="post" name="frm">
			<table style="width: 1em; margin: auto;">
				<tr>
					<td>
						<input type="text" name="id" id="id" 
						class="w3-input w3-border" placeholder="아이디">
					</td>
					<td rowspan="2">
						<input type="submit" style="height: 48px;" value="로그인">
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
					<div id="gSignInWrapper">
						  <div id="customBtn" class="customgPlusSignIn">
						     <span class="icon"><img class="logo" src="/resources/icons/g-logo.png"> </span>
						     <span class="buttonText">구글 로그인</span>
						  </div> 
					</div>
 					<script>startApp();</script>
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
</body>
</html>