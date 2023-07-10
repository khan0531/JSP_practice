<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    // 삭제할 ID 파라미터 가져오기
    int id = Integer.parseInt(request.getParameter("id"));

    // 데이터베이스 연결 및 쿼리 실행
    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("org.sqlite.JDBC");
        conn = DriverManager.getConnection("jdbc:sqlite:/Users/han/zerobase_wifi.db");

        // History 테이블에서 해당 ID의 데이터 삭제
        String deleteQuery = "DELETE FROM Bookmark_contents WHERE ID = ?";
        pstmt = conn.prepareStatement(deleteQuery);
        pstmt.setInt(1, id);
        pstmt.executeUpdate();

        // 응답에 성공 상태 전송
        response.setStatus(HttpServletResponse.SC_OK);
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
        // 응답에 실패 상태 전송
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    } catch (SQLException e) {
        e.printStackTrace();
        // 응답에 실패 상태 전송
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
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
%>
