
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONException" %>
<%@page import="java.sql.*, javax.sql.*, javax.naming.*"%>

<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<% 
    String std_code = "";	
	String std_birth_day = "";

	std_code = request.getParameter("std_code");	
	std_birth_day = request.getParameter("std_birth_day");   

    JSONObject data_json_obj_result = new JSONObject();
    String error_message = "";
    int error_message_status = 0;

    String clientOrigin = request.getHeader("origin");
	response.setHeader("Access-Control-Allow-Origin", clientOrigin);
	response.setHeader("Access-Control-Allow-Methods", "POST");
	response.setHeader("Access-Control-Allow-Headers", "Content-Type");
	response.setHeader("Access-Control-Max-Age", "86400");

    if(std_code != null && std_birth_day != null){

            DataSource data_resource = null;
            Context context = new InitialContext();
            Context env_context = (Context) context.lookup("java:comp/env");
            data_resource =  (DataSource)env_context.lookup("jdbc/rubram");     
        
            Connection db_connect = null;
	        Statement sql_statement = null;
            String str_query = "";

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

            db_connect =  data_resource.getConnection();
		    sql_statement = db_connect.createStatement();

            str_query  = " SELECT  A.STD_CODE, A.SEX, A.PRENAME_NO, A.FIRST_NAME_THAI, A.LAST_NAME_THAI, TO_CHAR(A.BIRTH_DATE, 'MM/DD/YYYY','NLS_CALENDAR=''THAI BUDDHA'' NLS_DATE_LANGUAGE=THAI') AS BIRTH_DATE , B.MAJOR_NAME_THAI, B.MAJOR_NO, B.FACULTY_NO FROM DBBACH00.UGB_STUDENT A, DBBACH00.VM_GRADUATE_V2 B WHERE  A.STD_CODE = '"+ std_code +"' AND A.BIRTH_DATE = TO_DATE('"+ std_birth_day +"', 'MM/DD/YYYY') AND B.STD_CODE = '"+ std_code +"' AND A.STD_CODE  = B.STD_CODE ";             
            ResultSet result_set = sql_statement.executeQuery(str_query);

            while( ( result_set != null ) && ( result_set.next() ) ){
                
                STD_CODE = result_set.getString("STD_CODE");
                SEX = result_set.getString("SEX");
                PRENAME_NO = result_set.getString("PRENAME_NO");
                FIRST_NAME_THAI = result_set.getString("FIRST_NAME_THAI");
                LAST_NAME_THAI = result_set.getString("LAST_NAME_THAI");
                BIRTH_DATE = result_set.getString("BIRTH_DATE");                                   
                    
                error_message_status = 1;
            }
            
            //เริ่ม--- คำนวณหาอายุ นักศึกษา ---
            String temp_age_srt = new String(BIRTH_DATE);
            int temp_age_num = Integer.parseInt(temp_age_srt.substring(6));
            AGE = String.valueOf(2564 - temp_age_num);
            //จบ--- คำนวณหาอายุ นักศึกษา ---
  
            data_json_obj_result.put("STD_CODE",STD_CODE); 
            data_json_obj_result.put("SEX",SEX);
            data_json_obj_result.put("PRENAME_NO",PRENAME_NO);
            data_json_obj_result.put("FIRST_NAME_THAI",FIRST_NAME_THAI);
            data_json_obj_result.put("LAST_NAME_THAI",LAST_NAME_THAI);
            data_json_obj_result.put("BIRTH_DATE",BIRTH_DATE);  
            data_json_obj_result.put("AGE",AGE);                       

                   

        }catch(Exception e){

            error_message = e.getMessage();

        }       

        sql_statement.close();
        db_connect.close();	

    } else {

        //ค่า Parameters ที่ส่งมาไม่ครบ หรือไม่ได้ส่งค่ามาเลย
        error_message_status = 2;        
        data_json_obj_result.put("std_code",std_code+"");
        data_json_obj_result.put("std_birth_day",std_birth_day+"");
       
    }

    //เริ่ม --- การใส่ค่า String สำหรับแสดงผล error_message
    if(error_message_status == 1){

        error_message = " Congratulation Successfuly ( สำเร็จ ) :-) ";        

    }else if(error_message_status == 2){

        error_message = "Parameters is null values... ( ค่า Parameters ที่ส่งมาไม่ครบ หรือไม่ได้ส่งค่ามาเลย ) :-|";

    }else{

        error_message = "The database could not be found. ( ไม่พบข้อมูลใน Database ) :-(";

    }  

     data_json_obj_result.put("error_message",error_message);
     data_json_obj_result.put("error_message_status",error_message_status);
    //จบ --- การใส่ค่า String สำหรับแสดงผล error_message

    out.print(data_json_obj_result);
    out.flush();
%>



