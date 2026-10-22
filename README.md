# ALU 8-bit (Verilog) – từ RTL đến tổng hợp logic (Cadence Genus, 45 nm)

ALU tổ hợp 8-bit viết bằng Verilog, gồm khối số học, khối logic/so sánh, testbench mô phỏng và toàn bộ kết quả tổng hợp (netlist, SDC, báo cáo timing/power/area).

<p align="center"><img src="docs/images/01_alu_block.png" width="360" alt="ALU 8-bit block"></p>

## Cấu trúc thư mục

```
rtl/                 Mã nguồn thiết kế
  ALU.v              Top module (chọn khối số học / logic, sinh cờ)
  arith_unit.v       ADD, SUB, MUL, INC, DEC, dịch trái/phải (+ full adder, subtractor, multiplier, shifter)
  logic_unit.v       COMPARE, AND, OR, XOR, NOT A, NOT B (+ bộ so sánh 8-bit)
tb/
  tb_ALU.v           Testbench (có $monitor + dump VCD)
  run_sim.sh         Chạy mô phỏng (xrun hoặc iverilog)
docs/images/        Sơ đồ khối, schematic, waveform, báo cáo (dùng trong README)
synthesis/
  sdc/ALU_sdc.sdc    Ràng buộc thời gian
  scripts/alu_synth.tcl  Luồng tổng hợp Genus
  outputs/           Netlist generic & mapped (.v) + SDC
  reports/           timing, power, area, check_design, timing_lint
```

## Giao diện

| Cổng | Rộng | Mô tả |
|---|---|---|
| `in_a`, `in_b` | WIDTH (mặc định 8) | Toán hạng |
| `input_carry` | 1 | Carry/borrow vào (và bit đưa vào khi dịch) |
| `alu_opcode` | 4 | Mã lệnh (bảng dưới) |
| `alu_out` | WIDTH | Kết quả |
| `alu_out_flag` | 5 | `[0]` zero, `[1]` A>B, `[2]` A=B, `[3]` A<B, `[4]` carry/overflow |

## Bảng opcode

`alu_opcode[3]` = 0 → khối số học, = 1 → khối logic.

| Opcode | Lệnh | Ghi chú |
|---|---|---|
| `0000` | ADD | `A + B + cin`, cờ [4] = carry out |
| `0001` | SUB | `A − B − bin` |
| `0010` | MUL | Nhân 4×4 bit (dùng `A[3:0]`, `B[3:0]`), cờ [4] = overflow (kết quả > 4 bit) |
| `0011` | INC | `A + 1 + cin` |
| `0100` | DEC | `A − 1 − bin` |
| `0101` | SHL | Dịch trái, bit vào = `input_carry`, cờ [4] = bit MSB bị đẩy ra |
| `0110` | SHR | Dịch phải, bit vào = `input_carry`, cờ [4] = bit LSB bị đẩy ra |
| `1000` | COMPARE | `alu_out = 1` nếu A = B; cờ GT/EQ/LT luôn được cập nhật |
| `1001` | AND | `A & B` |
| `1010` | OR | `A \| B` |
| `1011` | XOR | `A ^ B` |
| `1100` | NOT A | `~A` |
| `1101` | NOT B | `~B` |

## Kiến trúc

Sơ đồ tổng thể: `alu_opcode[3]` chọn giữa khối số học và khối logic; `alu_opcode[2:0]` chọn phép toán bên trong khối.

![ALU top](docs/images/02_alu_top_schematic.png)

**Khối số học** (ADD, SUB, MUL, INC, DEC, SHL/SHR) và **khối logic** (COMPARE, AND, OR, XOR, NOT A, NOT B):

![Arithmetic unit](docs/images/03_arith_unit_schematic.png)
![Logic unit](docs/images/04_logic_unit_schematic.png)

### Các khối mức thấp

| Bộ cộng ripple-carry 8-bit | Bộ trừ ripple-borrow 8-bit |
|---|---|
| ![adder](docs/images/05_ripple_adder_8bit.png) | ![subtractor](docs/images/06_ripple_subtractor_8bit.png) |

**Bộ nhân mảng 4×4:**

<p align="center"><img src="docs/images/07_multiplier_4bit.png" width="520" alt="4-bit array multiplier"></p>

**Bộ so sánh 8-bit** (chuỗi 8 bộ so sánh 1-bit, tạo cờ GT/EQ/LT):

![comparator](docs/images/08_comparator_8bit.png)

## Kết quả mô phỏng

Dạng sóng tham chiếu (ADD, SUB, MUL, INC, DEC, SHL, SHR, COMPARE):

![reference waveform](docs/images/09_waveform_reference.png)

Dạng sóng mô phỏng thực tế từ `tb_ALU.v`:

![simulation waveform](docs/images/10_waveform_simulation.png)

## Chạy mô phỏng

```bash
./tb/run_sim.sh
# hoặc Cadence:  xrun rtl/ALU.v tb/tb_ALU.v -access +rwc -64bit
# hoặc Icarus :  iverilog -g2005 -o sim.out rtl/ALU.v tb/tb_ALU.v && vvp sim.out
```
Sóng được ghi ra `dump.vcd` (xem bằng GTKWave/SimVision).

## Kết quả tổng hợp (Genus 21.12, PVT_1P32V_0C)

| Chỉ tiêu | Giá trị |
|---|---|
| Số cell | 338 |
| Diện tích | 517.788 µm² |
| Công suất tổng | ≈ 247.6 µW (leakage 45 nW, internal 141.5 µW, switching 106 µW) |
| Ràng buộc | Virtual clock 0.5 ns, input/output delay 0.1 ns |
| Timing (in→out) | MET, slack +22 ps (đường dài nhất `in_b[0]` → `alu_out_flag[4]`) |

<details><summary>Báo cáo timing và power (ảnh)</summary>

![timing](docs/images/11_timing_report.png)
![power](docs/images/13_power_report.png)

</details>

Chạy lại tổng hợp: chuẩn bị thư viện `.lib` (không đưa lên repo), rồi `cd synthesis && genus -f scripts/alu_synth.tcl`.

## Vấn đề đã biết / hướng cải tiến

- `fadder_8bit` và `fsubtrator_8bit` có dấu phẩy thừa ở cuối danh sách cổng (`output cout,`) – một số trình biên dịch Verilog nghiêm ngặt sẽ báo lỗi.
- Cờ [4] của INC/DEC đang lấy từ `add_cf`/`sub_cf` của khối ADD/SUB thay vì `inc_cf`/`dec_cf`, nên có thể sai.
- INC/DEC cộng/trừ thêm `input_carry` (ví dụ 10+1+1 = 12), trong khi comment testbench ghi kỳ vọng 11.
- Testbench chưa tự kiểm tra (self-checking) – hiện chỉ in ra để quan sát.
- Bộ cộng ripple-carry; có thể thay bằng carry-lookahead để cải thiện timing.

## Công cụ

Cadence Genus 21.12 (tổng hợp), Cadence Xcelium 22.03 (mô phỏng), thư viện GPDK045 / OSU FreePDK 45 nm.
