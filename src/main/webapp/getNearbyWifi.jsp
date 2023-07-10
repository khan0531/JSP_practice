<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.sql.DriverManager" %>

<% try {
    Class.forName("org.sqlite.JDBC");
} catch (ClassNotFoundException e) {
    throw new RuntimeException(e);
} %>
<%
    // 전달받은 위도(latitude)와 경도(longitude) 값을 가져옴
    double latitude = Double.parseDouble(request.getParameter("lat"));
    double longitude = Double.parseDouble(request.getParameter("lnt"));

    // 데이터베이스 연결
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        conn = DriverManager.getConnection("jdbc:sqlite:/Users/han/zerobase_wifi.db");
        // 근처 와이파이 정보(상위 20개)를 가져오는 쿼리를 작성
        String query = "SELECT *, " +
                "6371 * 2 * ASIN(SQRT(POWER(SIN((RADIANS(?) - RADIANS(CASE WHEN LAT > LNT THEN LNT ELSE LAT END)) / 2), 2) + " +
                "COS(RADIANS(?)) * COS(RADIANS(CASE WHEN LAT > LNT THEN LNT ELSE LAT END)) * POWER(SIN((RADIANS(?) - RADIANS(CASE WHEN LAT > LNT THEN LAT ELSE LNT END)) / 2), 2))) " +
                "AS distance FROM Wifi ORDER BY distance LIMIT 20";
        pstmt = conn.prepareStatement(query);
        pstmt.setDouble(1, latitude);
        pstmt.setDouble(2, latitude);
        pstmt.setDouble(3, longitude);
        
        // 쿼리 실행
        rs = pstmt.executeQuery();
        
        // 결과를 JSON 형식으로 변환하여 클라이언트에 전송
        StringBuilder jsonBuilder = new StringBuilder();
        jsonBuilder.append("[");
        boolean isFirst = true;
        while (rs.next()) {
            if (!isFirst) {
                jsonBuilder.append(",");
            }
            jsonBuilder.append("{");
            jsonBuilder.append("\"id\": \"" + rs.getString("id") + "\",");
            jsonBuilder.append("\"distance\": \"" + rs.getString("distance") + "\",");
            jsonBuilder.append("\"MGR_NO\": \"" + rs.getString("MGR_NO") + "\",");
            jsonBuilder.append("\"WRDOFC\": \"" + rs.getString("WRDOFC") + "\",");
            jsonBuilder.append("\"MAIN_NM\": \"" + rs.getString("MAIN_NM") + "\",");
            jsonBuilder.append("\"ADRES1\": \"" + rs.getString("ADRES1") + "\",");
            jsonBuilder.append("\"ADRES2\": \"" + rs.getString("ADRES2") + "\",");
            jsonBuilder.append("\"INSTL_FLOOR\": \"" + rs.getString("INSTL_FLOOR") + "\",");
            jsonBuilder.append("\"INSTL_TY\": \"" + rs.getString("INSTL_TY") + "\",");
            jsonBuilder.append("\"INSTL_MBY\": \"" + rs.getString("INSTL_MBY") + "\",");
            jsonBuilder.append("\"SVC_SE\": \"" + rs.getString("SVC_SE") + "\",");
            jsonBuilder.append("\"CMCWR\": \"" + rs.getString("CMCWR") + "\",");
            jsonBuilder.append("\"CNSTC_YEAR\": \"" + rs.getString("CNSTC_YEAR") + "\",");
            jsonBuilder.append("\"INOUT\": \"" + rs.getString("INOUT") + "\",");
            jsonBuilder.append("\"REMARS3\": \"" + rs.getString("REMARS3") + "\",");
            String lat = rs.getString("LAT");
            String lnt = rs.getString("LNT");
            // LAT와 LNT 값 서로 스왑
            if (lat != null && lnt != null && Double.parseDouble(lat) > Double.parseDouble(lnt)) {
                jsonBuilder.append("\"LAT\": \"" + lnt + "\",");
                jsonBuilder.append("\"LNT\": \"" + lat + "\",");
            } else {
                jsonBuilder.append("\"LAT\": \"" + lat + "\",");
                jsonBuilder.append("\"LNT\": \"" + lnt + "\",");
            }
            jsonBuilder.append("\"WORK_DTTM\": \"" + rs.getString("WORK_DTTM") + "\"");
            jsonBuilder.append("}");
            isFirst = false;
        }
        jsonBuilder.append("]");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(jsonBuilder.toString());
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        // 데이터베이스 연결 및 리소스 해제
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
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
