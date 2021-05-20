<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>TEST2</title>
<script type="text/javascript" src="/resources/jquery-3.6.0.min.js"></script>


</head>
   <body>
   
  <!-- Insert these scripts at the bottom of the HTML, but before you use any Firebase services -->

  <!-- Firebase App (the core Firebase SDK) is always required and must be listed first -->
  <script src="https://www.gstatic.com/firebasejs/8.6.1/firebase-app.js"></script>

  <!-- If you enabled Analytics in your project, add the Firebase SDK for Analytics -->
  <script src="https://www.gstatic.com/firebasejs/8.6.1/firebase-analytics.js"></script>

  <!-- Add Firebase products that you want to use -->
  <script src="https://www.gstatic.com/firebasejs/8.6.1/firebase-auth.js"></script>
  <script src="https://www.gstatic.com/firebasejs/8.6.1/firebase-firestore.js"></script>

	<script src="https://www.gstatic.com/firebasejs/8.6.1/firebase-database.js"></script>

      <br>  파이어베이스 실시간으로 웹페이지 연동하기 </br>

        Firebase + Realtime + Web 

        <p id="demo">A Paragraph.</p>

        <pre id="object"></pre>

        <button type="button" onclick="myFunction()">데이터 쓰기</button>

        <script>
     // Your web app's Firebase configuration
        // For Firebase JS SDK v7.20.0 and later, measurementId is optional
        var db;
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
        db = firebase.firestore(app);
        db.collection("cities").doc("LA").set({
            name: "Los Angeles",
            state: "CA",
            country: "USA"
        })
        .then(() => {
            console.log("Document successfully written!");
        })
        .catch((error) => {
            console.error("Error writing document: ", error);
        });
            // firebase에서 읽기

            var demo = document.getElementById("demo");

            var preObject = document.getElementById("object");

            var dbRef = firebase.database().ref().child("Demo");

            //dbRef.on('value',snap => demo.innerHTML = snap.val());

            dbRef.on('value',snap => {

                preObject.innerText = JSON.stringify(snap.val(),null,3);

            });

        </script>

 

        <script>

            function myFunction() {

                document.getElementById("demo").innerHTML = "쓰기를 완료";

                alert("쓰기 완료");

                

                //firebase에 쓰기

                firebase.database('diff').ref('Demo').set({

                    username: "test",

                    age: 11                    

                });

            }

        </script>

    </body>
</html>