
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONException" %>
<%@page import="java.sql.*, javax.sql.*, javax.naming.*"%>
<%@page import="java.util.Base64" %>

<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<% 
	String __std_code = request.getParameter("__std_code");	
	String __std_birth_day = request.getParameter("__std_birth_day");    

    DataSource __data_resource = null;
    Context __context = new InitialContext();
    Context __env_context = (Context) __context.lookup("java:comp/env");
    __data_resource =  (DataSource)__env_context.lookup("jdbc/rubram");     

    JSONObject _data_result_records = new JSONObject();
    String __error_message = "";


    String clientOrigin = request.getHeader("origin");
	response.setHeader("Access-Control-Allow-Origin", clientOrigin);
	response.setHeader("Access-Control-Allow-Methods", "POST");
	response.setHeader("Access-Control-Allow-Headers", "Content-Type");
	response.setHeader("Access-Control-Max-Age", "86400");

    if(__std_code != null && __std_birth_day != null){
        
            Connection __db_connect = null;
	        Statement __sql_statement = null;
            String __str_query = "";

            String STD_CODE = "";
            String SEX = "";
            String PRENAME_NO = "";
            String FIRST_NAME_THAI = "";
            String LAST_NAME_THAI = "";
            String BIRTH_DATE = "";
            
            
        try{

            __db_connect =  __data_resource.getConnection();
		    __sql_statement = __db_connect.createStatement();

            __str_query  = "SELECT A.STD_CODE, A.SEX, A.PRENAME_NO, A.FIRST_NAME_THAI, A.LAST_NAME_THAI, A.BIRTH_DATE";
            __str_query += "FROM UGB_STUDENT A WHERE A.STD_CODE = '"+ __std_code +"' ";             
            ResultSet __result_set = __sql_statement.executeQuery(__str_query);

            while( ( __result_set != null ) && ( __result_set.next() ) ){
            
                STD_CODE = __result_set.getString("STD_CODE");
                SEX = __result_set.getString("SEX");
                PRENAME_NO = __result_set.getString("PRENAME_NO");
                FIRST_NAME_THAI = __result_set.getString("FIRST_NAME_THAI");
                LAST_NAME_THAI = __result_set.getString("LAST_NAME_THAI");
                BIRTH_DATE = __result_set.getString("BIRTH_DATE");               
                   
            }
                
            __sql_statement.close();
            __db_connect.close();	

            __error_message = " ข้อมูลถูกต้อง :-) ";

        }catch(Exception e){

            __error_message = e.getMessage();

        }

        _data_result_records.put("__error_message",__error_message);   
        _data_result_records.put("STD_CODE",STD_CODE); 
        _data_result_records.put("SEX",SEX);
        _data_result_records.put("PRENAME_NO",PRENAME_NO);
        _data_result_records.put("FIRST_NAME_THAI",FIRST_NAME_THAI);
        _data_result_records.put("LAST_NAME_THAI",LAST_NAME_THAI);
        _data_result_records.put("BIRTH_DATE",BIRTH_DATE);

    } else {

    }

    out.print(_data_result_records);
    out.flush();
%>



