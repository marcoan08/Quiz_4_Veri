class test #(parameter width = 16, parameter depth = 8);
    comando_test_sb_mbx test_sb_mbx;
    comando_test_agent_mbx test_agent_mbx;

    parameter num_transacciones = 10;
    parameter max_retardo = 4;
    solicitud_sb orden;
    instrucciones_agente instr_agent;
    solicitud_sb instr_sb;

    //definicion del ambiente de prueba
    ambiente #(.width(width), .depth(depth)) ambiente_inst;

    //definicion de laa interface a la que se conecta el DUT
    virtual fifo_if #(.width(width)) _if;

    function new;
        test_sb_mbx = new();
        test_agent_mbx = new();

        //definicion y conexion del driver

        ambiente_inst = new();
        ambiente_inst._if = _if;
        ambiente_inst.test_sb_mbx = test_sb_mbx;
        ambiente_inst.scoreboard_inst.test_sb_mbx = test_sb_mbx;
        ambiente_inst.test_agent_mbx = test_agent_mbx;
        ambiente_inst.agent_inst.test_agent_mbx = test_agent_mbx;
        ambiente_inst.agent_inst.num_transacciones = num_transacciones;
        ambiente_inst.agent_inst.max_retardo = max_retardo;
    endfunction
    task run;
        $display("[%g] El test fue inicializado",$time);
        fork
            ambiente_inst.run;
        join_none

        instr_agent = llenado_aleatorio;
        test_agent_mbx.put(instr_agent);
        $display ("[%g] Test: Enviada la primera instruccion al agente llenado aleatorio con num_transacciones %g",$time, num_transacciones);

        instr_agent = trans_aleatoria;
        test_agent_mbx.put(instr_agent);
        $display ("[%g] Test: Enviada la segunda instruccion al agente transaccion aleatoria ",$time);

        ambiente_inst.agent_inst.ret_spec = 3;
        ambiente_inst.agent_inst.tpo_spec = escritura;
        ambiente_inst.agent_inst.dto_spec = {width/4{4'h5}};
        instr_agent = trans_especifica;
        test_agent_mbx.put(instr_agent);
        $display("[%g] Test: Enviada la tercera instruccion al agente transaccion especifica",$time);

        instr_agent = sec_trans_aleatorias;
        test_agent_mbx.put(instr_agent);
        $display ("[%g] Test: Enviada la cuarta instruccion al agente secuencia de transacciones aleatorias con num_transacciones %g",$time, num_transacciones);

        #40000  
        $display("[%g] Test: Se alcanza el tiempo limite de la prueba",$time);
        instr_sb = retardo_promedio;
        test_sb_mbx.put(instr_sb);
        instr_sb = reporte;
        test_sb_mbx.put(instr_sb);
        #20
        $finish;
    endtask
endclass