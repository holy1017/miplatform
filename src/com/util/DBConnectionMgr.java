package com.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class DBConnectionMgr {
	// 선언부
	private final String _DREIVER = "oracle.jdbc.driver.OracleDriver";
	private final String _URL = "jdbc:oracle:thin:@localhost:1521:orcl";
	private final String _USER = "scott";
	private final String _PW = "test1234";
	private static DBConnectionMgr instance = null;

	// 생성자

	//
	public static DBConnectionMgr getInstance() {
		// 인스턴스를 메소드를 통해 할수 있다.
		if (instance == null) {
			synchronized (DBConnectionMgr.class) {
				if (instance == null) {
					instance = new DBConnectionMgr();
				}
			}
		}
		return instance;
	}

	// Connection생성하기
	public Connection getConnection() {
		Connection con = null;
		try {
			Class.forName(_DREIVER);
			con = DriverManager.getConnection(_URL, _USER, _PW);
		} catch (ClassNotFoundException ce) {
			System.out.println("드라이버 클래스를 찾을 수 없습니다.");
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return con;
	}

	// 사용한 자원반납하기
	// 생성한 역순으로 반납한다. Connection, Statement, ResultSet
	public void freeConnection(Connection con, Statement stmt) {
		try {
			if (stmt != null) stmt.close();
			if (con != null) con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public void freeConnection(Connection con, PreparedStatement pstmt) {
		try {

			if (pstmt != null) pstmt.close();
			if (con != null) con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public void freeConnection(Connection con, ResultSet rs) {
		try {
			if (con != null) con.close();
			if (rs != null)	rs.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public void freeConnection(Connection con, PreparedStatement pstmt,
			ResultSet rs) {
		try {

			if (con != null) con.close();
			if (pstmt != null) pstmt.close();
			if (rs != null)	rs.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}

	}
}
//

