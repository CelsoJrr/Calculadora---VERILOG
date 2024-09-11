module bin2bcd(
  input [13:0] bin,
   output reg [15:0] bcd
   );
   
integer i;
	
always @(bin) begin
    bcd=0;		 	
    for (i=0;i<14;i=i+1) begin
    if (bcd[3:0] >= 5) bcd[3:0] = bcd[3:0] + 3;
	if (bcd[7:4] >= 5) bcd[7:4] = bcd[7:4] + 3;
	if (bcd[11:8] >= 5) bcd[11:8] = bcd[11:8] + 3;
	if (bcd[15:12] >= 5) bcd[15:12] = bcd[15:12] + 3;
	bcd = {bcd[14:0],bin[13-i]};
    end
end
endmodule


module BCDto7SEGMENT( a, b, c, d, e, f, g, D, C, B, A);
output a, b, c, d, e, f, g;
input D, C, B, A;
reg  [6:0] SeteSegmentos;
 
always @(*)
    begin
        case({D, C, B, A})
            4'b0000: SeteSegmentos = 7'b1111110;
            4'b0001: SeteSegmentos = 7'b0110000;
            4'b0010: SeteSegmentos = 7'b1101101;
            4'b0011: SeteSegmentos = 7'b1111001;
            4'b0100: SeteSegmentos = 7'b0110011;
            4'b0101: SeteSegmentos = 7'b1011011;
            4'b0110: SeteSegmentos = 7'b0011111;
            4'b0111: SeteSegmentos = 7'b1110000;
            4'b1000: SeteSegmentos = 7'b1111111;
            4'b1001: SeteSegmentos = 7'b1110011;
            default: SeteSegmentos = 7'b0000000;
        endcase
    end
assign {a, b, c, d, e, f, g} = SeteSegmentos;
endmodule

module Ula (a,b,mode,result, ledAlerta);
    input [3:0] a;      
    input [3:0] b;           
  	input [1:0] mode; 
  output reg [13:0]result; 
  output reg ledAlerta;

  always @(a or b or mode) begin
    ledAlerta = 1'b0;
        case (mode)
            2'b00: begin 
              //somar
              result = a + b; 
            end
            2'b01: begin
              //subtrair
              if ( a >= b)result = a - b ; 
              else begin
                ledAlerta = 1'b1;
                result =  b - a;
              end
            end
          	  //multiplicar
            2'b10: begin 
                result = a * b;
            end
          	2'b11: begin
              //dividir
              if(b != 0) begin
                result = a / b;            
                end else begin 
                  ledAlerta = 1'b1;
                  result = 0; 
                end 
            end 
        endcase
  end
endmodule


module FSM(clock, switch_00, switch_01, switch_02, switch_03, switch_10, switch_11, switch_12, switch_13, btn_reset, btn_modo, btn_res,
led_alerta, led_modo0, led_modo1, led_modo2, led_modo3, 
display00, display01, display02, display03, display10, display11, display20, display21);

// Inputs e outputs
input clock, switch_00, switch_01, switch_02, switch_03, switch_10, switch_11, switch_12, switch_13, btn_reset, btn_modo, btn_res;
output led_alerta, led_modo0, led_modo1, led_modo2, led_modo3;
output [6:0] display00, display01, display02, display03, display10, display11, display20, display21;

// Valores a manter na FSM
reg EstadoAtual, EstadoFuturo;
reg [13:0] input1;
reg [13:0] input2;
reg [1:0] modoAtual;
reg [1:0] modoFuturo;
wire [13:0] resultado;
wire [15:0] bcd_res;
wire [15:0] bcd_input1;
wire [15:0] bcd_input2;
reg [6:0] di00, di01, di02, di03;
reg [6:0] di10, di11;
reg [6:0] di20, di21;
reg [6:0] difuturo00, difuturo01, difuturo02, difuturo03;
wire [6:0] res00, res01, res02, res03;
wire [6:0] res10, res11;
wire [6:0] res20, res21;
reg ledAlertaFuturo, ledAlertaAtual;
reg pressionado;
wire ledAlertaUla;


// Resultado
  BCDto7SEGMENT result1(res00[6], res00[5], res00[4], res00[3], res00[2], res00[1], res00[0], bcd_res[3],bcd_res[2], bcd_res[1], bcd_res[0]);  
  BCDto7SEGMENT result2(res01[6], res01[5], res01[4], res01[3], res01[2], res01[1], res01[0], bcd_res[7],bcd_res[6], bcd_res[5], bcd_res[4]);   
  BCDto7SEGMENT result3(res02[6], res02[5], res02[4], res02[3], res02[2], res02[1], res02[0], bcd_res[11],bcd_res[10], bcd_res[9], bcd_res[8]);
  BCDto7SEGMENT result4(res03[6], res03[5], res03[4], res03[3], res03[2], res03[1], res03[0], bcd_res[15],bcd_res[14], bcd_res[13], bcd_res[12]);
// Primeiro número
  BCDto7SEGMENT number1_1(res10[6], res10[5], res10[4], res10[3], res10[2], res10[1], res10[0], bcd_input1[3],bcd_input1[2], bcd_input1[1], bcd_input1[0]);
  BCDto7SEGMENT number1_2(res11[6], res11[5], res11[4], res11[3], res11[2], res11[1], res11[0], bcd_input1[7],bcd_input1[6], bcd_input1[5], bcd_input1[4]);  
// Segundo núm
  BCDto7SEGMENT number2_1(res20[6], res20[5], res20[4], res20[3], res20[2], res20[1], res20[0], bcd_input2[3],bcd_input2[2], bcd_input2[1], bcd_input2[0]);
  BCDto7SEGMENT number2_2(res21[6], res21[5], res21[4], res21[3], res21[2], res21[1], res21[0], bcd_input2[7],bcd_input2[6], bcd_input2[5], bcd_input2[4]);

// Módulos
Ula ula(input1, input2, modoAtual, resultado, ledAlertaUla);
bin2bcd number1(input1, bcd_input1);
bin2bcd number2(input2, bcd_input2);
bin2bcd resultDisplay(resultado, bcd_res); 

// Parâmetros de estado
parameter
    EscolhendoModo = 1'b0,
    MostraResultado = 1'b1;

  always @(posedge clock)
begin
    atualizaEventos;
  if(~btn_reset)
	begin
        modoAtual <= 2'b00;
        EstadoAtual <= EscolhendoModo;
        limpaVisor;
	end
    else
    begin
        modoAtual <= modoFuturo;
        EstadoAtual <= EstadoFuturo;
        atualizaVisor;
    end
end
// Display num 1
assign display10 = di10;
assign display11 = di11;
//Display num 2
assign display20 = di20;
assign display21 = di21;
// Display resultado
assign display00 = di00;
assign display01 = di01;
assign display02 = di02;
assign display03 = di03; 

  
  
// LEDs de modo
assign led_modo3 = modoAtual >= 2'b11;
assign led_modo2 = modoAtual >= 2'b10;
assign led_modo1 = modoAtual >= 2'b01;
assign led_modo0 = 1'b1; // Sempre ligado

// LED de alerta
assign led_alerta = ledAlertaAtual;

  
// Ação do usuário - botão de modo ou de resultado
  always @(EstadoAtual or ~btn_modo or ~btn_res)
begin
    EstadoFuturo = EscolhendoModo;
    zeraDisplayFuturo;
    ledAlertaFuturo = 1'b0;

    case (EstadoAtual)

      EscolhendoModo: case({~btn_modo, ~btn_res})
        2'b00:
            begin
                EstadoFuturo = EstadoAtual;
                ledAlertaFuturo = ledAlertaAtual;
                mantemDisplayFuturo;
            end
        2'b01:
            begin
                EstadoFuturo = MostraResultado;
                ledAlertaFuturo = ledAlertaUla;
                aplicaDisplayFuturo;
            end
        2'b10:
            begin
                EstadoFuturo = EscolhendoModo;
            end
        default:
            begin
                EstadoFuturo = EstadoAtual;
                ledAlertaFuturo = ledAlertaAtual;
                mantemDisplayFuturo;
            end
        endcase

      MostraResultado: case({~btn_modo, ~btn_res})
        2'b00:
            begin
                EstadoFuturo = EstadoAtual;
                ledAlertaFuturo = ledAlertaAtual;
                mantemDisplayFuturo;
            end
        2'b01:
            begin
                EstadoFuturo = MostraResultado;
                ledAlertaFuturo = ledAlertaUla;
                aplicaDisplayFuturo;
            end
        2'b10:
            begin
                EstadoFuturo = MostraResultado;
            end
        default:
            begin
                EstadoFuturo = EstadoAtual;
                ledAlertaFuturo = ledAlertaAtual;
                mantemDisplayFuturo;
            end
        endcase
	endcase
end
// Ajuste do contador de modo
always @(EstadoAtual or !btn_modo)
begin
	modoFuturo = modoAtual;
	if(!btn_modo && !pressionado)
		modoFuturo = modoAtual == 2'b11 ? 2'b00 : modoAtual + 1;
	pressionado = !btn_modo;
end

// Zerar o display para o bloco always dos modos
task zeraDisplayFuturo;
begin
    difuturo00 = 7'b0;
    difuturo01 = 7'b0;
    difuturo02 = 7'b0;
    difuturo03 = 7'b0;
end
endtask

// Atualiza o resultado
task aplicaDisplayFuturo;
begin
    difuturo00 = res00;
    difuturo01 = res01;
    difuturo02 = res02;
    difuturo03 = res03;
end
endtask

// Mantém o resultado atual
task mantemDisplayFuturo;
begin
    difuturo00 = di00;
    difuturo01 = di01;
    difuturo02 = di02;
    difuturo03 = di03;
end
endtask

// Atualiza n1 e n2
task atualizaEventos;
begin
    input1 <= {switch_03, switch_02, switch_01, switch_00};
    input2 <= {switch_13, switch_12, switch_11, switch_10};
    di10 <= res10;
    di11 <= res11;
    di20 <= res20;
    di21 <= res21;
	ledAlertaAtual <= ledAlertaFuturo;
 
end
endtask

// Atualiza o visor na borda de clock
task atualizaVisor;
begin
    di00 <= difuturo00;
    di01 <= difuturo01;
    di02 <= difuturo02;
    di03 <= difuturo03;
end
endtask

// Limpa o visor (reset)
task limpaVisor;
begin
    di00 <= 7'b0;
    di01 <= 7'b0;
    di02 <= 7'b0;
    di03 <= 7'b0;
end
endtask
endmodule