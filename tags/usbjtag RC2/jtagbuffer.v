//--------------------------------------------------------------------------------------------------
//
// Title       : jtagbuffer
// Design      : jtagbuffer
// Author      : Igor Chudakov
// Company     : Home
//
//-------------------------------------------------------------------------------------------------
//
// File        : jtagbuffer.v
// Generated   : Fri Mar 24 21:48:17 2006
// From        : interface description file
// By          : Itf2Vhdl ver. 1.20
//
//-------------------------------------------------------------------------------------------------
//
// Description : Buffer for USB JTAG device that works with ARM processors.
//	Designed because different level adapters are hard to buy ;-)
//
//-------------------------------------------------------------------------------------------------
`timescale 1 ns / 100 ps

//{module {jtagbuffer}}
module jtagbuffer ( input SRST_N_OE_N ,SRST_N_OUT, TRST_N_OE_N ,TRST_N_OUT , 	// 3.3V
					input JTAG_OE_N ,TCK_OUT ,TMS_OUT ,TDI_OUT ,	// 3.3V
					output wire TDO_IN ,SRST_N_IN,					// 3.3V
					output wire VREF_LED, VREF_N_IN,Y_LED, 				// 3.3V
					output tri armTCK ,armTMS ,armTDI ,TRST_N ,				// External VREF
					input armTDO, VREF,								// External VREF
					inout tri SRST_N								// External VREF
					);				

   assign {armTCK, armTMS, armTDI} = (!JTAG_OE_N)? {TCK_OUT, TMS_OUT, TDI_OUT}: 3'bzzz;
   assign TDO_IN = armTDO;
   assign TRST_N = (!TRST_N_OE_N)? TRST_N_OUT: 1'bz;
   assign SRST_N = (!SRST_N_OE_N)? SRST_N_OUT: 1'bz;
   assign SRST_N_IN = (SRST_N === 1'bz)? 1'b1: SRST_N;
   assign Y_LED = (SRST_N === 1'bz)? 1'b1: SRST_N;
   assign VREF_LED = !VREF;
   assign VREF_N_IN = !VREF;

endmodule
