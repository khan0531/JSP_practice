<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="css/bootstrap.css">
    <title>와이파이 정보 구하기</title>

    <style>
        .link-group {
            display: flex;
            align-items: center;
        }

        .link-group a {
            margin-right: 10px;
            color: black;
            text-decoration: none;
        }

        .separator {
            width: 1px;
            height: 20px;
            background-color: #CCCCCC;
            margin: 0 10px;
        }
    </style>
</head>
<body>
<h1>북마크 관리</h1>

<div class="link-group">
    <a href="home.jsp">홈</a>
    <span class="separator"></span>
    <a href="location_history.jsp">위치 히스토리 목록</a>
    <span class="separator"></span>
    <a href="open_api_insert.jsp">Open API 와이파이 정보 가져오기</a>
    <span class="separator"></span>
    <a href="bookmark_management.jsp">북마크 보기</a>
    <span class="separator"></span>
    <a href="bookmark_group_management.jsp">북마크 그룹 관리</a>
</div>

<style>
    .link-group a {
        margin-right: 10px;
        color: black;
        text-decoration: underline;
    }
</style>

<style>
    table {
        border-collapse: collapse;
        width: 100%;
        margin-bottom: 20px;
    }

    th, td {
        padding: 8px;
        text-align: left;
        border: 1px solid black;
    }

    th {
        background-color: #4CAF50;
        color: white;
        text-align: center;
    }

    td {
        font-size: 12px;
    }

    td {
        text-align: left;
    }
</style>

<table id="bookmarkTable">
    <tr>
        <th>ID</th>
        <th>북마크 이름</th>
        <th>와이파이명</th>
        <th>등록일자</th>
        <th>비고</th>
    </tr>
    <%
        // 데이터베이스 연결 및 쿼리 실행
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet resultSet = null;

        try {
            Class.forName("org.sqlite.JDBC");
            conn = DriverManager.getConnection("jdbc:sqlite:/Users/han/zerobase_wifi.db");

            // Bookmarks 테이블에서 데이터 조회
            String selectQuery = "SELECT * FROM Bookmark_contents";
            pstmt = conn.prepareStatement(selectQuery);
            resultSet = pstmt.executeQuery();

            // 결과를 테이블에 표시
            while (resultSet.next()) {
                int id = resultSet.getInt("ID");
                String bookmarkName = resultSet.getString("BOOKMARK_NAME");
                String wifiName = resultSet.getString("wifi_name");
                String instDttm = resultSet.getString("INST_DTTM");


    %><tr id="row<%=id%>">
    <td><%=id%></td>
    <td><%=bookmarkName%></td>
    <td><%=wifiName%></td>
    <td><%=instDttm%></td>
    <td class="text-center">
        <button onclick="deleteRow(<%=id%>)">삭제</button>
    </td>
</tr><%
        }
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        // 리소스 정리
        try {
            if (resultSet != null)
                resultSet.close();
            if (pstmt != null)
                pstmt.close();
            if (conn != null)
                conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
</table>

<script>
    function deleteRow(id) {
        location.href = "bookmark_delete.jsp?id=" + id;
    }
</script>

</body>
</html>