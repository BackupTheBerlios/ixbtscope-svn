// защелка на 8 бит
module JTAGcore  #(parameter Idle=0, RD_Active=1, WR_Active=2)
				 ( input RESET, CLK,        // сброс, тактирование EPM3064
				  input N_TXE, N_RXF,  		// FT245 готов прин€ть/передать данные
  				  inout [7:0]d,        		// Ўина данных между EPM3064 и FT245
				  output wire GREEN_LED, RED_LED, 	// светодиоды
				
				// JTAG наружу 
				  input CDONE, DATAOUT,
				  output JTCK, N_CONF, N_CS, N_CE, ASDI,    // выходы JTAG/Config
				  
				  output N_RD,      // управление FT245
				  output reg WR	
                  );


  
  reg[7:0] From_FT245;	// –егистр защелка данный от FT245 
  wire [7:0] ft245_d;

// внутренние сигналы дл€ приведени€ сигналов к положительной логике
  wire RXF, TXE;	
  reg RD;
  reg tmp;
  reg[1:0] RD_SM;	// State Machine прием данных от FT245

assign GREEN_LED=From_FT245[6];
assign RED_LED  =From_FT245[7];

assign JTCK     =From_FT245[0];
assign N_CONF   =From_FT245[1];
assign N_CE     =From_FT245[2];
assign N_CS     =From_FT245[3];
assign ASDI     =From_FT245[4];

assign RXF = ~ N_RXF;	// ѕриведем вход к положительной логике
assign TXE = ~ N_TXE;	// ѕриведем вход к положительной логике 
assign N_RD = ~ RD;		// ѕриведем выход к положительной логике 	

// ¬ыдаем данные из внутреннего регистра
assign d = WR ? {From_FT245[7:2],CDONE,DATAOUT} : 8'bZ ;

//assign data<=d;
//assign outp  = bidir;

 assign ft245_d = RD? d: From_FT245;

// ѕрием данных от FT245
// –абота машины состо€ни€ переходы

always@(posedge CLK or negedge RESET)
	begin
	 	if (!RESET) 
		  begin
		   RD_SM <= Idle;
		   RD  	 <= 1'b0;
		   WR  	 <= 1'b0;	
		   tmp 	 <= 1'b0;
		   From_FT245 <= 8'h0;
		  end
	   else
		begin 
		  From_FT245 <= ft245_d;
		   case(RD_SM)
		    Idle: if (tmp)  // в первую очередь отдаем данные в FT245
				     begin
				      if (TXE)		 // √отов ли ѕрин€ть данные FT245?
				       begin
				        RD_SM=WR_Active;
				        WR <= 1;
				        RD <= 0; 
					    tmp<= 0;
					   end
					 end
				  else if (RXF)   // во вторую очередь принимаем данные от FT245
					 begin
					  RD_SM<=RD_Active;
					  WR <= 0;
					  RD <= 1;
					  tmp<= 1;
					 end
			
		    RD_Active:
				     begin
				      RD_SM<=Idle;
				      WR<=0;
				      RD<=0; 
				     end

			WR_Active:
					 begin
				      RD_SM<=Idle;
				      WR<=0;
				      RD<=0;
				      tmp<=0; 
				     end

		    default:
				      begin
				      RD_SM<=Idle;
				      WR<=0;
				      RD<=0;
				      tmp<=0;
				     end
		   endcase 
	  end
	end //always@(posedge CLK or posedge RESET)

endmodule

