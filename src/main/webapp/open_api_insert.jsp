<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Db.ApiExplorer" %>
<%
    // JDBC 드라이버 로드 -> 그래야 자바 파일 실행 했을 때 데이터베이스에 연결 될 수 있다.
    try {
        Class.forName("org.sqlite.JDBC");
    } catch (ClassNotFoundException e) {
        throw new RuntimeException(e);
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="css/bootstrap.css">
    <title>Open API 와이파이 정보 가져오기</title>
    <style>
        body {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            /*height: 100vh;*/
            text-align: center;
        }
    </style>
</head>
<body>
<h1>23000개의 WIFI 정보를 정상적으로 저장하였습니다.</h1>

<%
    try {
        // 데이터베이스에 정보를 삽입
        ApiExplorer.func2();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<a href="home.jsp">홈 으로 가기</a>

</body>
</html>
