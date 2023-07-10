package Db;

import com.google.gson.Gson;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

public class ApiExplorer {
    public static void func(int n) throws IOException {
        /*URL*/
        StringBuilder urlBuilder = new StringBuilder("http://openapi.seoul.go.kr:8088");
        /*인증키(sample사용시에는 호출시 제한됩니다.)*/
        urlBuilder.append("/" + URLEncoder.encode("6865634f47636f6f3932754f754a4e","UTF-8") );
        /*요청파일타입(xml,xmlf,xls,json) */
        urlBuilder.append("/" + URLEncoder.encode("json","UTF-8") );
        /*서비스명 (대소문자 구분 필수입니다.)*/
        urlBuilder.append("/" + URLEncoder.encode("TbPublicWifiInfo","UTF-8"));
        /*요청시작위치*/
        urlBuilder.append("/" + URLEncoder.encode(String.valueOf(n),"UTF-8"));
        /*요청종료위치*/
        int end = n + 999;
        urlBuilder.append("/" + URLEncoder.encode(String.valueOf(end),"UTF-8"));
        URL url = new URL(urlBuilder.toString());
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Content-type", "application/xml");

        /* 연결자체에 대한 확인이 필요하므로 추가합니다.*/
        System.out.println("Response code: " + conn.getResponseCode());
        BufferedReader rd;
        // 서비스코드가 정상이면 200~300사이의 숫자가 나옵니다.
        if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
            rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        } else {
            rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
        }
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = rd.readLine()) != null) {
            sb.append(line);
        }
        rd.close();
        conn.disconnect();
        String jsonData = sb.toString();

        // 한국 시간 형식 지정
        DateTimeFormatter koreanDateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")
                .withLocale(Locale.KOREA);

        // 현재 한국 시간 가져오기
        ZonedDateTime currentDateTime = ZonedDateTime.now();

        // 한국 시간 형식으로 포맷팅
        String koreanDateTime = currentDateTime.format(koreanDateTimeFormatter);

        // SQLite 데이터베이스에 연결
        try (Connection connection = DriverManager.getConnection("jdbc:sqlite:/Users/han/zerobase_wifi.db")) {
            // JSON 데이터 파싱
            Gson gson = new Gson();
            TbPublicWifiInfo wifiInfo = gson.fromJson(jsonData, TbPublicWifiInfo.class);
            TbPublicWifiInfo.TbPublicWifiInfoInner innerData = wifiInfo.getTbPublicWifiInfo();

            if (innerData != null) {
                TbPublicWifiInfo.Row[] rows = innerData.getRow();

                // 데이터 삽입을 위한 SQL 문
                String insertQuery = "INSERT INTO Wifi (MGR_NO, WRDOFC, MAIN_NM, ADRES1, ADRES2, INSTL_FLOOR, INSTL_TY, INSTL_MBY, " +
                        "SVC_SE, CMCWR, CNSTC_YEAR, INOUT, REMARS3, LAT, LNT, WORK_DTTM) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

                // PreparedStatement 객체 생성
                try (PreparedStatement pstmt = connection.prepareStatement(insertQuery)) {
                    // 데이터 삽입
                    for (TbPublicWifiInfo.Row row : rows) {
                        pstmt.setString(1, row.getX_SWIFI_MGR_NO());
                        pstmt.setString(2, row.getX_SWIFI_WRDOFC());
                        pstmt.setString(3, row.getX_SWIFI_MAIN_NM());
                        pstmt.setString(4, row.getX_SWIFI_ADRES1());
                        pstmt.setString(5, row.getX_SWIFI_ADRES2());
                        pstmt.setString(6, row.getX_SWIFI_INSTL_FLOOR());
                        pstmt.setString(7, row.getX_SWIFI_INSTL_TY());
                        pstmt.setString(8, row.getX_SWIFI_INSTL_MBY());
                        pstmt.setString(9, row.getX_SWIFI_SVC_SE());
                        pstmt.setString(10, row.getX_SWIFI_CMCWR());
                        pstmt.setInt(11, Integer.parseInt(row.getX_SWIFI_CNSTC_YEAR()));
                        pstmt.setString(12, row.getX_SWIFI_INOUT_DOOR());
                        pstmt.setString(13, row.getX_SWIFI_REMARS3());
                        pstmt.setDouble(14, Double.parseDouble(row.getLAT()));
                        pstmt.setDouble(15, Double.parseDouble(row.getLNT()));
                        pstmt.setString(16, koreanDateTime);

                        pstmt.executeUpdate();
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public static void func2() throws IOException {
    	for (int i = 0; i < 23; i++) {
            func(1000*i + 1);
        }
    }
    
    public static void main(String[] args) throws IOException {
		ApiExplorer.func2();
	}
}

