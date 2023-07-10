<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.time.ZonedDateTime" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    String bookmarkName = new String(request.getParameter("bookmarkName").getBytes("ISO-8859-1"), "UTF-8");
    int sequence = Integer.parseInt(request.getParameter("sequence"));

    try {
        Class.forName("org.sqlite.JDBC");
        conn = DriverManager.getConnection("jdbc:sqlite:/Users/han/zerobase_wifi.db");
        conn.prepareStatement("PRAGMA encoding = 'UTF-8'").executeUpdate();

        // 한국 시간 형식 지정
        DateTimeFormatter koreanDateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")
                .withLocale(Locale.KOREA);

        // 현재 한국 시간 가져오기
        ZonedDateTime currentDateTime = ZonedDateTime.now();

        // 한국 시간 형식으로 포맷팅
        String koreanDateTime = currentDateTime.format(koreanDateTimeFormatter);

        // 테이블 생성 쿼리
        String createTableQuery = "CREATE TABLE IF NOT EXISTS Bookmarks (ID INTEGER PRIMARY KEY AUTOINCREMENT, BOOKMARK_NAME VARCHAR(100), SEQUENCE INT, WORK_DTTM DATETIME, EDIT_DTTM DATETIME)";
        pstmt = conn.prepareStatement(createTableQuery);
        pstmt.executeUpdate();

        // 데이터 저장 쿼리
        String insertDataQuery = "INSERT INTO Bookmarks (BOOKMARK_NAME, SEQUENCE, WORK_DTTM, EDIT_DTTM) VALUES (?, ?, ?, DATETIME(''))";
        pstmt = conn.prepareStatement(insertDataQuery);
        pstmt.setString(1, bookmarkName);
        pstmt.setInt(2, sequence);
        pstmt.setString(3, koreanDateTime);
        pstmt.executeUpdate();

    } catch (ClassNotFoundException e) {
        e.printStackTrace();
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
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
