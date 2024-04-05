DECLARE 
    l_context apex_exec.t_context;
    l_filters apex_exec.t_filters;
    l_columns apex_exec.t_columns;
    -- l_parameters     apex_exec.t_parameters;
    l_row     pls_integer := 1;
    l_spoweridx pls_integer;
    l_timeidx pls_integer;
 
BEGIN
    l_context := apex_exec.open_rest_source_query(
    p_static_id     => 'givenergyinvertercurrent',            
    p_max_rows      => 1000 );

    -- current API doesnt need parameters


    l_spoweridx := apex_exec.get_column_position( l_context, 'SOLAR_POWER' );
    l_timeidx := apex_exec.get_column_position( l_context, 'TIME' );


    while apex_exec.next_row( l_context ) LOOP


    apex_json.open_object;       
    apex_json.write('success', true);  
    apex_json.write('SPOWER', apex_exec.get_number( l_context, l_spoweridx  ));  
    apex_json.write('TIME', apex_exec.get_timestamp_tz( l_context, l_timeidx ));  
    apex_json.close_object; 
    apex_json.close_all;          
    END LOOP;

     apex_exec.close( l_context );
EXCEPTION
     when others then
         apex_exec.close( l_context );
     RAISE;
END;