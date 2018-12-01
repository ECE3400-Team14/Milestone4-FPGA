module SERIAL(
	CLK,
	RESULT,
	colorFinished,
	shapeFinished,
	SIG,
	DATA,
	shape,
	write,
	SHAPE_DATA
);

input CLK;

input [7:0] RESULT;//result from image processor

input colorFinished;

input shapeFinished;

input SIG;//signal line from Arduino
input [1:0] shape;
output reg DATA = 1;//data line to Arduino

output reg [3:0] SHAPE_DATA;//storing all relevant shape data

output reg [3:0] write = 9;//select which bit to send on DATA line


always @ (posedge colorFinished, posedge shapeFinished) begin
	//set color
	if(colorFinished) begin
		SHAPE_DATA[1:0] <= RESULT[1:0];
	end
	else begin
		SHAPE_DATA[1:0] <= SHAPE_DATA[1:0];
	end
	
	//set shape
	if(shapeFinished) begin
		SHAPE_DATA[3:2] <= shape;
	end
	else begin
		SHAPE_DATA[3:2] <= SHAPE_DATA[3:2];
	end
	
end

always @ (posedge SIG) begin
	write = write - 1;
	
	if (write>10)
	begin
		DATA = 0;
	end
	if (write == 10 || write == 5 || write == 0)
	begin
		DATA = 1;
	end
	if (write == 4 || write == 9) begin
		DATA = SHAPE_DATA[3];
	end
	if (write == 3 || write == 8) begin
		DATA = SHAPE_DATA[2];
	end
	if (write == 2 || write == 7) begin
		DATA = SHAPE_DATA[1];
	end
	if (write == 1 || write == 6) begin
		DATA = SHAPE_DATA[0];
	end
end



endmodule

