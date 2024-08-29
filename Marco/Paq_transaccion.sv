
typedef enum  {lectura,escritura,reset  } tipo_trans;
// Transaccion: Transacciones que entran y salen de la fifo
class trans_fifo #(parameter width = 16);
    rand int retardo;
    rand bit [width-1:0] dato;
    int tiempo;
    rand tipo_trans tipo;
    int max_retardo;

    constraint const_retardo {
        retardo < max_retardo; 
        retardo > 0;
    }

    function new(int ret = 0, bit [width-1:0 dto=0] dto, int tmp = 0, tipo_trans tpo = lectura, int mx_rtrd = 10 );

        this.retardo = ret;
        this.dato = dto;
        this.tiempo = tmp;
        this.tipo = tpo;
        this.max_retardo = mx_rtrd;
    endfunction //new()

    function clean;
    this.retardo = 0;
    this.dato = 0;
    this.tiempo = 0;
    this.tipo = lectura;
    endfunction

    function void print (string tag = "");

        $$display("[%g] %s Tiempo = %g Tipo = %s Retardo = %g dato = 0x%h", $time,tag,tiempo, this.tipo, this.retardo, this.dato);
    endfunction
endclass //trans_fifo #(parameter width = 16)


//objeto de transaccion usado en el scoreboard

class trans_sb #(parameter width = 16);

    bit [width-1:0] dato_enviado;
    int tiempo_push;
    int tiempo_pop;
    bit completado;
    bit overflow; 
    bit underflow;
    bit reset; 
    int latencia; 

    function clean();
        this.dato_enviado = 0;
        this.tiempo_push = 0;
        this.tiempo_pop = 0;
        this.completado = 0;
        this.overflow = 0;
        this.underflow = 0;
        this.reset = 0;
        this.latencia = 0;
    endfunction

    task calc_latencia;
        this.latencia = this.tiempo_pop - this.tiempo_push;
    endtask

    function print (string tag);
        $display("[%g] %s dato=%h, t_push=%g, t_pop = %g, cmplt = %g, ovrflw = %g, undrflw = %g, rst = %g, ltncy = %g", 
        $time, 
        tag,
        this.dato_enviado,
        this.tiempo_push,
        this.tiempo_pop,
        this.completado,
        this.overflow,
        this.underflow,
        this.reset,
        this.latencia
        );
    endfunction
endclass

//Deffinicion de estructura para generar comandos hacia el scoreboard

typedef enum  {retardo_promedio, reporte  } solicitud_sb;

//Definicion de estructura para generar comandos hacia el agente

typedef enum  {llenado_aleatorio, trans_aleatoria, trans_especifica, sec_trans_aleatorias} instrucciones_agente;


//Definicion de mailboxes de tipo definifo trans_fifo para comunicar interfases.
typedef mailbox #(trans_fifo) trans_fifo_mbx;

typedef mailbox #(trans_sb) trans_sb_mbx;

typedef mailbox #(solicitud_sb) comando_test_sb_mbx;

typedef mailbox #(instrucciones_agente) comando_test_agent_mbx;

//Definicion de mailboxes de tipo definifo trans_fifo para comunicar interfases.

