module lfsr #(
parameter CHOICE = 0
) (
  input               clk       ,
  input               rst_n     ,
  input               enable    ,
  input       [15:0]  seed_data ,
  output reg  [15:0]  r_LFSR 
);

reg r_XNOR;

always @(posedge clk or negedge rst_n) begin
  if(~rst_n)    r_LFSR <= seed_data;                else
  if(enable)    r_LFSR <= {r_LFSR[14:0], r_XNOR};
end

always @(*) begin
  case(CHOICE)
    0: r_XNOR = r_LFSR[10] ^ r_LFSR[7];
    1: r_XNOR = r_LFSR[9] ^ r_LFSR[5];
    2: r_XNOR = r_LFSR[15] ^ r_LFSR[14];
    3: r_XNOR = r_LFSR[11] ^ r_LFSR[9];
    4: r_XNOR = r_LFSR[8] ^ r_LFSR[6] ^ r_LFSR[5] ^ r_LFSR[4];
    5: r_XNOR = r_LFSR[14] ^ r_LFSR[5] ^ r_LFSR[3] ^ r_LFSR[1];
    6: r_XNOR = r_LFSR[12] ^ r_LFSR[6] ^ r_LFSR[4] ^ r_LFSR[1];
    7: r_XNOR = r_LFSR[13] ^ r_LFSR[4] ^ r_LFSR[3] ^ r_LFSR[1];
    default: r_XNOR = r_LFSR[16] ^ r_LFSR[15] ^ r_LFSR[13] ^ r_LFSR[4];
  endcase
end



endmodule