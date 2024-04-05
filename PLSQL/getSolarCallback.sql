DECLARE 
    l_context apex_exec.t_context;
    l_filters apex_exec.t_filters;
    l_columns apex_exec.t_columns;
    -- l_parameters     apex_exec.t_parameters;
    l_row     pls_integer := 1;
    l_spoweridx pls_integer;
    l_timeidx pls_integer;
    l_inverterTempidx pls_integer;
    l_batterychargeidx pls_integer;
    l_batterytempidx pls_integer;
    l_inverterstatus pls_integer;

 
BEGIN
    l_context := apex_exec.open_rest_source_query(
    p_static_id     => 'givenergyinvertercurrent',            
    p_max_rows      => 1000 );

    -- current API doesnt need parameters


    l_spoweridx := apex_exec.get_column_position( l_context, 'SOLAR_POWER' );
    l_inverterTempidx := apex_exec.get_column_position( l_context, 'INVERTER_TEMPERATURE' );
    l_timeidx := apex_exec.get_column_position( l_context, 'TIME' );
    l_batterychargeidx := apex_exec.get_column_position( l_context, 'BATTERY_CHARGE' );
    l_batterytempidx := apex_exec.get_column_position( l_context, 'BATTERY_TEMPERATURE' );
    l_inverterstatus := apex_exec.get_column_position( l_context, 'STATUS' );

    while apex_exec.next_row( l_context ) LOOP


    apex_json.open_object;       
    apex_json.write('success', true);  
    apex_json.write('SPOWER', apex_exec.get_number( l_context, l_spoweridx  ));  
    apex_json.write('TIME', apex_exec.get_timestamp_tz( l_context, l_timeidx ));  
    apex_json.write('INVERTER_TEMPERATURE', apex_exec.get_number( l_context, l_inverterTempidx ));
    apex_json.write('BATTERY_CHARGE', apex_exec.get_number( l_context, l_batterychargeidx ));
    apex_json.write('BATTERY_TEMPERATURE', apex_exec.get_number( l_context, l_batterytempidx ));
    apex_json.write('STATUS', apex_exec.get_varchar2( l_context, l_inverterstatus ));

    apex_json.close_object; 
    apex_json.close_all;          
    END LOOP;

     apex_exec.close( l_context );
EXCEPTION
     when others then
         apex_exec.close( l_context );
     RAISE;
END;