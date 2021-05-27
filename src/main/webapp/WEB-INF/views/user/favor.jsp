<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script type="text/javascript" src="/resources/jquery-3.6.0.min.js"></script>
<link rel="icon" type="image/png" sizes="32x32" href="/resources/icons/favicon-32x32.png">
<link rel="stylesheet" href="/resources/css/table.css">
<title>즐겨찾기</title>
<script type="text/javascript">
	$(function getfavorite(){
		var id = "${user.user_ID}"
			$.ajax({
				url: "/user/getfavorite",
				type: "post",
				data: {"id":id },
				async: true,
				success: function(data) {
					var list = "";
						for(var i=0; i<data.length; i++){
							list += "<tr><td>"+(i+1)+". </td><td><a href='http://place.map.kakao.com/"+
							data[i].link+"' target='_blank' style>"+data[i].name+"</a></td>"+
							"<td>&emsp;<a href='#'onclick="+'"favorite('+"'"+data[i].name+"'"+",'"+data[i].link+"')"+'">삭제</a></td>'+"</tr>";
						}
					document.getElementById("tb").innerHTML = list;
				}
			});
	});
	
	function favorite(name, link){
		var id = "${user.user_ID}"
		$.ajax({
			url: "/user/favorite",
			type: "post",
			data: {"name":name, "link":link,"id":id },
			success: function(data) {
				if(data.result=="y"){
					window.location.reload();
					parent.search();

				}else if("n"){
					alert("즐겨찾기 업데이트 실패! 다시 시도해주세요.");
				}
					 
			}
		});
	}
</script>
</head>
<body>
<table id="tb"></table>
</body>
</html>