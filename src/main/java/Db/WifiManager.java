package Db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class WifiManager {
    public static void getNearbyWifi(double latitude, double longitude) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            // SQLite 데이터베이스 연결
            Class.forName("org.sqlite.JDBC");
            String dbURL = "jdbc:sqlite:/Users/han/zerobase_wifi.db";
            conn = DriverManager.getConnection(dbURL);

            // 현재 내 위치와 가장 가까운 20개의 와이파이 정보를 가져오는 쿼리 작성
            String query = "SELECT *, " +
                    "6371 * 2 * ASIN(SQRT(POWER(SIN((RADIANS(?) - RADIANS(LAT)) / 2), 2) + " +
                    "COS(RADIANS(?)) * COS(RADIANS(LAT)) * POWER(SIN((RADIANS(?) - RADIANS(LNT)) / 2), 2))) " +
                    "AS distance FROM Wifi ORDER BY distance LIMIT 20";
            stmt = conn.prepareStatement(query);
            stmt.setDouble(1, latitude);
            stmt.setDouble(2, latitude);
            stmt.setDouble(3, longitude);

            // 쿼리 실행 및 결과 처리
            rs = stmt.executeQuery();
            while (rs.next()) {
                // 와이파이 정보 출력
                System.out.println("거리: " + rs.getDouble("distance") + " Km");
                System.out.println("관리번호: " + rs.getString("MGR_NO"));
                System.out.println("자치구: " + rs.getString("WRDOFC"));
                System.out.println("와이파이명: " + rs.getString("MAIN_NM"));
                System.out.println("도로명주소: " + rs.getString("ADRES1"));
                System.out.println("상세주소: " + rs.getString("ADRES2"));
                System.out.println("설치위치(층): " + rs.getString("INSTL_FLOOR"));
                System.out.println("설치유형: " + rs.getString("INSTL_TY"));
                System.out.println("설치기관: " + rs.getString("INSTL_MBY"));
                System.out.println("서비스구분: " + rs.getString("SVC_SE"));
                System.out.println("망종류: " + rs.getString("CMCWR"));
                System.out.println("설치년도: " + rs.getString("CNSTC_YEAR"));
                System.out.println("실내외구분: " + rs.getString("INOUT"));
                System.out.println("WIFI접속환경: " + rs.getString("REMARS3"));
                System.out.println("X좌표: " + rs.getDouble("LAT"));
                System.out.println("Y좌표: " + rs.getDouble("LNT"));
                System.out.println("작업일자: " + rs.getString("DATE"));
                System.out.println();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // 리소스 해제
            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (stmt != null) {
                try {
                    stmt.close();
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
    }

    public static void main(String[] args) {
        double latitude = 37.5665; // 위도
        double longitude = 126.9780; // 경도

        getNearbyWifi(latitude, longitude);
    }
}
