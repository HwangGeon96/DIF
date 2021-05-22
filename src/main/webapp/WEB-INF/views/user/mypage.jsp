<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지</title>
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