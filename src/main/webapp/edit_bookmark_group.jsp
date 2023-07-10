<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.time.ZonedDateTime" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    int id = Integer.parseInt(request.getParameter("id"));
    String bookmarkName = new String(request.getParameter("bookmarkName").getBytes("ISO-8859-1"), "UTF-8");
    int sequence = Integer.parseInt(request.getParameter("sequence"));

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

        // Bookmarks 테이블에서 데이터 업데이트
        String updateQuery = "UPDATE Bookmarks SET BOOKMARK_NAME = ?, SEQUENCE = ?, EDIT_DTTM = ? WHERE ID = ?";
        pstmt = conn.prepareStatement(updateQuery);
        pstmt.setString(1, bookmarkName);
        pstmt.setInt(2, sequence);
        pstmt.setString(3, koreanDateTime);
        pstmt.setInt(4, id);
        int rowsUpdated = pstmt.executeUpdate();

        if (rowsUpdated > 0) {
            out.println("데이터 업데이트 성공");
        } else {
            out.println("데이터 업데이트 실패");
        }
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
