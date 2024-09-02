class agent #(parameter width = 16, parameter depth = 8);
    trans_fifo_mbx agnt_drv_mbx;
    comando_test_agent_mbx test_agent_mbx;
    int num_transacciones; 
    int max_retardo;
    int ret_spec;
    tipo_trans tpo_spec;
    bit [width-1:0] dto_spec;
    instrucciones_agente instruccion;
    trans_fifo #(.width(width)) transaccion;

    function new;
        num_transacciones = 2;
        max_retardo = 10;
    endfunction

    task run;
        $display("[%g] EL agente fue inicializado", $time);
        forever begin
            #1
            if(test_agent_mbx.num() > 0) begin
                $display("[%g] Agente: Se recibe instruccion", $time);
                test_agent_mbx.get (instruccion);
                case (instruccion)
                    llenado_aleatorio: begin //lo llena y lo lee todo 
                        for(int i=0; i < num_transacciones; i++) begin
                            transaccion = new;  
                            transaccion.max_retardo = max_retardo;
                            transaccion.randomize(); //preguntar si sobreescribe Max_retardo o si solo randomiza todas las que no llame acá.
                            tpo_spec = escritura;    
                            transaccion.tipo = tpo_spec;
                            transaccion.print("Agente: transaccion creada");
                            agnt_drv_mbx.put(transaccion);
                        end

                        for(int i=0; i < num_transacciones; i++)begin
                            transaccion = new;  
                            transaccion.max_retardo = max_retardo;
                            transaccion.randomize(); //preguntar si sobreescribe Max_retardo o si solo randomiza todas las que no llame acá.
                            tpo_spec = lectura;    
                            transaccion.tipo = tpo_spec;
                            transaccion.print("Agente: transaccion creada");
                            agnt_drv_mbx.put(transaccion);
                        end
                    end

                    trans_aleatoria: begin
                        transaccion = new;
                        transaccion.max_retardo = max_retardo;
                        transaccion.randomize();
                        transaccion.print ("Agente: transaccion creada");
                        agnt_drv_mbx.put(transaccion);
                    end

                    trans_especifica: begin //preguntar que valores se le dan al tpo_spec y dto_pec y ret_spec
                        transaccion = new;
                        transaccion.tipo = tpo_spec;
                        transaccion.dato = dto_spec;
                        transaccion.retardo = ret_spec;
                        transaccion.print("Agente: transaccion creada");
                        agnt_drv_mbx.put(transaccion);
                    end

                    sec_trans_aleatorias: begin
                        for(int i = 0; i < num_transacciones; i++)begin
                            transaccion = new;
                            transaccion.max_retardo = max_retardo;
                            transaccion.randomize();
                            transaccion.print("Agente: transaccion creada");
                            agnt_drv_mbx.put(transaccion);
                        end
                    end
                endcase  
            end
        end
    endtask
endclass