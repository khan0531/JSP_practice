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
            text-align: center;
            cursor: pointer;
        }
    </style>
</head>
<body>
<h1>와이파이 정보 구하기</h1>

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
    <label>LAT:</label>
    <input type="text" id="latDouble">

    <label>LNT:</label>
    <input type="text" id="lntDouble">

    <button onclick="getCurrentLocation()">내 위치 가져오기</button>
    <button onclick="getNearbyWifi()">근처 WIFI 정보 보기</button>
</div>

<table id="wifiTable">
    <tr>
        <th>거리 (Km)</th>
        <th>관리번호</th>
        <th>자치구</th>
        <th>와이파이명</th>
        <th>도로명주소</th>
        <th>상세주소</th>
        <th>설치위치 (층)</th>
        <th>설치유형</th>
        <th>설치기관</th>
        <th>서비스구분</th>
        <th>망종류</th>
        <th>설치년도</th>
        <th>실내외구분</th>
        <th>WIFI접속환경</th>
        <th>X좌표</th>
        <th>Y좌표</th>
        <th>작업일자</th>
    </tr>
    <tr id="infoMessageRow">
        <td colspan="17">위치 정보를 입력한 후에 조회해 주세요.</td>
    </tr>
</table>

<script>
    function getCurrentLocation() {
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(showPosition);
        } else {
            alert("Geolocation is not supported by this browser.");
        }
    }

    function savePosition(position) {
        var latitude = position.coords.latitude;
        var longitude = position.coords.longitude;

        document.getElementById("latDouble").value = latitude;
        document.getElementById("lntDouble").value = longitude;

        // AJAX를 사용하여 서버에 위치 정보를 전송하여 저장
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 200) {
                console.log(this.responseText);
                alert("위치 정보가 저장되었습니다.");
            }
        };
        xhttp.open("POST", "save_location.jsp", true);
        xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        xhttp.send("latitude=" + latitude + "&longitude=" + longitude);
    }

    function showPosition(position) {
        var latitude = position.coords.latitude;
        var longitude = position.coords.longitude;

        document.getElementById("latDouble").value = latitude;
        document.getElementById("lntDouble").value = longitude;
    }

    function getNearbyWifi() {
        var latitude = document.getElementById("latDouble").value;
        var longitude = document.getElementById("lntDouble").value;

        if (navigator.geolocation) {
            savePosition({coords: {latitude: latitude, longitude: longitude}});
        } else {
            alert("Geolocation is not supported by this browser.");
        }

        // AJAX를 사용하여 서버에 현재 위치 정보를 전송하고 결과를 받아옴
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 200) {
                // 서버에서 받은 결과를 테이블에 출력
                console.log(this.responseText);
                try {
                    // console.log(this.responseText);
                    var wifiData = JSON.parse(this.responseText);
                    var table = document.getElementById("wifiTable");
                    var infoMessageRow = document.getElementById("infoMessageRow");
                    infoMessageRow.style.display = "none"; // "위치 정보를 입력한 후에 조회해 주세요." 메시지 숨기기

                    wifiData.forEach(function(wifi) {
                        var row = table.insertRow();
                        var distanceCell = row.insertCell();
                        distanceCell.innerHTML = wifi.distance;

                        var managementNumberCell = row.insertCell();
                        managementNumberCell.innerHTML = wifi.MGR_NO;

                        var districtCell = row.insertCell();
                        districtCell.innerHTML = wifi.WRDOFC;

                        var wifiNameCell = row.insertCell();
                        var wifiNameLink = document.createElement("a");
                        wifiNameLink.innerHTML = wifi.MAIN_NM;
                        console.log(wifi.distance);
                        wifiNameLink.href =
                            "wifi_info.jsp?id=" + encodeURIComponent(wifi.id) +
                            "&distance=" + encodeURIComponent(wifi.distance); // ID 값을 URL에 추가 // 클릭 시 이동할 페이지 URL
                        wifiNameCell.appendChild(wifiNameLink);

                        var roadAddressCell = row.insertCell();
                        roadAddressCell.innerHTML = wifi.ADRES1;

                        var detailAddressCell = row.insertCell();
                        detailAddressCell.innerHTML = wifi.ADRES2;

                        var installLocationCell = row.insertCell();
                        installLocationCell.innerHTML = wifi.INSTL_FLOOR;

                        var installTypeCell = row.insertCell();
                        installTypeCell.innerHTML = wifi.INSTL_TY;

                        var installMBYCell = row.insertCell();
                        installMBYCell.innerHTML = wifi.INSTL_MBY;

                        var serviceTypeCell = row.insertCell();
                        serviceTypeCell.innerHTML = wifi.SVC_SE;

                        var networkTypeCell = row.insertCell();
                        networkTypeCell.innerHTML = wifi.CMCWR;

                        var installYearCell = row.insertCell();
                        installYearCell.innerHTML = wifi.CNSTC_YEAR;

                        var indoorOutdoorTypeCell = row.insertCell();
                        indoorOutdoorTypeCell.innerHTML = wifi.INOUT;

                        var wifiEnvironmenCell = row.insertCell();
                        wifiEnvironmenCell.innerHTML = wifi.REMARS3;

                        var xCoordinateCell = row.insertCell();
                        xCoordinateCell.innerHTML = wifi.LAT;

                        var yCoordinateCell = row.insertCell();
                        yCoordinateCell.innerHTML = wifi.LNT;

                        var dateCell = row.insertCell();
                        dateCell.innerHTML = wifi.WORK_DTTM;
                    });
                } catch (error) {
                    console.error("Error parsing JSON 1:", error);
                }
            }
        };
        xhttp.open("GET", "getNearbyWifi.jsp?lat=" + latitude + "&lnt=" + longitude, true);
        xhttp.send();
    }
</script>

</body>
</html>
