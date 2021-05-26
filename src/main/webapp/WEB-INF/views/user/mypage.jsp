<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>  
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script type="text/javascript" src="/resources/jquery-3.6.0.min.js"></script>
<link rel="icon" type="image/png" sizes="32x32" href="/resources/icons/favicon-32x32.png">
<link rel="stylesheet" href="/resources/css/joinform.css">
<title>마이페이지</title>
<script type="text/javascript">

$(function(){

var pw = true;
var pwCheck = true;
var email = true;
var nickname = true;

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

$("#user_ID").value = "${user.user_ID}";

var type = "${user.user_PW}";
if(type.length>1){
	$("#user_PW").prop("type", "text");
	$("#user_PW").val("소셜로그인이용자입니다"); 
	$("#user_PW").attr("readonly",true); 
	$("#user_Email").val("${user.user_Email}");
	$("#user_Email").attr("readonly",true);
	$("#pwchkchk").css("display","none");
}else{
	$("#user_Email").val("${user.user_Email}");
}

if("${result}"==2){
	alert("회원정보 수정에 실패하셨습니다. 다시 시도해주세요.");
}
if("${result}"==3){
	alert("회원탈퇴에 실패하셨습니다. 다시 시도해주세요.");
}

$("#user_PW").keyup(function() {
	
	if(pwJ.test($("#user_PW").val())&&empJ.test($("#user_PW").val())==false||$("#user_PW").val()==""){
		$("#pwCheck").html('');
		pw=true;
	}else{
		$("#pwCheck").html('4~12자 사이<br>영어와 숫자만 가능합니다.');
		$('#pwCheck').css('color', 'red');
		pw=false;
	}
	
});

$("#user_PWchk").keyup(function() {
	var pwd1=$("#user_PW").val();
	var pwd2=$("#user_PWchk").val();
	
	if(pwd1==pwd2){
		$("#pwChkChk").html('');
		pwCheck=true;
	}else{
		$("#pwChkChk").html('같은 비밀번호를 입력해주십시오.');
		$('#pwChkChk').css('color', 'red');
		pwCheck=false;
	}
});


$("#user_Email").keyup(function() {
	
	if(mailJ.test($("#user_Email").val())&&empJ.test($("#user_Email").val())==false){

		$("#EmailChk").html('');
		email=true;
	}else{
		$("#EmailChk").html('이메일형식을 확인해주십시오.');
		$('#EmailChk').css('color', 'red');
		email=false;
	}
});

$("#user_NickName").keyup(function() {
	
	if(nameJ.test($("#user_NickName").val())&&empJ.test($("#user_NickName").val())==false){

		$("#NickNameCheck").html('');
		nickname=true;
	}else{
		$("#NickNameCheck").html('닉네임은 1~8글자<br>영어,한글,숫자만가능합니다.');
		$('#NickNameCheck').css('color', 'red');
		nickname=false;
	}
});



$("#signFrm").submit(function(){

	if(pw==false){
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
function deleteUser(){
	if(confirm("정말 탈퇴하시겠습니까?")){
		location.href="deleteUser";
	}else{
		return false;
	}
	
}
</script>
</head>
<body>
	<div class="wrap wd668">
      <div class="container">
        <div class="form_txtInput">
       		<h2 class="sub_tit_txt">마이페이지</h2>
       		<p class="exTxt">소셜 로그인 이용자는 닉네임만 수정 가능합니다.</p>
			
			<form id="signFrm" name="signFrm" action="mypage" method="POST">
			<div class="join_form">
            <table>
              <colgroup>
                <col width="30%"/>
                <col width="auto"/>
              </colgroup>
              
              <tbody>
              <tr>
              	<th><span>아이디</span></th>
              	<td><input type="text" id="user_ID" name="user_ID" style="display: inline;" value="${user.user_ID}" readonly="readonly" ></td>
              	<td><div class="check_font" id="idCheck"></div></td>
              </tr>
              
			  <tr>
              	<th><span>비밀번호</span></th>
              	<td><input id="user_PW" name="user_PW" type="password" placeholder="바꿀 비밀번호 입력"></td>
              	<td><div class="check_font" id="pwCheck"></div></td>
              </tr>
              
			  <tr id="pwchkchk">
              	<th><span>비밀번호 확인</span></th>
              	<td><input type="password" id="user_PWchk" name="user_PWchk"></td>
              	<td><div class="check_font" id="pwChkChk"></div></td>
              </tr>
              
              <tr>
              	<th><span>이메일</span></th>
              	<td><input type="text" id="user_Email" name="user_Email" required></td>
              	<td><div class="check_font" id="EmailChk"></div></td>
              </tr>
              
			  <tr>
              	<th><span>닉네임</span></th>
              	<td><input type="text" id="user_NickName" name="user_NickName" value="${user.user_NickName }" required></td>
              	<td><div class="check_font" id="NickNameCheck"></div></td>
              </tr>
				</tbody>
			</table>
			
            <div class="exform_txt"><span><a href="javascript:;" onclick="location.href='/'">홈으로</a></span>&emsp;&emsp;<span><a href="javascript:;" onclick="deleteUser();">회원탈퇴</a></span></div>
            <div class="btn_wrap">
		       <a href="javascript:;" onclick="$('#signFrm').submit();">회원정보수정</a>
			</div>
			</div>
			</form>
   		</div> 
      </div>
    </div> 
	 	
</body>
</html>