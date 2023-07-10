<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
<h1>북마크 그룹 추가</h1>

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
        <th>북마크 이름</th>
        <td><input type="text" name="bookmarkName"></td>
    </tr>
    <tr>
        <th>순서</th>
        <td><input type="number" name="sequence"></td>
    </tr>
    <tr>
        <td colspan="2" style="text-align: center;">
            <button type="button" onclick="addBookmark()">추가</button>
        </td>
    </tr>

</table>

<script>
    function addBookmark() {
        // 입력 필드에서 값을 가져온다
        var bookmarkName = encodeURIComponent(document.getElementsByName("bookmarkName")[0].value);
        var sequence = document.getElementsByName("sequence")[0].value;
        console.log(document.getElementsByName("bookmarkName")[0].value);
        console.log(bookmarkName);

        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 200) {
                console.log(this.responseText);
                alert("북마크 정보를 추가하였습니다.");
                window.location.href = "bookmark_group_management.jsp";
            }
        };
        xhttp.open("POST", "save_bookmark.jsp", true);
        xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        xhttp.send("bookmarkName=" + bookmarkName + "&sequence=" + sequence);
    }

</script>

</body>
</html>