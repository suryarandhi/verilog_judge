import json
import re
import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
PROBLEMS_DIR = ROOT / "backend" / "problems"
SOURCE_JSON = ROOT / "scripts" / "generated_problems_100.json"


EXTRA_PROBLEMS = [
    {
        "id": "bcd_to_7segment",
        "title": "BCD to 7-segment Display",
        "difficulty": "Easy",
        "category": "Combinational",
        "tags": ["decoder", "display", "truth-table"],
        "module_signature": "module bcd_to_7seg(input [3:0] bcd, output reg [6:0] seg);",
        "statement": "Design a BCD to 7-segment decoder for decimal digits 0 through 9. The output segment vector is active high and ordered as {a,b,c,d,e,f,g}. Invalid BCD inputs from 10 to 15 should turn all segments off. The circuit is purely combinational.",
        "behavior": ["Drive the correct active-high segment pattern for BCD values 0 through 9.", "Drive all segments low for invalid BCD inputs 10 through 15.", "Do not store state or depend on a clock."],
        "constraints": ["Must be synthesizable Verilog.", "Use combinational logic.", "Do not infer latches."],
        "example": "bcd  digit  seg\n0000 0      1111110\n0001 1      0110000\n1010 invalid 0000000",
        "hint": "A case statement maps cleanly from BCD values to segment patterns.",
    },
    {
        "id": "mealy_sequence_detector_1011",
        "title": "Mealy Sequence Detector: 1011",
        "difficulty": "Medium",
        "category": "FSM",
        "tags": ["mealy", "sequence-detector", "overlap", "fsm"],
        "module_signature": "module mealy_1011_detector(input clk, input reset, input din, output reg detected);",
        "statement": "Design a Mealy FSM that detects the serial input pattern 1011. The detector must support overlapping matches. The output should assert in the same cycle that the final bit of the pattern is received. Reset returns the FSM to its initial state.",
        "behavior": ["Sample din on each rising edge of clk.", "Assert detected for one cycle when the sequence 1011 is observed.", "Support overlapping sequence matches.", "Reset clears the FSM state and detected output."],
        "constraints": ["Must be synthesizable Verilog.", "Use an FSM.", "Do not use arrays of past input bits."],
        "example": "din:      1 0 1 1 0 1 1\ndetected: 0 0 0 1 0 0 1",
        "hint": "Track the longest suffix that is also a prefix of 1011.",
    },
    {
        "id": "parameterized_clock_divider",
        "title": "Parameterized Clock Divider",
        "difficulty": "Medium",
        "category": "Sequential",
        "tags": ["counter", "clock-divider", "parameterized"],
        "module_signature": "module clock_divider #(parameter N = 4)(input clk, input reset, output reg clk_out);",
        "statement": "Design a parameterized clock divider that toggles an output clock after N input clock cycles. Reset clears the counter and output clock. This problem is parameterized because divide ratio is a design parameter, not a separate concept. Assume N is greater than 1.",
        "behavior": ["On reset, clk_out becomes 0 and the internal count clears.", "Count rising edges of clk.", "When the counter reaches N-1, clear the counter and toggle clk_out."],
        "constraints": ["Must be synthesizable Verilog.", "Do not generate clocks with delays.", "Do not use multiple clock domains internally."],
        "example": "N=3\nclk edge: 1 2 3 4 5 6\nclk_out:  0 0 1 1 1 0",
        "hint": "Use a counter register and toggle clk_out at the terminal count.",
    },
    {
        "id": "byte_swap_32",
        "title": "32-bit Byte Swapper",
        "difficulty": "Easy",
        "category": "Datapath",
        "tags": ["byte-order", "datapath", "bit-manipulation"],
        "module_signature": "module byte_swap_32(input [31:0] data_in, output [31:0] data_out);",
        "statement": "Design a 32-bit byte swapper that reverses byte order. The least significant byte becomes the most significant byte and vice versa. The operation is purely combinational and is useful for endian conversion in datapaths.",
        "behavior": ["data_out[31:24] equals data_in[7:0].", "data_out[23:16] equals data_in[15:8].", "data_out[15:8] equals data_in[23:16].", "data_out[7:0] equals data_in[31:24]."],
        "constraints": ["Must be synthesizable Verilog.", "Use combinational logic.", "Do not use a clock."],
        "example": "data_in  = 11223344\ndata_out = 44332211",
        "hint": "Concatenate the four bytes in reverse order.",
    },
    {
        "id": "gray_counter_3bit",
        "title": "3-bit Gray Counter",
        "difficulty": "Medium",
        "category": "Sequential",
        "tags": ["counter", "gray-code", "sequential"],
        "module_signature": "module gray_counter_3bit(input clk, input reset, output reg [2:0] gray);",
        "statement": "Design a 3-bit Gray-code counter. Only one output bit should change between adjacent count states. Reset initializes the counter to 000. This counter is useful when crossing encoded count values between timing regions.",
        "behavior": ["On reset, gray becomes 000.", "On each rising edge of clk, advance to the next 3-bit Gray-code state.", "After 100, the counter wraps to 000."],
        "constraints": ["Must be synthesizable Verilog.", "Use registered state.", "Do not use delays."],
        "example": "cycle: 0   1   2   3   4\ngray:  000 001 011 010 110",
        "hint": "Keep a binary counter internally and convert it to Gray code.",
    },
    {
        "id": "ready_valid_skid_buffer",
        "title": "Ready/Valid Skid Buffer",
        "difficulty": "Hard",
        "category": "Datapath",
        "tags": ["ready-valid", "buffer", "handshake"],
        "module_signature": "module ready_valid_skid_buffer(input clk, input reset, input in_valid, input [7:0] in_data, input out_ready, output in_ready, output reg out_valid, output reg [7:0] out_data);",
        "statement": "Design a one-entry skid buffer for a ready/valid interface. The buffer accepts input data when in_valid and in_ready are high, and presents data while out_valid is high. It must hold data stable when the downstream side is not ready. Reset clears the valid flag.",
        "behavior": ["in_ready is high when the buffer is empty or the output is being accepted.", "Capture in_data when in_valid and in_ready are high.", "Hold out_data stable while out_valid is high and out_ready is low.", "Reset clears out_valid."],
        "constraints": ["Must be synthesizable Verilog.", "Use nonblocking assignments in sequential logic.", "Do not drop valid data under backpressure."],
        "example": "in_valid out_ready | in_ready out_valid\n1        1         | 1        1\n1        0         | 0        1",
        "hint": "A one-entry valid register is enough for this simplified skid buffer.",
    },
]


CUSTOM_SOLUTIONS = {
    "mux_2to1": "assign y = sel ? b : a;",
    "decoder_3to8": "assign y = 8'b00000001 << sel;",
    "comparator_unsigned": "assign gt = a > b;\n  assign eq = a == b;\n  assign lt = a < b;",
    "even_parity_generator": "assign parity = ~^a;",
    "sign_extender_8to16": "assign y = {{8{a[7]}}, a};",
    "zero_detector": "assign is_zero = a == 8'b0;",
    "majority_gate": "assign y = (a & b) | (a & c) | (b & c);",
    "detect_msb_one": "assign msb_one = a[7];",
    "threshold_detector": "assign above_threshold = a > 8'd100;",
    "bitwise_nand": "assign y = ~(a & b);",
    "priority_encoder_4to2": "always @(*) begin\n    valid = |in;\n    if (in[3]) code = 2'd3;\n    else if (in[2]) code = 2'd2;\n    else if (in[1]) code = 2'd1;\n    else code = 2'd0;\n  end",
    "population_count": "integer i;\n  always @(*) begin\n    count = 4'd0;\n    for (i = 0; i < 8; i = i + 1) count = count + a[i];\n  end",
    "bit_reversal": "assign y = {a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7]};",
    "bcd_to_7segment": "always @(*) begin\n    case (bcd)\n      4'd0: seg = 7'b1111110;\n      4'd1: seg = 7'b0110000;\n      4'd2: seg = 7'b1101101;\n      4'd3: seg = 7'b1111001;\n      4'd4: seg = 7'b0110011;\n      4'd5: seg = 7'b1011011;\n      4'd6: seg = 7'b1011111;\n      4'd7: seg = 7'b1110000;\n      4'd8: seg = 7'b1111111;\n      4'd9: seg = 7'b1111011;\n      default: seg = 7'b0000000;\n    endcase\n  end",
    "byte_swap_32": "assign data_out = {data_in[7:0], data_in[15:8], data_in[23:16], data_in[31:24]};",
    "absolute_difference": "always @(*) begin\n    diff = (a >= b) ? (a - b) : (b - a);\n  end",
    "absolute_value_unit": "always @(*) begin\n    y = a[7] ? (~a + 8'd1) : a;\n  end",
    "address_incrementer": "assign next_addr = incr ? addr + 16'd1 : addr;",
    "arithmetic_shift_unit": "assign y = a >>> shamt;",
    "assertion_checker": "always @(*) begin\n    fault = value > 4'd12;\n  end",
    "branch_condition_unit": "assign taken = branch_neg && (value <= 0);",
    "carry_lookahead_adder": "assign {cout, sum} = a + b + cin;",
    "conditional_incrementer": "assign y = enable ? a + 8'd1 : a;",
    "data_router": "assign y = (sel == 2'd0) ? a : (sel == 2'd1) ? b : (sel == 2'd2) ? c : d;",
    "fixed_point_multiplier": "assign product = a * b;",
    "flag_generator": "assign zero = result == 8'b0;\n  assign negative = result[7];\n  assign parity = ~^result;\n  assign carry_out = carry_in;",
    "formal_property_checker": "always @(*) begin\n    violation = !permit && value > 8'd200;\n  end",
    "min_max_selector": "assign y = sel ? ((a > b) ? a : b) : ((a < b) ? a : b);",
    "modulo_unit": "always @(*) begin\n    remainder = (b == 8'd0) ? 8'd0 : a % b;\n  end",
    "one_hot_to_binary": "always @(*) begin\n    case (one_hot)\n      8'b00000001: code = 3'd0;\n      8'b00000010: code = 3'd1;\n      8'b00000100: code = 3'd2;\n      8'b00001000: code = 3'd3;\n      8'b00010000: code = 3'd4;\n      8'b00100000: code = 3'd5;\n      8'b01000000: code = 3'd6;\n      8'b10000000: code = 3'd7;\n      default: code = 3'd0;\n    endcase\n  end\n  assign valid = one_hot != 8'b0 && (one_hot & (one_hot - 8'b1)) == 8'b0;",
    "overflow_detector": "assign overflow = (a[7] == b[7]) && (sum[7] != a[7]);",
    "priority_encoder_8to3": "assign valid = |in;\n  always @(*) begin\n    code = in[7] ? 3'd7 : in[6] ? 3'd6 : in[5] ? 3'd5 : in[4] ? 3'd4 : in[3] ? 3'd3 : in[2] ? 3'd2 : in[1] ? 3'd1 : 3'd0;\n  end",
    "find_bug_priority_encoder": "always @(*) begin\n    valid = |in;\n    if (in[7]) code = 3'd7;\n    else if (in[6]) code = 3'd6;\n    else if (in[5]) code = 3'd5;\n    else if (in[4]) code = 3'd4;\n    else if (in[3]) code = 3'd3;\n    else if (in[2]) code = 3'd2;\n    else if (in[1]) code = 3'd1;\n    else code = 3'd0;\n  end",
    "ripple_carry_adder": "assign {cout, sum} = a + b + cin;",
    "saturating_adder": "reg signed [8:0] tmp;\n  always @(*) begin\n    tmp = a + b;\n    if (tmp > 9'sd127) y = 8'sd127;\n    else if (tmp < -9'sd128) y = -8'sd128;\n    else y = tmp[7:0];\n  end",
    "saturating_subtractor": "reg signed [8:0] tmp;\n  always @(*) begin\n    tmp = a - b;\n    if (tmp > 9'sd127) y = 8'sd127;\n    else if (tmp < -9'sd128) y = -8'sd128;\n    else y = tmp[7:0];\n  end",
    "shifter_mux": "assign y = (sel == 2'd0) ? a : (sel == 2'd1) ? (a << 1) : (sel == 2'd2) ? (a >> 1) : ~a;",
    "sign_extension_datapath": "assign y = {{9{a[6]}}, a};",
    "sign_magnitude_comparator": "assign gt = a > b;\n  assign eq = a == b;\n  assign lt = a < b;",
    "signed_magnitude_selector": "reg signed [7:0] aa;\n  reg signed [7:0] bb;\n  always @(*) begin\n    aa = a[7] ? -a : a;\n    bb = b[7] ? -b : b;\n    if (sel) y = (aa >= bb) ? a : b;\n    else y = (a >= b) ? a : b;\n    negative = y[7];\n  end",
    "unsigned_multiplier_4x4": "assign product = a * b;",
    "zero_flag_unit": "assign zero = value == 8'b0;",
    "compare_select": "always @(*) begin\n    y = sel ? ((a > b) ? a : b) : ((a < b) ? a : b);\n  end",
    "simple_alu_8bit": "always @(*) begin\n    case (op)\n      3'b000: result = a + b;\n      3'b001: result = a - b;\n      3'b010: result = a & b;\n      3'b011: result = a | b;\n      3'b100: result = ~a;\n      default: result = 8'b0;\n    endcase\n    zero = result == 8'b0;\n  end",
    "alu_with_flags": "reg [8:0] tmp;\n  always @(*) begin\n    tmp = 9'b0;\n    case (op)\n      3'b000: begin tmp = a + b; result = tmp[7:0]; carry = tmp[8]; end\n      3'b001: begin tmp = {1'b0, a} - {1'b0, b}; result = tmp[7:0]; carry = a < b; end\n      3'b010: begin result = a & b; carry = 1'b0; end\n      3'b011: begin result = a | b; carry = 1'b0; end\n      3'b100: begin result = a ^ b; carry = 1'b0; end\n      default: begin result = 8'b0; carry = 1'b0; end\n    endcase\n    zero = result == 8'b0;\n    negative = result[7];\n  end",
    "d_flipflop_sync_reset": "always @(posedge clk) begin\n    if (rst) q <= 1'b0;\n    else q <= d;\n  end",
    "clock_enable_register": "always @(posedge clk) begin\n    if (rst) q <= 8'b0;\n    else if (en) q <= d;\n  end",
    "loadable_register": "always @(posedge clk) begin\n    if (rst) q <= 8'b0;\n    else if (load) q <= d;\n  end",
    "shift_register_8bit": "always @(posedge clk) begin\n    if (rst) q <= 8'b0;\n    else q <= {q[6:0], serial_in};\n  end",
    "serial_to_parallel_register": "always @(posedge clk) begin\n    if (rst) q <= 8'b0;\n    else if (load) q <= {q[6:0], serial_in};\n  end",
    "rising_edge_detector": "reg prev;\n  always @(posedge clk) begin\n    if (rst) begin prev <= 1'b0; pulse <= 1'b0; end\n    else begin pulse <= signal & ~prev; prev <= signal; end\n  end",
    "bit_pulse_generator": "reg prev;\n  always @(posedge clk) begin\n    if (rst) begin prev <= 1'b0; pulse <= 1'b0; end\n    else begin pulse <= in_bit & ~prev; prev <= in_bit; end\n  end",
    "pulse_stretcher": "reg hold;\n  always @(posedge clk) begin\n    if (rst) begin pulse_out <= 1'b0; hold <= 1'b0; end\n    else begin pulse_out <= pulse_in | hold; hold <= pulse_in; end\n  end",
    "saturating_counter": "always @(posedge clk) begin\n    if (rst) count <= 4'd0;\n    else if (en && count != 4'hf) count <= count + 4'd1;\n  end",
    "synchronous_clear_counter": "always @(posedge clk) begin\n    if (rst || clear) count <= 4'd0;\n    else count <= count + 4'd1;\n  end",
    "up_down_counter": "always @(posedge clk) begin\n    if (rst) count <= 4'd0;\n    else if (dir) count <= count + 4'd1;\n    else count <= count - 4'd1;\n  end",
    "johnson_counter_4bit": "always @(posedge clk) begin\n    if (rst) q <= 4'b0000;\n    else q <= {~q[0], q[3:1]};\n  end",
    "gray_counter_3bit": "reg [2:0] bin;\n  always @(posedge clk) begin\n    if (reset) begin bin <= 3'b000; gray <= 3'b000; end\n    else begin bin <= bin + 3'd1; gray <= ((bin + 3'd1) >> 1) ^ (bin + 3'd1); end\n  end",
    "gated_d_latch": "initial q = 1'b0;\n  always @(*) begin\n    if (en) q = d;\n  end",
    "buggy_register_debug": "always @(posedge clk) begin\n    if (rst) q <= 8'b0;\n    else if (en) q <= d;\n  end",
    "identify_race_condition": "always @(posedge clk) begin\n    if (rst) q <= 2'b00;\n    else q <= {a, b};\n  end",
    "find_bug_dff_reset_polarity": "always @(posedge clk) begin\n    if (rst) q <= 1'b0;\n    else q <= d;\n  end",
    "find_bug_clock_divider": "reg [3:0] count;\n  always @(posedge clk) begin\n    if (rst) begin count <= 4'd0; clk_out <= 1'b0; end\n    else if (count >= n) begin count <= 4'd0; clk_out <= ~clk_out; end\n    else count <= count + 4'd1;\n  end",
    "multiplier_accumulator": "always @(posedge clk) begin\n    if (rst) acc <= 8'b0;\n    else if (en) acc <= acc + (a * b);\n  end",
    "saturating_accumulator": "reg signed [8:0] tmp;\n  always @(posedge clk) begin\n    if (rst) q <= 8'sd0;\n    else if (en) begin\n      tmp = q + d;\n      if (tmp > 9'sd127) q <= 8'sd127;\n      else if (tmp < -9'sd128) q <= -8'sd128;\n      else q <= tmp[7:0];\n    end\n  end",
    "parameterized_clock_divider": "reg [31:0] count;\n  always @(posedge clk) begin\n    if (reset) begin count <= 0; clk_out <= 1'b0; end\n    else if (count == N - 1) begin count <= 0; clk_out <= ~clk_out; end\n    else count <= count + 1;\n  end",
    "handshake_controller": "always @(posedge clk) begin\n    if (rst) ack <= 1'b0;\n    else if (req) ack <= 1'b1;\n    else ack <= 1'b0;\n  end",
    "bus_arbiter": "always @(posedge clk) begin\n    if (rst) grant <= 3'b000;\n    else if (req[0]) grant <= 3'b001;\n    else if (req[1]) grant <= 3'b010;\n    else if (req[2]) grant <= 3'b100;\n    else grant <= 3'b000;\n  end",
    "memory_arbiter_3to1": "always @(posedge clk) begin\n    if (rst) grant <= 3'b000;\n    else if (req[2]) grant <= 3'b100;\n    else if (req[1]) grant <= 3'b010;\n    else if (req[0]) grant <= 3'b001;\n    else grant <= 3'b000;\n  end",
    "find_bug_memory_arbitration": "always @(posedge clk) begin\n    if (rst) grant <= 3'b000;\n    else if (req[2]) grant <= 3'b100;\n    else if (req[1]) grant <= 3'b010;\n    else if (req[0]) grant <= 3'b001;\n    else grant <= 3'b000;\n  end",
    "traffic_light_fsm": "reg [1:0] state;\n  always @(posedge clk) begin\n    if (rst) state <= 2'd0;\n    else if (state == 2'd2) state <= 2'd0;\n    else state <= state + 2'd1;\n  end\n  always @(*) begin\n    red = state == 2'd0;\n    green = state == 2'd1;\n    yellow = state == 2'd2;\n  end",
    "pedestrian_crossing_controller": "reg [1:0] state;\n  always @(posedge clk) begin\n    if (rst) state <= 2'd0;\n    else case (state)\n      2'd0: state <= walk_request ? 2'd1 : 2'd0;\n      2'd1: state <= 2'd2;\n      2'd2: state <= 2'd3;\n      default: state <= 2'd0;\n    endcase\n  end\n  always @(*) begin\n    vehicle_green = state == 2'd0;\n    vehicle_yellow = state == 2'd1;\n    vehicle_red = state == 2'd2 || state == 2'd3;\n    walk = state == 2'd3;\n  end",
    "thermal_shutdown_fsm": "always @(posedge clk) begin\n    if (rst) fan_enable <= 1'b0;\n    else if (temp >= 8'd100) fan_enable <= 1'b0;\n    else if (temp < 8'd90) fan_enable <= 1'b1;\n  end",
    "elevator_floor_controller": "always @(posedge clk) begin\n    if (rst) begin floor <= 2'd1; moving_up <= 1'b0; moving_down <= 1'b0; end\n    else if (request_up && floor < 2'd3) begin floor <= floor + 2'd1; moving_up <= 1'b1; moving_down <= 1'b0; end\n    else if (request_down && floor > 2'd1) begin floor <= floor - 2'd1; moving_up <= 1'b0; moving_down <= 1'b1; end\n    else begin moving_up <= 1'b0; moving_down <= 1'b0; end\n  end",
    "vending_machine_controller": "reg [4:0] credit;\n  always @(posedge clk) begin\n    if (rst) begin credit <= 5'd0; dispense <= 1'b0; end\n    else begin\n      dispense <= 1'b0;\n      if (credit + (coin5 ? 5'd5 : 5'd0) + (coin10 ? 5'd10 : 5'd0) >= 5'd15) begin credit <= 5'd0; dispense <= 1'b1; end\n      else credit <= credit + (coin5 ? 5'd5 : 5'd0) + (coin10 ? 5'd10 : 5'd0);\n    end\n  end",
    "mealy_sequence_detector_1011": "reg [1:0] state;\n  always @(posedge clk) begin\n    if (reset) begin state <= 2'd0; detected <= 1'b0; end\n    else begin\n      detected <= 1'b0;\n      case (state)\n        2'd0: state <= din ? 2'd1 : 2'd0;\n        2'd1: state <= din ? 2'd1 : 2'd2;\n        2'd2: state <= din ? 2'd3 : 2'd0;\n        default: begin detected <= din; state <= din ? 2'd1 : 2'd2; end\n      endcase\n    end\n  end",
    "serial_frame_detector": "reg [3:0] count;\n  always @(posedge clk) begin\n    if (rst) begin count <= 4'd0; frame_valid <= 1'b0; end\n    else begin\n      frame_valid <= 1'b0;\n      if (count == 4'd0) count <= serial_in ? 4'd0 : 4'd1;\n      else if (count == 4'd9) begin frame_valid <= serial_in; count <= 4'd0; end\n      else count <= count + 4'd1;\n    end\n  end",
    "debounce_filter": "reg [1:0] hist;\n  always @(posedge clk) begin\n    if (rst) begin hist <= 2'b00; clean <= 1'b0; end\n    else begin hist <= {hist[0], noisy}; if (&{hist[0], noisy}) clean <= 1'b1; else if (~|{hist[0], noisy}) clean <= 1'b0; end\n  end",
    "single_port_ram_16x8": "reg [7:0] mem [0:15];\n  integer i;\n  always @(posedge clk) begin\n    if (rst) begin dout <= 8'b0; for (i = 0; i < 16; i = i + 1) mem[i] <= 8'b0; end\n    else begin if (wr_en) mem[addr] <= din; dout <= mem[addr]; end\n  end",
    "sram_1kx8": "reg [7:0] mem [0:1023];\n  integer i;\n  always @(posedge clk) begin\n    if (rst) begin dout <= 8'b0; for (i = 0; i < 1024; i = i + 1) mem[i] <= 8'b0; end\n    else begin if (wr_en) mem[addr] <= din; dout <= mem[addr]; end\n  end",
    "dual_port_ram": "reg [7:0] mem [0:15];\n  integer i;\n  initial begin for (i = 0; i < 16; i = i + 1) mem[i] = 8'b0; end\n  always @(posedge clk) begin\n    if (wr_en) mem[wr_addr] <= wr_data;\n    rd_data <= mem[rd_addr];\n  end",
    "register_file_8x8_2r1w": "reg [7:0] regs [0:7];\n  integer i;\n  always @(posedge clk) begin\n    if (rst) begin for (i = 0; i < 8; i = i + 1) regs[i] <= 8'b0; end\n    else if (write_en) regs[write_addr] <= write_data;\n  end\n  assign read_data_a = regs[read_addr_a];\n  assign read_data_b = regs[read_addr_b];",
    "shared_register_file": "reg [7:0] regs [0:7];\n  integer i;\n  always @(posedge clk) begin\n    if (rst) begin for (i = 0; i < 8; i = i + 1) regs[i] <= 8'b0; end\n    else if (write_en) regs[write_addr] <= write_data;\n  end\n  assign read_data_a = regs[read_addr_a];\n  assign read_data_b = regs[read_addr_b];",
    "banked_register_file": "reg [7:0] bank0 [0:7];\n  reg [7:0] bank1 [0:7];\n  integer i;\n  always @(posedge clk) begin\n    if (rst) begin for (i = 0; i < 8; i = i + 1) begin bank0[i] <= 8'b0; bank1[i] <= 8'b0; end end\n    else if (write_en) begin if (bank_sel) bank1[write_addr] <= write_data; else bank0[write_addr] <= write_data; end\n  end\n  assign read_data_a = bank_sel ? bank1[read_addr_a] : bank0[read_addr_a];\n  assign read_data_b = bank_sel ? bank1[read_addr_b] : bank0[read_addr_b];",
    "read_after_write_buffer": "reg [7:0] mem [0:15];\n  integer i;\n  always @(posedge clk) begin\n    if (rst) begin data_out <= 8'b0; for (i = 0; i < 16; i = i + 1) mem[i] <= 8'b0; end\n    else begin if (wr_en) mem[addr] <= data_in; if (rd_en) data_out <= (wr_en && addr == rd_addr) ? data_in : mem[rd_addr]; end\n  end",
    "write_back_buffer": "reg [7:0] mem [0:15];\n  integer i;\n  always @(posedge clk) begin\n    if (rst) begin data_out <= 8'b0; pending <= 1'b0; for (i = 0; i < 16; i = i + 1) mem[i] <= 8'b0; end\n    else begin if (wr_en) begin mem[addr] <= data_in; pending <= 1'b1; end else pending <= 1'b0; if (rd_en) data_out <= mem[rd_addr]; end\n  end",
    "cache_line_buffer": "reg [7:0] tags [0:3];\n  reg [15:0] data [0:3];\n  reg valid [0:3];\n  integer i;\n  always @(posedge clk) begin\n    if (rst) begin data_out <= 16'b0; hit <= 1'b0; for (i = 0; i < 4; i = i + 1) begin tags[i] <= 8'b0; data[i] <= 16'b0; valid[i] <= 1'b0; end end\n    else begin if (write_en) begin tags[index] <= tag; data[index] <= data_in; valid[index] <= 1'b1; end hit <= valid[index] && tags[index] == tag; data_out <= data[index]; end\n  end",
    "circular_buffer": "reg [7:0] mem [0:3];\n  reg [2:0] count;\n  reg [1:0] head;\n  reg [1:0] tail;\n  integer i;\n  always @(posedge clk) begin\n    if (rst) begin dout <= 8'b0; full <= 1'b0; empty <= 1'b1; count <= 3'd0; head <= 2'd0; tail <= 2'd0; for (i = 0; i < 4; i = i + 1) mem[i] <= 8'b0; end\n    else begin if (push && !full) begin mem[tail] <= din; tail <= tail + 2'd1; count <= count + 3'd1; end if (pop && !empty) begin dout <= mem[head]; head <= head + 2'd1; count <= count - 3'd1; end full <= count == 3'd4; empty <= count == 3'd0; end\n  end",
    "pointer_based_buffer": "reg [7:0] mem [0:3];\n  reg [2:0] count;\n  reg [1:0] wr_ptr;\n  reg [1:0] rd_ptr;\n  integer i;\n  always @(posedge clk) begin\n    if (rst) begin dout <= 8'b0; full <= 1'b0; empty <= 1'b1; count <= 3'd0; wr_ptr <= 2'd0; rd_ptr <= 2'd0; for (i = 0; i < 4; i = i + 1) mem[i] <= 8'b0; end\n    else begin if (write_en && !full) begin mem[wr_ptr] <= din; wr_ptr <= wr_ptr + 2'd1; count <= count + 3'd1; end if (read_en && !empty) begin dout <= mem[rd_ptr]; rd_ptr <= rd_ptr + 2'd1; count <= count - 3'd1; end full <= count == 3'd4; empty <= count == 3'd0; end\n  end",
    "fifo_sync_8x8": "reg [7:0] mem [0:7];\n  reg [3:0] count;\n  reg [2:0] wr_ptr;\n  reg [2:0] rd_ptr;\n  integer i;\n  always @(posedge clk) begin\n    if (rst) begin dout <= 8'b0; full <= 1'b0; empty <= 1'b1; count <= 4'd0; wr_ptr <= 3'd0; rd_ptr <= 3'd0; for (i = 0; i < 8; i = i + 1) mem[i] <= 8'b0; end\n    else begin if (write_en && !full) begin mem[wr_ptr] <= din; wr_ptr <= wr_ptr + 3'd1; count <= count + 4'd1; end if (read_en && !empty) begin dout <= mem[rd_ptr]; rd_ptr <= rd_ptr + 3'd1; count <= count - 4'd1; end full <= count == 4'd8; empty <= count == 4'd0; end\n  end",
    "ready_valid_skid_buffer": "assign in_ready = !out_valid || out_ready;\n  always @(posedge clk) begin\n    if (reset) begin out_valid <= 1'b0; out_data <= 8'b0; end\n    else if (in_ready) begin out_valid <= in_valid; if (in_valid) out_data <= in_data; end\n  end",
}


def read_source_problems():
    source = json.loads(SOURCE_JSON.read_text(encoding="utf-16"))
    problems = []
    seen = set()
    for item in source:
        if item["id"] in seen:
            continue
        seen.add(item["id"])
        problems.append(item)
    for item in EXTRA_PROBLEMS:
        if item["id"] not in seen:
            problems.append(item)
            seen.add(item["id"])
    if len(problems) != 100:
        raise RuntimeError(f"Expected exactly 100 curated problems, got {len(problems)}")
    return problems


def normalize_constraints(value):
    if isinstance(value, list):
        return value
    return [value] if value else ["Must be synthesizable in Icarus Verilog."]


def template_from_signature(signature):
    if "(" not in signature:
        name = module_name(signature)
        return f"module {name};\n  // Write your testbench or checker here\nendmodule"
    return signature.rstrip(";") + ";\n  // Write your code here\n\nendmodule"


def module_name(signature):
    match = re.search(r"\bmodule\s+([A-Za-z_][A-Za-z0-9_]*)", signature)
    if not match:
        raise ValueError(f"Cannot find module name in signature: {signature}")
    return match.group(1)


def split_ports(signature):
    if "(" not in signature or ")" not in signature:
        return []
    end = signature.rindex(")")
    start = signature.rfind("(", 0, end)
    inside = signature[start + 1: end]
    return [part.strip() for part in inside.split(",") if part.strip()]


def parse_port(part):
    direction = "input" if part.startswith("input") else "output"
    is_reg = " reg " in f" {part} "
    signed = " signed " in f" {part} "
    width_match = re.search(r"\[[^\]]+\]", part)
    width = width_match.group(0) if width_match else ""
    name = part.split()[-1]
    return {"direction": direction, "reg": is_reg, "signed": signed, "width": width, "name": name}


def width_value(width):
    if not width:
        return 1
    match = re.match(r"\[(\d+):(\d+)\]", width)
    if not match:
        return 1
    return abs(int(match.group(1)) - int(match.group(2))) + 1


def zero_literal(width):
    size = width_value(width)
    return "1'b0" if size == 1 else f"{size}'b0"


def fallback_body(signature):
    ports = [parse_port(part) for part in split_ports(signature)]
    outputs = [p for p in ports if p["direction"] == "output"]
    if not outputs:
        return "initial begin\n    $display(\"OK\");\n  end"

    assigns = []
    reg_outputs = []
    for port in outputs:
        if port["reg"]:
            reg_outputs.append(port)
        else:
            assigns.append(f"assign {port['name']} = {zero_literal(port['width'])};")

    if reg_outputs:
        assigns.append("always @(*) begin")
        for port in reg_outputs:
            assigns.append(f"    {port['name']} = {zero_literal(port['width'])};")
        assigns.append("  end")
    return "\n  ".join(assigns)


def timing_assumptions(ports):
    has_clk = any(p["name"] == "clk" for p in ports)
    reset_ports = [p["name"] for p in ports if p["name"] in ("reset", "rst")]
    if not has_clk:
        return [
            "Purely combinational: outputs must settle after input changes.",
            "Do not depend on initial register values, clocks, or delays.",
            "All outputs must be driven to known 0/1 values for every input case.",
        ]

    reset_name = reset_ports[0] if reset_ports else None
    assumptions = [
        "All state updates occur on the rising edge of clk.",
        "Use non-blocking assignments in clocked always blocks.",
        "Outputs must never depend on uninitialized x/z state after reset.",
    ]
    if reset_name:
        assumptions.insert(
            1,
            f"{reset_name} is active-high and synchronous unless the problem statement explicitly says otherwise.",
        )
        assumptions.append(f"When {reset_name} is asserted on a rising edge, registered outputs reset to their documented initial values.")
    else:
        assumptions.append("The testbench initializes inputs before the first active clock edge.")
    return assumptions


def solution_for(problem):
    signature = problem["module_signature"].rstrip(";")
    name = module_name(signature)
    body = CUSTOM_SOLUTIONS.get(problem["id"], fallback_body(signature))
    return f"{signature};\n  {body}\nendmodule\n"


def testbench_for(problem):
    signature = problem["module_signature"]
    name = module_name(signature)
    ports = [parse_port(part) for part in split_ports(signature)]
    if not ports:
        return f"`timescale 1ns/1ps\nmodule tb;\n  {name} dut();\nendmodule\n"

    input_ports = [p for p in ports if p["direction"] == "input"]
    output_ports = [p for p in ports if p["direction"] == "output"]
    declarations = []
    for port in input_ports:
        signed = " signed" if port["signed"] else ""
        width = f" {port['width']}" if port["width"] else ""
        declarations.append(f"  reg{signed}{width} {port['name']};")
    for port in output_ports:
        signed = " signed" if port["signed"] else ""
        width = f" {port['width']}" if port["width"] else ""
        declarations.append(f"  wire{signed}{width} {port['name']};")

    conns = ", ".join(f".{p['name']}({p['name']})" for p in ports)
    output_names = ", ".join(p["name"] for p in output_ports) or '"OK"'
    output_fmt = " ".join("%b" for _ in output_ports) or "%s"
    has_clk = any(p["name"] == "clk" for p in input_ports)
    assignments = []
    for index in range(8):
        lines = []
        for port in input_ports:
            if port["name"] == "clk":
                continue
            elif port["name"] in ("reset", "rst"):
                lines.append(f"{port['name']} = {1 if index == 0 else 0}")
            elif port["name"] in ("sel", "dir", "en", "we", "rd_en", "wr_en", "valid", "in_valid", "out_ready", "timer_done", "permit"):
                lines.append(f"{port['name']} = {index % 2}")
            else:
                size = width_value(port["width"])
                mask = (1 << size) - 1
                pattern = [0, 1, mask, int("10101010"[-min(size, 8):], 2) & mask, 2, 3, mask >> 1, (mask ^ 0x55) & mask]
                value = pattern[index]
                lines.append(f"{port['name']} = {size}'d{value}")
        if has_clk:
            assignments.append("    " + "; ".join(lines) + f"; #1; @(posedge clk); #1; $display(\"{output_fmt}\", {output_names});")
        else:
            assignments.append("    " + "; ".join(lines) + f"; #1; $display(\"{output_fmt}\", {output_names});")

    clock = "  initial begin clk = 0; forever #5 clk = ~clk; end\n" if any(p["name"] == "clk" for p in input_ports) else ""
    return f"""`timescale 1ns/1ps
module tb;
{chr(10).join(declarations)}

  {name} dut({conns});
{clock}
  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
{chr(10).join(assignments)}
    $finish;
  end
endmodule
"""


def clean_output(text):
    lines = []
    for line in text.splitlines():
        line = line.rstrip()
        if line and not line.startswith("VCD info:"):
            lines.append(line)
    return "\n".join(lines)


def generate_expected(path):
    binary = path / "seed_check.out"
    compile_result = subprocess.run(
        ["iverilog", "-g2005", "-o", str(binary), "solution.v", "tb.v"],
        cwd=path,
        capture_output=True,
        text=True,
        timeout=8,
    )
    if compile_result.returncode != 0:
        raise RuntimeError(f"{path.name} compile failed:\n{compile_result.stdout}{compile_result.stderr}")
    run_result = subprocess.run(
        ["vvp", str(binary)],
        cwd=path,
        capture_output=True,
        text=True,
        timeout=8,
    )
    if run_result.returncode != 0:
        raise RuntimeError(f"{path.name} simulation failed:\n{run_result.stdout}{run_result.stderr}")
    output = clean_output(run_result.stdout)
    if re.search(r"[xz]", output, re.IGNORECASE):
        raise RuntimeError(f"{path.name} generated unknown x/z expected output:\n{output}")
    (path / "expected.txt").write_text(output + "\n", encoding="utf-8")
    for artifact in [binary, path / "simulation.vcd"]:
        if artifact.exists():
            artifact.unlink()


def uncurate_existing():
    for metadata_path in PROBLEMS_DIR.glob("*/problem.json"):
        try:
            metadata = json.loads(metadata_path.read_text(encoding="utf-8"))
        except Exception:
            continue
        metadata["curated"] = False
        metadata_path.write_text(json.dumps(metadata, indent=2) + "\n", encoding="utf-8")


def write_problem(problem):
    path = PROBLEMS_DIR / problem["id"]
    path.mkdir(parents=True, exist_ok=True)
    ports = [parse_port(part) for part in split_ports(problem["module_signature"])]
    behavior = list(problem.get("behavior", []))
    for assumption in timing_assumptions(ports):
        if assumption not in behavior:
            behavior.append(assumption)
    metadata = {
        "id": problem["id"],
        "title": problem["title"],
        "difficulty": problem["difficulty"],
        "category": problem["category"],
        "tags": problem.get("tags", [])[:4],
        "statement": problem["statement"],
        "module_signature": problem["module_signature"],
        "behavior": behavior,
        "constraints": normalize_constraints(problem.get("constraints")),
        "example": problem.get("example", ""),
        "hint": problem.get("hint", ""),
        "template": template_from_signature(problem["module_signature"]),
        "curated": True,
    }
    (path / "problem.json").write_text(json.dumps(metadata, indent=2) + "\n", encoding="utf-8")
    (path / "solution.v").write_text(solution_for(problem), encoding="utf-8")
    (path / "tb.v").write_text(testbench_for(problem), encoding="utf-8")
    generate_expected(path)


def main():
    PROBLEMS_DIR.mkdir(parents=True, exist_ok=True)
    problems = read_source_problems()
    uncurate_existing()
    ids = [problem["id"] for problem in problems]
    if len(ids) != len(set(ids)):
        raise RuntimeError("Duplicate curated IDs remain after dedupe")
    for problem in problems:
        write_problem(problem)
    print(f"Seeded {len(problems)} curated no-duplicate problems.")


if __name__ == "__main__":
    main()
