<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지</title>
<script type="text/javascript">
<script type="text/javascript" src="/resources/jquery-3.6.0.min.js"></script>
<script type="text/javascript">
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
	<form action="/user/mypage" method="post">
			<label class="control-label" for="user_ID">아이디</label>
			<input class="form-control" type="text" id="user_ID" name="user_ID" value="${userVO.user_ID}" readonly="readonly"/>
				
			<label for="user_PW" style="display: inline;">비밀번호  </label>
			<input id="user_PW" name="user_PW" type="password" style="display: inline;" class="form-control" required>
					
			<label for="user_Email" style="display: inline;">이메일</label>
			<input type="text" class="form-control" id="user_Email" name="user_Email" style="display: inline;" required>
					
			<label for="user_NickName" style="display: inline;">닉네임</label>
			<input type="text" class="form-control" id="user_NickName" name="user_NickName" style="display: inline;" value="${userVO.user_NickName }" placeholder="${userVO.user_NickName }" required>
				     
			<div class="form-group has-feedback">
				<button class="btn btn-success" type="submit" id="submit">회원정보수정</button>
				<button class="btn btn-success" type="submit" id="submit">회원탈퇴</button>
				<button class="cencle btn btn-danger" type="button">취소</button>
			</div>
	 </form>
</body>
</html>