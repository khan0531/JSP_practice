<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Db.ApiExplorer" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%--<%--%>
<%--    // JDBC 드라이버 로드 -> 그래야 자바 파일 실행 했을 때 데이터베이스에 연결 될 수 있다.--%>
<%--    try {--%>
<%--        Class.forName("org.sqlite.JDBC");--%>
<%--    } catch (ClassNotFoundException e) {--%>
<%--        throw new RuntimeException(e);--%>
<%--    }--%>
<%--%>--%>

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
        Class.forName("org.sqlite.JDBC");
        Connection conn = DriverManager.getConnection("jdbc:sqlite:/Users/han/zerobase_wifi.db");

        // History 테이블이 없으면 생성
        String createTableQuery = "CREATE TABLE IF NOT EXISTS Wifi (" +
                "ID INTEGER PRIMARY KEY AUTOINCREMENT, " +
                "MGR_NO VARCHAR(100), " +
                "WRDOFC VARCHAR(100), " +
                "MAIN_NM VARCHAR(100), " +
                "ADRES1 VARCHAR(100), " +
                "ADRES2 VARCHAR(100), " +
                "INSTL_FLOOR VARCHAR(100), " +
                "INSTL_TY VARCHAR(100), " +
                "INSTL_MBY VARCHAR(100), " +
                "SVC_SE VARCHAR(100), " +
                "CMCWR VARCHAR(100), " +
                "CNSTC_YEAR INT, " +
                "INOUT VARCHAR(100), " +
                "REMARS3 VARCHAR(100), " +
                "LAT DOUBLE, " +
                "LNT DOUBLE, " +
                "WORK_DTTM DATETIME" +
                ");";
        PreparedStatement pstmt = conn.prepareStatement(createTableQuery);
        pstmt.executeUpdate();
        // 데이터베이스에 정보를 삽입
        ApiExplorer.func2();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<a href="home.jsp">홈 으로 가기</a>

</body>
</html>
