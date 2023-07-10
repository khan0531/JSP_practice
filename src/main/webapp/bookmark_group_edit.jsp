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
    </style>
</head>
<body>
<h1>북마크 그룹 수정</h1>

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
            String selectQuery = "SELECT BOOKMARK_NAME, SEQUENCE FROM Bookmarks WHERE id = ?";
            pstmt = conn.prepareStatement(selectQuery);
            pstmt.setInt(1, id);
            resultSet = pstmt.executeQuery();

            // 결과를 테이블에 표시
            while (resultSet.next()) {
                String bookmarkName = resultSet.getString("BOOKMARK_NAME");
                int sequence = resultSet.getInt("SEQUENCE");
    %>
    <tr id="row">
    <tr>
        <th>북마크 이름</th>
        <td><input type="text" name="bookmarkName" id="bookmarkName" value="<%=bookmarkName%>"></td>
    </tr>
    <tr>
        <th>순서</th>
        <td><input type="number" name="sequence" id="sequence" value="<%=sequence%>"></td>
    </tr>
    <tr>
        <td colspan="2" style="text-align: center;">
            <a href="bookmark_group_management.jsp">돌아가기</a>
            <button type="button" onclick="editBookmark()">수정</button>
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

    function editBookmark() {
        var bookmarkName = encodeURIComponent(document.getElementsByName("bookmarkName")[0].value);
        var sequence = document.getElementsByName("sequence")[0].value;

        // AJAX를 이용하여 서버로 수정 요청을 보냅니다.
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 200) {
                console.log(this.responseText);
                alert("북마크 정보를 수정하였습니다.");
                window.location.href = "bookmark_group_management.jsp";
            }
        };
        xhttp.open("POST", "edit_bookmark_group.jsp?id=" + id, true);
        xhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xhttp.send("bookmarkName=" + bookmarkName + "&sequence=" + sequence);
    }
</script>

</body>
</html>