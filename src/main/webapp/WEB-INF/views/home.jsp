<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
	<meta charset="UTF-8">
	<title>Home</title>
	<script type="text/javascript" src="/resources/jquery-3.6.0.min.js"></script>
	<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=652e898fa106f8aae6e2e77e0cf646c2&libraries=services"></script>
	<script type="text/javascript">
			 var page = 1;
			 var lat = 1;
			 var lon = 1;
			 var keyword = "";
			 var geocoder = new kakao.maps.services.Geocoder();
			 
		$(document).ready(function(){
				 if (navigator.geolocation) {
				        navigator.geolocation.getCurrentPosition(function(position) {
				        
				        lat = position.coords.latitude; // 위도
					    lon = position.coords.longitude; //경도
					    
					    $.ajax({
							type: "get",
							url: "https://dapi.kakao.com/v2/local/geo/coord2address.json",
							headers: {"Authorization": "KakaoAK 9b9be0e29b88e81dd2087c490c185123"},
							dataType: "json",
							data: {"x":lon, "y":lat},
							success: function(data) {
								document.getElementById("postInfo").value = data.documents[0].address.address_name;
							}
						});  
			  }, function(error) {
				  		/* document.getElementById("postInfo").value = "위치정보를 찾을 수 없습니다."; */
				  		$("#postInfo").text("위치정보를 찾을 수 없습니다.");
				  		console.error(error);
			  }, {
					      enableHighAccuracy: true,
					      maximumAge: 0,
					      timeout: Infinity
			 })
			 }	 
			 });

			 function postInfo() {
			        new daum.Postcode({
			            oncomplete: function(data) {
			            	
			                var addr = ''; // 주소 변수
			                var extraAddr = ''; // 참고항목 변수

			                //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
			                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
			                    addr = data.roadAddress;
			                } else { // 사용자가 지번 주소를 선택했을 경우(J)
			                    addr = data.jibunAddress;
			                }

			                // 우편번호와 주소 정보를 해당 필드에 넣는다.
			                document.getElementById("postInfo").value = addr;
			                
			                geocoder.addressSearch(addr, function(result, status) {

					            // 정상적으로 검색이 완료됐으면 
					             if (status === kakao.maps.services.Status.OK) {
					                lat = result[0].y; // 위도
								    lon = result[0].x; //경도
					            } 
					        });    
			            }
			        }).open();
			    }
			 
			 
			 
			 function setPage(updown){
				 	//please set parameter up = 1, down = 2
			    	if(updown==2){
			    		page-=1;
			    		search();
			    		
			    	};
			    	
			    	if(updown==1){
			    		page+=1;
			    		search();
			    	};
			  };
			  
			  function pushEnter() { if (window.event.keyCode == 13) {searchKeyword();}}
			  
			  function searchKeyword(){
				  keyword =  document.getElementById('keyword').value;
				  page = 1;
				  search();
			  }
			  
			  function search(){
						$.ajax({
							type: "get",
							url: "https://dapi.kakao.com/v2/local/search/keyword.json",
							headers: {"Authorization": "KakaoAK 9b9be0e29b88e81dd2087c490c185123"},
							dataType: "json",
							data: {"query":keyword, "page":page, "radius":"3000", "size":"15", "category_group_code":"FD6", "x":lon, "y":lat, "sort":"distance", lon, lat},
							success: function(data) {
								console.log(data);
								var list = "";
								
								for(var i=0;i<data.documents.length;i++){
									
									var link = data.documents[i].place_url;
									link.replace("http", "https");
									
									list += "<tr>"+"<td>"+"<a href="+link+" target='_blank'>"+data.documents[i].place_name+"</a>"+"</td>"+"<td>"+data.documents[i].distance+"m"+"</td>"+"<td>"+data.documents[i].phone+"</td>"+"</tr>";
								}
								document.getElementById('tb').innerHTML = list;
								
								if(data.meta.is_end){
									document.getElementById('upBtn').disabled = true;
								}else{
									document.getElementById('upBtn').disabled = false;
								}
								
								if(page==1){
									document.getElementById('downBtn').disabled = true;
								}else{
									document.getElementById('downBtn').disabled = false;
								}
							}
						})  
			};   
			 
		
	</script>
	
</head>
<body>
	<!-- <df-messenger
	  chat-title="ChatBot"
	  agent-id="c4800ae0-fe04-4429-a29f-1242678f6c8f"
	  language-code="ko"
	></df-messenger> -->
	
	<div style="display: block; text-align: right;">
	<c:if test="${empty user_ID }">
		<a class="btn" href="/user/SignUp">회원가입</a>
		<a class="btn" href="/login">로그인</a>
		</c:if>
	<c:if test="${not empty user_ID }">
	<a class="btn" href="/member/logout">로그아웃</a>
	    <a class="btn" href="/user/modify">회원정보수정</a>
	    <a class="btn" href="/user/withdrawal">회원탈퇴</a>
	</c:if>	
	</div>
	<br>
	<div style="text-align: right;">
		<input type="button" value="🌎" onclick="postInfo();">
		<input id="postInfo" type="text" style="width: 200px; border:none; background: white; text-align: center; color: black;" disabled="disabled">
	</div>
	<br>
	
	<table id="tb" style="margin: auto;">
		<tr>
			<td height="250px">검색 내용이 없습니다.</td>
		</tr>
	</table>
	<br>
	<div style="text-align: center;">
		<input id="downBtn" type="button" disabled="disabled" value="◁" onclick="setPage(2);">
		<input id="upBtn" type="button" disabled="disabled" value="▷" onclick="setPage(1);">	
	</div>
	<br>
	<div style="display: block; text-align: center;">
		<input type="text" id="keyword" onkeyup="pushEnter();">
		<input type="button" value="검색" onclick="searchKeyword();">
	</div>
	
	<!-- <input type="button" value="한식" onclick="setMenu('한식');">
	<input type="button" value="중식" onclick="setMenu('중식');">
	<input type="button" value="일식" onclick="setMenu('일식');"> -->

</body>
</html>
