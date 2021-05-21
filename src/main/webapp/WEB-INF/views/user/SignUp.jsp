<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="_csrf" content="${_csrf.token}"/>
<script type="text/javascript" src="/resources/jquery-3.6.0.min.js"></script>
<title>회원가입</title>
<script type="text/javascript">
var csrfToken = $("meta[name='_csrf']").attr("content");
$.ajaxPrefilter(function(options, originalOptions, jqXHR){
  if (options['type'].toLowerCase() === "post") {
      jqXHR.setRequestHeader('X-CSRF-TOKEN', csrfToken);
  }
});

$(function(){

//모든 공백 체크 정규식
var empJ = /\s/g;
//아이디 정규식
var idJ = /^[a-z0-9]{4,12}$/;
// 비밀번호 정규식
var pwJ = /^[A-Za-z0-9]{4,12}$/; 
// 닉네임 정규식
var nameJ = /^[A-Za-z0-9가-힣]{1,8}$/;
// 이메일 검사 정규식
var mailJ = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;

var idCheck = false;
var pw = false;
var pwCheck = false;
var email = false;
var nickname = false;

$("#user_PW").keyup(function() {
	
	if(pwJ.test($("#user_PW").val())&&empJ.test($("#user_PW").val())==false){
		$("#pwCheck").text('');
		pw=true;
	}else{
		$("#pwCheck").text('4~12사이영어와숫자만가능합니다.');
		$('#pwCheck').css('color', 'red');
		pw=false;
	}
});

$("#user_PWchk").keyup(function() {
	var pwd1=$("#user_PW").val();
	var pwd2=$("#user_PWchk").val();
	
	if(pwd1==pwd2){
		$("#pwChkChk").text('');
		pwCheck=true;
	}else{
		$("#pwChkChk").text('같은 비밀번호를 입력해주십시오.');
		$('#pwChkChk').css('color', 'red');
		pwCheck=false;
	}
});

$("#user_Email").keyup(function() {
	
	if(mailJ.test($("#user_Email").val())&&empJ.test($("#user_Email").val())==false){
		$("#EmailChk").text('');
		email=true;
	}else{
		$("#EmailChk").text('이메일형식을 확인해주십시오.');
		$('#EmailChk').css('color', 'red');
		email=false;
	}
});

$("#user_NickName").keyup(function() {
	
	if(nameJ.test($("#user_NickName").val())&&empJ.test($("#user_NickName").val())==false){
		$("#NickNameCheck").text('');
		nickname=true;
	}else{
		$("#NickNameCheck").text('닉네임은 1~8글자 영어,한글,숫자만가능합니다.');
		$('#NickNameCheck').css('color', 'red');
		nickname=false;
	}
});

$("#user_ID").keyup(function(){
	var id = document.getElementById('user_ID').value;
	
	if(idJ.test(id)&&empJ.test(id)==false){
		$.ajax({
			  url : "/user/idCheck",
			  type : "post",
			  data : {"userId":id},
			  success : function(data) {
				  	if(data=="yes"){
				  		document.getElementById('idCheck').innerHTML = "";
				  		idCheck=true;
					}else{
						document.getElementById('idCheck').innerHTML = "중복된 ID가 존재합니다.";
						document.getElementById('idCheck').style.color="red";
						idCheck=false;
					}
			  }
			 }); 
	}else{
		document.getElementById('idCheck').innerHTML = "4~12사이소문자영어와숫자만가능합니다.";
		document.getElementById('idCheck').style.color="red";
		idCheck=false;
	}
})

$("#signFrm").submit(function(){

	if(idCheck==false){
		alert("아이디를 확인해주세요");
		return false;
	}else if(pw==false){
		alert("비밀번호를 확인해주세요");
		return false;
	}else if(pwCheck==false){
		alert("비밀번호 확인란을 확인해주세요");
		return false;
	}else if(email==false){
		alert("이메일을 확인해주세요");
		return false;
	}else if(nickname==false){
		alert("닉네임을 확인해주세요");
		return false;
	}
});
	 
});	
</script>
</head>
<body>
   <h1>회원가입</h1>
	<hr>
	<form id="signFrm" name="signFrm" action="SignUp" method="POST">
				<div>
					<label for="user_ID" style="display: inline;">아이디</label>
					<input type="text" id="user_ID" name="user_ID" style="display: inline;" >
					<div class="check_font" id="idCheck" style="display: inline;"></div>
				</div>
				
				<div style="display: inline;">
				  <label for="user_PW" style="display: inline;">비밀번호  </label>
					<input id="user_PW" name="user_PW" type="password" style="display: inline;" class="form-control" required>
				  <div class="check_font" id="pwCheck" style="display: inline;"></div>
			    </div>
			    
				<div >
				  <label for="user_PWchk" style="display: inline;">비밀번호 확인</label>
					<input type="password" class="form-control" id="user_PWchk" name="user_PWchk" style="display: inline;" required>
				  <div class="check_font" id="pwChkChk" style="display: inline;"></div>
			    </div>

				<div >
				  <label for="user_Email" style="display: inline;">이메일</label>
					<input type="text" class="form-control" id="user_Email" name="user_Email" style="display: inline;" required>
				  <div class="check_font" id="EmailChk" style="display: inline;"></div>
			    </div>

				<div >
				  <label for="user_NickName" style="display: inline;">닉네임</label>
				     <input type="text" class="form-control" id="user_NickName" name="user_NickName" style="display: inline;" required>
				  <div class="check_font" id="NickNameCheck" style="display: inline;"></div>
			    </div>
		       <!-- <input type="submit" name="join" value="회원가입"> -->
		       <button class="btn btn-primary px-3" id="submit">
					<i class="fa fa-heart pr-2" aria-hidden="true"></i>가입하기
				</button>
	</form>
</body>
</html>