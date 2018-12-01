`define y_min 32
`define y_mid 72
`define y_max 112
`define x_min 48
`define x_mid 88
`define x_max 128

module CONTROL_UNIT (
  CLK,
  HREF,
  VSYNC,
  input_data,
  output_data,
  X_ADDR,
  Y_ADDR,
  w_en,
  part1,
  part2
);

input CLK;
input [7:0] input_data;
input HREF;
input VSYNC;

output reg [14:0] X_ADDR;
output reg [14:0] Y_ADDR;
output reg w_en;
output [7:0] output_data;//wire!

reg write = 0;
output reg [7:0] part1;
output reg [7:0] part2;

wire [7:0] RED =    8'b11100000;
wire [7:0] GREEN =  8'b00011100;
wire [7:0] BLUE =   8'b00000011;
wire [7:0] YELLOW = RED | GREEN;
wire [7:0] CYAN =   GREEN | BLUE;
wire [7:0] MAGENTA = RED | BLUE;
wire [7:0] WHITE = 8'b11111111;
wire [7:0] BLACK = 0;

//always @ (posedge CLK) begin
//	w_en = 1;
//	if (X_ADDR == 175 && Y_ADDR == 143) begin
//		X_ADDR <= 0;
//		Y_ADDR <= 0;
//	end
//	else begin
//		if (X_ADDR == 175) begin
//			X_ADDR <= 0;
//			Y_ADDR <= Y_ADDR + 1;
//		end
//		else begin
//			X_ADDR <= X_ADDR + 1;
//		end
//	end
//end

//always @ (*) begin
// old triangle
//	if ( Y_ADDR < 100 && Y_ADDR>2*X_ADDR-50 && Y_ADDR > 160-2*X_ADDR) begin
//		output_data <= BLACK;
//	end
//	else begin
//		output_data <= WHITE;
//	end

	////triangle
//   if ( Y_ADDR > `y_min && Y_ADDR < `y_max && X_ADDR > `x_mid - (Y_ADDR - `y_min)*4/7 && X_ADDR < `x_mid + (Y_ADDR - `y_min)*4/7) begin
//		output_data <= BLACK;
//	end
//	else begin
//		output_data <= WHITE;
//	end
//////square
//	if ( Y_ADDR > `y_min && Y_ADDR < `y_max && X_ADDR > `x_min && X_ADDR < `x_max) begin
//		output_data <= BLACK;
//	end
//	else begin
//		output_data <= WHITE;
//	end

////diamond
//  if (
//( Y_ADDR > `y_min && Y_ADDR < `y_mid && X_ADDR > `x_mid - (Y_ADDR - `y_min) && X_ADDR < `x_mid + (Y_ADDR - `y_min)) 
//|| ( Y_ADDR >= `y_mid && Y_ADDR < `y_max && X_ADDR > `x_mid - (`y_max - Y_ADDR) && X_ADDR < `x_mid + (`y_max - Y_ADDR )) 
//)
//
//	begin
//		output_data <= RED;
//	end
//	else begin
//		output_data <= WHITE;
//	end
//
//end

//camera control unit
always @ (posedge CLK) begin
  if (HREF)
  begin
    if (write == 0)
    begin
	  w_en = 0;
      part1 = input_data;
	   write = 1;
    end
    else
	 begin
      part2 = input_data;
	   write = 0;
	   w_en = 1;
		X_ADDR = X_ADDR+1;
    end
  end
  else
  begin
    w_en = 0;
	 write = 0;
	 X_ADDR = 0;
  end
end

always @ (posedge VSYNC, negedge HREF) begin
	if (VSYNC) begin
		Y_ADDR <= 0;
	end
	else
	begin
		Y_ADDR <= Y_ADDR + 1;
	end
end


DOWNSAMPLE downsampler(
  .RGB565({part1,part2}),
  .RGB332(output_data)
);

  
endmodule
