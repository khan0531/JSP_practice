<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Db.ApiExplorer" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>

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
<%
    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("org.sqlite.JDBC");
        conn = DriverManager.getConnection("jdbc:sqlite:/Users/han/zerobase_wifi.db");

        // Wifi 테이블이 없으면 생성
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
        pstmt = conn.prepareStatement(createTableQuery);
        pstmt.executeUpdate();
        // 데이터베이스에 정보를 삽입
        ApiExplorer.func2();

        // Wifi 테이블의 행 수 가져오기
        String countQuery = "SELECT COUNT(*) FROM Wifi";
        Statement stmt = conn.createStatement();
        ResultSet resultSet = stmt.executeQuery(countQuery);
        int rowCount = 0;
        if (resultSet.next()) {
            rowCount = resultSet.getInt(1);
        }
%>

<h1><%= rowCount %>개의 WIFI 정보를 정상적으로 저장하였습니다.</h1>

<%
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        // 리소스 해제
        if (pstmt != null) {
            try {
                pstmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
%>

<a href="home.jsp">홈으로 가기</a>

</body>
</html>
