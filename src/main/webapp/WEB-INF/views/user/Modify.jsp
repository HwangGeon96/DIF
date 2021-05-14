<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원정보수정</title>
<script type="text/javascript" src="/resources/jquery-3.6.0.min.js"></script>
<script type="text/javascript">
$(function(){

	//모든 공백 체크 정규식
	var empJ = /\s/g;
	//아이디 정규식
	var idJ = /^[a-z0-9]{4,12}$/;
	// 비밀번호 정규식
	var pwJ = /^[A-Za-z0-9]{4,12}$/; 
	// 이름 정규식
	var nameJ = /^[가-힣]{2,6}$/;
	// 이메일 검사 정규식
	var mailJ = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;


	$("#user_PW").blur(function() {
		
		if(pwJ.test($("#user_PW").val())){
			$("#pwCheck").text('');
		}else{
			$("#pwCheck").text('4~12사이영어와숫자만가능합니다.');
			$('#pwCheck').css('color', 'red');
		}
	});


	$("#user_Email").blur(function() {
		
		if(mailJ.test($("#user_Email").val())){
			$("#EmailChk").text('');
		}else{
			$("#EmailChk").text('이메일형식을 확인해주십시오.');
			$('#EmailChk').css('color', 'red');
		}
	});

	$("#user_NickName").blur(function() {
		
		if(nameJ.test($("#user_NickName").val())){
			$("#NickNameCheck").text('');
		}else{
			$("#NickNameCheck").text('이름을 확인해주십시오.');
			$('#NickNameCheck').css('color', 'red');
		}
	});

	
	function deleteForm(id){
		document.getElementById(id).innerHTML = "";
	}
	});	

</script>
</head>
<body>
<section id="container">
			<form action="/user/Modify" method="post">
				<div class="form-group has-feedback">
					<label class="control-label" for="user_ID">아이디</label>
					<input class="form-control" type="text" id="user_ID" name="user_ID" value="${user.userId}" readonly="readonly"/>
				</div>
				<div class="form-group has-feedback">
					<label class="control-label" for="user_PW">패스워드</label>
					<input class="form-control" type="password" id="user_PW" name="user_PW" />
					<div class="check_font" id="pwCheck" style="display: inline;"></div>
				</div>
				<div class="form-group has-feedback">
					<label class="control-label" for="user_Email">이메일</label>
					<input class="form-control" type="password" id="user_Email" name="user_Email" />
					<div class="check_font" id="EmailChk" style="display: inline;"></div>
				</div>
				<div class="form-group has-feedback">
					<label class="control-label" for="user_NickName">닉네임</label>
					<input class="form-control" type="password" id="user_NickName" name="user_NickName" />
					<div class="check_font" id="NickNameCheck" style="display: inline;"></div>
				</div>
				<div class="form-group has-feedback">
					<button class="btn btn-success" type="submit" id="submit">회원정보수정</button>
					<button class="cencle btn btn-danger" type="button">취소</button>
				</div>
			</form>
</section>
</body>
</html>