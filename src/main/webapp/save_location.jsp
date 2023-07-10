<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.time.ZonedDateTime" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    double latitude = Double.parseDouble(request.getParameter("latitude"));
    double longitude = Double.parseDouble(request.getParameter("longitude"));

    // 데이터베이스 연결 및 쿼리 실행
    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("org.sqlite.JDBC");
        conn = DriverManager.getConnection("jdbc:sqlite:/Users/han/zerobase_wifi.db");

        // History 테이블이 없으면 생성
        String createTableQuery = "CREATE TABLE IF NOT EXISTS History (" +
                "ID INTEGER PRIMARY KEY AUTOINCREMENT, " +
                "LAT DOUBLE, " +
                "LNT DOUBLE, " +
                "WORK_DTTM DATETIME" +
                ");";
        pstmt = conn.prepareStatement(createTableQuery);
        pstmt.executeUpdate();

        // 한국 시간 형식 지정
        DateTimeFormatter koreanDateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")
                .withLocale(Locale.KOREA);

        // 현재 한국 시간 가져오기
        ZonedDateTime currentDateTime = ZonedDateTime.now();

        // 한국 시간 형식으로 포맷팅
        String koreanDateTime = currentDateTime.format(koreanDateTimeFormatter);

        // 위치 정보를 History 테이블에 저장
        String insertQuery = "INSERT INTO History (LAT, LNT, WORK_DTTM) VALUES (?, ?, ?)";
        pstmt = conn.prepareStatement(insertQuery);
        pstmt.setDouble(1, latitude);
        pstmt.setDouble(2, longitude);
        pstmt.setString(3, koreanDateTime);
        pstmt.executeUpdate();

    } catch (ClassNotFoundException e) {
        e.printStackTrace();
    } catch (SQLException e) {
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
