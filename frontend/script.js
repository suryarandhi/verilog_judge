const apiBase = '/api';
const progressKey = 'verilogJudgeProgress';
const draftPrefix = 'verilogJudgeDraft:';
const leaderboardKey = 'verilogJudgeLeaderboard';
const streakKey = 'verilogJudgeStreak';
const attemptPrefix = 'verilogJudgeAttempts:';
const hintPrefix = 'verilogJudgeHintLevel:';

let currentUser = null;
let globalLeaderboardCache = [];
let allProblems = [];
let activeProblem = null;
let activeProblemStartedAt = Date.now();
let activeWaveform = null;
let waveformZoom = 1;
let waveformFit = false;
let activeQuizTopic = 'all';
let quizPage = 0;
const quizPageSize = 5;

const trackDefinitions = [
  { title: 'Combinational Logic', match: ['Combinational', 'Datapath'], goal: 'Boolean logic, muxes, decoders, encoders, comparators, and bit manipulation.' },
  { title: 'Sequential Logic', match: ['Sequential'], goal: 'Flip-flops, registers, reset behavior, enables, and clocked state.' },
  { title: 'FSM', match: ['FSM'], goal: 'State encoding, transition logic, output logic, and reset-to-idle patterns.' },
  { title: 'Counters', matchText: ['counter', 'clock-divider'], goal: 'Modulo counters, enables, rollover, timers, and pulse generation.' },
  { title: 'Memories', match: ['Memory'], goal: 'Register files, RAMs, read/write ports, and deterministic output behavior.' },
  { title: 'Arithmetic Circuits', match: ['Arithmetic'], goal: 'Adders, subtractors, flags, carries, overflow, and fixed-width datapaths.' },
  { title: 'Verification', match: ['Verification'], goal: 'Assertions, race fixes, checkers, coverage thinking, and debug practice.' },
];

const dailyChallenges = [
  { title: 'Design MOD-10 Counter', prompt: 'Create a synchronous BCD counter with active-high reset and enable.', topic: 'Counters' },
  { title: 'Handshake Timeout Detector', prompt: 'Assert timeout if ack does not arrive within four clock cycles after req.', topic: 'Verification' },
  { title: 'Parity Protected Register', prompt: 'Store 8-bit data and expose an even-parity error flag.', topic: 'Sequential' },
  { title: 'One-Cycle Valid Pulse', prompt: 'Generate a single-cycle valid pulse on a rising input transition.', topic: 'Sequential' },
  { title: 'MOD-6 Traffic Timer', prompt: 'Build a timer that rolls over after six clock enables.', topic: 'FSM' },
];

const dailyDvConcepts = [
  {
    topic: 'Testbench Architecture',
    concept: 'Separate stimulus, observation, checking, and coverage so each part has one job.',
    interview: 'Explain the difference between a driver, monitor, scoreboard, and coverage collector.',
    practice: 'Draw a block diagram for verifying a FIFO with driver, monitor, scoreboard, and coverage.',
  },
  {
    topic: 'SystemVerilog Randomization',
    concept: 'Constrained random testing explores legal input space without manually writing every vector.',
    interview: 'What is the difference between rand and randc? When can randomize() fail?',
    practice: 'Write a packet class with address, data, write_en, and constraints for aligned addresses.',
  },
  {
    topic: 'Assertions',
    concept: 'Assertions encode protocol rules close to the signal behavior they protect.',
    interview: 'What is the difference between immediate and concurrent assertions?',
    practice: 'Write a property that valid must remain high until ready is seen.',
  },
  {
    topic: 'Functional Coverage',
    concept: 'Coverage answers whether important scenarios happened, not whether the design is correct.',
    interview: 'What are coverpoints, bins, crosses, and illegal_bins?',
    practice: 'Create a coverage plan for an ALU opcode, operand corner values, and overflow flag.',
  },
  {
    topic: 'Scoreboards',
    concept: 'A scoreboard compares observed DUT behavior against a reference model or expected stream.',
    interview: 'How would you handle out-of-order responses in a scoreboard?',
    practice: 'Write pseudocode for a scoreboard that checks read data from a small memory.',
  },
  {
    topic: 'UVM Sequences',
    concept: 'Sequences describe transaction intent; drivers translate those transactions to pins.',
    interview: 'What is the relationship between sequence, sequencer, and driver?',
    practice: 'List three sequences for testing a FIFO: reset, fill-drain, and random burst traffic.',
  },
  {
    topic: 'Debug Strategy',
    concept: 'Good DV debug narrows failure from symptom to transaction to signal to root cause.',
    interview: 'Your random test fails after 2000 cycles. What do you inspect first?',
    practice: 'Add one log message each at generator, driver, monitor, and scoreboard boundaries.',
  },
];

const verificationItems = [
  'Assertion practice: write properties for reset, hold, and handshake behavior.',
  'UVM quiz: drivers, monitors, sequencers, scoreboards, and phases.',
  'Constrained-random questions: ranges, distributions, and legal packet generation.',
  'Coverage questions: coverpoints, bins, crosses, and closure strategy.',
  'Bug fixing challenges: race conditions, reset polarity, memory arbitration, and priority logic.',
  'Multi-HDL roadmap: Verilog now, SystemVerilog module support next.',
];

const quizQuestions = [
  {
    topic: 'SystemVerilog',
    question: 'Which block is preferred for combinational logic in SystemVerilog?',
    choices: ['always_comb', 'always_ff', 'initial'],
    answer: 'always_comb',
  },
  {
    topic: 'UVM',
    question: 'Which UVM component compares expected and observed transactions?',
    choices: ['scoreboard', 'driver', 'sequencer'],
    answer: 'scoreboard',
  },
  {
    topic: 'Coverage',
    question: 'What captures whether important value ranges were exercised?',
    choices: ['coverpoint', 'mailbox', 'modport'],
    answer: 'coverpoint',
  },
  {
    topic: 'SystemVerilog',
    question: 'Which block is intended for edge-triggered registers?',
    choices: ['always_ff', 'always_comb', 'assign'],
    answer: 'always_ff',
  },
  {
    topic: 'UVM',
    question: 'Which component converts sequence items into pin-level activity?',
    choices: ['driver', 'scoreboard', 'subscriber'],
    answer: 'driver',
  },
  {
    topic: 'Assertions',
    question: 'Which implication checks that a consequent follows on the next sampled cycle?',
    choices: ['|=>', '|->', 'inside'],
    answer: '|=>',
  },
  {
    topic: 'SystemVerilog',
    question: 'Which data type is 4-state and commonly used for RTL signals?',
    choices: ['logic', 'bit', 'byte unsigned'],
    answer: 'logic',
  },
  {
    topic: 'SystemVerilog',
    question: 'Which keyword marks a class property for constrained randomization?',
    choices: ['rand', 'coverpoint', 'virtual'],
    answer: 'rand',
  },
  {
    topic: 'SystemVerilog',
    question: 'Which construct connects a testbench to DUT signals with direction rules?',
    choices: ['interface modport', 'package import', 'typedef enum'],
    answer: 'interface modport',
  },
  {
    topic: 'SystemVerilog',
    question: 'What does a virtual interface let a class-based testbench access?',
    choices: ['DUT interface signals', 'compile options', 'coverage database'],
    answer: 'DUT interface signals',
  },
  {
    topic: 'SystemVerilog',
    question: 'Which assignment style is preferred inside always_ff?',
    choices: ['non-blocking <=', 'blocking =', 'continuous assign'],
    answer: 'non-blocking <=',
  },
  {
    topic: 'Assertions',
    question: 'In SVA, which implication checks overlapping same-cycle behavior?',
    choices: ['|->', '|=>', '##'],
    answer: '|->',
  },
  {
    topic: 'Assertions',
    question: 'Which operator delays a sequence by a number of clock ticks?',
    choices: ['##', 'inside', 'dist'],
    answer: '##',
  },
  {
    topic: 'Coverage',
    question: 'Which construct measures combinations of two or more coverpoints?',
    choices: ['cross', 'bins', 'sequence'],
    answer: 'cross',
  },
  {
    topic: 'Coverage',
    question: 'Which bins mark values that should never occur?',
    choices: ['illegal_bins', 'ignore_bins', 'auto bins'],
    answer: 'illegal_bins',
  },
  {
    topic: 'UVM',
    question: 'Which UVM port commonly broadcasts observed transactions from a monitor?',
    choices: ['analysis_port', 'seq_item_port', 'blocking_put_port'],
    answer: 'analysis_port',
  },
  {
    topic: 'UVM',
    question: 'Which phase is commonly used to create components and fetch configuration?',
    choices: ['build_phase', 'run_phase', 'extract_phase'],
    answer: 'build_phase',
  },
  {
    topic: 'UVM',
    question: 'What keeps a UVM run_phase alive while stimulus is active?',
    choices: ['objections', 'covergroups', 'type overrides'],
    answer: 'objections',
  },
  {
    topic: 'Interview',
    question: 'A FIFO should not accept writes when full. What should you add?',
    choices: ['Assertion plus full-condition tests', 'Only waveform viewing', 'Only code comments'],
    answer: 'Assertion plus full-condition tests',
  },
  {
    topic: 'Interview',
    question: 'What is the main purpose of a scoreboard?',
    choices: ['Compare expected and observed behavior', 'Drive clock signals', 'Generate random seeds'],
    answer: 'Compare expected and observed behavior',
  },
  {
    topic: 'SystemVerilog',
    question: 'Which type is 2-state and can improve testbench simulation speed?',
    choices: ['bit', 'logic', 'reg'],
    answer: 'bit',
  },
  {
    topic: 'SystemVerilog',
    question: 'Which access keyword restricts a class member to the class where it is declared?',
    choices: ['local', 'virtual', 'pure'],
    answer: 'local',
  },
  {
    topic: 'SystemVerilog',
    question: 'Which keyword allows a subclass to override a method polymorphically?',
    choices: ['virtual', 'static', 'randc'],
    answer: 'virtual',
  },
  {
    topic: 'SystemVerilog',
    question: 'Which collection grows and shrinks dynamically by index?',
    choices: ['dynamic array', 'packed vector', 'enum'],
    answer: 'dynamic array',
  },
  {
    topic: 'SystemVerilog',
    question: 'Which collection is best for sparse lookup by arbitrary key?',
    choices: ['associative array', 'queue', 'packed array'],
    answer: 'associative array',
  },
  {
    topic: 'SystemVerilog',
    question: 'Which queue method removes the first element?',
    choices: ['pop_front()', 'push_back()', 'delete()'],
    answer: 'pop_front()',
  },
  {
    topic: 'SystemVerilog',
    question: 'Which construct defines named values for readable states?',
    choices: ['enum', 'mailbox', 'clocking block'],
    answer: 'enum',
  },
  {
    topic: 'SystemVerilog',
    question: 'Which construct helps avoid testbench/DUT race timing on signal access?',
    choices: ['clocking block', 'typedef', 'constraint block'],
    answer: 'clocking block',
  },
  {
    topic: 'SystemVerilog',
    question: 'Which mechanism passes transactions safely between processes?',
    choices: ['mailbox', 'modport', 'coverpoint'],
    answer: 'mailbox',
  },
  {
    topic: 'SystemVerilog',
    question: 'Which process-control method starts parallel threads and waits for all?',
    choices: ['fork...join', 'fork...join_none', 'disable fork only'],
    answer: 'fork...join',
  },
  {
    topic: 'Randomization',
    question: 'Which random variable cycles through all values before repeating?',
    choices: ['randc', 'rand', 'static'],
    answer: 'randc',
  },
  {
    topic: 'Randomization',
    question: 'Which method is called automatically before randomize solves constraints?',
    choices: ['pre_randomize()', 'post_randomize()', 'sample()'],
    answer: 'pre_randomize()',
  },
  {
    topic: 'Randomization',
    question: 'Which method is called after successful randomization?',
    choices: ['post_randomize()', 'build_phase()', 'write()'],
    answer: 'post_randomize()',
  },
  {
    topic: 'Randomization',
    question: 'Which operator gives weighted random choices?',
    choices: ['dist', 'inside', 'throughout'],
    answer: 'dist',
  },
  {
    topic: 'Randomization',
    question: 'Which constraint limits a variable to a set or range?',
    choices: ['inside', 'bins', 'iff'],
    answer: 'inside',
  },
  {
    topic: 'Assertions',
    question: 'Where are concurrent assertions sampled?',
    choices: ['On a clocking event', 'Only at time 0', 'Only after simulation ends'],
    answer: 'On a clocking event',
  },
  {
    topic: 'Assertions',
    question: 'Which keyword disables an assertion during reset?',
    choices: ['disable iff', 'ignore_bins', 'randcase'],
    answer: 'disable iff',
  },
  {
    topic: 'Assertions',
    question: 'Which repetition means consecutive repetition in SVA?',
    choices: ['[*]', '[=]', '[->]'],
    answer: '[*]',
  },
  {
    topic: 'Assertions',
    question: 'Which property checks that req eventually sees ack within 3 cycles?',
    choices: ['req |-> ##[1:3] ack', 'req ##0 ack forever', 'ack |-> req[*0]'],
    answer: 'req |-> ##[1:3] ack',
  },
  {
    topic: 'Assertions',
    question: 'Which SVA function detects a rising edge?',
    choices: ['$rose()', '$fell()', '$stable()'],
    answer: '$rose()',
  },
  {
    topic: 'Assertions',
    question: 'Which SVA function checks a signal did not change?',
    choices: ['$stable()', '$past()', '$onehot0()'],
    answer: '$stable()',
  },
  {
    topic: 'Coverage',
    question: 'Which method records a covergroup sample manually?',
    choices: ['sample()', 'randomize()', 'write()'],
    answer: 'sample()',
  },
  {
    topic: 'Coverage',
    question: 'Which keyword excludes values from coverage calculation?',
    choices: ['ignore_bins', 'illegal_bins', 'randc'],
    answer: 'ignore_bins',
  },
  {
    topic: 'Coverage',
    question: 'What does functional coverage measure?',
    choices: ['Scenarios exercised', 'Lines executed only', 'Gate delay only'],
    answer: 'Scenarios exercised',
  },
  {
    topic: 'Coverage',
    question: 'Which coverage is produced automatically by tools from executed HDL lines?',
    choices: ['Code coverage', 'Functional coverage', 'Scoreboard coverage'],
    answer: 'Code coverage',
  },
  {
    topic: 'Coverage',
    question: 'What is a coverage hole?',
    choices: ['A planned scenario not yet exercised', 'A syntax error', 'A reset value'],
    answer: 'A planned scenario not yet exercised',
  },
  {
    topic: 'UVM',
    question: 'Which macro registers a component with the factory?',
    choices: ['`uvm_component_utils', '`uvm_object_utils', '`include'],
    answer: '`uvm_component_utils',
  },
  {
    topic: 'UVM',
    question: 'Which macro registers a transaction object with the factory?',
    choices: ['`uvm_object_utils', '`uvm_component_utils', '`timescale'],
    answer: '`uvm_object_utils',
  },
  {
    topic: 'UVM',
    question: 'Which phase contains time-consuming stimulus?',
    choices: ['run_phase', 'build_phase', 'connect_phase'],
    answer: 'run_phase',
  },
  {
    topic: 'UVM',
    question: 'Which phase connects analysis ports and TLM connections?',
    choices: ['connect_phase', 'build_phase', 'report_phase'],
    answer: 'connect_phase',
  },
  {
    topic: 'UVM',
    question: 'Which UVM object usually represents one bus operation?',
    choices: ['sequence_item', 'scoreboard', 'env'],
    answer: 'sequence_item',
  },
  {
    topic: 'UVM',
    question: 'Which method sends a sequence item from sequence to sequencer?',
    choices: ['start_item/finish_item', 'sample/write', 'raise/drop'],
    answer: 'start_item/finish_item',
  },
  {
    topic: 'UVM',
    question: 'Which database shares virtual interfaces and config objects?',
    choices: ['uvm_config_db', 'mailbox', 'covergroup'],
    answer: 'uvm_config_db',
  },
  {
    topic: 'UVM',
    question: 'Which mechanism changes a component/object type without editing the testbench hierarchy?',
    choices: ['factory override', 'clocking block', 'modport'],
    answer: 'factory override',
  },
  {
    topic: 'UVM',
    question: 'Which component groups driver, sequencer, and monitor?',
    choices: ['agent', 'scoreboard', 'sequence item'],
    answer: 'agent',
  },
  {
    topic: 'Interview',
    question: 'How do you verify reset behavior?',
    choices: ['Assert reset, check known state, then resume traffic', 'Only inspect source code', 'Skip reset in random tests'],
    answer: 'Assert reset, check known state, then resume traffic',
  },
  {
    topic: 'Interview',
    question: 'What should you do when a random failure is not reproducible?',
    choices: ['Capture seed and rerun with same seed', 'Delete the test', 'Increase clock speed'],
    answer: 'Capture seed and rerun with same seed',
  },
  {
    topic: 'Interview',
    question: 'What is the difference between monitor and driver?',
    choices: ['Driver drives pins; monitor observes pins', 'Monitor drives pins; driver compares data', 'Both only generate coverage'],
    answer: 'Driver drives pins; monitor observes pins',
  },
  {
    topic: 'Interview',
    question: 'Why use constrained random instead of only directed tests?',
    choices: ['To explore many legal scenarios with less manual effort', 'To avoid checking results', 'To remove assertions'],
    answer: 'To explore many legal scenarios with less manual effort',
  },
  {
    topic: 'Interview',
    question: 'What is a reference model?',
    choices: ['A simpler expected-behavior model used by the scoreboard', 'A waveform file', 'A synthesis report'],
    answer: 'A simpler expected-behavior model used by the scoreboard',
  },
  {
    topic: 'Interview',
    question: 'What is the first thing to check for X propagation?',
    choices: ['Reset, uninitialized registers, and incomplete assignments', 'Only clock frequency', 'Only comments'],
    answer: 'Reset, uninitialized registers, and incomplete assignments',
  },
  {
    topic: 'Protocols',
    question: 'In valid/ready protocol, when does transfer occur?',
    choices: ['When valid and ready are both high', 'When valid is low', 'Only on reset'],
    answer: 'When valid and ready are both high',
  },
  {
    topic: 'Protocols',
    question: 'Which rule is common for valid/ready sources?',
    choices: ['Hold valid/data stable until accepted', 'Drop valid before ready', 'Change data every delta cycle'],
    answer: 'Hold valid/data stable until accepted',
  },
  {
    topic: 'Protocols',
    question: 'For an arbiter, which property checks no two grants are high?',
    choices: ['$onehot0(grant)', '$stable(req)', '$rose(clk)'],
    answer: '$onehot0(grant)',
  },
  {
    topic: 'Protocols',
    question: 'For FIFO verification, which pair of errors is most important?',
    choices: ['Read empty and write full', 'Only opcode decode', 'Only package imports'],
    answer: 'Read empty and write full',
  },
];

quizQuestions.push(...buildExpandedQuizQuestions());
shuffleInitialQuizQuestions();
validateQuizBank();

function shuffleInitialQuizQuestions() {
  quizQuestions.forEach((quiz) => {
    quiz.choices = shuffleQuizChoices(quiz.choices, quiz.question);
  });
}

function buildExpandedQuizQuestions() {
  const questions = [];
  const add = (topic, question, answer, distractors) => {
    questions.push({ topic, question, choices: shuffleQuizChoices([answer, ...distractors], question), answer });
  };

  const svFacts = [
    ['always_comb', 'model combinational procedural logic', ['always_ff', 'initial']],
    ['always_latch', 'model intentional latch behavior', ['always_comb', 'assign']],
    ['always_ff', 'model edge-triggered sequential logic', ['always_latch', 'initial']],
    ['logic', 'declare a 4-state signal usable by procedural assignments', ['bit', 'shortint']],
    ['bit', 'declare a 2-state scalar or vector', ['logic', 'tri']],
    ['enum', 'create named values for states or opcodes', ['mailbox', 'interface']],
    ['struct', 'group fields into one composite value', ['modport', 'coverpoint']],
    ['union', 'view the same storage through multiple field layouts', ['queue', 'sequence']],
    ['package', 'share typedefs, parameters, and classes across files', ['program', 'clocking']],
    ['import', 'bring package symbols into scope', ['export DPI', 'bind']],
    ['typedef', 'create an alias for a type', ['parameter', 'generate']],
    ['interface', 'bundle related DUT pins and tasks together', ['class', 'covergroup']],
    ['modport', 'declare signal directions for an interface user', ['mailbox', 'property']],
    ['clocking block', 'control testbench sampling and driving timing', ['enum', 'dist']],
    ['virtual interface', 'let a class handle access interface signals', ['packed struct', 'localparam']],
    ['class', 'define object-oriented testbench data and behavior', ['module', 'nettype']],
    ['extends', 'derive a subclass from a base class', ['inside', 'bins']],
    ['super', 'call base-class methods or constructors', ['this', 'static']],
    ['this', 'refer to the current object handle', ['super', 'global']],
    ['new', 'construct a class object', ['randomize', 'sample']],
    ['virtual', 'enable method dispatch through a base-class handle', ['local', 'randc']],
    ['pure virtual', 'declare a method that subclasses must implement', ['static local', 'automatic rand']],
    ['static', 'share a class member across all objects of that class', ['automatic', 'protected']],
    ['local', 'hide a class member from subclasses and external users', ['virtual', 'rand']],
    ['protected', 'allow subclasses to access a class member', ['localparam', 'wire']],
    ['mailbox', 'pass transactions between concurrent processes', ['modport', 'covergroup']],
    ['semaphore', 'control access to a shared testbench resource', ['enum', 'clocking block']],
    ['event', 'synchronize processes with trigger/wait behavior', ['dist', 'coverpoint']],
    ['fork...join', 'start parallel threads and wait for all to finish', ['fork...join_none', 'disable iff']],
    ['fork...join_any', 'start parallel threads and wait for one to finish', ['fork...join', 'foreach']],
    ['fork...join_none', 'start parallel threads without waiting', ['fork...join_any', 'wait fork']],
    ['disable fork', 'terminate active child forked processes', ['break fork', 'kill join']],
    ['automatic', 'give a task or function stack-based storage per call', ['static', 'local']],
    ['ref', 'pass an argument by reference', ['input', 'local']],
    ['const ref', 'pass a read-only argument by reference', ['output', 'randc']],
    ['queue', 'store an ordered variable-size collection', ['packed vector', 'enum']],
    ['dynamic array', 'allocate an indexed array size at run time', ['associative array', 'modport']],
    ['associative array', 'store sparse values indexed by arbitrary keys', ['queue', 'packed array']],
    ['foreach', 'iterate over arrays and queues cleanly', ['forever', 'generate']],
    ['unique case', 'request checking for overlapping or missing case items', ['casex', 'priority if']],
    ['priority case', 'express priority selection intent', ['randomize case', 'cover case']],
    ['inside', 'check membership in a set or range', ['dist', 'throughout']],
    ['casez', 'treat z or ? bits as wildcards in case items', ['case', 'casex']],
    ['signed', 'interpret a vector as a signed value', ['unsigned', 'packed']],
    ['$bits', 'return the bit width of a type or expression', ['$size', '$countones']],
    ['$clog2', 'compute ceiling log base 2 for sizing', ['$rose', '$sampled']],
    ['$cast', 'safely cast enum or class handle values', ['$bits', '$fatal']],
    ['$isunknown', 'detect x or z bits in an expression', ['$onehot', '$past']],
    ['$onehot', 'check exactly one bit is high', ['$onehot0', '$stable']],
    ['$onehot0', 'check zero or one bit is high', ['$onehot', '$rose']],
  ];

  svFacts.forEach(([answer, purpose, distractors]) => {
    add('SystemVerilog', `Which SystemVerilog construct is used to ${purpose}?`, answer, distractors);
  });

  const randomFacts = [
    ['rand', 'declare a variable that the solver may randomize', ['randc', 'coverpoint']],
    ['randc', 'cycle through random values before repeating', ['rand', 'static']],
    ['constraint', 'declare rules for legal randomized values', ['covergroup', 'property']],
    ['randomize()', 'invoke the constraint solver for an object', ['sample()', 'write()']],
    ['pre_randomize()', 'run code immediately before solving constraints', ['post_randomize()', 'build_phase()']],
    ['post_randomize()', 'run code immediately after successful randomization', ['pre_randomize()', 'connect_phase()']],
    ['dist', 'assign weighted probabilities to random choices', ['inside', 'intersect']],
    ['soft constraint', 'provide a default rule that can be overridden', ['hard assign', 'illegal bin']],
    ['constraint_mode(0)', 'disable a constraint block', ['rand_mode(1)', 'sample(0)']],
    ['rand_mode(0)', 'disable randomization for a variable', ['constraint_mode(1)', 'drop_objection']],
    ['solve before', 'influence solve ordering between random variables', ['before solve', 'ordered rand']],
    ['std::randomize', 'randomize variables without requiring a class object', ['uvm_do', 'covergroup::sample']],
    ['inline constraint', 'add temporary constraints in a randomize() call', ['static constraint', 'cover option']],
    ['randomize() returns 0', 'detect that constraints could not be solved', ['randomize() returns x', 'sample() returns 0']],
    ['unique values constraint', 'prevent duplicate choices across array elements', ['default clocking', 'analysis export']],
    ['foreach constraint', 'apply a rule to each element of an array', ['forever constraint', 'generate bin']],
  ];

  randomFacts.forEach(([answer, purpose, distractors]) => {
    add('Randomization', `Which randomization feature is used to ${purpose}?`, answer, distractors);
  });

  const assertionFacts = [
    ['assert property', 'check a concurrent property during simulation', ['covergroup', 'randcase']],
    ['assume property', 'constrain legal environment behavior in formal or assertion context', ['ignore_bins', 'uvm_config_db']],
    ['cover property', 'record that a temporal behavior occurred', ['coverpoint', 'post_randomize']],
    ['property', 'name a reusable temporal rule', ['package', 'modport']],
    ['sequence', 'name a reusable temporal pattern', ['class', 'mailbox']],
    ['disable iff', 'turn off an assertion during reset or invalid sampling', ['ignore_bins', 'rand_mode']],
    ['|->', 'express overlapping implication', ['|=>', '##']],
    ['|=>', 'express non-overlapping implication', ['|->', 'throughout']],
    ['##1', 'delay one clock tick in a sequence', ['#1', '@1']],
    ['##[1:3]', 'allow a delay range of one to three clock ticks', ['#[1:3]', '[*1:3]']],
    ['[*3]', 'require consecutive repetition three times', ['[=3]', '[->3]']],
    ['throughout', 'require an expression to hold for an entire sequence', ['inside', 'dist']],
    ['intersect', 'require two sequences to match over the same interval', ['inside', 'randc']],
    ['first_match', 'choose the earliest matching sequence instance', ['priority case', 'unique0']],
    ['$past()', 'sample a signal value from a prior clock', ['$rose()', '$bits()']],
    ['$rose()', 'detect a 0-to-1 sampled transition', ['$fell()', '$stable()']],
    ['$fell()', 'detect a 1-to-0 sampled transition', ['$rose()', '$changed()']],
    ['$stable()', 'check that a sampled value did not change', ['$past()', '$onehot()']],
    ['$changed()', 'check that a sampled value changed', ['$stable()', '$isunknown()']],
    ['$sampled()', 'refer to the sampled value in assertion action code', ['$cast()', '$clog2()']],
  ];

  assertionFacts.forEach(([answer, purpose, distractors]) => {
    add('Assertions', `Which SVA feature is used to ${purpose}?`, answer, distractors);
  });

  const propertyPatterns = [
    ['valid must stay high until ready', 'valid && !ready |=> valid', ['valid |-> ready', 'ready |-> !valid']],
    ['request should be acknowledged within 1 to 4 cycles', 'req |-> ##[1:4] ack', ['ack |-> ##[1:4] req', 'req ##0 ack forever']],
    ['grant should be zero-or-one-hot', '$onehot0(grant)', ['$stable(grant)', '$rose(grant)']],
    ['output should not contain x or z', '!$isunknown(out)', ['$changed(out)', '$past(out)']],
    ['data should hold while stalled', 'valid && !ready |=> $stable(data)', ['ready |=> $changed(data)', 'valid |-> $rose(data)']],
    ['reset should clear state on the next sampled cycle', 'rst |=> state == IDLE', ['state == IDLE |=> rst', 'rst |-> $changed(state)']],
    ['write must not happen when full', 'full |-> !wr_en', ['wr_en |-> full', 'full |-> rd_en']],
    ['read must not happen when empty', 'empty |-> !rd_en', ['rd_en |-> empty', 'empty |-> wr_en']],
    ['ack should only occur after a request', 'ack |-> $past(req)', ['req |-> $past(ack)', 'ack |-> $rose(clk)']],
    ['signal should rise only when enable is high', '$rose(sig) |-> en', ['en |-> $rose(sig)', '$fell(sig) |-> en']],
  ];

  propertyPatterns.forEach(([scenario, answer, distractors]) => {
    add('Assertions', `Which assertion best checks: ${scenario}?`, answer, distractors);
  });

  const coverageFacts = [
    ['covergroup', 'define a functional coverage model', ['property', 'sequence']],
    ['coverpoint', 'measure values of one expression', ['analysis_port', 'mailbox']],
    ['bins', 'define named value buckets for a coverpoint', ['randc', 'objections']],
    ['cross', 'measure combinations of coverpoints', ['inside', 'factory']],
    ['ignore_bins', 'exclude values from coverage goals', ['illegal_bins', 'auto bins']],
    ['illegal_bins', 'flag values that should not occur', ['ignore_bins', 'soft bins']],
    ['sample()', 'manually sample a covergroup', ['randomize()', 'write()']],
    ['iff', 'sample coverage only when a condition is true', ['disable iff', 'dist']],
    ['option.per_instance', 'track coverage separately for each covergroup instance', ['option.weight', 'rand_mode']],
    ['option.goal', 'set the target percentage for a covergroup', ['option.seed', 'option.phase']],
    ['auto bins', 'tool-created bins for uncovered value ranges', ['illegal bins only', 'mailbox bins']],
    ['transition bin', 'cover value changes over time', ['cross bin', 'wildcard import']],
    ['wildcard bins', 'allow wildcard bits in coverage values', ['queue bins', 'factory bins']],
    ['coverage closure', 'the process of explaining and closing coverage holes', ['reset sequencing', 'compile ordering']],
    ['code coverage', 'measure executed HDL structure such as lines and branches', ['functional coverage', 'scoreboard compare']],
    ['functional coverage', 'measure planned behavior and scenarios', ['line coverage only', 'syntax coverage']],
  ];

  coverageFacts.forEach(([answer, purpose, distractors]) => {
    add('Coverage', `Which coverage concept is used to ${purpose}?`, answer, distractors);
  });

  const uvmFacts = [
    ['uvm_sequence_item', 'represent one transaction sent through an agent', ['uvm_scoreboard', 'uvm_env']],
    ['uvm_sequence', 'generate ordered transaction streams', ['uvm_driver', 'uvm_monitor']],
    ['uvm_sequencer', 'arbitrate sequences and provide items to a driver', ['uvm_subscriber', 'uvm_reg']],
    ['uvm_driver', 'convert sequence items into pin-level activity', ['uvm_monitor', 'uvm_agent']],
    ['uvm_monitor', 'observe pins and publish transactions', ['uvm_driver', 'uvm_sequence']],
    ['uvm_agent', 'group sequencer, driver, and monitor', ['uvm_test', 'uvm_factory']],
    ['uvm_scoreboard', 'compare expected and observed transactions', ['uvm_driver', 'uvm_config_db']],
    ['uvm_env', 'hold agents, scoreboards, and shared verification components', ['uvm_sequence_item', 'uvm_phase']],
    ['uvm_test', 'configure the environment and start top-level sequences', ['uvm_monitor', 'uvm_port']],
    ['analysis_port', 'broadcast transactions from a producer', ['seq_item_port', 'config_db']],
    ['analysis_export', 'receive analysis transactions through an implementation connection', ['seq_item_export', 'raise_objection']],
    ['uvm_subscriber', 'receive transactions and often sample coverage', ['uvm_driver', 'uvm_reg_block']],
    ['uvm_config_db', 'pass virtual interfaces and configuration objects', ['mailbox', 'covergroup']],
    ['factory override', 'swap implementations without changing hierarchy code', ['clocking block', 'bind']],
    ['build_phase', 'create components and fetch configuration', ['run_phase', 'extract_phase']],
    ['connect_phase', 'connect TLM ports and exports', ['report_phase', 'final_phase']],
    ['run_phase', 'execute time-consuming stimulus and checking', ['build_phase', 'end_of_elaboration_phase']],
    ['check_phase', 'perform end-of-test consistency checks', ['build_phase', 'connect_phase']],
    ['report_phase', 'summarize results after simulation activity', ['main_phase', 'reset_phase']],
    ['raise_objection', 'keep a UVM phase from ending', ['drop_objection', 'uvm_info']],
    ['drop_objection', 'allow a phase to end when work is done', ['raise_objection', 'uvm_error']],
    ['`uvm_component_utils', 'register a component with the factory', ['`uvm_object_utils', '`include']],
    ['`uvm_object_utils', 'register a sequence item or object with the factory', ['`uvm_component_utils', '`timescale']],
    ['start_item/finish_item', 'send sequence items through a sequencer', ['sample/write', 'raise/drop']],
    ['seq_item_port', 'let a driver pull items from a sequencer', ['analysis_port', 'config_db']],
  ];

  uvmFacts.forEach(([answer, purpose, distractors]) => {
    add('UVM', `Which UVM concept is used to ${purpose}?`, answer, distractors);
  });

  const interviewFacts = [
    ['Reproduce with the same seed and inspect the first failing transaction', 'random regression fails once overnight', ['Delete the failing seed', 'Only rerun without logs']],
    ['Check reset sequencing and uninitialized state first', 'outputs show x values after reset', ['Increase coverage goal', 'Disable assertions']],
    ['Add directed full and empty boundary tests plus assertions', 'verifying a FIFO', ['Only randomize data values', 'Only check line coverage']],
    ['Use a reference model in the scoreboard', 'checking complex expected output behavior', ['Compare waveform screenshots', 'Skip result checking']],
    ['Monitor observed bus traffic and compare protocol rules', 'debugging a protocol violation', ['Drive more random clocks', 'Remove valid-ready checks']],
    ['Capture transaction logs at generator, driver, monitor, and scoreboard', 'finding where expected and observed streams diverge', ['Only look at final pass/fail', 'Hide timestamps']],
    ['Cross opcode with important operand corner cases', 'building ALU functional coverage', ['Only cover reset', 'Only cover source lines']],
    ['Constrain illegal stimulus and assert illegal DUT responses never happen', 'testing a bus protocol', ['Allow every random value', 'Remove all constraints']],
    ['Use assertions for local temporal rules and scoreboard for end-to-end data correctness', 'choosing checkers', ['Use only coverage', 'Use only print statements']],
    ['Plan features, tests, checks, and coverage before coding', 'starting verification for a new block', ['Start random tests with no plan', 'Wait until RTL is final']],
    ['Use regression results, coverage holes, and bug trends', 'deciding what to test next', ['Pick random files manually', 'Ignore failed seeds']],
    ['Make the failing case smaller while preserving the bug', 'debugging a long random failure', ['Add more unrelated traffic', 'Change all constraints at once']],
    ['Explain remaining uncovered bins with waiver or new tests', 'coverage closure', ['Delete covergroups', 'Claim line coverage is enough']],
    ['Check that the monitor is passive and not driving DUT signals', 'reviewing a verification agent', ['Move driving into monitor', 'Remove interface']],
    ['Keep driver protocol code separate from sequence intent', 'building reusable UVM agents', ['Put pin toggles in every test', 'Put scoreboard in sequence item']],
  ];

  interviewFacts.forEach(([answer, scenario, distractors]) => {
    add('Interview', `What is the best DV response when ${scenario}?`, answer, distractors);
  });

  return questions;
}

function quizHash(value) {
  return String(value).split('').reduce((hash, char) => {
    return ((hash << 5) - hash + char.charCodeAt(0)) | 0;
  }, 0);
}

function shuffleQuizChoices(choices, seedText) {
  const shuffled = [...choices];
  let seed = Math.abs(quizHash(seedText)) || 1;
  for (let index = shuffled.length - 1; index > 0; index -= 1) {
    seed = (seed * 1664525 + 1013904223) >>> 0;
    const swapIndex = seed % (index + 1);
    [shuffled[index], shuffled[swapIndex]] = [shuffled[swapIndex], shuffled[index]];
  }
  return shuffled;
}

function validateQuizBank() {
  const seen = new Set();
  quizQuestions.forEach((quiz, index) => {
    if (!quiz.choices.includes(quiz.answer)) {
      console.warn(`Quiz answer key mismatch at ${index}: ${quiz.question}`);
    }
    const key = `${quiz.topic}:${quiz.question}`;
    if (seen.has(key)) {
      console.warn(`Duplicate quiz question: ${quiz.question}`);
    }
    seen.add(key);
  });
}

async function fetchJson(url, options = {}) {
  const response = await fetch(url, options);
  const data = await response.json();
  if (!response.ok) {
    throw new Error(data.error || 'Request failed');
  }
  return data;
}

async function fetchCurrentUser() {
  try {
    const data = await fetchJson(`${apiBase}/auth/me`);
    currentUser = data.user || null;
  } catch (error) {
    currentUser = null;
  }
  return currentUser;
}

function renderAuthWidget() {
  const widget = document.getElementById('authWidget');
  if (!widget) {
    return;
  }
  if (currentUser) {
    widget.innerHTML = `
      <div class="auth-chip">
        <span class="auth-username">${escapeHtml(currentUser.username)}</span>
        <button id="authLogoutButton" class="auth-link-button" type="button">Log out</button>
      </div>
    `;
    document.getElementById('authLogoutButton')?.addEventListener('click', handleLogout);
  } else {
    widget.innerHTML = `<button id="authSigninButton" class="auth-signin-button" type="button">Sign in</button>`;
    document.getElementById('authSigninButton')?.addEventListener('click', () => openAuthModal('login'));
  }
}

function openAuthModal(initialTab) {
  closeAuthModal();
  const backdrop = document.createElement('div');
  backdrop.className = 'auth-modal-backdrop';
  backdrop.id = 'authModalBackdrop';
  backdrop.innerHTML = `
    <div class="auth-modal" role="dialog" aria-modal="true">
      <div class="auth-modal-tabs">
        <button type="button" data-tab="login">Sign in</button>
        <button type="button" data-tab="register">Create account</button>
      </div>
      <h2 id="authModalTitle">Sign in</h2>
      <form id="authForm">
        <div class="auth-field">
          <label for="authUsername">Username</label>
          <input id="authUsername" name="username" type="text" autocomplete="username" required />
        </div>
        <div class="auth-field">
          <label for="authPassword">Password</label>
          <input id="authPassword" name="password" type="password" autocomplete="current-password" required />
        </div>
        <p id="authError" class="auth-error"></p>
        <div class="auth-modal-actions">
          <button type="button" class="secondary-button" id="authCancelButton">Cancel</button>
          <button type="submit" class="primary-button" id="authSubmitButton">Sign in</button>
        </div>
      </form>
    </div>
  `;
  document.body.appendChild(backdrop);

  const setTab = (tab) => {
    backdrop.querySelectorAll('[data-tab]').forEach((button) => {
      button.classList.toggle('active', button.dataset.tab === tab);
    });
    backdrop.querySelector('#authModalTitle').textContent = tab === 'login' ? 'Sign in' : 'Create account';
    backdrop.querySelector('#authSubmitButton').textContent = tab === 'login' ? 'Sign in' : 'Create account';
    backdrop.querySelector('#authPassword').autocomplete = tab === 'login' ? 'current-password' : 'new-password';
    backdrop.dataset.mode = tab;
    backdrop.querySelector('#authError').textContent = '';
  };
  backdrop.querySelectorAll('[data-tab]').forEach((button) => {
    button.addEventListener('click', () => setTab(button.dataset.tab));
  });
  setTab(initialTab || 'login');

  backdrop.querySelector('#authCancelButton').addEventListener('click', closeAuthModal);
  backdrop.addEventListener('click', (event) => {
    if (event.target === backdrop) {
      closeAuthModal();
    }
  });
  backdrop.querySelector('#authForm').addEventListener('submit', handleAuthSubmit);
}

function closeAuthModal() {
  document.getElementById('authModalBackdrop')?.remove();
}

async function handleAuthSubmit(event) {
  event.preventDefault();
  const backdrop = document.getElementById('authModalBackdrop');
  const mode = backdrop.dataset.mode;
  const username = document.getElementById('authUsername').value.trim();
  const password = document.getElementById('authPassword').value;
  const errorBox = document.getElementById('authError');
  const submitButton = document.getElementById('authSubmitButton');
  errorBox.textContent = '';
  submitButton.disabled = true;

  try {
    const endpoint = mode === 'login' ? 'login' : 'register';
    const data = await fetchJson(`${apiBase}/auth/${endpoint}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ username, password }),
    });
    currentUser = data.user;
    closeAuthModal();
    renderAuthWidget();
    await syncAccountAfterLogin();
  } catch (error) {
    errorBox.textContent = error.message;
  } finally {
    submitButton.disabled = false;
  }
}

async function handleLogout() {
  try {
    await fetchJson(`${apiBase}/auth/logout`, { method: 'POST' });
  } catch (error) {
    // Ignore network errors on logout; clear local state regardless.
  }
  currentUser = null;
  renderAuthWidget();
  if (document.getElementById('problemGrid')) {
    rerenderHome();
  }
}

async function syncAccountAfterLogin() {
  if (!currentUser) {
    return;
  }
  try {
    const [progressData, statsData] = await Promise.all([
      fetchJson(`${apiBase}/me/progress`),
      fetchJson(`${apiBase}/me/stats`),
    ]);
    const localProgress = readProgress();
    Object.entries(progressData.progress || {}).forEach(([problemId, entry]) => {
      if (entry.accepted) {
        localProgress[problemId] = {
          accepted: true,
          acceptedAt: entry.acceptedAt || localProgress[problemId]?.acceptedAt || new Date().toISOString(),
          lastAcceptedAt: entry.lastAcceptedAt || new Date().toISOString(),
        };
      }
    });
    writeProgress(localProgress);

    const stats = statsData.stats || {};
    writeJsonStorage(streakKey, {
      count: stats.streak_count || 0,
      lastDay: stats.last_streak_day || '',
    });
  } catch (error) {
    // Server sync is best-effort; local data stays intact if it fails.
  }
  if (document.getElementById('problemGrid')) {
    rerenderHome();
  }
}

async function syncAcceptedToServer(problemId, result) {
  if (!currentUser) {
    return;
  }
  const code = window.editorInstance?.getValue() || '';
  const problem = activeProblem || allProblems.find((item) => item.id === problemId) || {};
  const codeLines = code.split('\n').filter((line) => line.trim()).length;
  const solveSeconds = Math.max(1, Math.round((Date.now() - activeProblemStartedAt) / 1000));
  const score = Math.max(10, 1000 - solveSeconds - codeLines * 2);
  try {
    await fetchJson(`${apiBase}/progress/accept`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        problem_id: problemId,
        title: problem.title || problemId,
        score,
        code_lines: codeLines,
        solve_seconds: solveSeconds,
        sim_time: result.time_seconds || 0,
      }),
    });
  } catch (error) {
    // Best-effort sync; the local leaderboard already recorded this attempt.
  }
}

async function initAuth() {
  await fetchCurrentUser();
  renderAuthWidget();
  if (currentUser) {
    await syncAccountAfterLogin();
  }
}

function difficultyClass(difficulty) {
  return `difficulty-pill difficulty-${String(difficulty).toLowerCase()}`;
}

function problemHref(problem) {
  return `problem.html?problem=${encodeURIComponent(problem.id)}`;
}

function escapeHtml(value) {
  return String(value ?? '').replace(/[&<>"']/g, (char) => ({
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;',
    '"': '&quot;',
    "'": '&#39;',
  })[char]);
}

function readProgress() {
  try {
    return JSON.parse(localStorage.getItem(progressKey)) || {};
  } catch (error) {
    return {};
  }
}

function writeProgress(progress) {
  localStorage.setItem(progressKey, JSON.stringify(progress));
}

function isSolved(problemId) {
  return Boolean(readProgress()[problemId]?.accepted);
}

function markAccepted(problemId) {
  const progress = readProgress();
  const previous = progress[problemId] || {};
  progress[problemId] = {
    accepted: true,
    acceptedAt: previous.acceptedAt || new Date().toISOString(),
    lastAcceptedAt: new Date().toISOString(),
  };
  writeProgress(progress);
}

function attemptKey(problemId) {
  return `${attemptPrefix}${problemId}`;
}

function hintKey(problemId) {
  return `${hintPrefix}${problemId}`;
}

function readAttempts(problemId) {
  return Number(localStorage.getItem(attemptKey(problemId)) || 0);
}

function incrementAttempts(problemId) {
  const attempts = readAttempts(problemId) + 1;
  localStorage.setItem(attemptKey(problemId), String(attempts));
  return attempts;
}

function solvedCountByDifficulty(difficulty) {
  return allProblems.filter((problem) => problem.difficulty === difficulty && isSolved(problem.id)).length;
}

function isDifficultyUnlocked(difficulty) {
  if (difficulty === 'Easy') {
    return true;
  }
  if (difficulty === 'Medium') {
    return solvedCountByDifficulty('Easy') >= 5;
  }
  if (difficulty === 'Hard') {
    return solvedCountByDifficulty('Medium') >= 10;
  }
  if (difficulty === 'Expert') {
    return solvedCountByDifficulty('Hard') >= 15;
  }
  return true;
}

function unlockMessage(difficulty) {
  if (difficulty === 'Medium') {
    return 'Complete 5 Easy problems to unlock Medium.';
  }
  if (difficulty === 'Hard') {
    return 'Complete 10 Medium problems to unlock Hard.';
  }
  if (difficulty === 'Expert') {
    return 'Complete 15 Hard problems to unlock Expert.';
  }
  return '';
}

function readJsonStorage(key, fallback) {
  try {
    return JSON.parse(localStorage.getItem(key)) || fallback;
  } catch (error) {
    return fallback;
  }
}

function writeJsonStorage(key, value) {
  localStorage.setItem(key, JSON.stringify(value));
}

function draftKey(problemId) {
  return `${draftPrefix}${problemId}`;
}

function difficultyRank(difficulty) {
  return { Easy: 0, Medium: 1, Hard: 2 }[difficulty] ?? 3;
}

function createProblemCard(problem) {
  const element = document.createElement('a');
  const locked = !isDifficultyUnlocked(problem.difficulty);
  element.className = `problem-card${locked ? ' problem-locked' : ''}`;
  element.href = locked ? '#' : problemHref(problem);
  element.dataset.title = problem.title.toLowerCase();
  element.dataset.category = problem.category || 'Combinational';
  element.dataset.difficulty = problem.difficulty || 'Medium';
  element.dataset.status = isSolved(problem.id) ? 'solved' : 'unsolved';
  if (locked) {
    element.addEventListener('click', (event) => event.preventDefault());
  }
  element.innerHTML = `
    <div>
      <div class="card-title-row">
        <h3>${escapeHtml(problem.title)}</h3>
        ${locked ? '<span class="status-pill status-locked">Locked</span>' : isSolved(problem.id) ? '<span class="status-pill status-solved">Accepted</span>' : '<span class="status-pill">Open</span>'}
      </div>
      <div class="card-meta">${escapeHtml(problem.category || 'Combinational')}</div>
      <p>${locked ? unlockMessage(problem.difficulty) : `${escapeHtml(problem.description.slice(0, 130))}${problem.description.length > 130 ? '...' : ''}`}</p>
    </div>
    <span class="${difficultyClass(problem.difficulty)}">${problem.difficulty}</span>
  `;
  return element;
}

function renderProblemList(problems) {
  const list = document.getElementById('problemList');
  const grid = document.getElementById('problemGrid');
  if (!list || !grid) {
    return;
  }

  list.innerHTML = '';
  grid.innerHTML = '';

  problems.forEach((problem) => {
    const locked = !isDifficultyUnlocked(problem.difficulty);
    const navItem = document.createElement('a');
    navItem.className = `problem-nav-item${locked ? ' problem-locked' : ''}`;
    navItem.href = locked ? '#' : problemHref(problem);
    navItem.dataset.title = problem.title.toLowerCase();
    navItem.dataset.category = problem.category || 'Combinational';
    navItem.dataset.difficulty = problem.difficulty || 'Medium';
    navItem.dataset.status = isSolved(problem.id) ? 'solved' : 'unsolved';
    if (locked) {
      navItem.addEventListener('click', (event) => event.preventDefault());
    }
    navItem.innerHTML = `<span>${escapeHtml(problem.title)}</span><span>${locked ? 'Locked' : isSolved(problem.id) ? 'Accepted' : escapeHtml(problem.category || problem.difficulty)}</span>`;
    list.appendChild(navItem);
    grid.appendChild(createProblemCard(problem));
  });

  document.getElementById('problemCount').textContent = problems.length;
  document.getElementById('solvedCount').textContent = problems.filter((problem) => isSolved(problem.id)).length;
}

function renderList(title, items) {
  const listItems = Array.isArray(items) ? items : (items ? [items] : []);
  if (!listItems.length) {
    return '';
  }
  return `
    <section class="statement-section">
      <h2>${title}</h2>
      <ul>${listItems.map((item) => `<li>${escapeHtml(item)}</li>`).join('')}</ul>
    </section>
  `;
}

function renderProblemContent(problem) {
  return `
    <section class="statement-section">
      <h2>Problem</h2>
      <p>${escapeHtml(problem.statement || problem.description || '')}</p>
    </section>
    <section class="statement-section">
      <h2>Required Module</h2>
      <pre class="code-snippet">${escapeHtml(problem.module_signature || '')}</pre>
    </section>
    ${renderList('Behavior', problem.behavior)}
    ${renderList('Constraints', problem.constraints)}
    <section class="statement-section">
      <h2>Example</h2>
      <pre class="code-snippet">${escapeHtml(problem.example || '')}</pre>
    </section>
  `;
}

function applyHomeControls() {
  const query = document.getElementById('searchInput').value.toLowerCase();
  const difficulty = document.getElementById('difficultyFilter').value;
  const category = document.getElementById('categoryFilter').value;
  const status = document.getElementById('statusFilter').value;
  let visibleCount = 0;

  document.querySelectorAll('.problem-card, .problem-nav-item').forEach((item) => {
    const matchesQuery = item.textContent.toLowerCase().includes(query);
    const matchesDifficulty = difficulty === 'all' || item.dataset.difficulty === difficulty;
    const matchesCategory = category === 'all' || item.dataset.category === category;
    const matchesStatus = status === 'all' || item.dataset.status === status;
    const visible = matchesQuery && matchesDifficulty && matchesCategory && matchesStatus;
    item.hidden = !visible;
    if (visible && item.classList.contains('problem-card')) {
      visibleCount += 1;
    }
  });

  const summary = document.getElementById('resultSummary');
  if (summary) {
    summary.textContent = `${visibleCount} of ${allProblems.length} problems shown.`;
  }
}

function sortProblems(problems, mode) {
  return [...problems].sort((left, right) => {
    if (mode === 'difficulty') {
      return difficultyRank(left.difficulty) - difficultyRank(right.difficulty) || left.title.localeCompare(right.title);
    }
    if (mode === 'category') {
      return String(left.category).localeCompare(String(right.category)) || left.title.localeCompare(right.title);
    }
    return left.title.localeCompare(right.title);
  });
}

function populateCategoryFilter(problems) {
  const categoryFilter = document.getElementById('categoryFilter');
  const categories = [...new Set(problems.map((problem) => problem.category || 'Combinational'))].sort();
  categoryFilter.innerHTML = '<option value="all">All categories</option>';
  categories.forEach((category) => {
    const option = document.createElement('option');
    option.value = category;
    option.textContent = category;
    categoryFilter.appendChild(option);
  });
}

function rerenderHome() {
  const sorted = sortProblems(allProblems, document.getElementById('sortSelect').value);
  renderProblemList(sorted);
  applyHomeControls();
  renderTracks();
  renderDailyChallenge();
  renderDailyDvPrep();
  renderLeaderboard();
  renderGlobalLeaderboard();
  renderVerificationLab();
  renderProgressMap();
}

function renderTracks() {
  const trackGrid = document.getElementById('trackGrid');
  if (!trackGrid) {
    return;
  }
  trackGrid.innerHTML = trackDefinitions.map((track) => {
    const problems = allProblems.filter((problem) => {
      const haystack = `${problem.title} ${(problem.tags || []).join(' ')} ${problem.category}`.toLowerCase();
      const categoryMatch = track.match?.includes(problem.category);
      const textMatch = track.matchText?.some((term) => haystack.includes(term));
      return categoryMatch || textMatch;
    });
    const solved = problems.filter((problem) => isSolved(problem.id)).length;
    const percent = problems.length ? Math.round((solved / problems.length) * 100) : 0;
    return `
      <button class="track-card" type="button" data-track="${escapeHtml(track.title)}">
        <span>${escapeHtml(track.title)}</span>
        <small>${solved}/${problems.length} complete</small>
        <span class="progress-bar"><span style="width: ${percent}%"></span></span>
      </button>
    `;
  }).join('');

  trackGrid.querySelectorAll('.track-card').forEach((button) => {
    button.addEventListener('click', () => {
      const track = trackDefinitions.find((item) => item.title === button.dataset.track);
      const categoryFilter = document.getElementById('categoryFilter');
      if (track?.match?.length && [...categoryFilter.options].some((option) => option.value === track.match[0])) {
        categoryFilter.value = track.match[0];
      }
      applyHomeControls();
    });
  });
}

function renderDailyChallenge() {
  const dailyChallenge = document.getElementById('dailyChallenge');
  if (!dailyChallenge) {
    return;
  }
  const dayIndex = Math.floor(Date.now() / 86400000) % dailyChallenges.length;
  const challenge = dailyChallenges[dayIndex];
  dailyChallenge.innerHTML = `
    <div>
      <span class="status-pill status-solved">${escapeHtml(challenge.topic)}</span>
      <h3>${escapeHtml(challenge.title)}</h3>
      <p>${escapeHtml(challenge.prompt)}</p>
    </div>
    <a class="secondary-link" href="problem.html?problem=synchronous_clear_counter">Open practice editor</a>
  `;
}

function renderDailyDvPrep() {
  const dailyDvPrep = document.getElementById('dailyDvPrep');
  if (!dailyDvPrep) {
    return;
  }
  const dayIndex = Math.floor(Date.now() / 86400000) % dailyDvConcepts.length;
  const item = dailyDvConcepts[dayIndex];
  dailyDvPrep.innerHTML = `
    <div>
      <span class="status-pill status-solved">${escapeHtml(item.topic)}</span>
      <h3>${escapeHtml(item.concept)}</h3>
    </div>
    <div class="dv-prep-row">
      <strong>Interview</strong>
      <p>${escapeHtml(item.interview)}</p>
    </div>
    <div class="dv-prep-row">
      <strong>Practice</strong>
      <p>${escapeHtml(item.practice)}</p>
    </div>
  `;
}

function renderLeaderboard() {
  const leaderboard = document.getElementById('leaderboard');
  if (!leaderboard) {
    return;
  }
  const entries = readJsonStorage(leaderboardKey, []);
  const streak = readJsonStorage(streakKey, { count: 0 });
  if (!entries.length) {
    leaderboard.innerHTML = `<p class="muted-text">Submit accepted solutions to start filling your local leaderboard. Current streak: ${streak.count || 0}.</p>`;
    return;
  }
  const sorted = [...entries].sort((left, right) => right.score - left.score).slice(0, 6);
  leaderboard.innerHTML = `
    <div class="leaderboard-stats">
      <span>Streak: ${streak.count || 0}</span>
      <span>Total score: ${entries.reduce((sum, entry) => sum + entry.score, 0)}</span>
    </div>
    ${sorted.map((entry, index) => `
      <div class="leaderboard-row">
        <span>${index + 1}. ${escapeHtml(entry.title)}</span>
        <span>${entry.time}s &middot; ${entry.codeLines} lines &middot; ${entry.score} pts</span>
      </div>
    `).join('')}
  `;
}

async function renderGlobalLeaderboard() {
  const board = document.getElementById('globalLeaderboard');
  if (!board) {
    return;
  }
  try {
    const data = await fetchJson(`${apiBase}/leaderboard`);
    globalLeaderboardCache = data.leaderboard || [];
  } catch (error) {
    board.innerHTML = `<p class="muted-text">Global leaderboard is unavailable right now.</p>`;
    return;
  }
  if (!globalLeaderboardCache.length) {
    board.innerHTML = `<p class="muted-text">No accounts have solved a problem yet. Sign in and submit an accepted solution to be first.</p>`;
    return;
  }
  board.innerHTML = globalLeaderboardCache.map((entry, index) => `
    <div class="leaderboard-row">
      <span>${index + 1}. ${escapeHtml(entry.username)}</span>
      <span>${entry.accepted_count} solved &middot; streak ${entry.best_streak} &middot; ${entry.total_score} pts</span>
    </div>
  `).join('');
}

function renderVerificationLab() {
  const verificationLab = document.getElementById('verificationLab');
  if (!verificationLab) {
    return;
  }
  const debugProblem = allProblems.find((problem) => /bug|debug|fix|race/i.test(`${problem.id} ${problem.title} ${(problem.tags || []).join(' ')}`));
  verificationLab.innerHTML = `
    ${verificationItems.map((item) => `<div>${escapeHtml(item)}</div>`).join('')}
    ${debugProblem ? `<a class="secondary-link" href="${problemHref(debugProblem)}">Debug mode: ${escapeHtml(debugProblem.title)}</a>` : ''}
  `;
  renderQuizLab();
}

function renderQuizLab() {
  const quizLab = document.getElementById('quizLab');
  if (!quizLab) {
    return;
  }
  const topics = [...new Set(quizQuestions.map((quiz) => quiz.topic))];
  const filteredQuestions = activeQuizTopic === 'all'
    ? quizQuestions
    : quizQuestions.filter((quiz) => quiz.topic === activeQuizTopic);
  const pageCount = Math.max(1, Math.ceil(filteredQuestions.length / quizPageSize));
  quizPage = Math.min(quizPage, pageCount - 1);
  const start = quizPage * quizPageSize;
  const visibleQuestions = filteredQuestions.slice(start, start + quizPageSize);
  quizLab.innerHTML = `
    <div class="quiz-topic-tabs">
      <button class="${activeQuizTopic === 'all' ? 'quiz-topic-active' : ''}" type="button" data-topic="all">All</button>
      ${topics.map((topic) => `<button class="${activeQuizTopic === topic ? 'quiz-topic-active' : ''}" type="button" data-topic="${escapeHtml(topic)}">${escapeHtml(topic)}</button>`).join('')}
    </div>
    <div class="quiz-toolbar">
      <span>${filteredQuestions.length} questions available</span>
      <span>Showing ${filteredQuestions.length ? start + 1 : 0}-${Math.min(start + quizPageSize, filteredQuestions.length)} of ${filteredQuestions.length}</span>
    </div>
    <div id="quizCards" class="quiz-cards">
      ${visibleQuestions.map((quiz, visibleIndex) => {
        const index = start + visibleIndex;
        return `
        <div class="quiz-card" data-topic="${escapeHtml(quiz.topic)}">
          <span class="status-pill">${escapeHtml(quiz.topic)}</span>
          <strong>${escapeHtml(quiz.question)}</strong>
          <div class="quiz-options">
            ${quiz.choices.map((choice) => `<button type="button" data-quiz="${index}" data-answer="${escapeHtml(choice)}">${escapeHtml(choice)}</button>`).join('')}
          </div>
          <small id="quizFeedback${index}" class="muted-text"></small>
        </div>
      `;
      }).join('')}
    </div>
    <div class="quiz-pager">
      <button id="quizPrev" class="secondary-button" type="button" ${quizPage === 0 ? 'disabled' : ''}>Previous</button>
      <span>Page ${quizPage + 1} of ${pageCount}</span>
      <button id="quizNext" class="secondary-button" type="button" ${quizPage >= pageCount - 1 ? 'disabled' : ''}>Next</button>
    </div>
  `;
  quizLab.querySelectorAll('.quiz-topic-tabs button').forEach((button) => {
    button.addEventListener('click', () => {
      activeQuizTopic = button.dataset.topic;
      quizPage = 0;
      renderQuizLab();
    });
  });
  document.getElementById('quizPrev')?.addEventListener('click', () => {
    quizPage = Math.max(0, quizPage - 1);
    renderQuizLab();
  });
  document.getElementById('quizNext')?.addEventListener('click', () => {
    quizPage = Math.min(pageCount - 1, quizPage + 1);
    renderQuizLab();
  });
  quizLab.querySelectorAll('button').forEach((button) => {
    if (!button.dataset.quiz) {
      return;
    }
    button.addEventListener('click', () => {
      const quiz = filteredQuestions[Number(button.dataset.quiz)];
      const feedback = document.getElementById(`quizFeedback${button.dataset.quiz}`);
      const correct = button.dataset.answer === quiz.answer;
      feedback.textContent = correct ? 'Correct.' : `Not quite. Answer: ${quiz.answer}.`;
      button.closest('.quiz-card').querySelectorAll('button').forEach((item) => {
        item.classList.toggle('quiz-correct', item.dataset.answer === quiz.answer);
        item.classList.toggle('quiz-wrong', item === button && !correct);
      });
    });
  });
}

function renderProgressMap() {
  const progressMap = document.getElementById('progressMap');
  if (!progressMap) {
    return;
  }
  progressMap.innerHTML = trackDefinitions.map((track) => {
    const problems = allProblems.filter((problem) => {
      const haystack = `${problem.title} ${(problem.tags || []).join(' ')} ${problem.category}`.toLowerCase();
      return track.match?.includes(problem.category) || track.matchText?.some((term) => haystack.includes(term));
    });
    const solved = problems.filter((problem) => isSolved(problem.id)).length;
    const percent = problems.length ? Math.round((solved / problems.length) * 100) : 0;
    const next = problems.find((problem) => !isSolved(problem.id) && isDifficultyUnlocked(problem.difficulty));
    const locked = problems.find((problem) => !isSolved(problem.id) && !isDifficultyUnlocked(problem.difficulty));
    return `
      <div class="progress-topic">
        <div>
          <strong>${escapeHtml(track.title)}</strong>
          <small>${solved}/${problems.length} solved</small>
        </div>
        <p>${escapeHtml(track.goal)}</p>
        <span class="progress-bar"><span style="width: ${percent}%"></span></span>
        ${next ? `<a class="secondary-link" href="${problemHref(next)}">Next: ${escapeHtml(next.title)}</a>` : `<span class="muted-text">${locked ? unlockMessage(locked.difficulty) : 'Track complete.'}</span>`}
      </div>
    `;
  }).join('');
}

function getQueryParameter(key) {
  return new URLSearchParams(window.location.search).get(key);
}

function renderTestCases(result) {
  if (!result.test_cases?.length) {
    return '';
  }
  const failed = result.test_cases.filter((testCase) => !testCase.passed);
  return `
    <section class="result-section">
      <h3>Hidden Tests</h3>
      <div class="test-summary">
        <span>Passed: ${result.passed_tests}/${result.total_tests}</span>
        <span>Hidden tests: ${result.hidden_tests ?? result.total_tests}</span>
      </div>
      ${failed.length ? `
        <div class="failed-tests">
          <strong>Failed</strong>
          ${failed.slice(0, 8).map((testCase) => `
            <div class="test-row">
              <span>Test ${testCase.index}</span>
              <code>expected ${escapeHtml(testCase.expected || '(no output)')} got ${escapeHtml(testCase.actual || '(no output)')}</code>
            </div>
          `).join('')}
        </div>
      ` : '<p class="muted-text">All hidden tests passed.</p>'}
    </section>
  `;
}

function renderCompileErrors(result) {
  if (result.verdict !== 'Compilation Error') {
    return '';
  }
  const errors = result.compile_errors || [];
  if (!errors.length) {
    return `<section class="result-section"><h3>Compilation Error</h3><pre>${escapeHtml(result.message)}</pre></section>`;
  }
  return `
    <section class="result-section">
      <h3>Compilation Error Panel</h3>
      ${errors.map((error) => `
        <button class="error-row" type="button" data-line="${error.line}">
          <span>Line ${error.line}</span>
          <strong>${escapeHtml(error.friendly)}</strong>
          <small>${escapeHtml(error.raw)}</small>
        </button>
      `).join('')}
    </section>
  `;
}

function compactSignalName(name) {
  return String(name || '').replace(/\[[^\]]+\]$/, '').slice(-42);
}

function baseSignalName(name) {
  return String(name || '').split('.').pop().replace(/\[[^\]]+\]$/, '').toLowerCase();
}

function signalChangeSignature(signal) {
  return signal.changes.map((change) => `${change.time}:${change.value}`).join('|');
}

function signalRank(signal) {
  const name = signal.name.toLowerCase();
  const base = baseSignalName(signal.name);
  if (/^(clk|clock)$/.test(base)) {
    return 0;
  }
  if (/^(rst|reset|reset_n|rst_n)$/.test(base)) {
    return 1;
  }
  if (!name.includes('.dut.') && !name.endsWith('.dut')) {
    return 2;
  }
  if (name.includes('.dut.')) {
    return 3;
  }
  return 4;
}

function orderedSignals(signals) {
  return [...signals].sort((left, right) => {
    const rankDelta = signalRank(left) - signalRank(right);
    if (rankDelta) {
      return rankDelta;
    }
    return left.name.localeCompare(right.name);
  });
}

function isDuplicateAlias(signal, seenByBaseAndValue) {
  const name = signal.name.toLowerCase();
  if (!name.includes('.dut.')) {
    return false;
  }
  const key = `${baseSignalName(signal.name)}:${signal.width}:${signalChangeSignature(signal)}`;
  return seenByBaseAndValue.has(key);
}

function visibleWaveformSignals(vcd) {
  const search = document.getElementById('waveformSearch')?.value.trim().toLowerCase() || '';
  const hideAliases = document.getElementById('waveformHideAliases')?.checked ?? true;
  const seenByBaseAndValue = new Set();
  const visible = [];

  orderedSignals(vcd.signals).forEach((signal) => {
    const key = `${baseSignalName(signal.name)}:${signal.width}:${signalChangeSignature(signal)}`;
    const duplicateAlias = hideAliases && isDuplicateAlias(signal, seenByBaseAndValue);
    if (!duplicateAlias && (!search || signal.name.toLowerCase().includes(search))) {
      visible.push(signal);
    }
    if (!signal.name.toLowerCase().includes('.dut.')) {
      seenByBaseAndValue.add(key);
    }
  });

  return visible.slice(0, 48);
}

function parseVcd(text) {
  const signalsById = new Map();
  const signalOrder = [];
  const scope = [];
  let timeScale = '1ps';
  let currentTime = 0;
  let parsingHeader = true;

  function addChange(id, value) {
    const signal = signalsById.get(id);
    if (!signal) {
      return;
    }
    const previous = signal.changes[signal.changes.length - 1];
    if (previous && previous.time === currentTime) {
      previous.value = value;
      return;
    }
    signal.changes.push({ time: currentTime, value });
  }

  text.split(/\r?\n/).forEach((rawLine) => {
    const line = rawLine.trim();
    if (!line) {
      return;
    }
    if (line.startsWith('$timescale')) {
      timeScale = line.replace('$timescale', '').replace('$end', '').trim().replace(/\s+/g, '');
      return;
    }
    if (line.startsWith('$scope')) {
      const parts = line.split(/\s+/);
      if (parts[2]) {
        scope.push(parts[2]);
      }
      return;
    }
    if (line.startsWith('$upscope')) {
      scope.pop();
      return;
    }
    if (line.startsWith('$var')) {
      const parts = line.split(/\s+/);
      const width = Number(parts[2]) || 1;
      const id = parts[3];
      const name = parts.slice(4, -1).join(' ');
      const scopedName = [...scope, name].filter(Boolean).join('.');
      const signal = { id, name: scopedName || name || id, width, changes: [] };
      signalsById.set(id, signal);
      signalOrder.push(signal);
      return;
    }
    if (line.startsWith('$enddefinitions')) {
      parsingHeader = false;
      return;
    }
    if (parsingHeader || line.startsWith('$')) {
      return;
    }
    if (line.startsWith('#')) {
      currentTime = Number(line.slice(1)) || 0;
      return;
    }
    if (/^[01xz]/i.test(line[0])) {
      addChange(line.slice(1), line[0].toLowerCase());
      return;
    }
    if (/^[br]/i.test(line[0])) {
      const parts = line.split(/\s+/);
      addChange(parts[1], parts[0].slice(1).toLowerCase());
    }
  });

  const signals = signalOrder.filter((signal) => signal.changes.length);
  const maxTime = signals.reduce((max, signal) => {
    const last = signal.changes[signal.changes.length - 1];
    return Math.max(max, last?.time || 0);
  }, 0);

  return { signals, maxTime, timeScale };
}

function signalValueAt(signal, time) {
  let value = 'x';
  for (const change of signal.changes) {
    if (change.time > time) {
      break;
    }
    value = change.value;
  }
  return value;
}

function scalarPath(points, xScale, top, height) {
  const high = top + 8;
  const low = top + height - 8;
  const mid = top + height / 2;
  const yFor = (value) => {
    if (value === '1') {
      return high;
    }
    if (value === '0') {
      return low;
    }
    return mid;
  };
  const commands = [];
  points.forEach((point, index) => {
    const x = Math.round(point.time * xScale);
    const y = yFor(point.value);
    if (index === 0) {
      commands.push(`M ${x} ${y}`);
      return;
    }
    const previousY = yFor(points[index - 1].value);
    commands.push(`L ${x} ${previousY} L ${x} ${y}`);
  });
  return commands.join(' ');
}

function busSegmentMarkup(point, next, xScale, top, height, labelWidth) {
  const x = Math.round(point.time * xScale) + labelWidth;
  const nextX = Math.round(next.time * xScale) + labelWidth;
  const minWidth = 4;
  if (nextX - x < minWidth) {
    return '';
  }
  const yTop = top + 10;
  const yBottom = top + height - 10;
  const yMid = top + height / 2;
  const notch = Math.min(10, Math.max(3, Math.floor((nextX - x) / 3)));
  const hasLeftJoin = point.time > 0;
  const hasRightJoin = next.time > point.time && next.value !== point.value;
  const leftTop = hasLeftJoin ? x + notch : x;
  const leftBottom = hasLeftJoin ? x + notch : x;
  const rightTop = hasRightJoin ? nextX - notch : nextX;
  const rightBottom = hasRightJoin ? nextX - notch : nextX;
  const valueLabel = nextX - x > 34
    ? `<text x="${x + (nextX - x) / 2}" y="${yMid + 4}" class="wave-value" text-anchor="middle">${escapeHtml(point.value)}</text>`
    : '';

  return `
    <polygon points="${leftTop},${yTop} ${rightTop},${yTop} ${nextX},${yMid} ${rightBottom},${yBottom} ${leftBottom},${yBottom} ${x},${yMid}" class="wave-bus-fill" />
    <polyline points="${x},${yMid} ${leftTop},${yTop} ${rightTop},${yTop} ${nextX},${yMid} ${rightBottom},${yBottom} ${leftBottom},${yBottom} ${x},${yMid}" class="wave-bus-outline" />
    ${valueLabel}
  `;
}

function renderWaveformSvg(vcd, signals) {
  const labelWidth = 180;
  const rowHeight = 40;
  const timelineHeight = 26;
  const viewerWidth = document.getElementById('waveformViewer')?.clientWidth || 760;
  const fittedWidth = Math.max(360, viewerWidth - labelWidth - 36);
  const scaledWidth = Math.ceil((vcd.maxTime || 1) * 0.04 * waveformZoom);
  const timeWidth = waveformFit ? fittedWidth : Math.max(520, scaledWidth);
  const width = labelWidth + timeWidth + 24;
  const height = timelineHeight + signals.length * rowHeight + 18;
  const xScale = timeWidth / Math.max(vcd.maxTime || 1, 1);
  const ticks = Array.from({ length: 6 }, (_, index) => Math.round((vcd.maxTime || 0) * index / 5));

  const rows = signals.map((signal, index) => {
    const top = timelineHeight + index * rowHeight;
    const changes = signal.changes[0]?.time === 0 ? signal.changes : [{ time: 0, value: 'x' }, ...signal.changes];
    const points = [...changes, { time: vcd.maxTime || 1, value: signalValueAt(signal, vcd.maxTime || 1) }];
    const line = signal.width === 1
      ? `<path d="${scalarPath(points, xScale, top, rowHeight)}" class="wave-line" transform="translate(${labelWidth},0)" />`
      : points.slice(0, -1).map((point, pointIndex) => {
          const next = points[pointIndex + 1];
          return busSegmentMarkup(point, next, xScale, top, rowHeight, labelWidth);
        }).join('');

    return `
      <g>
        <rect x="0" y="${top}" width="${width}" height="${rowHeight}" class="wave-row-bg ${index % 2 ? 'wave-row-alt' : ''}" />
        <text x="12" y="${top + 25}" class="wave-label">${escapeHtml(compactSignalName(signal.name))}</text>
        ${line}
      </g>
    `;
  }).join('');

  const tickMarkup = ticks.map((tick) => {
    const x = labelWidth + Math.round(tick * xScale);
    return `
      <line x1="${x}" y1="18" x2="${x}" y2="${height - 10}" class="wave-grid" />
      <text x="${x + 4}" y="16" class="wave-tick">${tick}</text>
    `;
  }).join('');

  return `
    <svg class="waveform-svg" viewBox="0 0 ${width} ${height}" width="${width}" height="${height}" role="img" aria-label="Simulation waveform">
      <rect x="0" y="0" width="${width}" height="${height}" class="wave-bg" />
      ${tickMarkup}
      ${rows}
    </svg>
  `;
}

function renderWaveform() {
  const panel = document.getElementById('waveformPanel');
  const viewer = document.getElementById('waveformViewer');
  const meta = document.getElementById('waveformMeta');
  if (!panel || !viewer || !meta || !activeWaveform) {
    return;
  }
  const visibleSignals = visibleWaveformSignals(activeWaveform);
  panel.hidden = false;
  meta.textContent = `${visibleSignals.length}/${activeWaveform.signals.length} signals | ${activeWaveform.maxTime} ${activeWaveform.timeScale}`;
  viewer.innerHTML = visibleSignals.length
    ? renderWaveformSvg(activeWaveform, visibleSignals)
    : '<p class="muted-text">No matching signal changes were found in this VCD.</p>';
}

async function loadWaveform(url) {
  const panel = document.getElementById('waveformPanel');
  const viewer = document.getElementById('waveformViewer');
  if (!panel || !viewer || !url) {
    return;
  }
  panel.hidden = false;
  viewer.innerHTML = '<p class="muted-text">Loading waveform...</p>';
  try {
    const response = await fetch(url);
    if (!response.ok) {
      throw new Error('Waveform could not be loaded.');
    }
    activeWaveform = parseVcd(await response.text());
    waveformZoom = 1;
    waveformFit = false;
    const search = document.getElementById('waveformSearch');
    if (search) {
      search.value = '';
    }
    const hideAliases = document.getElementById('waveformHideAliases');
    if (hideAliases) {
      hideAliases.checked = true;
    }
    renderWaveform();
  } catch (error) {
    activeWaveform = null;
    viewer.innerHTML = `<p class="muted-text">${escapeHtml(error.message)}</p>`;
  }
}

function formatResultHtml(result) {
  return `
    <section class="result-section">
      <h3>Verdict</h3>
      <p>${escapeHtml(result.message || result.verdict)}</p>
    </section>
    ${renderCompileErrors(result)}
    ${renderTestCases(result)}
    ${result.actual?.length ? `
      <section class="result-section">
        <h3>Output</h3>
        <pre>${escapeHtml(result.actual.join('\n'))}</pre>
      </section>
    ` : ''}
  `;
}

function highlightCompileErrors(errors = []) {
  if (!window.editorInstance || !window.monaco) {
    return;
  }
  const model = window.editorInstance.getModel();
  const markers = errors.map((error) => ({
    startLineNumber: error.line,
    startColumn: 1,
    endLineNumber: error.line,
    endColumn: model.getLineMaxColumn(error.line),
    message: error.friendly,
    severity: monaco.MarkerSeverity.Error,
  }));
  monaco.editor.setModelMarkers(model, 'verilog-judge', markers);
}

function focusEditorLine(line) {
  if (!window.editorInstance || !line) {
    return;
  }
  window.editorInstance.revealLineInCenter(Number(line));
  window.editorInstance.setPosition({ lineNumber: Number(line), column: 1 });
  window.editorInstance.focus();
}

function reviewCode(code, result, problem) {
  const notes = [];
  const isClocked = /input\s+clk\b/.test(problem?.module_signature || '') || /\bposedge\s+clk\b/.test(code);
  if (isClocked && /\balways\s*@\s*\([^)]*posedge/.test(code) && /[^<]=/.test(code.replace(/<=/g, ''))) {
    notes.push('Your sequential block appears to use blocking assignment. Prefer non-blocking <= for flip-flop updates.');
  }
  if (isClocked && !/\bif\s*\(\s*(rst|reset)\s*\)/.test(code) && /(rst|reset)/.test(problem?.module_signature || '')) {
    notes.push('The module has a reset input. Make sure reset behavior is explicit and matches the statement.');
  }
  if (result.verdict === 'Wrong Answer' && result.test_cases?.some((testCase) => /x|z/i.test(testCase.actual))) {
    notes.push('Some outputs are unknown. Every output needs a deterministic value in each branch or after reset.');
  }
  if ((problem?.category || '').includes('FSM') && !/\bcase\b/.test(code)) {
    notes.push('FSM solutions are usually clearer with encoded states and a case statement.');
  }
  if ((problem?.category || '').includes('Arithmetic') && /carry|adder|sum/i.test(problem?.title || '') && !/[+]/.test(code)) {
    notes.push('Think about carry propagation and whether the final carry-out is being preserved.');
  }
  if (!notes.length && result.verdict === 'Accepted') {
    notes.push('Your code passes. Next improvement: keep combinational and sequential logic separated for readability.');
  }
  return notes;
}

function updateStreak() {
  const today = new Date().toISOString().slice(0, 10);
  const streak = readJsonStorage(streakKey, { count: 0, lastDay: '' });
  if (streak.lastDay === today) {
    return streak;
  }
  const yesterday = new Date(Date.now() - 86400000).toISOString().slice(0, 10);
  const next = {
    count: streak.lastDay === yesterday ? (streak.count || 0) + 1 : 1,
    lastDay: today,
  };
  writeJsonStorage(streakKey, next);
  return next;
}

function recordLeaderboard(problemId, result) {
  const code = window.editorInstance?.getValue() || '';
  const problem = activeProblem || allProblems.find((item) => item.id === problemId) || {};
  const entries = readJsonStorage(leaderboardKey, []);
  const codeLines = code.split('\n').filter((line) => line.trim()).length;
  const solveSeconds = Math.max(1, Math.round((Date.now() - activeProblemStartedAt) / 1000));
  const score = Math.max(10, 1000 - solveSeconds - codeLines * 2);
  const existingIndex = entries.findIndex((entry) => entry.problemId === problemId);
  const entry = {
    problemId,
    title: problem.title || problemId,
    time: solveSeconds,
    codeLines,
    score,
    acceptedAt: new Date().toISOString(),
    simTime: result.time_seconds || 0,
  };
  if (existingIndex === -1 || entries[existingIndex].score < score) {
    if (existingIndex !== -1) {
      entries.splice(existingIndex, 1);
    }
    entries.push(entry);
    writeJsonStorage(leaderboardKey, entries);
  }
  updateStreak();
}

function explanationForProblem(problem) {
  const title = problem?.title || 'This design';
  const signature = problem?.module_signature || '';
  const category = problem?.category || 'RTL';
  const metadataExplanation = Array.isArray(problem?.explanation) ? problem.explanation : (problem?.explanation ? [problem.explanation] : []);
  const lines = [...metadataExplanation, `${title} works by matching the required module interface and producing the documented behavior for each hidden test vector.`];
  const behavior = Array.isArray(problem?.behavior) ? problem.behavior : (problem?.behavior ? [problem.behavior] : []);
  behavior.slice(0, 2).forEach((item) => lines.push(`Key behavior: ${item}`));
  if (/\bclk\b/.test(signature) || /(Sequential|FSM|Memory)/i.test(category)) {
    lines.push('The design updates state only on the clock edge, so outputs change in a predictable synchronous order.');
  } else {
    lines.push('The design is combinational, so each output is driven directly from the current inputs without storing state.');
  }
  if (/(rst|reset)/i.test(signature)) {
    lines.push('Reset handling is important because the judge rejects unknown or uninitialized state.');
  }
  if (/(signed|magnitude|overflow|carry|adder|subtract|alu)/i.test(`${title} ${(problem?.tags || []).join(' ')}`)) {
    lines.push('The arithmetic behavior must preserve width, signedness, and carry or overflow semantics described in the statement.');
  }
  return [...new Set(lines)].slice(0, 6);
}

function showAcceptanceExplanation(result) {
  const explanationBox = document.getElementById('explanationBox');
  const assistantPanel = document.getElementById('assistantPanel');
  if (!explanationBox || !assistantPanel || result.verdict !== 'Accepted') {
    return;
  }
  assistantPanel.hidden = false;
  explanationBox.hidden = false;
  explanationBox.innerHTML = `
    <h3>Why It Works</h3>
    <ul>${explanationForProblem(activeProblem).map((line) => `<li>${escapeHtml(line)}</li>`).join('')}</ul>
  `;
}

function updateSolutionButton(problemId) {
  const button = document.getElementById('solutionButton');
  if (!button) {
    return;
  }
  const attempts = readAttempts(problemId);
  const unlocked = attempts >= 3 || isSolved(problemId);
  button.disabled = !unlocked;
  button.textContent = unlocked ? 'Solution' : `Solution (${Math.max(0, 3 - attempts)} tries)`;
  button.title = unlocked ? 'Reveal the official reference solution.' : 'Submit three attempts or solve the problem to unlock.';
}

async function revealSolution(problemId) {
  const attempts = readAttempts(problemId);
  const accepted = isSolved(problemId);
  if (attempts < 3 && !accepted) {
    updateSolutionButton(problemId);
    return;
  }
  const solutionBox = document.getElementById('solutionBox');
  const assistantPanel = document.getElementById('assistantPanel');
  if (!solutionBox || !assistantPanel) {
    return;
  }
  assistantPanel.hidden = false;
  solutionBox.hidden = false;
  solutionBox.innerHTML = '<h3>Official Solution</h3><p class="muted-text">Loading...</p>';
  try {
    const params = new URLSearchParams({
      attempts: String(attempts),
      accepted: String(accepted),
    });
    const data = await fetchJson(`${apiBase}/solution/${encodeURIComponent(problemId)}?${params.toString()}`);
    solutionBox.innerHTML = `<h3>Official Solution</h3><pre class="code-snippet">${escapeHtml(data.solution)}</pre>`;
  } catch (error) {
    solutionBox.innerHTML = `<h3>Official Solution</h3><p class="muted-text">${escapeHtml(error.message)}</p>`;
  }
}

function debugTemplate(problem) {
  const signature = problem?.module_signature || problem?.template?.split('\n')[0] || 'module debug_module();';
  const header = signature.trim().replace(/;?$/, ';');
  const firstOutput = (signature.match(/\boutput(?:\s+reg)?(?:\s+\[[^\]]+\])?\s+([a-zA-Z_][a-zA-Z0-9_]*)/) || [])[1] || 'y';
  if (/buggy_register_debug/.test(signature)) {
    return `${header}\n  always @(posedge clk) begin\n    if (rst)\n      q <= 8'b0;\n    else if (!en)\n      q <= d; // Bug: this should update when en is high.\n  end\nendmodule`;
  }
  if (/\bclk\b/.test(signature)) {
    if (/(rst|reset)/i.test(signature)) {
      const resetName = /\brst\b/.test(signature) ? 'rst' : 'reset';
      return `${header}\n  always @(posedge clk) begin\n    if (${resetName})\n      ${firstOutput} <= 1'bx;\n    else\n      ${firstOutput} <= ${firstOutput}; // Bug: replace with the required state update.\n  end\nendmodule`;
    }
    return `${header}\n  always @(posedge clk) begin\n    ${firstOutput} <= ${firstOutput}; // Bug: replace with the required state update.\n  end\nendmodule`;
  }
  return `${header}\n  assign ${firstOutput} = 1'bx; // Bug: replace with complete combinational logic.\nendmodule`;
}

function startDebugMode() {
  if (!window.editorInstance || !activeProblem) {
    return;
  }
  window.editorInstance.setValue(debugTemplate(activeProblem));
  localStorage.setItem(draftKey(activeProblem.id), window.editorInstance.getValue());
  setDraftStatus('Debug starter loaded');
  const reviewBox = document.getElementById('reviewBox');
  const assistantPanel = document.getElementById('assistantPanel');
  if (reviewBox && assistantPanel) {
    assistantPanel.hidden = false;
    reviewBox.hidden = false;
    reviewBox.innerHTML = `
      <h3>Debug Mode</h3>
      <ul>
        <li>Intentionally broken starter loaded with the required interface.</li>
        <li>The same hidden tests and acceptance flow are active.</li>
      </ul>
    `;
  }
  showHint();
}

function showReview(result) {
  const reviewBox = document.getElementById('reviewBox');
  const assistantPanel = document.getElementById('assistantPanel');
  if (!reviewBox || !assistantPanel || !window.editorInstance) {
    return;
  }
  const notes = reviewCode(window.editorInstance.getValue(), result, activeProblem);
  if (!notes.length) {
    reviewBox.hidden = true;
    return;
  }
  assistantPanel.hidden = false;
  reviewBox.hidden = false;
  reviewBox.innerHTML = `<h3>Code Review</h3><ul>${notes.map((note) => `<li>${escapeHtml(note)}</li>`).join('')}</ul>`;
}

function setResult(result) {
  const verdict = result.verdict || 'Error';
  const badge = document.getElementById('verdictBadge');
  const outputConsole = document.getElementById('outputConsole');
  const executionTime = document.getElementById('executionTime');
  const waveformArea = document.getElementById('waveformArea');
  const waveformPanel = document.getElementById('waveformPanel');
  const waveformViewer = document.getElementById('waveformViewer');

  badge.textContent = verdict;
  badge.className = `verdict-badge verdict-${verdict.toLowerCase().replace(/\s+/g, '-')}`;
  executionTime.textContent = result.time_seconds ? `${result.time_seconds.toFixed(3)}s` : '';
  outputConsole.innerHTML = formatResultHtml(result);
  waveformArea.innerHTML = result.waveform_url ? `
    <button id="viewWaveformButton" class="waveform-link" type="button">View waveform</button>
    <a href="${result.waveform_url}" download>Download VCD</a>
  ` : '';
  if (!result.waveform_url) {
    activeWaveform = null;
    if (waveformPanel) {
      waveformPanel.hidden = true;
    }
    if (waveformViewer) {
      waveformViewer.innerHTML = '';
    }
  }
  highlightCompileErrors(result.compile_errors || []);
  outputConsole.querySelectorAll('.error-row').forEach((button) => {
    button.addEventListener('click', () => focusEditorLine(button.dataset.line));
  });
  document.getElementById('viewWaveformButton')?.addEventListener('click', () => loadWaveform(result.waveform_url));
  showReview(result);
  showAcceptanceExplanation(result);
}

async function submitSolution(problemId) {
  const button = document.getElementById('submitButton');
  button.disabled = true;
  button.textContent = 'Running...';
  setResult({ verdict: 'Running', message: 'Compiling and simulating your Verilog...' });

  try {
    incrementAttempts(problemId);
    updateSolutionButton(problemId);
    const result = await fetchJson(`${apiBase}/submit/${encodeURIComponent(problemId)}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ code: window.editorInstance.getValue() }),
    });
    setResult(result);
    if (result.verdict === 'Accepted') {
      markAccepted(problemId);
      recordLeaderboard(problemId, result);
      syncAcceptedToServer(problemId, result);
      updateSolutionButton(problemId);
    }
  } catch (error) {
    setResult({ verdict: 'Error', message: error.message });
  } finally {
    button.disabled = false;
    button.textContent = 'Submit';
  }
}

async function loadHomePage() {
  const data = await fetchJson(`${apiBase}/problems`);
  allProblems = data.problems;
  populateCategoryFilter(allProblems);
  rerenderHome();
  ['searchInput', 'difficultyFilter', 'categoryFilter', 'statusFilter'].forEach((id) => {
    document.getElementById(id).addEventListener('input', applyHomeControls);
  });
  document.getElementById('sortSelect').addEventListener('input', rerenderHome);
}

function setProblemNavigation(problemId) {
  const previous = document.getElementById('previousProblem');
  const next = document.getElementById('nextProblem');
  if (!previous || !next || !allProblems.length) {
    return;
  }

  const index = allProblems.findIndex((problem) => problem.id === problemId);
  const previousProblem = allProblems[(index - 1 + allProblems.length) % allProblems.length];
  const nextProblem = allProblems[(index + 1) % allProblems.length];
  previous.href = problemHref(previousProblem);
  previous.textContent = `Previous: ${previousProblem.title}`;
  next.href = problemHref(nextProblem);
  next.textContent = `Next: ${nextProblem.title}`;
}

function setDraftStatus(text) {
  const draftStatus = document.getElementById('draftStatus');
  if (draftStatus) {
    draftStatus.textContent = text;
  }
}

function initDrafts(problemId, template) {
  const resetButton = document.getElementById('resetButton');
  const savedDraft = localStorage.getItem(draftKey(problemId));
  const initialCode = savedDraft || template || '// Write your module here';

  window.initEditor(initialCode, (editor) => {
    setDraftStatus(savedDraft ? 'Draft restored' : 'Draft ready');
    editor.onDidChangeModelContent(() => {
      localStorage.setItem(draftKey(problemId), editor.getValue());
      setDraftStatus('Draft saved');
    });
  });

  resetButton.addEventListener('click', () => {
    if (!window.editorInstance) {
      return;
    }
    window.editorInstance.setValue(template || '// Write your module here');
    localStorage.removeItem(draftKey(problemId));
    setDraftStatus('Template restored');
  });
}

function buildHint(problem) {
  const metadataHints = Array.isArray(problem.hints) ? problem.hints : (problem.hint ? [problem.hint] : []);
  const hints = [...metadataHints];
  const category = problem.category || '';
  const text = `${problem.title} ${(problem.tags || []).join(' ')} ${problem.statement || ''}`.toLowerCase();
  hints.push(`Start by matching the exact module signature: ${problem.module_signature || 'use the required module header'}`);
  if (/(sequential|fsm|counter|register|memory)/i.test(category) || /\bclk\b/.test(problem.module_signature || '')) {
    hints.push('Use always @(posedge clk) for synchronous state updates.');
    hints.push('Use non-blocking assignments <= for registers and flip-flops.');
  } else {
    hints.push('This is likely combinational logic, so every output should be continuously assigned or assigned in every branch of always @(*).');
  }
  if (/(rst|reset)/.test(problem.module_signature || '')) {
    hints.push('Reset is active-high and synchronous unless this problem explicitly says otherwise.');
  }
  if (text.includes('carry') || text.includes('adder')) {
    hints.push('Think about carry propagation and whether the output needs one extra bit.');
  }
  if (text.includes('fsm') || category === 'FSM') {
    hints.push('Define states, reset to the idle state, then update state on each clock edge.');
  }
  if (text.includes('priority')) {
    hints.push('Check the highest-priority input first, then fall through to lower priorities.');
  }
  if (text.includes('memory') || category === 'Memory') {
    hints.push('Initialize or reset readable outputs so the testbench never sees unknown data.');
  }
  return [...new Set(hints)].slice(0, 4);
}

function showHint() {
  const hintBox = document.getElementById('hintBox');
  const assistantPanel = document.getElementById('assistantPanel');
  if (!hintBox || !assistantPanel || !activeProblem) {
    return;
  }
  const hints = buildHint(activeProblem);
  const nextLevel = Math.min(hints.length, Number(localStorage.getItem(hintKey(activeProblem.id)) || 0) + 1);
  localStorage.setItem(hintKey(activeProblem.id), String(nextLevel));
  assistantPanel.hidden = false;
  hintBox.hidden = false;
  hintBox.innerHTML = `
    <h3>Hint ${nextLevel}/${hints.length}</h3>
    <ul>${hints.slice(0, nextLevel).map((hint) => `<li>${escapeHtml(hint)}</li>`).join('')}</ul>
  `;
}

async function loadProblemPage() {
  const problemId = getQueryParameter('problem');
  if (!problemId) {
    window.location.href = '/';
    return;
  }

  try {
    const listData = await fetchJson(`${apiBase}/problems`);
    allProblems = listData.problems;
    const problem = await fetchJson(`${apiBase}/problems/${encodeURIComponent(problemId)}`);
    activeProblem = problem;
    activeProblemStartedAt = Date.now();
    document.title = `${problem.title} - Verilog Judge`;
    document.getElementById('problemTitle').textContent = problem.title;
    document.getElementById('problemDifficulty').textContent = problem.difficulty;
    document.getElementById('problemDifficulty').className = difficultyClass(problem.difficulty);
    document.getElementById('problemCategory').textContent = problem.category || 'Combinational';
    document.getElementById('problemTags').innerHTML = (problem.tags || []).map((tag) => `<span>${tag}</span>`).join('');
    document.getElementById('problemContent').innerHTML = renderProblemContent(problem);
    setProblemNavigation(problemId);
    initDrafts(problemId, problem.template);
    updateSolutionButton(problemId);
    if (!isDifficultyUnlocked(problem.difficulty)) {
      setResult({ verdict: 'Locked', message: unlockMessage(problem.difficulty) });
      document.getElementById('submitButton').disabled = true;
    }
    document.getElementById('submitButton').addEventListener('click', () => submitSolution(problemId));
    document.getElementById('hintButton').addEventListener('click', showHint);
    document.getElementById('debugModeButton')?.addEventListener('click', startDebugMode);
    document.getElementById('solutionButton')?.addEventListener('click', () => revealSolution(problemId));
    document.getElementById('waveformSearch')?.addEventListener('input', renderWaveform);
    document.getElementById('waveformHideAliases')?.addEventListener('change', renderWaveform);
    document.getElementById('waveformFit')?.addEventListener('click', () => {
      waveformFit = true;
      renderWaveform();
    });
    document.getElementById('waveformZoomOut')?.addEventListener('click', () => {
      waveformFit = false;
      waveformZoom = Math.max(0.5, waveformZoom / 1.5);
      renderWaveform();
    });
    document.getElementById('waveformZoomIn')?.addEventListener('click', () => {
      waveformFit = false;
      waveformZoom = Math.min(8, waveformZoom * 1.5);
      renderWaveform();
    });
    window.addEventListener('keydown', (event) => {
      if ((event.ctrlKey || event.metaKey) && event.key === 'Enter') {
        event.preventDefault();
        submitSolution(problemId);
      }
    });
  } catch (error) {
    document.getElementById('problemTitle').textContent = 'Problem not found';
    document.getElementById('problemContent').textContent = error.message;
  }
}

initAuth();

if (document.getElementById('problemGrid')) {
  loadHomePage().catch((error) => {
    document.getElementById('problemGrid').textContent = error.message;
  });
}

if (document.getElementById('editor')) {
  window.addEventListener('DOMContentLoaded', loadProblemPage);
}
