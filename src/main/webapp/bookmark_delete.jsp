<%@ page import="java.sql.SQLException" %>
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
</head>
<body>
<h1>북마크 삭제</h1>

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

<label>북마크를 삭제하시겠습니까?</label>
<table id="bookmarkTable">
    <%
        int id = Integer.parseInt(request.getParameter("id"));
        // 데이터베이스 연결 및 쿼리 실행
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet resultSet = null;

        try {
            Class.forName("org.sqlite.JDBC");
            conn = DriverManager.getConnection("jdbc:sqlite:/Users/han/zerobase_wifi.db");

            // Bookmarks 테이블에서 데이터 조회
            String selectQuery = "SELECT BOOKMARK_NAME, WIFI_NAME, INST_DTTM FROM Bookmark_contents WHERE id = ?";
            pstmt = conn.prepareStatement(selectQuery);
            pstmt.setInt(1, id);
            resultSet = pstmt.executeQuery();

            // 결과를 테이블에 표시
            while (resultSet.next()) {
                String bookmarkName = resultSet.getString("BOOKMARK_NAME");
                String wifiName = resultSet.getString("WIFI_NAME");
                String instDttm = resultSet.getString("INST_DTTM");
    %>
    <tr id="row<%=id%>">
        <th>북마크 이름</th>
        <td><%=bookmarkName%></td>
    </tr>
    <tr>
        <th>와이파이 이름</th>
        <td><%=wifiName%></td>
    </tr>
    <tr>
        <th>등록 일자</th>
        <td><%=instDttm%></td>
    </tr>
    <tr>
        <td colspan="2" style="text-align: center;">
            <a href="bookmark_management.jsp">돌아가기</a>
            <button type="button" onclick="deleteBookmark(<%=id%>)">삭제</button>
        </td>
    </tr>
    <%
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
    var id = <%= request.getParameter("id") %>;
    function deleteBookmark(id) {
        // 삭제 버튼 클릭 시 해당 ID의 데이터 삭제
        if (confirm("데이터를 삭제하시겠습니까?")) {
            // AJAX를 이용하여 서버로 삭제 요청
            var xhttp = new XMLHttpRequest();
            xhttp.onreadystatechange = function() {
                if (xhttp.readyState === 4 && xhttp.status === 200) {
                    // 삭제 성공 시 행을 테이블에서 제거
                    alert("북마크 정보를 삭제하였습니다.")
                    window.location.href = "bookmark_management.jsp";
                }
            };
            xhttp.open("POST", "delete_bookmark.jsp?id=" + id, true);
            xhttp.send();
        }
    }
</script>

</body>
</html>
