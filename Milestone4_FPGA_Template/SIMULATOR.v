`define SCREEN_WIDTH 176
`define SCREEN_HEIGHT 144
`define STRIDE 180
`define FRAME_LENGTH 2400000 // 0 VSYNC low, 1-2 VSYNC high, 3 VSYNC low, then start at 4, each row with 176*2 valid data bytes while HREF high, then 8 cycles while HREF low

module SIMULATOR(
  CLK,
  VSYNC,
  HREF,
  DATA
);

input CLK;
output reg VSYNC;
output reg HREF;
output reg [7:0] DATA;

reg [15:0] counter = 0;

//Testing some patterns
//wire [15:0] RED =    16'b1111100000000000;
//wire [15:0] GREEN =  16'b0000011111100000;
//wire [15:0] BLUE =   16'b0000000000011111;
wire [15:0] RED =    16'b0000111100000000;//444 red
wire [15:0] GREEN =  16'b0000000011110000;//444 green
wire [15:0] BLUE =   16'b0000000000001111;//444 blue

wire [15:0] YELLOW = RED | GREEN;
wire [15:0] CYAN =   GREEN | BLUE;
wire [15:0] MAGENTA = RED | BLUE;
wire [15:0] WHITE = 16'b1111111111111111;
wire [15:0] BLACK = 0;
reg [15:0] COLOR;
reg [7:0] x = 0;
reg [7:0] y = 0;

always @ (negedge CLK) begin
  if (counter == `FRAME_LENGTH) begin
    // end of frame
    counter <= 0;
    HREF <= 0;
    VSYNC <= 0;
    DATA <= 0;
    //reset addr
	 x <= 0;
    y <= 0;
  end
  else begin
    if (counter > 0 && counter < 3) begin
      // VSYNC high at the beginning
      counter <= counter + 1;
      HREF <= 0;
      VSYNC <= 1;
      DATA <= 0;
    end
    else begin
      if (counter == 0 || counter == 3) begin
        // right before and after VSYNC high
        counter <= counter + 1;
        HREF <= 0;
        VSYNC <= 0;
        DATA <= 0;
      end
      else begin
        if (((counter-4) % (2*`STRIDE)) < 2*`SCREEN_WIDTH) begin
			 if (((counter-4) % (2*`STRIDE)) == 2*`SCREEN_WIDTH-1) begin
				y <= y + 1;
			 end
          if ((counter % 2) == 0) begin
            //part1
            counter <= counter + 1;
            HREF <= 1;
            VSYNC <= 0;
				DATA = COLOR[15:8];
          end
          else begin
            //part2
            counter <= counter + 1;
            HREF <= 1;
            VSYNC <= 0;
				x <= x + 1;//move?
				DATA = COLOR[7:0];
          end
        end
        else begin
			 // in between rows
		    counter <= counter + 1;
			 HREF <= 0;
			 VSYNC <= 0;
			 DATA <= 0;
			 x <= 0;
        end
      end
    end
  end
end

//draw patterns here
always @ (posedge CLK) begin
	if ( ((x-88)**2+(y-72)**2)<2500 ) begin
		COLOR <= YELLOW;
	end
	else begin
		COLOR <= CYAN;
	end
//	if (x % 5 == 0) begin
//		COLOR <= RED;
//	end
//	else
//	begin
//		COLOR <= BLUE;
//	end
//  if (x < 20)
//  begin
//    COLOR <= RED;
//  end
//  if (x < 40 && x > 19)
//  begin
//    COLOR <= GREEN;
//  end
//  if (x < 60 && x > 39)
//  begin
//    COLOR <= BLUE;
//  end
//  if (x < 80 && x > 59)
//  begin
//    COLOR <= YELLOW;
//  end
//  if (x < 100 && x > 79)
//  begin
//    COLOR <= CYAN;
//  end
//  if (x < 120 && x > 99)
//  begin
//    COLOR <= MAGENTA;
//  end
//  if (x < 140 && x > 119)
//  begin
//    COLOR <= WHITE;
//  end
//  if (x < 176 && x > 139)
//  begin
//    COLOR <= BLACK;
//  end

end

endmodule
