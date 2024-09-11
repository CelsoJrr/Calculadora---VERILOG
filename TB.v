module testb;  
  reg clock,switch_00, switch_01, switch_02, switch_03, switch_10, switch_11, switch_12, switch_13, btn_reset, btn_modo, btn_res;
  wire led_alerta, led_modo0, led_modo1, led_modo2, led_modo3;
  wire [6:0] display00, display01, display02, display03, display10, display11, display20, display21;
  
  FSM fsm(clock, switch_00, switch_01, switch_02, switch_03, switch_10, switch_11, switch_12, switch_13, btn_reset, btn_modo, btn_res,
led_alerta, led_modo0, led_modo1, led_modo2, led_modo3,display00, display01, display02, display03, display10, display11, display20, display21);
  
 always #10 clock <= ~clock;
  
  
  initial begin  
    clock = 0;
  	btn_reset = 0;
    btn_modo = 1;
    btn_res=1;
    {switch_03,switch_02,switch_01,switch_00} = 4'b0000; {switch_13,switch_12, switch_11, switch_10} = 4'b0000;
    #50 btn_reset = 1;
    
    $monitor("monitor   time=%0d , LED ALERTA = %b ,RESULTADO: display4= %b  display3= %b   display2= %b display1=%b  / NUMERO 1:display2=%b display1=%b /NUMERO 2: display2=%b display1=%b" , $time, led_alerta,display03, display02, display01, display00, display11, display10, display21, display20);

   //adição 
    {switch_03,switch_02,switch_01,switch_00} = 4'b1100; {switch_13,switch_12, switch_11, switch_10} = 4'b0100;
  
    #50 btn_res=0;
    #50 btn_res = 1;
    #50 btn_modo = 0;
    #50 btn_modo = 1;
    //subtração
     {switch_03,switch_02,switch_01,switch_00} = 4'b1100; {switch_13,switch_12, switch_11, switch_10} = 4'b0100;
    #50 btn_res = 0;
    #50 btn_res = 1;
    #50 btn_modo = 0;
    #50 btn_modo = 1;
    //multiplicação
     {switch_03,switch_02,switch_01,switch_00} = 4'b1100; {switch_13,switch_12, switch_11, switch_10} = 4'b0100;
  	#50 btn_res = 0;
    #50 btn_res = 1;
    
    //divisão
    #50 btn_modo = 0;
    #50 btn_modo = 1;
     {switch_03,switch_02,switch_01,switch_00} = 4'b1100; {switch_13,switch_12, switch_11, switch_10} = 4'b0100;
    #50 btn_res = 0; 
    #50 btn_res = 1;
     
    {switch_03,switch_02,switch_01,switch_00} = 4'b1100; {switch_13,switch_12, switch_11, switch_10} = 4'b0101;
    #50 btn_res = 0; 
    #50 btn_res = 1;
 
   
   
    {switch_03,switch_02,switch_01,switch_00} = 4'b1100; {switch_13,switch_12, switch_11, switch_10} = 4'b0110;
    #50 btn_res = 0; 
    #50 btn_res = 1;
    
    {switch_03,switch_02,switch_01,switch_00} = 4'b1110; {switch_13,switch_12, switch_11, switch_10} = 4'b0110;
    #50 btn_res = 0; 
    #50 btn_res = 1;
    
    //adição 
     #50 btn_modo = 0;
    #50 btn_modo = 1;
    {switch_03,switch_02,switch_01,switch_00} = 4'b1110; {switch_13,switch_12, switch_11, switch_10} = 4'b0110;
  
    #50 btn_res=0;
    #50 btn_res = 1;
    
     //subtração
     #50 btn_modo = 0;
    #50 btn_modo = 1;
    {switch_03,switch_02,switch_01,switch_00} = 4'b1110; {switch_13,switch_12, switch_11, switch_10} = 4'b0110; 
    #50 btn_res=0;
    #50 btn_res = 1; 
    {switch_03,switch_02,switch_01,switch_00} = 4'b0110; {switch_13,switch_12, switch_11, switch_10} = 4'b1110;
    #50 btn_res=0;
    #50 btn_res = 1; 
    {switch_03,switch_02,switch_01,switch_00} = 4'b0110; {switch_13,switch_12, switch_11, switch_10} = 4'b0110;
    #50 btn_res=0;
    #50 btn_res = 1;
    //// Colocando result 2 vezes
     #50 btn_res=0;
    #50 btn_res = 1;  
    //reset
	#50 btn_reset=0;
    #50 btn_reset=1;
    //mudar modo
    #50 btn_modo = 0;
    #50 btn_modo = 1;
    #50 btn_modo = 0;
    #50 btn_modo = 1;
    #50 btn_modo = 0;
    #50 btn_modo = 1;
    {switch_03,switch_02,switch_01,switch_00} = 4'b0010; {switch_13,switch_12, switch_11, switch_10} = 4'b0010;
    #50
    {switch_03,switch_02,switch_01,switch_00} = 4'b0010; {switch_13,switch_12, switch_11, switch_10} = 4'b0010;
    #50
    {switch_03,switch_02,switch_01,switch_00} = 4'b0010; {switch_13,switch_12, switch_11, switch_10} = 4'b0000;
    #50 btn_res=0;
    #50 btn_res = 1;  
   
    
       #10 $finish;
    end
endmodule