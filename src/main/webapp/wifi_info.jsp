<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.sql.SQLException" %>
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
<h1>와이파이 정보</h1>

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

<select id="bookmarkSelect">
    <option value="">북마크 그룹 이름 선택</option>
    <%
        // 데이터베이스 연결 및 쿼리 실행
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet res = null;

        try {
            Class.forName("org.sqlite.JDBC");
            conn = DriverManager.getConnection("jdbc:sqlite:/Users/han/zerobase_wifi.db");

            // Bookmarks 테이블에서 데이터 조회
            String selectQuery = "SELECT bookmark_name FROM bookmarks";
            pstmt = conn.prepareStatement(selectQuery);
            res = pstmt.executeQuery();

            // 결과를 select 엘리먼트에 옵션으로 추가
            while (res.next()) {
                String bookmarkName = res.getString("bookmark_name");
    %>
    <option value="<%=bookmarkName%>"><%=bookmarkName%></option>
    <%
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // 리소스 정리
            try {
                if (res != null)
                    res.close();
                if (pstmt != null)
                    pstmt.close();
                if (conn != null)
                    conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    %>
</select>
<button id="addBookmarkButton" onclick="addBookmark()">북마크 추가하기</button>

<script>
    function addBookmark() {
        var wifi_name = encodeURIComponent(document.getElementsByTagName("th")[3].nextElementSibling.textContent); // 와이파이명 가져오기
        var bookmarkSelect = document.getElementById("bookmarkSelect");
        var bookmark_name = encodeURIComponent(bookmarkSelect.options[bookmarkSelect.selectedIndex].value);

        // AJAX를 이용하여 서버로 수정 요청을 보냅니다.
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 200) {
                console.log("북마크 추가하기 버튼이 클릭되었습니다.");
                alert("북마크 정보를 추가하였습니다.");
                window.location.href = "bookmark_management.jsp";
            }
        };
        console.log(bookmark_name);
        console.log(wifi_name);
        xhttp.open("POST", "insert_bookmark.jsp", true);
        xhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xhttp.send("wifi_name=" + wifi_name + "&bookmark_name=" + bookmark_name);
    }
</script>

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
        text-align: left;
    }
</style>

<table id="wifiInfoTable">
    <%
        int id = Integer.parseInt(request.getParameter("id"));
        double distance = Double.parseDouble(request.getParameter("distance"));
        // 데이터베이스 연결 및 쿼리 실행
        conn = null;
        pstmt = null;
        res = null;

        try {
            Class.forName("org.sqlite.JDBC");
            conn = DriverManager.getConnection("jdbc:sqlite:/Users/han/zerobase_wifi.db");

            // Bookmarks 테이블에서 데이터 조회
            String selectQuery = "SELECT * FROM wifi WHERE id = ?";
            pstmt = conn.prepareStatement(selectQuery);
            pstmt.setInt(1, id);
            res = pstmt.executeQuery();

            // 결과를 테이블에 표시
            if (res.next()) {
                String MGR_NO = res.getString("MGR_NO");
                String WRDOFC = res.getString("WRDOFC");
                String MAIN_NM = res.getString("MAIN_NM");
                String ADRES1 = res.getString("ADRES1");
                String ADRES2 = res.getString("ADRES2");
                String INSTL_FLOOR = res.getString("INSTL_FLOOR");
                String INSTL_TY = res.getString("INSTL_TY");
                String INSTL_MBY = res.getString("INSTL_MBY");
                String SVC_SE = res.getString("SVC_SE");
                String CMCWR = res.getString("CMCWR");
                int CNSTC_YEAR = res.getInt("CNSTC_YEAR");
                String INOUT = res.getString("INOUT");
                String REMARS3 = res.getString("REMARS3");
                String LAT = res.getString("LAT");
                String LNT = res.getString("LNT");
                String WORK_DTTM = res.getString("WORK_DTTM");

                if (LAT != null && LNT != null && Double.parseDouble(LAT) > Double.parseDouble(LNT)) {
                    String temp = LAT;
                    LAT = LNT;
                    LNT = temp;
                }
    %>
    <tr>
        <th>거리(Km)</th>
        <td><%=distance%></td>
    </tr>
    <tr>
        <th>관리번호</th>
        <td><%=MGR_NO%></td>
    </tr>
    <tr>
        <th>자치구</th>
        <td><%=WRDOFC%></td>
    </tr>
    <tr>
        <th>와이파이명</th>
        <td><%=MAIN_NM%></td>
    </tr>
    <tr>
        <th>도로명주소</th>
        <td><%=ADRES1%></td>
    </tr>
    <tr>
        <th>상세주소</th>
        <td><%=ADRES2%></td>
    </tr>
    <tr>
        <th>설치위치(층)</th>
        <td><%=INSTL_FLOOR%></td>
    </tr>
    <tr>
        <th>설치유형</th>
        <td><%=INSTL_TY%></td>
    </tr>
    <tr>
        <th>설치기관</th>
        <td><%=INSTL_MBY%></td>
    </tr>
    <tr>
        <th>서비스구분</th>
        <td><%=SVC_SE%></td>
    </tr>
    <tr>
        <th>망종류</th>
        <td><%=CMCWR%></td>
    </tr>
    <tr>
        <th>설치년도</th>
        <td><%=CNSTC_YEAR%></td>
    </tr>
    <tr>
        <th>실내외구분</th>
        <td><%=INOUT%></td>
    </tr>
    <tr>
        <th>WIFI접속환경</th>
        <td><%=REMARS3%></td>
    </tr>
    <tr>
        <th>X좌표</th>
        <td><%=LAT%></td>
    </tr>
    <tr>
        <th>Y좌표</th>
        <td><%=LNT%></td>
    </tr>
    <tr>
        <th>작업일자</th>
        <td><%=WORK_DTTM%></td>
    </tr>
    <%
    } else {
    %>
    <tr>
        <td colspan="2">해당하는 와이파이 정보를 찾을 수 없습니다.</td>
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
                if (res != null)
                    res.close();
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


</script>

</body>
</html>
