module logic_unit#(parameter WIDTH=8)(
  input [WIDTH-1:0] in_a,
  input [WIDTH-1:0] in_b,
  input [2:0] alu_opcode,
  output reg [WIDTH-1:0] logic_out,
  output comp_gt,
  output comp_eq,
  output comp_lt
);
  localparam [2:0] COMP=3'b000,ANDG=3'b001,ORG=3'b010,XORG=3'b011,NOTA=3'b100,NOTB=3'b101;
  wire [2:0] comp_result;
  compare_8bit my_comparator(
    .in_a(in_a),
    .in_b(in_b),
    .y(comp_result)
  );
  assign comp_lt=comp_result[0];
  assign comp_eq=comp_result[1];
  assign comp_gt=comp_result[2];
  always@(*)begin
    case(alu_opcode)
      COMP:begin
        logic_out=(comp_result[1]) ? 1'b1:1'b0;
      end
      ANDG:begin
        logic_out=in_a & in_b;
      end
      ORG:begin
        logic_out=in_a | in_b;
      end
      XORG:begin
        logic_out=in_a ^ in_b;
      end
      NOTA:begin
        logic_out=~in_a;
      end
      NOTB:begin
        logic_out=~in_b;
      end
      default:logic_out=0;
    endcase
  end
endmodule

module compare_1bit(
  input a,
  input b,
  input c1,c2,c3,
  output [2:0] y
);
  assign y[0]= c1 | c2&(~a &b);//lt
  assign y[1]=c2 & (~(a^b));//eq
  assign y[2]=c3 | c2 & (a&~b);//grt
endmodule

module compare_8bit#(parameter WIDTH=8)(
  input [WIDTH-1:0] in_a,
  input [WIDTH-1:0] in_b,
  output [2:0] y
);
  wire [2:0] y1;
  wire [2:0] y2;
  wire [2:0] y3;
  wire [2:0] y4;
  wire [2:0] y5;
  wire [2:0] y6;
  wire [2:0] y7;
  compare_1bit F0(.a(in_a[7]),.b(in_b[7]),.c1(1'b0),.c2(1'b1),.c3(1'b0),.y(y1));
  compare_1bit F1(.a(in_a[6]),.b(in_b[6]),.c1(y1[0]),.c2(y1[1]),.c3(y1[2]),.y(y2));
  compare_1bit F2(.a(in_a[5]),.b(in_b[5]),.c1(y2[0]),.c2(y2[1]),.c3(y2[2]),.y(y3));
  compare_1bit F3(.a(in_a[4]),.b(in_b[4]),.c1(y3[0]),.c2(y3[1]),.c3(y3[2]),.y(y4));
  compare_1bit F4(.a(in_a[3]),.b(in_b[3]),.c1(y4[0]),.c2(y4[1]),.c3(y4[2]),.y(y5));
  compare_1bit F5(.a(in_a[2]),.b(in_b[2]),.c1(y5[0]),.c2(y5[1]),.c3(y5[2]),.y(y6));
  compare_1bit F6(.a(in_a[1]),.b(in_b[1]),.c1(y6[0]),.c2(y6[1]),.c3(y6[2]),.y(y7));
  compare_1bit F7(.a(in_a[0]),.b(in_b[0]),.c1(y7[0]),.c2(y7[1]),.c3(y7[2]),.y(y));
endmodule
