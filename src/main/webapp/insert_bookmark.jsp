<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.time.ZonedDateTime" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    String wifi_name = new String(request.getParameter("wifi_name").getBytes("ISO-8859-1"), "UTF-8");
    String bookmark_name = new String(request.getParameter("bookmark_name").getBytes("ISO-8859-1"), "UTF-8");
    // 데이터베이스 연결 및 쿼리 실행
    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("org.sqlite.JDBC");
        conn = DriverManager.getConnection("jdbc:sqlite:/Users/han/zerobase_wifi.db");

        // 한국 시간 형식 지정
        DateTimeFormatter koreanDateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")
                .withLocale(Locale.KOREA);

        // 현재 한국 시간 가져오기
        ZonedDateTime currentDateTime = ZonedDateTime.now();

        // 한국 시간 형식으로 포맷팅
        String koreanDateTime = currentDateTime.format(koreanDateTimeFormatter);
        // 테이블 생성 쿼리
        String createTableQuery = "CREATE TABLE IF NOT EXISTS Bookmark_contents (ID INTEGER PRIMARY KEY AUTOINCREMENT, bookmark_name VARCHAR(100), wifi_name VARCHAR(100), INST_DTTM DATETIME)";
        pstmt = conn.prepareStatement(createTableQuery);
        pstmt.executeUpdate();

        // 테이블 저장 쿼리
        String insertDataQuery = "INSERT INTO Bookmark_contents (bookmark_name, wifi_name, INST_DTTM) VALUES (?, ?, ?)";
        pstmt = conn.prepareStatement(insertDataQuery);
        pstmt.setString(1, bookmark_name);
        pstmt.setString(2, wifi_name);
        pstmt.setString(3, koreanDateTime);
        pstmt.executeUpdate();

    } catch (ClassNotFoundException e) {
        e.printStackTrace();
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        // 리소스 정리
        try {
            if (pstmt != null)
                pstmt.close();
            if (conn != null)
                conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 연결 및 리소스 정리
    pstmt.close();
    conn.close();
%>
