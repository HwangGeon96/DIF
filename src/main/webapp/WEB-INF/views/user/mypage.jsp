<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지</title>
</head>
<body>
			<form action="/user/mypage" method="post">
					<label class="control-label" for="user_ID">아이디</label>
					<input class="form-control" type="text" id="user_ID" name="user_ID" value="${user.userId}" readonly="readonly"/>
				<c:choose>
				    <c:when test="${name eq 'frm'}"></c:when>
				    <c:when test="${ }"></c:when>	
				</c:choose>	
				<div class="form-group has-feedback">
					<button class="btn btn-success" type="submit" id="submit">회원정보수정</button>
					<button class="cencle btn btn-danger" type="button">취소</button>
				</div>
			</form>
</body>
</html>