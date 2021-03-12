
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONException" %>
<%@page import="java.sql.*, javax.sql.*, javax.naming.*"%>

<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<% 
    String __std_code = "";	
	String __std_birth_day = "";

	__std_code = request.getParameter("__std_code");	
	__std_birth_day = request.getParameter("__std_birth_day");   

    JSONObject __data_json_obj_result = new JSONObject();
    String __error_message = "";
    int __error_message_status = 0;

    String clientOrigin = request.getHeader("origin");
	response.setHeader("Access-Control-Allow-Origin", clientOrigin);
	response.setHeader("Access-Control-Allow-Methods", "POST");
	response.setHeader("Access-Control-Allow-Headers", "Content-Type");
	response.setHeader("Access-Control-Max-Age", "86400");

    if(__std_code != null && __std_birth_day != null){

            DataSource __data_resource = null;
            Context __context = new InitialContext();
            Context __env_context = (Context) __context.lookup("java:comp/env");
            __data_resource =  (DataSource)__env_context.lookup("jdbc/rubram");     
        
            Connection __db_connect = null;
	        Statement __sql_statement = null;
            String __str_query = "";

            String STD_CODE = "";
            String SEX = "";
            String PRENAME_NO = "";
            String FIRST_NAME_THAI = "";
            String LAST_NAME_THAI = "";
            String BIRTH_DATE = "";
            String MAJOR = "";
            String FACULTY = "";
            String AGE = "";            
            
        try{

            __db_connect =  __data_resource.getConnection();
		    __sql_statement = __db_connect.createStatement();

            __str_query  = " SELECT  A.STD_CODE, A.SEX, A.PRENAME_NO, A.FIRST_NAME_THAI, A.LAST_NAME_THAI, TO_CHAR(A.BIRTH_DATE, 'MM/DD/YYYY','NLS_CALENDAR=''THAI BUDDHA'' NLS_DATE_LANGUAGE=THAI') AS BIRTH_DATE , B.MAJOR_NAME_THAI, B.MAJOR_NO, B.FACULTY_NO FROM DBBACH00.UGB_STUDENT A, DBBACH00.VM_GRADUATE_V2 B WHERE  A.STD_CODE = '"+ __std_code +"' AND A.BIRTH_DATE = TO_DATE('"+ __std_birth_day +"', 'MM/DD/YYYY') AND B.STD_CODE = '"+ __std_code +"' AND A.STD_CODE  = B.STD_CODE ";             
            ResultSet __result_set = __sql_statement.executeQuery(__str_query);

            while( ( __result_set != null ) && ( __result_set.next() ) ){
                
                STD_CODE = __result_set.getString("STD_CODE");
                SEX = __result_set.getString("SEX");
                PRENAME_NO = __result_set.getString("PRENAME_NO");
                FIRST_NAME_THAI = __result_set.getString("FIRST_NAME_THAI");
                LAST_NAME_THAI = __result_set.getString("LAST_NAME_THAI");
                BIRTH_DATE = __result_set.getString("BIRTH_DATE");                                   
                    
                __error_message_status = 1;
            }
            
            //เริ่ม--- คำนวณหาอายุ นักศึกษา ---
            String __temp_age_srt = new String(BIRTH_DATE);
            int __temp_age_num = Integer.parseInt(__temp_age_srt.substring(6));
            AGE = String.valueOf(2564 - __temp_age_num);
            //จบ--- คำนวณหาอายุ นักศึกษา ---
  
            __data_json_obj_result.put("STD_CODE",STD_CODE); 
            __data_json_obj_result.put("SEX",SEX);
            __data_json_obj_result.put("PRENAME_NO",PRENAME_NO);
            __data_json_obj_result.put("FIRST_NAME_THAI",FIRST_NAME_THAI);
            __data_json_obj_result.put("LAST_NAME_THAI",LAST_NAME_THAI);
            __data_json_obj_result.put("BIRTH_DATE",BIRTH_DATE);  
            __data_json_obj_result.put("AGE",AGE);                       

                   

        }catch(Exception e){

            __error_message = e.getMessage();

        }       

        __sql_statement.close();
        __db_connect.close();	

    } else {

        //ค่า Parameters ที่ส่งมาไม่ครบ หรือไม่ได้ส่งค่ามาเลย
        __error_message_status = 2;        
        __data_json_obj_result.put("__std_code",__std_code+"");
        __data_json_obj_result.put("__std_birth_day",__std_birth_day+"");
       
    }

    //เริ่ม --- การใส่ค่า String สำหรับแสดงผล __error_message
    if(__error_message_status == 1){

        __error_message = " Congratulation Successfuly ( สำเร็จ ) :-) ";        

    }else if(__error_message_status == 2){

        __error_message = "Parameters is null values... ( ค่า Parameters ที่ส่งมาไม่ครบ หรือไม่ได้ส่งค่ามาเลย ) :-|";

    }else{

        __error_message = "The database could not be found. ( ไม่พบข้อมูลใน Database ) :-(";

    }  

     __data_json_obj_result.put("__error_message",__error_message);
     __data_json_obj_result.put("__error_message_status",__error_message_status);
    //จบ --- การใส่ค่า String สำหรับแสดงผล __error_message

    out.print(__data_json_obj_result);
    out.flush();
%>



