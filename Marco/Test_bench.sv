`timescale 1ns/1ps
`include "fifo.sv"
`include "Paq_transaccion.sv"
`include "Driver.sv"
`include "Checker.sv"
`include "Score_Board.sv"
`include "Agente.sv"
`include "Ambiente.sv"
`include "Test.sv"

//Modulo para correr la prueba

module test_bench;
    reg clk;
    parameter width = 16;
    parameter depth = 8;
    Test #(.depth(depth), .width(width)) t0;

    fifo_if #(.width(width)) _if(.clk(clk));
    always #5 clk = ~clk;

    fifo_flops #(.depth(depth), .bits(width)) uut(

        .Din(_if.dato_in),
        .Dout(_if.dato_out),
        .push(_if.push),
        .pop(_if.pop),
        .clk(_if.clk);
        .full(_if.full);
        .pndng(_if.pndng),
        .rst(_if.rst)
    );

    initial begin
        clk = 0;
        t0 = new();
        to._if = _if;
        to.ambiente_inst.driver_inst.vif = _if;
        fork
            t0.run();
        join_none
    end   
    always@(posedge clk) begin
        if ($time > 100000)begin
            $display("Test_bench: Tiempo límite de prueba en el testbench alcanzado");
            $finish;
        end
    end
endmodule