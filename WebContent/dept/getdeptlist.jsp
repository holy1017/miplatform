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

<%!//DB���� ��ȸ�� ����� �޾Ƽ� ��ȯ�ϴ� �޼ҵ带 �����Ѵ�.

	public String rsGet(ResultSet rs, String id) throws Exception

	{

		if (rs.getString(id) == null)
			return "";

		else

			return rs.getString(id); //Ŀ���� �ִ� �ο��� id�� �÷������� ã�Ƽ� ��ȯ

	}%>

<%
	//�ڹٿ��� �����߿� �߻��� �����޽����� ���� ���� ����

	VariableList vl = new VariableList();

	//DataSet�������� ���� �� �ִ� ��ü ����

	//�ֳ��ϸ� �� ȭ�鿡 �������� �׸��带 ������ ���� �����ϱ�

	DatasetList dl = new DatasetList();

	String char_set = "utf-8";

	/*********** JDBC ����  ***********/

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

		/************** Dataset ���� *********************/

		//��ȸ ����� Dataset�� ��Ƽ� �����÷����� Grid�� ���ε� ���־��

		//ȭ�鿡�� ����� �� �� �ִ�.

		Dataset ds = new Dataset("ds_dept", char_set);

		//�����ͼ��� �ʱ�ȭ ���ش�. - �÷������� �ʱ�ȭ ���ش�.

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

	//ó�� ����� xml������ ��������.

	out.clear();

	out = pageContext.pushBody();

	out.clearBuffer();

	PlatformResponse pRes = new PlatformResponse(response, PlatformRequest.XML, char_set);

	pRes.sendData(vl, dl);
%>