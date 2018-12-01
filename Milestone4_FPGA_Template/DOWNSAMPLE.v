module DOWNSAMPLE (
  RGB565,
  RGB332
);

input  [15:0] RGB565;
output wire [7:0] RGB332;

//default
//assign RGB332 = {RGB565[15:13],RGB565[10:8],RGB565[4:3]};
//assign RGB332 = {RGB565[11:9],RGB565[7:5],RGB565[3:2]};

//def red/blue
//assign RGB332 = {RGB565[11:9],3'b0,RGB565[3:2]};
//msb/lsb swap
//assign RGB332 = {RGB565[8],RGB565[9],RGB565[10],3'b0,RGB565[0],RGB565[1]};

//swap red/blue


//assign RGB332 = {RGB565[3],RGB565[2],RGB565[1],//3 2 2
//RGB565[15],RGB565[14],RGB565[13],//15 13 13
//RGB565[11],RGB565[10]};

assign RGB332 = {RGB565[3],RGB565[2],RGB565[1],//3 2 2
RGB565[15],RGB565[14],RGB565[13],//15 13 13
RGB565[11],RGB565[10]};


//assign RGB332 = {RGB565[9],RGB565[10],RGB565[11],RGB565[5],RGB565[6],RGB565[7],RGB565[2],RGB565[3]};




//test1
//assign RGB332 = {RGB565[15],2'b0,RGB565[10],2'b0,RGB565[4],1'b0};

//RGB444
//assign RGB332 = {RGB565[11],2'b0,RGB565[7],2'b0,RGB565[3],1'b0};
//assign RGB332 = {RGB565[12],2'b0,RGB565[8],2'b0,RGB565[4],1'b0};
//assign RGB332 = {RGB565[12],7'b0};

//test2
//assign RGB332 = {RGB565[13],0,0,RGB565[8],0,0,RGB565[2],0};


endmodule
