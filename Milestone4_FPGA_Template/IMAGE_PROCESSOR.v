`define SCREEN_WIDTH 176
`define SCREEN_HEIGHT 144
`define NUM_BARS 3
`define BAR_HEIGHT 48

module IMAGE_PROCESSOR (
	PIXEL_IN,
	CLK,
	VGA_PIXEL_X,
	VGA_PIXEL_Y,
	VGA_VSYNC_NEG,
	RESULT,
	shape,
	color_count,
	top,
	first,
	second,
	third,
	bottom,
	colorFinished,
	shapeFinished,
	red,
	blue
);


//=======================================================
//  PORT declarations
//=======================================================
input	[7:0]	PIXEL_IN;
input 		CLK;

input [9:0] VGA_PIXEL_X;
input [9:0] VGA_PIXEL_Y;
input			VGA_VSYNC_NEG;

output reg [7:0] RESULT = 8'b0;

output reg [14:0] blue;
output reg [14:0] red;
output reg colorFinished;
reg resetColor;
always @ (posedge CLK) begin

	if (!colorFinished) begin
		if (VGA_PIXEL_X == 0 && VGA_PIXEL_Y == 0) begin
			blue <= 0;
			red <= 0;
		end
		else begin
			if (VGA_PIXEL_X < 176 && VGA_PIXEL_Y < 144) begin
				if (PIXEL_IN[7:5] >= 1 && PIXEL_IN[1:0] == 0 && PIXEL_IN[4:3] == 0) begin
					red <= red + 1;
				end
				else begin
					red <= red;
				end
				if (PIXEL_IN[7:6] == 0 && PIXEL_IN[4] == 0) begin
					blue <= blue + 1;
				end
				else begin
					blue <= blue;
				end
			end
		end
	end
	
	if (resetColor) begin
		blue <= 0;
		red <= 0;
	end
end

output reg shapeFinished;
output reg [2:0] shape;
output reg [7:0] top;
output reg [31:0] first;
output reg [31:0] second;
output reg [31:0] third;
output reg [7:0] bottom;
output reg [7:0] color_count;
always @ (posedge CLK) begin
	if (!shapeFinished && colorFinished) begin
		if (VGA_PIXEL_X == 0) begin
			color_count = 0;
		end else begin
			if (VGA_PIXEL_X > 20 && VGA_PIXEL_X < 156 && VGA_PIXEL_Y < 144 && (PIXEL_IN[7:5] >= 1 && PIXEL_IN[4] == 0 && RESULT[0] == 1) || (PIXEL_IN[7] == 0 && PIXEL_IN[4] == 0 && RESULT[1] == 1)) begin
				color_count = color_count + 1;
			end
		end
//		if (top == 0 && color_count > 20) begin
//			top = VGA_PIXEL_Y;
//		end
//		if (top != 0 && bottom == 0 && color_count < 21 && VGA_PIXEL_X == 175) begin
//			bottom = VGA_PIXEL_Y;
//		end
		if (VGA_PIXEL_Y == 48-20 && VGA_PIXEL_X == 175) begin //48
			first = color_count;
		end
		if (VGA_PIXEL_Y == 72 && VGA_PIXEL_X == 175) begin
			second = color_count;
		end
		if (VGA_PIXEL_Y == 96+20 && VGA_PIXEL_X == 175) begin //96
			third = color_count;			
		end
		if (first != 0 && second != 0 && third != 0) begin
			if ( (second-first)**2 < second**2/100 && (third-second)**2 < third**2/100) begin
			   //square
				shape = 3'b011;
			end else begin
				if (second < third) begin //second-first > second/10 && third-second > third/10 &&  && first < second
					//triangle
					shape = 3'b010;
				end
				else begin
					if (second > third) begin //second-first > second/10 && second-third > second/10 &&  && second > first
						//diamond
						shape = 3'b001;
					end else begin 
						shape = 3'b100;
					end
				end
			end
		end
	end
	else begin
		if (!colorFinished)
		begin
			shape = 0;
			top = 0;
			first = 0;
			second = 0;
			third = 0;
			bottom = 0;
		end
	end
end

always @ (*) begin
	//ISSUE: RESULT is not clearing
	if (!VGA_VSYNC_NEG) begin
		colorFinished <= 0;
		shapeFinished <= 0;
		RESULT <= 8'b0;
		resetColor <= 1;
	end else begin
		resetColor <= 0;
		if (red > 3000) begin//12678
			RESULT <= 8'b00000001;
			colorFinished <= 1;
		end
		else begin
			if (blue > 3000) begin
				RESULT <= 8'b00000010;
				colorFinished <= 1;
			end
			else begin
				RESULT <= 8'b0;
				colorFinished <= 0;
			end
		end
		
		if (shape != 0) begin
			shapeFinished <= 1;
		end
		
	end
end

endmodule