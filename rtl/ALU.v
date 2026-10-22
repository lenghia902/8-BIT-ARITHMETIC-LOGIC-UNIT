`include "arith_unit.v" 
`include "logic_unit.v"
module ALU#(parameter WIDTH=8)(
  input [WIDTH-1:0] in_a,
  input [WIDTH-1:0] in_b,
  input input_carry,
  input [3:0] alu_opcode,
  output reg [WIDTH-1:0] alu_out,
  output reg [4:0] alu_out_flag  // carry_flag, over_flag,zero_flag,state_compare
);
  
  
  localparam ZERO_INDEX=0;
  localparam A_GT_B_INDEX=1;
  localparam A_EQ_B_INDEX=2;
  localparam A_LT_B_INDEX=3;
  localparam FLAG_MUX_OUT_INDEX=4;//carry & overflow
  
  wire [WIDTH-1:0] arith_out;
  wire [WIDTH-1:0] logic_out;
  wire flag_mux_out;
  wire w_gt, w_eq, w_lt;
  arith_unit ari_module(
    .in_a(in_a),
    .in_b(in_b),
    .input_carry(input_carry),
    .alu_opcode(alu_opcode[2:0]),
    .arith_out(arith_out),
    .flag_mux_out(flag_mux_out)
  );
  logic_unit logic_module(
    .in_a(in_a),
    .in_b(in_b),
    .alu_opcode(alu_opcode[2:0]),
    .logic_out(logic_out),
    .comp_gt(w_gt),
    .comp_eq(w_eq),
    .comp_lt(w_lt)
  );
  always@(*)begin
    alu_out=0;
    alu_out_flag[4:0]=5'b0;
    case(alu_opcode[3])
      0:begin
        alu_out=arith_out;
        alu_out_flag[FLAG_MUX_OUT_INDEX]=flag_mux_out;
      end
      1:begin
        alu_out=logic_out;
        alu_out_flag[FLAG_MUX_OUT_INDEX]=1'b0;
      end
    endcase
    alu_out_flag[ZERO_INDEX]=(alu_out==0);
    alu_out_flag[A_GT_B_INDEX]=w_gt;
    alu_out_flag[A_EQ_B_INDEX]=w_eq;
    alu_out_flag[A_LT_B_INDEX]=w_lt;
  end
endmodule
