class ambiente #(parameter width = 16, parameter depth = 8);

    //declaracion de los componentes del ambiente

    driver #(.width(width)) driver_inst;
    checker1 #(.width(width),.depth(depth)) checker1_inst;
    score_board #(.width(width)) scoreboard_inst;
    agent #(.width(width),.depth(depth)) agent_inst;
    //declaro la interfase virtual que contecta el DUT

    virtual fifo_if #(.width(width)) _if;

    //declaracion de mailboxes que se tienen en los elementos pasados 

    trans_fifo_mbx agnt_drv_mbx;
    trans_fifo_mbx drv_chkr_mbx; 
    trans_sb_mbx chkr_sb_mbx;
    comando_test_agent_mbx test_sb_mbx;
    comando_test_agent_mbx test_agent_mbx;

    function new();
        //crea los mailbox
        drv_chkr_mbx = new();
        agnt_drv_mbx = new();
        chkr_sb_mbx = new();
        test_sb_mbx = new ();
        test_agent_mbx = new();

        //crea las instancias de cada parte del ambiente
        driver_inst = new();
        checker1_inst = new();
        scoreboard_inst = new();
        agent_inst = new();

        //conecta los maiboxes

        driver_inst.vif = _if;
        driver_inst.drv_chkr_mbx = drv_chkr_mbx;
        driver_inst.agnt_drv_mbx = agnt_drv_mbx;
        checker1_inst.drv_chkr_mbx = drv_chkr_mbx;
        checker1_inst.chkr_sb_mbx = chkr_sb_mbx;
        scoreboard_inst.chkr_sb_mbx = chkr_sb_mbx;
        scoreboard_inst.test_sb_mbx = test_sb_mbx;
        agent_inst.test_agent_mbx = test_agent_mbx;
        agent_inst.agnt_drv_mbx =agnt_drv_mbx;
    endfunction

    virtual task run();
        $display("[%g] El ambiente fue inicializado");
        fork
            driver_inst.run();
            checker1_inst.run();
            scoreboard_inst.run();
            agent_inst.run();
        join_none
    endtask
endclass
