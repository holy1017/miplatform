<%@page import="com.tobesoft.platform.PlatformRequest"%>

<%@page import="com.tobesoft.platform.PlatformResponse"%>

<%@page import="com.tobesoft.platform.data.Variant"%>

<%@page import="com.tobesoft.platform.data.ColumnInfo"%>

<%@page import="com.tobesoft.platform.data.Dataset"%>

<%@page import="com.util.DBConnectionMgr"%>

<%@page import="java.sql.PreparedStatement"%>

<%@page import="java.sql.Connection"%>

<%@page import="com.tobesoft.platform.data.DatasetList"%>

<%@page import="com.tobesoft.platform.data.VariableList"%>

<%@page import="java.sql.ResultSet"%>

<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>

<%!//DB에서 조회된 결과를 받아서 반환하는 메소드를 선언한다.

	public String rsGet(ResultSet rs, String id) throws Exception

	{

		if (rs.getString(id) == null)
			return "";

		else

			return rs.getString(id); //커서가 있는 로우의 id로 컬럼정보를 찾아서 반환

	}%>

<%
	//자바에서 실행중에 발생한 에러메시지를 담을 변수 선언

	VariableList vl = new VariableList();

	//DataSet여러개를 담을 수 있는 객체 선언

	//왜냐하면 한 화면에 여러개의 그리드를 보여줄 수도 있으니까

	DatasetList dl = new DatasetList();

	String char_set = "utf-8";

	/*********** JDBC 구현  ***********/

	DBConnectionMgr dbMgr = null;

	Connection con = null;

	PreparedStatement pstmt = null;

	ResultSet rs = null;

	StringBuilder sql = new StringBuilder();

	sql.append("SELECT deptno, dname, loc FROM dept");

	try {

		dbMgr = DBConnectionMgr.getInstance();

		con = dbMgr.getConnection();

		pstmt = con.prepareStatement(sql.toString());

		rs = pstmt.executeQuery();

		/************** Dataset 생성 *********************/

		//조회 결과를 Dataset에 담아서 마이플랫폼의 Grid에 바인딩 해주어야

		//화면에서 결과를 볼 수 있다.

		Dataset ds = new Dataset("ds_dept", char_set);

		//데이터셋을 초기화 해준다. - 컬럼정보를 초기화 해준다.

		ds.addColumn("deptno", ColumnInfo.CY_COLINFO_INT, 3);

		ds.addColumn("dname", ColumnInfo.CY_COLINFO_STRING, 30);

		ds.addColumn("loc", ColumnInfo.CY_COLINFO_STRING, 30);

		while (rs.next()) {

			int row = ds.appendRow();

			ds.setColumn(row, "deptno", new Variant(rsGet(rs, "deptno")));

			ds.setColumn(row, "dname", new Variant(rsGet(rs, "dname")));

			ds.setColumn(row, "loc", new Variant(rsGet(rs, "loc")));

		}

		dl.addDataset("ds_dept", ds);

	} catch (Exception e) {

		out.print(e.toString());

	} finally {

		dbMgr.freeConnection(con, pstmt, rs);

	}

	//처리 결과를 xml문서로 내보낸다.

	out.clear();

	out = pageContext.pushBody();

	out.clearBuffer();

	PlatformResponse pRes = new PlatformResponse(response, PlatformRequest.XML, char_set);

	pRes.sendData(vl, dl);
%>