`define SCREEN_WIDTH 176
`define SCREEN_HEIGHT 144
`define STRIDE 180
`define FRAME_LENGTH 51844 // 0 VSYNC low, 1-2 VSYNC high, 3 VSYNC low, then start at 4, each row with 176*2 valid data packets while HREF high, then 8 cycles while HREF low

module SIMULATOR(
  CLK,
  VSYNC,
  HREF,
  DATA
);

input CLK;
output VSYNC;
output HREF;
output [7:0] DATA;

reg [15:0] counter = 0;

always @ (posedge CLK) begin
  if (counter == FRAME_LENGTH) begin
    // end of frame
    counter <= 0;
    HREF <= 0;
    VSYNC <= 0;
    DATA <= 0;
  end
  else begin
    if (counter > 0 && counter < 3) begin
      // VSYNC high at the beginning
      counter <= counter + 1;
      HREF <= 0;
      VSYNC <= 1;
      DATA <= 0;
    end
    else
      if (counter == 0 || counter == 3) begin
        // right before and after VSYNC high
        counter <= counter + 1;
        HREF <= 0;
        VSYNC <= 0;
        DATA <= 0;
      end
      else begin
        if (((counter-4) % (2*STRIDE)) < 2*SCREEN_WIDTH) begin
          if ((counter % 2) == 0) begin
            //part1
            counter <= counter + 1;
            HREF <= 1;
            VSYNC <= 0;
            DATA <= 8'b11111000;
          end
          else begin
            //part2
            counter <= counter + 1;
            HREF <= 1;
            VSYNC <= 0;
            DATA <= 8'b00011111;
          end
        end
        else begin
          // in between rows
          counter <= counter + 1;
          HREF <= 0;
          VSYNC <= 0;
          DATA <= 0;
        end
      end
    end
  end
end

endmodule
