

/********************************************************************************************

Copyright 2011-2012 - Maven Silicon Softech Pvt Ltd. All Rights Reserved.

This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
It is considered a trade secret and is not to be divulged or used by parties who 
have not received written authorization from Maven Silicon Softech Pvt Ltd.

Maven Silicon Softech Pvt Ltd
Bangalore - 560076

Webpage: www.maven-silicon.com

Filename:	definitions.v   

Description:	This file has definitions of the MACROS 

Date:		27/03/2013

Author:		Susmita Nayak

Email:		siva@maven-silicon.com
		siva@aceic.com

Version:	2.0

*********************************************************************************************/

`define SLAVES 4
`ifdef  WRAPPING_INCR
   `define BEAT_4_WRAP 2
   `define BEAT_8_WRAP 4
   `define BEAT_16_WRAP 6
   `define BEAT_4_INCR 3
   `define BEAT_8_INCR 5
   `define BEAT_16_INCR 7
`endif
`define WIDTH_32
//`define WIDTH_64
//`define WIDTH_128
//`define WIDTH_256
//`define WIDTH_512
//`define WIDTH_1024

`ifdef WIDTH_32
	`define WIDTH 32
`endif

`ifdef WIDTH_64
	`define WIDTH 64
`endif

`ifdef WIDTH_128
	`define WIDTH 128
`endif

`ifdef WIDTH_256
	`define WIDTH 256
`endif

`ifdef WIDTH_512
	`define WIDTH 512
`endif

`ifdef WIDTH_1024
	`define WIDTH 1024
`endif

`define ADDR_OFFSET_WORD 0
`define ADDR_OFFSET_HFWORD_0 0
`define ADDR_OFFSET_HFWORD_2 2
`define ADDR_OFFSET_BYTE_0 0
`define ADDR_OFFSET_BYTE_1 1
`define ADDR_OFFSET_BYTE_2 2
`define ADDR_OFFSET_BYTE_3 3
