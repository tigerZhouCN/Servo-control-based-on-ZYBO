`timescale 1ns / 1ps
	
	//  Servo Control Program Based on ZYBO Development Board
	//  2017/5/11
	//  Control item: speed--  reg[3:0] speed  -- 1<=speed<=15
	//                initial jiaodu --  reg[14:0] jiaodu_ini  500<=jiaodu_ini<=2500   0°<=jiaodu<=x°  (x°--180° or 300°)
	//                servo jiaodu max-- reg[14:0] jiaodu_max   jiaodu_max<=2500    jiaodu<=x°   (x°--180° or 300°)
	//				  servo jiaodu min-- reg[14:0] jiaodu_min   jiaodu_min>=500     jiaodu>=0°
	
	module moter(
	        input clk,
	        input [1:0] swt,
			input reg[3:0] speed,
			input reg[14:0] jiaodu_ini,
			input reg[14:0] jiaodu_max,
			input reg[14:0] jiaodu_min,
	        output reg[14:0]  jiaodu,  //ILA real time monitoring jiaodu
	        output pwm1
	    );
	        reg pwm1;  
	        reg[32:0] counter; 
	        reg[32:0] counter1;
	   //     reg[32:0] counter2;
	       //(* MARKDEBUG = "TRUE" *) 
	      //  reg[7:0]  jiaodu;
	//        parameter jiaodu_0 = 8'd5;    //0°
	//        parameter jiaodu_ini = 8'd15;  //  180°/2 或 300°/2
	      
	        initial            //initial jiaodu 
	          jiaodu = jiaodu_ini;  
	        always@(posedge clk)
	          begin
	                  counter = counter + 1 ;   
	                  if(counter == 32'd125)   
	                  //  125MHz  0.001ms    
	                    begin
	                      counter = 0;
	                      counter1= counter1 + 1;    
	                    end   //generate  a 0.01ms 's clk
	                  if(counter1 == 8'd1)
	                      pwm1  <= 1;                       
	                  else if(counter1 == jiaodu)     
	                      pwm1 <= 0;    
	                  else if (counter1 == 16'd20000)
	                     begin
	                      counter1 = 0;
	                      case(swt)    //  control by  pwm jiaodu                        
	                             2'd01:                  //  jiaodu +
	                               begin
	                                if(jiaodu < jiaodu_max)
	                                    jiaodu = jiaodu + speed;
	                                else if(jiaodu >= jiaodu_max)
	                                    jiaodu = jiaodu_max;
	                               end
	                             2'd10:               //  jiaodu -
	                               begin
	                               if(jiaodu > jiaodu_min)
	                                    jiaodu = jiaodu - speed;
	                               else if(jiaodu <= jiaodu_min)
	                                    jiaodu = jiaodu_min;
	                               end
	                             default: jiaodu = jiaodu;
	                      endcase
	                  //    jiaodu = jiaodu_reg;
	                     end
	                      
	             end     
	                  
	endmodule
