package Db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class CreateDbTable2 {
    public static void main(String[] args) {
        Connection connection = null;
        Statement statement = null;

        try {
            // SQLite JDBC 드라이버를 로드합니다.
            Class.forName("org.sqlite.JDBC");

            // 데이터베이스 연결을 수립합니다.
            String url = "jdbc:sqlite:/Users/han/zerobase_wifi.db";
            connection = DriverManager.getConnection(url);

            // SQL 문을 실행하기 위한 Statement 객체를 생성합니다.
            statement = connection.createStatement();

            // Wifi 테이블 생성 쿼리
            String createTableQuery = "CREATE TABLE History (" +
                    "ID INTEGER PRIMARY KEY AUTOINCREMENT, " +
                    "LAT DOUBLE, " +
                    "LNT DOUBLE, " +
                    "WORK_DTTM DATETIME" +
                    ");";

            // 쿼리 실행
            statement.executeUpdate(createTableQuery);

            System.out.println("테이블 생성 완료.");

        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                // Statement와 Connection을 닫습니다.
                if (statement != null)
                    statement.close();
                if (connection != null)
                    connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
