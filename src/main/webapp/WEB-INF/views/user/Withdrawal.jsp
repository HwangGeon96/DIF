<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원탈퇴</title>
</head>
<script type="text/javascript">
		$(document).ready(function(){
			// 취소
			$(".cencle").on("click", function(){
				
				location.href = "/";
						    
			})
		
			$("#submit").on("click", function(){
				if($("#user_PW").val()==""){
					alert("비밀번호를 입력해주세요.");
					$("#user_PW").focus();
					return false;
				}	
			});
			
				
			
		})
	</script>
<body>
    <section id="container">
			<form action="/user/Withdrawl" method="post">
				<div class="form-group has-feedback">
					<label class="control-label" for="user_ID">아이디</label>
					<input class="form-control" type="text" id="user_ID" name="user_ID" value="${user.user_ID}" readonly="readonly"/>
				</div>
				<div class="form-group has-feedback">
					<label class="control-label" for="user_PW">패스워드</label>
					<input class="form-control" type="password" id="user_PW" name="user_PW" />
				</div>
				<div class="form-group has-feedback">
					<label class="control-label" for="user_Email">이메일</label>
					<input class="form-control" type="text" id="user_Email" name="user_Email" value="${user.user_Email}" readonly="readonly"/>
				</div>
				<div class="form-group has-feedback">
					<label class="control-label" for="user_NickName">이메일</label>
					<input class="form-control" type="text" id="user_NickName" name="user_NickName" value="${user.user_NickName}" readonly="readonly"/>
				</div>
				<div class="form-group has-feedback">
					<button class="btn btn-success" type="submit" id="submit">회원탈퇴</button>
					<button class="cencle btn btn-danger" type="button">취소</button>
				</div>
			</form>
			<div>
				<c:if test="${msg == false}">
					비밀번호가 맞지 않습니다.
				</c:if>
			</div>
		</section>

</body>
</html>