<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="_csrf" content="${_csrf.token}"/>
	<script type="text/javascript" src="/resources/jquery-3.6.0.min.js"></script>
	<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=652e898fa106f8aae6e2e77e0cf646c2&libraries=services"></script>
	<script src="https://www.gstatic.com/firebasejs/8.6.1/firebase-app.js"></script>
	<script src="https://www.gstatic.com/firebasejs/8.6.1/firebase-analytics.js"></script>
	<script src="https://www.gstatic.com/firebasejs/8.6.1/firebase-firestore.js"></script>
	<script src="https://www.gstatic.com/firebasejs/8.6.1/firebase-database.js"></script>
	<script src="https://www.gstatic.com/firebasejs/8.6.1/firebase-auth.js"></script>
	<link rel="stylesheet" href="/resources/css/menu.css">
	<link rel="stylesheet" href="/resources/css/table.css">
	<link rel="stylesheet" href="/resources/css/mainBtn.css">
	<link rel="stylesheet" href="/resources/css/search.css">
	<link rel="icon" type="image/png" sizes="32x32" href="/resources/icons/favicon-32x32.png">
	<title>Food Search</title>
	<script type="text/javascript">
	
		var page = 1;
		var lat = 1; // 위도
		var lon = 1; //경도
		var keyword = "";
		var geocoder = new kakao.maps.services.Geocoder();
		var temp = "";	 
		var date = 1;
		var time = "";  
		var firebaseConfig = {
	        		apiKey: "AIzaSyBKv54jgRaITfisHo3IWpL9CdVmSH-jRag",
	        	    authDomain: "difdatabase-iojf.firebaseapp.com",
	        	    databaseURL: "https://difdatabase-iojf-default-rtdb.firebaseio.com",
	        	    projectId: "difdatabase-iojf",
	        	    storageBucket: "difdatabase-iojf.appspot.com",
	        	    messagingSenderId: "811856851122",
	        	    appId: "1:811856851122:web:2c6427dee0a99000fb59ab",
	        	    measurementId: "G-CTP28D6C6E"
	        };
	        // Initialize Firebase
	        var app = firebase.initializeApp(firebaseConfig);
	        var db = firebase.firestore(app);
		 
		var csrfToken = $("meta[name='_csrf']").attr("content");
		$.ajaxPrefilter(function(options, originalOptions, jqXHR){
		  if (options['type'].toLowerCase() === "post") {
		      jqXHR.setRequestHeader('X-CSRF-TOKEN', csrfToken);
		  }
		});
		
		$(document).ready(function(){
			
				 if (navigator.geolocation&&sessionStorage.getItem("lat")==null) {
				        navigator.geolocation.getCurrentPosition(function(position) {
				        
				        lat = position.coords.latitude; // 위도
					    lon = position.coords.longitude; //경도
					    
					    getPost();
					     
			  }, function(error) {
				  		
				  		$("#postInfo").text("위치정보를 찾을 수 없습니다.");
				  		console.error(error);
			  }, {
					      enableHighAccuracy: true,
					      maximumAge: 0,
					      timeout: Infinity
			 })
			 }	
				if(sessionStorage.getItem("lat")!=null){
						lat = sessionStorage.getItem("lat");
						lon = sessionStorage.getItem("lon");
						
						getPost();
				} 
				getDateTime(); 
				getWeather();
			});

			function getPost(){
				 $.ajax({
						type: "get",
						url: "https://dapi.kakao.com/v2/local/geo/coord2address.json",
						headers: {"Authorization": "KakaoAK 9b9be0e29b88e81dd2087c490c185123"},
						dataType: "json",
						data: {"x":lon, "y":lat},
						success: function(data) {
							document.getElementById("postInfo").innerText = data.documents[0].address.address_name;
						}
				 });
			};
			
			function postInfo() {
			        new daum.Postcode({
			            oncomplete: function(data) {
			            	
			                var addr = data.jibunAddress; // 주소

			                // 우편번호와 주소 정보를 해당 필드에 넣는다.
			                document.getElementById("postInfo").innerText = addr;
			                
			                geocoder.addressSearch(addr, function(result, status) {

					            // 정상적으로 검색이 완료됐으면 
					             if (status === kakao.maps.services.Status.OK) {
					                lat = result[0].y; // 위도
								    lon = result[0].x; //경도
								    sessionStorage.setItem("lat", lat);
								    sessionStorage.setItem("lon", lon);
					            } 
					        });    
			            }
			        }).open();
			        console.log(temp);
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
			  
			 function searchKeyword(CAT){
				  var x = document.getElementsByClassName("btn green rounded");
				  
				  if(CAT!=null){  
					  
						keyword = CAT;
						/* document.getElementById("keyword").value = ""; */
						
						for(var i=0; i<x.length; i++){
							x[i].disabled = false;
						}
						
						document.getElementById(CAT).disabled = true;
						
				  }else{
					  
					    for(var i=0; i<x.length; i++){
							x[i].disabled = false;
						}
						
					  	keyword =  document.getElementById('keyword').value;
				  }
				  
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
								var list = "";
								
								list += "<h2>검색결과</h2><ul class='responsive-table'><li class='table-header'>"+	
							      "<div class='col col-1'>음식점명</div><div class='col col-2'>거리</div>"+
							      "<div class='col col-3'>전화번호</div><div class='col col-4'>지도/길찾기/즐겨찾기</div></li>";
								if(data.documents.length==0){
										list += "<li class='table-row'><div class='colno'>근처에 이용가능한 음식점이 없습니다.</div></li></ul>";
										document.getElementById('tb').innerHTML = list;
										document.getElementById('pageBtn').style.display="none";
								}else{
										
										for(var i=0;i<data.documents.length;i++){
											
											list += "<li class='table-row'><div class='col col-1' data-label='음식점명'><a href='http://place.map.kakao.com/"+data.documents[i].id+"' target='_blank'>"+data.documents[i].place_name+
											"</a></div><div class='col col-2' data-label='거리'>"+data.documents[i].distance+"m</div><div class='col col-3' data-label='전화번호'>"+
											data.documents[i].phone+"</div><div class='col col-4' data-label='지도/길찾기/즐겨찾기'><a href='https://map.kakao.com/link/map/"+data.documents[i].id+
											"' target='_blank'><img src='/resources/icons/location.png'></a>  "+
											"<a href='https://map.kakao.com/link/to/"+data.documents[i].id+
											"' target='_blank'><img src='/resources/icons/navigator.png'></a>  <c:if test='${not empty user.user_ID }'>"+'<a href="" onclick="favorite('+"'"+data.documents[i].place_name+
											"',"+data.documents[i].id+'); return false;"><img id="'+data.documents[i].id+'" style="width:32px;height:32px;"'+" src='/resources/icons/unImpStar.png'></a></c:if></div></li>";
										}
										
										list += "</ul>";
										document.getElementById('tb').innerHTML = list;
										getfavorite();
										document.getElementById('pageBtn').style.display="block";
										
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
										insertDB();
								}
							}
						})
						
			};

			function insertDB(){
		        if(${not empty user.user_ID }){
		        	 db.collection("Search").doc("${user.user_ID }").set({
				        	"insert": date,
				            "menu": keyword,
				            "time": time,
				            "weather": temp 
				        })
				        .then(() => {
				        })
				        .catch((error) => {
				        });
			    }else{
			    	db.collection("Search").doc().set({
			        	"insert": date,
			            "menu": keyword,
			            "time": time,
			            "weather": temp 
			        })
			        .then(() => {
			        })
			        .catch((error) => {
			        });
				}
			};

			function getDateTime(){
				var now = new Date();
				var year = now.getFullYear();              //yyyy
			    var month = (now.getMonth()+1);          //M
			    var day = now.getDate();                   //d
			    month = month >= 10 ? month : '0' + month;  //month 두자리로 저장
			    day = day >= 10 ? day : '0' + day;          //day 두자리로 저장
			    date = (year+month+day)*1;
			     
			    var t = now.getHours();
			    if(4<t&&t<=9){
			    	time = "아침";
				}else if(9<t&&t<=15){
					time = "점심";
				}else if(15<t&&t<=21){
					time = "저녁";
				}else{
					time = "야식";
				}
			}
			
			function getWeather(){
				$.ajax({
					type: "get",
					url: "https://api.openweathermap.org/data/2.5/weather",
					dataType: "json",
					data: {"lat":lat, "lon":lon,"appid": "5007fdb66e150a863a55bbcc8aff2887"},
					success: function(data) {
							
						var weather = data.weather[0].main.toLowerCase();
						var tp = parseInt(data.main.temp-273);
						
						if(tp>24){
							temp = "더워요";
						}else if(24>=tp&&tp>17){
							temp = "선선해요";
						}else if(17>=tp&&tp>9){
							temp = "쌀쌀해요";
						}else if(tp<10){
							temp = "추워요";
						}

						if(weather.includes("rain")||weather.includes("drizzle")){
							temp = "비내려요";
						}
						
					}
			 	});
			}

			function favorite(name, link){
				var id = "${user.user_ID}"
				$.ajax({
					url: "/user/favorite",
					type: "post",
					data: {"name":name, "link":link,"id":id },
					success: function(data) {
						if(data.result=="y"){
							$("#"+data.link).attr("src", data.icon);
						}else if("n"){
							alert("즐겨찾기 업데이트 실패! 다시 시도해주세요.");
						}
							 
					}
				});
			}

			function getfavorite(){
				var id = "${user.user_ID}"
					$.ajax({
						url: "/user/getfavorite",
						type: "post",
						data: {"id":id },
						success: function(data) {
 							for(var i=0; i<data.length; i++){
 								$("#"+data[i].link).attr("src", "/resources/icons/impStar.png");			
 	 						}
						}
					});
			}
			function showmap() {
				 if(document.all.layer.style.visibility=="visible") {
					 document.all.layer.style.visibility="hidden";
				 }
				}
		    
			function initLayerPosition(){
				document.all.layer.style.visibility="visible";
				var element_layer = document.getElementById('layer');
		        var width = 250; 
		        var height = 300; 
		        var borderWidth = 5; 

		        element_layer.style.width = width + 'px';
		        element_layer.style.height = height + 'px';
		        element_layer.style.border = borderWidth + 'px solid #2d2d2d';
		    }
	</script>
	<style type="text/css">
		.catbtn {
			width: 90px;
			height: 45px;
			text-align: center;		
		}
		#pageBtn {
			display: none;
		}
	</style>
</head>
<body>
<script src="https://www.gstatic.com/dialogflow-console/fast/messenger/bootstrap.js?v=1"></script>
<df-messenger
  intent="WELCOME"
  chat-title="ChatBot"
  agent-id="db55c310-a166-448e-aa69-cdd9f8aefc93"
  language-code="ko"
></df-messenger>
	<h2 style="font-weight: bold; font-size: 24pt; color: #9abf7f;">Food Search</h2>
        <nav id="topMenu" >
                <ul>
                        <li class="left"><a class="menuLink" href="/">Home</a></li>
				        <c:if test="${empty user.user_ID }">
							<li class="left"><a class="menuLink" href="/user/SignUp">회원가입</a></li>
							<li class="left"><a class="menuLink" href="/login" onclick="window.open(this.href,'로그인','toolbar=no, location=no, width=450, height=450, resizable=no'); return false;">로그인</a></li>
							</c:if>
						<c:if test="${not empty user.user_ID }">
							<script type="text/javascript">
								if(opener!=null){opener.location.reload(); window.close();};
								if("${result}"==1){alert("회원정보 수정에 성공하셨습니다.");};
							</script>
							<li class="left"><a class="menuLink" href="/user/mypage">${user.user_NickName } 님</a></li>
							<li class="left"><a class="menuLink" href="/logout">로그아웃</a></li>
						    <li class="left"><a class="menuLink" href=""  onclick="initLayerPosition();return false;">즐겨찾기</a>	
						    <div id="layer" style="visibility:hidden;position:fixed;overflow:hidden;z-index:1;-webkit-overflow-scrolling:touch; background: white;">
							<img src="//t1.daumcdn.net/postcode/resource/images/close.png" id="btnCloseLayer" style="cursor:pointer;position:absolute;right:-3px;top:-3px;z-index:1" onclick="showmap();return false;" alt="닫기 버튼">
							<iframe src="/user/favor" style="width: 250px; height: 300px; border: none;"></iframe>
							</div></li>
						</c:if>
						<li class="right"><a id="postInfo" class="menuLink" href="" onclick="postInfo();return false;"></a></li>	
						<li class="right"><a id="le" class="menuLink" href="" onclick="postInfo();return false;">🌎</a></li>
                </ul>
        </nav>
	<div class="container" id="tb"></div>
	<div id="pageBtn" style='text-align: center;'>
		<input id='downBtn' class="pagebt" type='button' disabled='disabled' value='◀' onclick='setPage(2);'>
		<input id='upBtn' class="pagebt" type='button' disabled='disabled' value='▶' onclick='setPage(1);'>
	</div>
	<br>
	<br>
	<div style="text-align: center;"><input id="한식" class="btn green rounded" type="button" value="한식" onclick="searchKeyword(this.value);"> <input id="중식" class="btn green rounded" type="button" value="중식" onclick="searchKeyword(this.value);"> <input id="일식" class="btn green rounded" type="button" value="일식" onclick="searchKeyword(this.value);"> <input id="패스트푸드" class="btn green rounded" type="button" value="패스트푸드" onclick="searchKeyword(this.value);"></div>
	<br>
	<div style="text-align: center;"><input id="피자" class="btn green rounded" type="button" value="피자" onclick="searchKeyword(this.value);"> <input id="치킨" class="btn green rounded" type="button" value="치킨" onclick="searchKeyword(this.value);"> <input id="분식" class="btn green rounded" type="button" value="분식" onclick="searchKeyword(this.value);"> <input id="족발" class="btn green rounded" type="button" value="족발" onclick="searchKeyword(this.value);"></div>
	<br>
	<br>
	<table id="sc">
		<tr>
			<td><div class="searchForm"><input type="text" id="keyword" placeholder="메뉴, 음식점, 카테고리" class="search" onkeyup="pushEnter();"></div></td>
			<td ><input type="button" class="bt" onclick="searchKeyword();" value="search"></td>
		</tr>
	</table>
</body>
</html>
