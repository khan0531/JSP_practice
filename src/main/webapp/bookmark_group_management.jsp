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
<h1>북마크 그룹 관리</h1>

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

<div>
    <button onclick="location.href='bookmark_group_insert.jsp'">북마크 그룹 이름 추가</button>
</div>

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
        <th>순서</th>
        <th>등록일자</th>
        <th>수정일자</th>
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
            String selectQuery = "SELECT * FROM Bookmarks ORDER BY SEQUENCE";
            pstmt = conn.prepareStatement(selectQuery);
            resultSet = pstmt.executeQuery();

            // 결과를 테이블에 표시
            while (resultSet.next()) {
                int id = resultSet.getInt("ID");
                String bookmarkName = resultSet.getString("BOOKMARK_NAME");
                int sequence = resultSet.getInt("SEQUENCE");
                String workDttm = resultSet.getString("WORK_DTTM");
                String editDttm = resultSet.getString("EDIT_DTTM");

                if (editDttm == null) {
                    editDttm = "";  // EDIT_DTTM이 null인 경우에는 공백으로 처리
                }

    %><tr id="row<%=id%>">
    <td><%=id%></td>
    <td><%=bookmarkName%></td>
    <td><%=sequence%></td>
    <td><%=workDttm%></td>
    <td><%=editDttm%></td>
    <td class="text-center">
        <a href="bookmark_group_edit.jsp?id=<%=id%>">수정</a>
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
        // 삭제 버튼 클릭 시 해당 ID의 데이터 삭제
        if (confirm("데이터를 삭제하시겠습니까?")) {
            // AJAX를 이용하여 서버로 삭제 요청
            var xhr = new XMLHttpRequest();
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    // 삭제 성공 시 행을 테이블에서 제거
                    var row = document.getElementById("row" + id);
                    row.parentNode.removeChild(row);
                }
            };
            xhr.open("POST", "delete_bookmark_group.jsp?id=" + id, true);
            xhr.send();
        }
    }

    function editBookmark(id) {
        location.href = "bookmark_group_edit.jsp?id=" + id;
    }
</script>

</body>
</html>