import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
PROBLEMS_DIR = ROOT / "backend" / "problems"


def bits(value, width):
    return format(value & ((1 << width) - 1), f"0{width}b")


def write_problem(problem_id, title, difficulty, tags, description, template, solution, tb, expected):
    path = PROBLEMS_DIR / problem_id
    path.mkdir(parents=True, exist_ok=True)
    metadata = {
        "title": title,
        "difficulty": difficulty,
        "tags": tags,
        "description": description,
        "template": template,
    }
    (path / "problem.json").write_text(json.dumps(metadata, indent=2) + "\n", encoding="utf-8")
    (path / "solution.v").write_text(solution.strip() + "\n", encoding="utf-8")
    (path / "tb.v").write_text(tb.strip() + "\n", encoding="utf-8")
    (path / "expected.txt").write_text(expected.strip() + "\n", encoding="utf-8")


def combinational_tb(module_name, declarations, instantiation, vectors):
    body = "\n".join(f"    {setup} #5; $display(\"{fmt}\", {signals});" for setup, fmt, signals in vectors)
    return f"""
`timescale 1ns/1ps
module tb;
{declarations}

  {module_name} dut({instantiation});

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
{body}
    $finish;
  end
endmodule
"""


def seed_bitwise_binary():
    ops = [
        ("and", "AND", "a & b", lambda a, b, w: a & b),
        ("or", "OR", "a | b", lambda a, b, w: a | b),
        ("xor", "XOR", "a ^ b", lambda a, b, w: a ^ b),
        ("nand", "NAND", "~(a & b)", lambda a, b, w: (~(a & b)) & ((1 << w) - 1)),
        ("nor", "NOR", "~(a | b)", lambda a, b, w: (~(a | b)) & ((1 << w) - 1)),
        ("xnor", "XNOR", "~(a ^ b)", lambda a, b, w: (~(a ^ b)) & ((1 << w) - 1)),
    ]
    widths = [1, 2, 3, 4, 8, 16]
    for op_id, op_name, expr, fn in ops:
        for width in widths:
            module = f"{op_id}_{width}bit"
            title = f"{width}-bit {op_name}"
            desc = f"Design a {width}-bit bitwise {op_name} circuit.\\n\\nRequired module:\\nmodule {module}(input [{width - 1}:0] a, input [{width - 1}:0] b, output [{width - 1}:0] y);"
            template = f"module {module}(input [{width - 1}:0] a, input [{width - 1}:0] b, output [{width - 1}:0] y);\\n  // Write your code here\\n\\nendmodule"
            solution = f"module {module}(input [{width - 1}:0] a, input [{width - 1}:0] b, output [{width - 1}:0] y);\n  assign y = {expr};\nendmodule"
            tests = [
                (0, 0),
                (0, (1 << width) - 1),
                ((1 << width) - 1, 0),
                ((1 << width) - 1, (1 << width) - 1),
                ((1 << (width - 1)) if width > 1 else 1, (1 << width) - 1),
                ((1 << width) // 3, ((1 << width) * 2) // 3),
            ]
            vectors = []
            expected = []
            for a, b in tests:
                y = fn(a, b, width)
                vectors.append((f"a = {width}'b{bits(a, width)}; b = {width}'b{bits(b, width)};", "%b %b %b", "a, b, y"))
                expected.append(f"{bits(a, width)} {bits(b, width)} {bits(y, width)}")
            tb = combinational_tb(
                module,
                f"  reg [{width - 1}:0] a, b;\n  wire [{width - 1}:0] y;",
                ".a(a), .b(b), .y(y)",
                vectors,
            )
            write_problem(module, title, "Easy", ["combinational", "bitwise"], desc, template, solution, tb, "\n".join(expected))


def seed_unary_and_reductions():
    for width in [1, 2, 3, 4, 8, 16]:
        module = f"not_{width}bit"
        desc = f"Design a {width}-bit inverter.\\n\\nRequired module:\\nmodule {module}(input [{width - 1}:0] a, output [{width - 1}:0] y);"
        template = f"module {module}(input [{width - 1}:0] a, output [{width - 1}:0] y);\\n  // Write your code here\\n\\nendmodule"
        solution = f"module {module}(input [{width - 1}:0] a, output [{width - 1}:0] y);\n  assign y = ~a;\nendmodule"
        tests = [0, (1 << width) - 1, 1, (1 << (width - 1)) if width > 1 else 1, ((1 << width) * 2) // 3]
        vectors = []
        expected = []
        for a in tests:
            y = (~a) & ((1 << width) - 1)
            vectors.append((f"a = {width}'b{bits(a, width)};", "%b %b", "a, y"))
            expected.append(f"{bits(a, width)} {bits(y, width)}")
        tb = combinational_tb(module, f"  reg [{width - 1}:0] a;\n  wire [{width - 1}:0] y;", ".a(a), .y(y)", vectors)
        write_problem(module, f"{width}-bit NOT", "Easy", ["combinational", "bitwise"], desc, template, solution, tb, "\n".join(expected))

    reductions = [
        ("reduction_and", "Reduction AND", "&a", lambda a, w: int(a == (1 << w) - 1)),
        ("reduction_or", "Reduction OR", "|a", lambda a, w: int(a != 0)),
        ("reduction_xor", "Reduction XOR", "^a", lambda a, w: bin(a).count("1") % 2),
    ]
    for op_id, title, expr, fn in reductions:
        for width in [4, 8, 16, 32]:
            module = f"{op_id}_{width}bit"
            desc = f"Reduce a {width}-bit input to one output bit.\\n\\nRequired module:\\nmodule {module}(input [{width - 1}:0] a, output y);"
            template = f"module {module}(input [{width - 1}:0] a, output y);\\n  // Write your code here\\n\\nendmodule"
            solution = f"module {module}(input [{width - 1}:0] a, output y);\n  assign y = {expr};\nendmodule"
            tests = [0, 1, (1 << width) - 1, 1 << (width - 1), ((1 << width) * 2) // 3]
            vectors = []
            expected = []
            for a in tests:
                y = fn(a, width)
                vectors.append((f"a = {width}'b{bits(a, width)};", "%b %b", "a, y"))
                expected.append(f"{bits(a, width)} {y}")
            tb = combinational_tb(module, f"  reg [{width - 1}:0] a;\n  wire y;", ".a(a), .y(y)", vectors)
            write_problem(module, f"{width}-bit {title}", "Easy", ["combinational", "reduction"], desc, template, solution, tb, "\n".join(expected))


def seed_arithmetic_and_compare():
    for width in [2, 3, 4, 8, 16]:
        max_value = (1 << width) - 1
        tests = [(0, 0), (1, 1), (max_value, 1), (max_value // 2, max_value // 3), (max_value, max_value)]

        module = f"adder_{width}bit"
        desc = f"Design a {width}-bit adder with carry out.\\n\\nRequired module:\\nmodule {module}(input [{width - 1}:0] a, input [{width - 1}:0] b, output [{width - 1}:0] sum, output cout);"
        template = f"module {module}(input [{width - 1}:0] a, input [{width - 1}:0] b, output [{width - 1}:0] sum, output cout);\\n  // Write your code here\\n\\nendmodule"
        solution = f"module {module}(input [{width - 1}:0] a, input [{width - 1}:0] b, output [{width - 1}:0] sum, output cout);\n  assign {{cout, sum}} = a + b;\nendmodule"
        vectors = []
        expected = []
        for a, b in tests:
            total = a + b
            vectors.append((f"a = {width}'b{bits(a, width)}; b = {width}'b{bits(b, width)};", "%b %b %b %b", "a, b, sum, cout"))
            expected.append(f"{bits(a, width)} {bits(b, width)} {bits(total, width)} {int(total > max_value)}")
        tb = combinational_tb(module, f"  reg [{width - 1}:0] a, b;\n  wire [{width - 1}:0] sum;\n  wire cout;", ".a(a), .b(b), .sum(sum), .cout(cout)", vectors)
        write_problem(module, f"{width}-bit Adder", "Medium", ["combinational", "arithmetic"], desc, template, solution, tb, "\n".join(expected))

        module = f"subtractor_{width}bit"
        desc = f"Design a {width}-bit subtractor with borrow out.\\n\\nRequired module:\\nmodule {module}(input [{width - 1}:0] a, input [{width - 1}:0] b, output [{width - 1}:0] diff, output borrow);"
        template = f"module {module}(input [{width - 1}:0] a, input [{width - 1}:0] b, output [{width - 1}:0] diff, output borrow);\\n  // Write your code here\\n\\nendmodule"
        solution = f"module {module}(input [{width - 1}:0] a, input [{width - 1}:0] b, output [{width - 1}:0] diff, output borrow);\n  assign diff = a - b;\n  assign borrow = a < b;\nendmodule"
        vectors = []
        expected = []
        for a, b in tests:
            vectors.append((f"a = {width}'b{bits(a, width)}; b = {width}'b{bits(b, width)};", "%b %b %b %b", "a, b, diff, borrow"))
            expected.append(f"{bits(a, width)} {bits(b, width)} {bits(a - b, width)} {int(a < b)}")
        tb = combinational_tb(module, f"  reg [{width - 1}:0] a, b;\n  wire [{width - 1}:0] diff;\n  wire borrow;", ".a(a), .b(b), .diff(diff), .borrow(borrow)", vectors)
        write_problem(module, f"{width}-bit Subtractor", "Medium", ["combinational", "arithmetic"], desc, template, solution, tb, "\n".join(expected))

        module = f"comparator_{width}bit"
        desc = f"Design a {width}-bit unsigned comparator.\\n\\nRequired module:\\nmodule {module}(input [{width - 1}:0] a, input [{width - 1}:0] b, output gt, output eq, output lt);"
        template = f"module {module}(input [{width - 1}:0] a, input [{width - 1}:0] b, output gt, output eq, output lt);\\n  // Write your code here\\n\\nendmodule"
        solution = f"module {module}(input [{width - 1}:0] a, input [{width - 1}:0] b, output gt, output eq, output lt);\n  assign gt = a > b;\n  assign eq = a == b;\n  assign lt = a < b;\nendmodule"
        vectors = []
        expected = []
        for a, b in tests:
            vectors.append((f"a = {width}'b{bits(a, width)}; b = {width}'b{bits(b, width)};", "%b %b %b %b %b", "a, b, gt, eq, lt"))
            expected.append(f"{bits(a, width)} {bits(b, width)} {int(a > b)} {int(a == b)} {int(a < b)}")
        tb = combinational_tb(module, f"  reg [{width - 1}:0] a, b;\n  wire gt, eq, lt;", ".a(a), .b(b), .gt(gt), .eq(eq), .lt(lt)", vectors)
        write_problem(module, f"{width}-bit Comparator", "Medium", ["combinational", "comparison"], desc, template, solution, tb, "\n".join(expected))


def seed_muxes_decoders_shifters():
    for width in [1, 2, 4, 8, 16]:
        module = f"mux2_{width}bit"
        desc = f"Design a {width}-bit 2:1 multiplexer.\\n\\nRequired module:\\nmodule {module}(input [{width - 1}:0] a, input [{width - 1}:0] b, input sel, output [{width - 1}:0] y);"
        template = f"module {module}(input [{width - 1}:0] a, input [{width - 1}:0] b, input sel, output [{width - 1}:0] y);\\n  // Write your code here\\n\\nendmodule"
        solution = f"module {module}(input [{width - 1}:0] a, input [{width - 1}:0] b, input sel, output [{width - 1}:0] y);\n  assign y = sel ? b : a;\nendmodule"
        tests = [(0, (1 << width) - 1, 0), (0, (1 << width) - 1, 1), (1, 2, 0), (1, 2, 1)]
        vectors = []
        expected = []
        for a, b, sel in tests:
            y = b if sel else a
            vectors.append((f"a = {width}'b{bits(a, width)}; b = {width}'b{bits(b, width)}; sel = {sel};", "%b %b %b %b", "a, b, sel, y"))
            expected.append(f"{bits(a, width)} {bits(b, width)} {sel} {bits(y, width)}")
        tb = combinational_tb(module, f"  reg [{width - 1}:0] a, b;\n  reg sel;\n  wire [{width - 1}:0] y;", ".a(a), .b(b), .sel(sel), .y(y)", vectors)
        write_problem(module, f"{width}-bit 2:1 Mux", "Easy", ["combinational", "mux"], desc, template, solution, tb, "\n".join(expected))

    for width in [4, 8, 16]:
        for direction, expr, fn in [
            ("left", "a << shamt", lambda a, s, w: a << s),
            ("right", "a >> shamt", lambda a, s, w: a >> s),
        ]:
            module = f"shift_{direction}_{width}bit"
            sw = 2 if width <= 4 else 3 if width <= 8 else 4
            desc = f"Shift a {width}-bit input {direction}.\\n\\nRequired module:\\nmodule {module}(input [{width - 1}:0] a, input [{sw - 1}:0] shamt, output [{width - 1}:0] y);"
            template = f"module {module}(input [{width - 1}:0] a, input [{sw - 1}:0] shamt, output [{width - 1}:0] y);\\n  // Write your code here\\n\\nendmodule"
            solution = f"module {module}(input [{width - 1}:0] a, input [{sw - 1}:0] shamt, output [{width - 1}:0] y);\n  assign y = {expr};\nendmodule"
            tests = [(1, 0), (1, 1), ((1 << width) - 1, 1), ((1 << width) // 3, 2), (1 << (width - 1), 3 if width > 4 else 1)]
            vectors = []
            expected = []
            for a, s in tests:
                y = fn(a, s, width)
                vectors.append((f"a = {width}'b{bits(a, width)}; shamt = {sw}'b{bits(s, sw)};", "%b %b %b", "a, shamt, y"))
                expected.append(f"{bits(a, width)} {bits(s, sw)} {bits(y, width)}")
            tb = combinational_tb(module, f"  reg [{width - 1}:0] a;\n  reg [{sw - 1}:0] shamt;\n  wire [{width - 1}:0] y;", ".a(a), .shamt(shamt), .y(y)", vectors)
            write_problem(module, f"{width}-bit Shift {direction.title()}", "Medium", ["combinational", "shift"], desc, template, solution, tb, "\n".join(expected))

    for in_width in [2, 3, 4]:
        out_width = 1 << in_width
        module = f"decoder_{in_width}to{out_width}"
        desc = f"Design a {in_width}-to-{out_width} decoder.\\n\\nRequired module:\\nmodule {module}(input [{in_width - 1}:0] a, output [{out_width - 1}:0] y);"
        template = f"module {module}(input [{in_width - 1}:0] a, output [{out_width - 1}:0] y);\\n  // Write your code here\\n\\nendmodule"
        solution = f"module {module}(input [{in_width - 1}:0] a, output [{out_width - 1}:0] y);\n  assign y = {out_width}'b1 << a;\nendmodule"
        tests = list(range(min(out_width, 8)))
        vectors = []
        expected = []
        for a in tests:
            y = 1 << a
            vectors.append((f"a = {in_width}'b{bits(a, in_width)};", "%b %b", "a, y"))
            expected.append(f"{bits(a, in_width)} {bits(y, out_width)}")
        tb = combinational_tb(module, f"  reg [{in_width - 1}:0] a;\n  wire [{out_width - 1}:0] y;", ".a(a), .y(y)", vectors)
        write_problem(module, f"{in_width}:{out_width} Decoder", "Easy", ["combinational", "decoder"], desc, template, solution, tb, "\n".join(expected))


def seed_sequential():
    for width in [2, 3, 4, 8, 16]:
        module = f"register_{width}bit"
        desc = f"Design a {width}-bit register with load enable and active-high asynchronous reset.\\n\\nRequired module:\\nmodule {module}(input clk, input reset, input load, input [{width - 1}:0] d, output reg [{width - 1}:0] q);"
        template = f"module {module}(input clk, input reset, input load, input [{width - 1}:0] d, output reg [{width - 1}:0] q);\\n  // Write your code here\\n\\nendmodule"
        solution = f"""
module {module}(input clk, input reset, input load, input [{width - 1}:0] d, output reg [{width - 1}:0] q);
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      q <= {width}'b0;
    end else if (load) begin
      q <= d;
    end
  end
endmodule
"""
        v1 = (1 << width) - 1
        v2 = (1 << (width - 1)) if width > 1 else 1
        tb = f"""
`timescale 1ns/1ps
module tb;
  reg clk, reset, load;
  reg [{width - 1}:0] d;
  wire [{width - 1}:0] q;
  {module} dut(.clk(clk), .reset(reset), .load(load), .d(d), .q(q));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    reset = 1; load = 0; d = {width}'b0; #7; $display("%b %b %b %b", reset, load, d, q);
    reset = 0; load = 1; d = {width}'b{bits(v1, width)}; #10; $display("%b %b %b %b", reset, load, d, q);
    load = 0; d = {width}'b{bits(v2, width)}; #10; $display("%b %b %b %b", reset, load, d, q);
    load = 1; d = {width}'b{bits(v2, width)}; #10; $display("%b %b %b %b", reset, load, d, q);
    reset = 1; #3; $display("%b %b %b %b", reset, load, d, q);
    $finish;
  end
endmodule
"""
        expected = "\n".join([
            f"1 0 {bits(0, width)} {bits(0, width)}",
            f"0 1 {bits(v1, width)} {bits(v1, width)}",
            f"0 0 {bits(v2, width)} {bits(v1, width)}",
            f"0 1 {bits(v2, width)} {bits(v2, width)}",
            f"1 1 {bits(v2, width)} {bits(0, width)}",
        ])
        write_problem(module, f"{width}-bit Register", "Medium", ["sequential", "register"], desc, template, solution, tb, expected)

        module = f"counter_up_{width}bit"
        desc = f"Design a {width}-bit up counter with enable and active-high asynchronous reset.\\n\\nRequired module:\\nmodule {module}(input clk, input reset, input enable, output reg [{width - 1}:0] count);"
        template = f"module {module}(input clk, input reset, input enable, output reg [{width - 1}:0] count);\\n  // Write your code here\\n\\nendmodule"
        solution = f"""
module {module}(input clk, input reset, input enable, output reg [{width - 1}:0] count);
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      count <= {width}'b0;
    end else if (enable) begin
      count <= count + {width}'b1;
    end
  end
endmodule
"""
        tb = f"""
`timescale 1ns/1ps
module tb;
  reg clk, reset, enable;
  wire [{width - 1}:0] count;
  {module} dut(.clk(clk), .reset(reset), .enable(enable), .count(count));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    reset = 1; enable = 0; #7; $display("%b %b %b", reset, enable, count);
    reset = 0; enable = 1; #10; $display("%b %b %b", reset, enable, count);
    #10; $display("%b %b %b", reset, enable, count);
    enable = 0; #10; $display("%b %b %b", reset, enable, count);
    enable = 1; #10; $display("%b %b %b", reset, enable, count);
    reset = 1; #3; $display("%b %b %b", reset, enable, count);
    $finish;
  end
endmodule
"""
        expected = "\n".join([
            f"1 0 {bits(0, width)}",
            f"0 1 {bits(1, width)}",
            f"0 1 {bits(2, width)}",
            f"0 0 {bits(2, width)}",
            f"0 1 {bits(3, width)}",
            f"1 1 {bits(0, width)}",
        ])
        write_problem(module, f"{width}-bit Up Counter", "Medium", ["sequential", "counter"], desc, template, solution, tb, expected)


def seed_detectors_muxes_and_bit_ops():
    for width in [1, 2, 3, 4, 8, 16, 32]:
        module = f"buffer_{width}bit"
        desc = f"Pass a {width}-bit input directly to the output.\\n\\nRequired module:\\nmodule {module}(input [{width - 1}:0] a, output [{width - 1}:0] y);"
        template = f"module {module}(input [{width - 1}:0] a, output [{width - 1}:0] y);\\n  // Write your code here\\n\\nendmodule"
        solution = f"module {module}(input [{width - 1}:0] a, output [{width - 1}:0] y);\n  assign y = a;\nendmodule"
        tests = [0, 1, (1 << width) - 1, ((1 << width) * 2) // 3]
        vectors = [(f"a = {width}'b{bits(a, width)};", "%b %b", "a, y") for a in tests]
        expected = "\n".join(f"{bits(a, width)} {bits(a, width)}" for a in tests)
        tb = combinational_tb(module, f"  reg [{width - 1}:0] a;\n  wire [{width - 1}:0] y;", ".a(a), .y(y)", vectors)
        write_problem(module, f"{width}-bit Buffer", "Easy", ["combinational", "bitwise"], desc, template, solution, tb, expected)

    detectors = [
        ("zero_detector", "Zero Detector", "a == 0", lambda a, w: int(a == 0)),
        ("nonzero_detector", "Nonzero Detector", "a != 0", lambda a, w: int(a != 0)),
        ("all_ones_detector", "All Ones Detector", "ALL_ONES", lambda a, w: int(a == (1 << w) - 1)),
    ]
    for detector_id, title, expr_template, fn in detectors:
        for width in [2, 3, 4, 8, 16, 32]:
            module = f"{detector_id}_{width}bit"
            expr = f"a == {{{width}{{1'b1}}}}" if expr_template == "ALL_ONES" else expr_template
            desc = f"Detect a condition on a {width}-bit input.\\n\\nRequired module:\\nmodule {module}(input [{width - 1}:0] a, output y);"
            template = f"module {module}(input [{width - 1}:0] a, output y);\\n  // Write your code here\\n\\nendmodule"
            solution = f"module {module}(input [{width - 1}:0] a, output y);\n  assign y = {expr};\nendmodule"
            tests = [0, 1, (1 << width) - 1, 1 << (width - 1), ((1 << width) * 2) // 3]
            vectors = [(f"a = {width}'b{bits(a, width)};", "%b %b", "a, y") for a in tests]
            expected = "\n".join(f"{bits(a, width)} {fn(a, width)}" for a in tests)
            tb = combinational_tb(module, f"  reg [{width - 1}:0] a;\n  wire y;", ".a(a), .y(y)", vectors)
            write_problem(module, f"{width}-bit {title}", "Easy", ["combinational", "detector"], desc, template, solution, tb, expected)

    for parity_id, title, expr, fn in [
        ("even_parity", "Even Parity", "~^a", lambda a: int(bin(a).count("1") % 2 == 0)),
        ("odd_parity", "Odd Parity", "^a", lambda a: int(bin(a).count("1") % 2 == 1)),
    ]:
        for width in [3, 4, 5, 8, 16, 32]:
            module = f"{parity_id}_{width}bit"
            desc = f"Compute {title.lower()} for a {width}-bit input.\\n\\nRequired module:\\nmodule {module}(input [{width - 1}:0] a, output y);"
            template = f"module {module}(input [{width - 1}:0] a, output y);\\n  // Write your code here\\n\\nendmodule"
            solution = f"module {module}(input [{width - 1}:0] a, output y);\n  assign y = {expr};\nendmodule"
            tests = [0, 1, 3, (1 << width) - 1, ((1 << width) * 2) // 3]
            vectors = [(f"a = {width}'b{bits(a, width)};", "%b %b", "a, y") for a in tests]
            expected = "\n".join(f"{bits(a, width)} {fn(a)}" for a in tests)
            tb = combinational_tb(module, f"  reg [{width - 1}:0] a;\n  wire y;", ".a(a), .y(y)", vectors)
            write_problem(module, f"{width}-bit {title}", "Easy", ["combinational", "parity"], desc, template, solution, tb, expected)

    for op_id, title, expr, fn in [
        ("incrementer", "Incrementer", "a + 1'b1", lambda a, w: a + 1),
        ("decrementer", "Decrementer", "a - 1'b1", lambda a, w: a - 1),
    ]:
        for width in [2, 3, 4, 8, 16, 32]:
            module = f"{op_id}_{width}bit"
            desc = f"Build a {width}-bit {title.lower()}.\\n\\nRequired module:\\nmodule {module}(input [{width - 1}:0] a, output [{width - 1}:0] y);"
            template = f"module {module}(input [{width - 1}:0] a, output [{width - 1}:0] y);\\n  // Write your code here\\n\\nendmodule"
            solution = f"module {module}(input [{width - 1}:0] a, output [{width - 1}:0] y);\n  assign y = {expr};\nendmodule"
            tests = [0, 1, 2, (1 << width) - 1, ((1 << width) * 2) // 3]
            vectors = [(f"a = {width}'b{bits(a, width)};", "%b %b", "a, y") for a in tests]
            expected = "\n".join(f"{bits(a, width)} {bits(fn(a, width), width)}" for a in tests)
            tb = combinational_tb(module, f"  reg [{width - 1}:0] a;\n  wire [{width - 1}:0] y;", ".a(a), .y(y)", vectors)
            write_problem(module, f"{width}-bit {title}", "Easy", ["combinational", "arithmetic"], desc, template, solution, tb, expected)

    for width in [1, 2, 4, 8, 16, 32]:
        module = f"mux4_{width}bit"
        desc = f"Design a {width}-bit 4:1 multiplexer.\\n\\nRequired module:\\nmodule {module}(input [{width - 1}:0] a, input [{width - 1}:0] b, input [{width - 1}:0] c, input [{width - 1}:0] d, input [1:0] sel, output reg [{width - 1}:0] y);"
        template = f"module {module}(input [{width - 1}:0] a, input [{width - 1}:0] b, input [{width - 1}:0] c, input [{width - 1}:0] d, input [1:0] sel, output reg [{width - 1}:0] y);\\n  // Write your code here\\n\\nendmodule"
        solution = f"""
module {module}(input [{width - 1}:0] a, input [{width - 1}:0] b, input [{width - 1}:0] c, input [{width - 1}:0] d, input [1:0] sel, output reg [{width - 1}:0] y);
  always @(*) begin
    case (sel)
      2'b00: y = a;
      2'b01: y = b;
      2'b10: y = c;
      default: y = d;
    endcase
  end
endmodule
"""
        vals = [0, 1, (1 << width) - 1, ((1 << width) * 2) // 3]
        vectors = []
        expected = []
        for sel in range(4):
            vectors.append((f"a = {width}'b{bits(vals[0], width)}; b = {width}'b{bits(vals[1], width)}; c = {width}'b{bits(vals[2], width)}; d = {width}'b{bits(vals[3], width)}; sel = 2'b{bits(sel, 2)};", "%b %b", "sel, y"))
            expected.append(f"{bits(sel, 2)} {bits(vals[sel], width)}")
        tb = combinational_tb(module, f"  reg [{width - 1}:0] a, b, c, d;\n  reg [1:0] sel;\n  wire [{width - 1}:0] y;", ".a(a), .b(b), .c(c), .d(d), .sel(sel), .y(y)", vectors)
        write_problem(module, f"{width}-bit 4:1 Mux", "Medium", ["combinational", "mux"], desc, template, solution, tb, "\n".join(expected))

    for width in [1, 2, 4, 8, 16, 32]:
        for value_id, title, value_expr, value_fn in [
            ("constant_zero", "Constant Zero", f"{width}'b0", 0),
            ("constant_ones", "Constant Ones", f"{{{width}{{1'b1}}}}", (1 << width) - 1),
        ]:
            module = f"{value_id}_{width}bit"
            desc = f"Drive a constant {width}-bit value.\\n\\nRequired module:\\nmodule {module}(output [{width - 1}:0] y);"
            template = f"module {module}(output [{width - 1}:0] y);\\n  // Write your code here\\n\\nendmodule"
            solution = f"module {module}(output [{width - 1}:0] y);\n  assign y = {value_expr};\nendmodule"
            tb = f"""
`timescale 1ns/1ps
module tb;
  wire [{width - 1}:0] y;
  {module} dut(.y(y));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    #5; $display("%b", y);
    $finish;
  end
endmodule
"""
            write_problem(module, f"{width}-bit {title}", "Easy", ["combinational", "constants"], desc, template, solution, tb, bits(value_fn, width))

    for width, indexes in [(4, range(4)), (8, range(8)), (16, range(8)), (32, range(8))]:
        for index in indexes:
            module = f"bit_select_{width}bit_{index}"
            desc = f"Select bit {index} from a {width}-bit input.\\n\\nRequired module:\\nmodule {module}(input [{width - 1}:0] a, output y);"
            template = f"module {module}(input [{width - 1}:0] a, output y);\\n  // Write your code here\\n\\nendmodule"
            solution = f"module {module}(input [{width - 1}:0] a, output y);\n  assign y = a[{index}];\nendmodule"
            tests = [0, 1 << index, (1 << width) - 1, ((1 << width) * 2) // 3]
            vectors = [(f"a = {width}'b{bits(a, width)};", "%b %b", "a, y") for a in tests]
            expected = "\n".join(f"{bits(a, width)} {int(bool(a & (1 << index)))}" for a in tests)
            tb = combinational_tb(module, f"  reg [{width - 1}:0] a;\n  wire y;", ".a(a), .y(y)", vectors)
            write_problem(module, f"Select Bit {index} of {width}", "Easy", ["combinational", "bit-manipulation"], desc, template, solution, tb, expected)

            for op_id, title, expr, fn in [
                ("bit_set", "Set", f"a | ({width}'b1 << {index})", lambda a, i: a | (1 << i)),
                ("bit_clear", "Clear", f"a & ~({width}'b1 << {index})", lambda a, i: a & ~(1 << i)),
                ("bit_toggle", "Toggle", f"a ^ ({width}'b1 << {index})", lambda a, i: a ^ (1 << i)),
            ]:
                module = f"{op_id}_{width}bit_{index}"
                desc = f"{title} bit {index} of a {width}-bit input.\\n\\nRequired module:\\nmodule {module}(input [{width - 1}:0] a, output [{width - 1}:0] y);"
                template = f"module {module}(input [{width - 1}:0] a, output [{width - 1}:0] y);\\n  // Write your code here\\n\\nendmodule"
                solution = f"module {module}(input [{width - 1}:0] a, output [{width - 1}:0] y);\n  assign y = {expr};\nendmodule"
                tests = [0, 1 << index, (1 << width) - 1, ((1 << width) * 2) // 3]
                vectors = [(f"a = {width}'b{bits(a, width)};", "%b %b", "a, y") for a in tests]
                expected = "\n".join(f"{bits(a, width)} {bits(fn(a, index), width)}" for a in tests)
                tb = combinational_tb(module, f"  reg [{width - 1}:0] a;\n  wire [{width - 1}:0] y;", ".a(a), .y(y)", vectors)
                write_problem(module, f"{title} Bit {index} of {width}", "Easy", ["combinational", "bit-manipulation"], desc, template, solution, tb, expected)


def main():
    PROBLEMS_DIR.mkdir(parents=True, exist_ok=True)
    seed_bitwise_binary()
    seed_unary_and_reductions()
    seed_arithmetic_and_compare()
    seed_muxes_decoders_shifters()
    seed_sequential()
    seed_detectors_muxes_and_bit_ops()
    print("Seeded generated problem bank.")


if __name__ == "__main__":
    main()
