module InstructionFetch(
  input         reset,
  input  [31:0] io_address,
  output [31:0] io_instruction,
  input         io_stall,
  output        io_coreInstrReq_valid,
  output [31:0] io_coreInstrReq_bits_addrRequest,
  input         io_coreInstrResp_valid,
  input  [31:0] io_coreInstrResp_bits_dataResponse
);
  assign io_instruction = io_coreInstrResp_valid ? io_coreInstrResp_bits_dataResponse : 32'h0; // @[InstructionFetch.scala 29:24]
  assign io_coreInstrReq_valid = reset | io_stall ? 1'h0 : 1'h1; // @[InstructionFetch.scala 27:31]
  assign io_coreInstrReq_bits_addrRequest = {{2'd0}, io_address[31:2]}; // @[InstructionFetch.scala 26:50]
endmodule
module HazardUnit(
  input        io_id_ex_memRead,
  input        io_ex_mem_memRead,
  input        io_id_ex_branch,
  input  [4:0] io_id_ex_rd,
  input  [4:0] io_ex_mem_rd,
  input  [4:0] io_id_rs1,
  input  [4:0] io_id_rs2,
  input        io_taken,
  input  [1:0] io_jump,
  input        io_branch,
  output       io_if_reg_write,
  output       io_pc_write,
  output       io_ctl_mux,
  output       io_ifid_flush,
  output       io_take_branch
);
  wire  _T_3 = io_id_ex_rd == io_id_rs1 | io_id_ex_rd == io_id_rs2; // @[HazardUnit.scala 35:34]
  wire  _T_4 = (io_id_ex_memRead | io_branch) & _T_3; // @[HazardUnit.scala 34:37]
  wire  _T_5 = io_id_ex_rd != 5'h0; // @[HazardUnit.scala 36:21]
  wire  _T_10 = _T_5 & io_id_rs2 != 5'h0; // @[HazardUnit.scala 37:28]
  wire  _T_11 = io_id_ex_rd != 5'h0 & io_id_rs1 != 5'h0 | _T_10; // @[HazardUnit.scala 36:51]
  wire  _T_12 = _T_4 & _T_11; // @[HazardUnit.scala 35:65]
  wire  _T_13 = ~io_id_ex_branch; // @[HazardUnit.scala 38:7]
  wire  _T_14 = _T_12 & _T_13; // @[HazardUnit.scala 37:51]
  wire  _GEN_0 = _T_14 ? 1'h0 : 1'h1; // @[HazardUnit.scala 40:3 HazardUnit.scala 41:16 HazardUnit.scala 26:14]
  assign io_if_reg_write = io_ex_mem_memRead & io_branch & (io_ex_mem_rd == io_id_rs1 | io_ex_mem_rd == io_id_rs2) ? 1'h0
     : _GEN_0; // @[HazardUnit.scala 47:101 HazardUnit.scala 48:16]
  assign io_pc_write = io_ex_mem_memRead & io_branch & (io_ex_mem_rd == io_id_rs1 | io_ex_mem_rd == io_id_rs2) ? 1'h0 :
    _GEN_0; // @[HazardUnit.scala 47:101 HazardUnit.scala 48:16]
  assign io_ctl_mux = io_ex_mem_memRead & io_branch & (io_ex_mem_rd == io_id_rs1 | io_ex_mem_rd == io_id_rs2) ? 1'h0 :
    _GEN_0; // @[HazardUnit.scala 47:101 HazardUnit.scala 48:16]
  assign io_ifid_flush = io_taken | io_jump != 2'h0; // @[HazardUnit.scala 55:17]
  assign io_take_branch = io_ex_mem_memRead & io_branch & (io_ex_mem_rd == io_id_rs1 | io_ex_mem_rd == io_id_rs2) ? 1'h0
     : _GEN_0; // @[HazardUnit.scala 47:101 HazardUnit.scala 48:16]
endmodule
module Control(
  input  [31:0] io_in,
  output        io_aluSrc,
  output [1:0]  io_memToReg,
  output        io_regWrite,
  output        io_memRead,
  output        io_memWrite,
  output        io_branch,
  output [1:0]  io_aluOp,
  output [1:0]  io_jump,
  output [1:0]  io_aluSrc1
);
  wire [31:0] _T = io_in & 32'h7f; // @[Lookup.scala 31:38]
  wire  _T_1 = 32'h33 == _T; // @[Lookup.scala 31:38]
  wire  _T_3 = 32'h13 == _T; // @[Lookup.scala 31:38]
  wire  _T_5 = 32'h3 == _T; // @[Lookup.scala 31:38]
  wire  _T_7 = 32'h23 == _T; // @[Lookup.scala 31:38]
  wire  _T_9 = 32'h63 == _T; // @[Lookup.scala 31:38]
  wire  _T_11 = 32'h37 == _T; // @[Lookup.scala 31:38]
  wire  _T_13 = 32'h17 == _T; // @[Lookup.scala 31:38]
  wire  _T_15 = 32'h6f == _T; // @[Lookup.scala 31:38]
  wire  _T_17 = 32'h67 == _T; // @[Lookup.scala 31:38]
  wire  _T_23 = _T_7 ? 1'h0 : _T_9; // @[Lookup.scala 33:37]
  wire  _T_24 = _T_5 ? 1'h0 : _T_23; // @[Lookup.scala 33:37]
  wire  _T_25 = _T_3 ? 1'h0 : _T_24; // @[Lookup.scala 33:37]
  wire [1:0] _T_26 = _T_17 ? 2'h2 : 2'h0; // @[Lookup.scala 33:37]
  wire [1:0] _T_27 = _T_15 ? 2'h2 : _T_26; // @[Lookup.scala 33:37]
  wire [1:0] _T_28 = _T_13 ? 2'h0 : _T_27; // @[Lookup.scala 33:37]
  wire [1:0] _T_29 = _T_11 ? 2'h0 : _T_28; // @[Lookup.scala 33:37]
  wire [1:0] _T_30 = _T_9 ? 2'h0 : _T_29; // @[Lookup.scala 33:37]
  wire [1:0] _T_31 = _T_7 ? 2'h0 : _T_30; // @[Lookup.scala 33:37]
  wire [1:0] _T_32 = _T_5 ? 2'h1 : _T_31; // @[Lookup.scala 33:37]
  wire [1:0] _T_33 = _T_3 ? 2'h0 : _T_32; // @[Lookup.scala 33:37]
  wire  _T_38 = _T_9 ? 1'h0 : _T_11 | (_T_13 | (_T_15 | _T_17)); // @[Lookup.scala 33:37]
  wire  _T_39 = _T_7 ? 1'h0 : _T_38; // @[Lookup.scala 33:37]
  wire  _T_49 = _T_3 ? 1'h0 : _T_5; // @[Lookup.scala 33:37]
  wire  _T_56 = _T_5 ? 1'h0 : _T_7; // @[Lookup.scala 33:37]
  wire  _T_57 = _T_3 ? 1'h0 : _T_56; // @[Lookup.scala 33:37]
  wire [1:0] _T_67 = _T_15 ? 2'h1 : _T_26; // @[Lookup.scala 33:37]
  wire [1:0] _T_68 = _T_13 ? 2'h0 : _T_67; // @[Lookup.scala 33:37]
  wire [1:0] _T_69 = _T_11 ? 2'h0 : _T_68; // @[Lookup.scala 33:37]
  wire [1:0] _T_70 = _T_9 ? 2'h0 : _T_69; // @[Lookup.scala 33:37]
  wire [1:0] _T_71 = _T_7 ? 2'h0 : _T_70; // @[Lookup.scala 33:37]
  wire [1:0] _T_72 = _T_5 ? 2'h0 : _T_71; // @[Lookup.scala 33:37]
  wire [1:0] _T_73 = _T_3 ? 2'h0 : _T_72; // @[Lookup.scala 33:37]
  wire [1:0] _T_81 = _T_3 ? 2'h2 : 2'h0; // @[Lookup.scala 33:37]
  wire [1:0] _T_85 = _T_11 ? 2'h2 : {{1'd0}, _T_13}; // @[Lookup.scala 33:37]
  wire [1:0] _T_86 = _T_9 ? 2'h0 : _T_85; // @[Lookup.scala 33:37]
  wire [1:0] _T_87 = _T_7 ? 2'h0 : _T_86; // @[Lookup.scala 33:37]
  wire [1:0] _T_88 = _T_5 ? 2'h0 : _T_87; // @[Lookup.scala 33:37]
  wire [1:0] _T_89 = _T_3 ? 2'h0 : _T_88; // @[Lookup.scala 33:37]
  assign io_aluSrc = _T_1 | _T_25; // @[Lookup.scala 33:37]
  assign io_memToReg = _T_1 ? 2'h0 : _T_33; // @[Lookup.scala 33:37]
  assign io_regWrite = _T_1 | (_T_3 | (_T_5 | _T_39)); // @[Lookup.scala 33:37]
  assign io_memRead = _T_1 ? 1'h0 : _T_49; // @[Lookup.scala 33:37]
  assign io_memWrite = _T_1 ? 1'h0 : _T_57; // @[Lookup.scala 33:37]
  assign io_branch = _T_1 ? 1'h0 : _T_25; // @[Lookup.scala 33:37]
  assign io_aluOp = _T_1 ? 2'h2 : _T_81; // @[Lookup.scala 33:37]
  assign io_jump = _T_1 ? 2'h0 : _T_73; // @[Lookup.scala 33:37]
  assign io_aluSrc1 = _T_1 ? 2'h0 : _T_89; // @[Lookup.scala 33:37]
endmodule
module Registers(
  input         clock,
  input         reset,
  input  [4:0]  io_readAddress_0,
  input  [4:0]  io_readAddress_1,
  input         io_writeEnable,
  input  [4:0]  io_writeAddress,
  input  [31:0] io_writeData,
  output [31:0] io_readData_0,
  output [31:0] io_readData_1
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_15;
  reg [31:0] _RAND_16;
  reg [31:0] _RAND_17;
  reg [31:0] _RAND_18;
  reg [31:0] _RAND_19;
  reg [31:0] _RAND_20;
  reg [31:0] _RAND_21;
  reg [31:0] _RAND_22;
  reg [31:0] _RAND_23;
  reg [31:0] _RAND_24;
  reg [31:0] _RAND_25;
  reg [31:0] _RAND_26;
  reg [31:0] _RAND_27;
  reg [31:0] _RAND_28;
  reg [31:0] _RAND_29;
  reg [31:0] _RAND_30;
  reg [31:0] _RAND_31;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] reg_0; // @[Registers.scala 14:20]
  reg [31:0] reg_1; // @[Registers.scala 14:20]
  reg [31:0] reg_2; // @[Registers.scala 14:20]
  reg [31:0] reg_3; // @[Registers.scala 14:20]
  reg [31:0] reg_4; // @[Registers.scala 14:20]
  reg [31:0] reg_5; // @[Registers.scala 14:20]
  reg [31:0] reg_6; // @[Registers.scala 14:20]
  reg [31:0] reg_7; // @[Registers.scala 14:20]
  reg [31:0] reg_8; // @[Registers.scala 14:20]
  reg [31:0] reg_9; // @[Registers.scala 14:20]
  reg [31:0] reg_10; // @[Registers.scala 14:20]
  reg [31:0] reg_11; // @[Registers.scala 14:20]
  reg [31:0] reg_12; // @[Registers.scala 14:20]
  reg [31:0] reg_13; // @[Registers.scala 14:20]
  reg [31:0] reg_14; // @[Registers.scala 14:20]
  reg [31:0] reg_15; // @[Registers.scala 14:20]
  reg [31:0] reg_16; // @[Registers.scala 14:20]
  reg [31:0] reg_17; // @[Registers.scala 14:20]
  reg [31:0] reg_18; // @[Registers.scala 14:20]
  reg [31:0] reg_19; // @[Registers.scala 14:20]
  reg [31:0] reg_20; // @[Registers.scala 14:20]
  reg [31:0] reg_21; // @[Registers.scala 14:20]
  reg [31:0] reg_22; // @[Registers.scala 14:20]
  reg [31:0] reg_23; // @[Registers.scala 14:20]
  reg [31:0] reg_24; // @[Registers.scala 14:20]
  reg [31:0] reg_25; // @[Registers.scala 14:20]
  reg [31:0] reg_26; // @[Registers.scala 14:20]
  reg [31:0] reg_27; // @[Registers.scala 14:20]
  reg [31:0] reg_28; // @[Registers.scala 14:20]
  reg [31:0] reg_29; // @[Registers.scala 14:20]
  reg [31:0] reg_30; // @[Registers.scala 14:20]
  reg [31:0] reg_31; // @[Registers.scala 14:20]
  wire [31:0] _GEN_65 = 5'h1 == io_readAddress_0 ? reg_1 : reg_0; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_66 = 5'h2 == io_readAddress_0 ? reg_2 : _GEN_65; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_67 = 5'h3 == io_readAddress_0 ? reg_3 : _GEN_66; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_68 = 5'h4 == io_readAddress_0 ? reg_4 : _GEN_67; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_69 = 5'h5 == io_readAddress_0 ? reg_5 : _GEN_68; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_70 = 5'h6 == io_readAddress_0 ? reg_6 : _GEN_69; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_71 = 5'h7 == io_readAddress_0 ? reg_7 : _GEN_70; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_72 = 5'h8 == io_readAddress_0 ? reg_8 : _GEN_71; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_73 = 5'h9 == io_readAddress_0 ? reg_9 : _GEN_72; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_74 = 5'ha == io_readAddress_0 ? reg_10 : _GEN_73; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_75 = 5'hb == io_readAddress_0 ? reg_11 : _GEN_74; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_76 = 5'hc == io_readAddress_0 ? reg_12 : _GEN_75; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_77 = 5'hd == io_readAddress_0 ? reg_13 : _GEN_76; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_78 = 5'he == io_readAddress_0 ? reg_14 : _GEN_77; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_79 = 5'hf == io_readAddress_0 ? reg_15 : _GEN_78; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_80 = 5'h10 == io_readAddress_0 ? reg_16 : _GEN_79; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_81 = 5'h11 == io_readAddress_0 ? reg_17 : _GEN_80; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_82 = 5'h12 == io_readAddress_0 ? reg_18 : _GEN_81; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_83 = 5'h13 == io_readAddress_0 ? reg_19 : _GEN_82; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_84 = 5'h14 == io_readAddress_0 ? reg_20 : _GEN_83; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_85 = 5'h15 == io_readAddress_0 ? reg_21 : _GEN_84; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_86 = 5'h16 == io_readAddress_0 ? reg_22 : _GEN_85; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_87 = 5'h17 == io_readAddress_0 ? reg_23 : _GEN_86; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_88 = 5'h18 == io_readAddress_0 ? reg_24 : _GEN_87; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_89 = 5'h19 == io_readAddress_0 ? reg_25 : _GEN_88; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_90 = 5'h1a == io_readAddress_0 ? reg_26 : _GEN_89; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_91 = 5'h1b == io_readAddress_0 ? reg_27 : _GEN_90; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_92 = 5'h1c == io_readAddress_0 ? reg_28 : _GEN_91; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_93 = 5'h1d == io_readAddress_0 ? reg_29 : _GEN_92; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_94 = 5'h1e == io_readAddress_0 ? reg_30 : _GEN_93; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_95 = 5'h1f == io_readAddress_0 ? reg_31 : _GEN_94; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_98 = 5'h1 == io_readAddress_1 ? reg_1 : reg_0; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_99 = 5'h2 == io_readAddress_1 ? reg_2 : _GEN_98; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_100 = 5'h3 == io_readAddress_1 ? reg_3 : _GEN_99; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_101 = 5'h4 == io_readAddress_1 ? reg_4 : _GEN_100; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_102 = 5'h5 == io_readAddress_1 ? reg_5 : _GEN_101; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_103 = 5'h6 == io_readAddress_1 ? reg_6 : _GEN_102; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_104 = 5'h7 == io_readAddress_1 ? reg_7 : _GEN_103; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_105 = 5'h8 == io_readAddress_1 ? reg_8 : _GEN_104; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_106 = 5'h9 == io_readAddress_1 ? reg_9 : _GEN_105; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_107 = 5'ha == io_readAddress_1 ? reg_10 : _GEN_106; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_108 = 5'hb == io_readAddress_1 ? reg_11 : _GEN_107; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_109 = 5'hc == io_readAddress_1 ? reg_12 : _GEN_108; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_110 = 5'hd == io_readAddress_1 ? reg_13 : _GEN_109; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_111 = 5'he == io_readAddress_1 ? reg_14 : _GEN_110; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_112 = 5'hf == io_readAddress_1 ? reg_15 : _GEN_111; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_113 = 5'h10 == io_readAddress_1 ? reg_16 : _GEN_112; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_114 = 5'h11 == io_readAddress_1 ? reg_17 : _GEN_113; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_115 = 5'h12 == io_readAddress_1 ? reg_18 : _GEN_114; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_116 = 5'h13 == io_readAddress_1 ? reg_19 : _GEN_115; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_117 = 5'h14 == io_readAddress_1 ? reg_20 : _GEN_116; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_118 = 5'h15 == io_readAddress_1 ? reg_21 : _GEN_117; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_119 = 5'h16 == io_readAddress_1 ? reg_22 : _GEN_118; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_120 = 5'h17 == io_readAddress_1 ? reg_23 : _GEN_119; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_121 = 5'h18 == io_readAddress_1 ? reg_24 : _GEN_120; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_122 = 5'h19 == io_readAddress_1 ? reg_25 : _GEN_121; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_123 = 5'h1a == io_readAddress_1 ? reg_26 : _GEN_122; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_124 = 5'h1b == io_readAddress_1 ? reg_27 : _GEN_123; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_125 = 5'h1c == io_readAddress_1 ? reg_28 : _GEN_124; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_126 = 5'h1d == io_readAddress_1 ? reg_29 : _GEN_125; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_127 = 5'h1e == io_readAddress_1 ? reg_30 : _GEN_126; // @[Registers.scala 23:22 Registers.scala 23:22]
  wire [31:0] _GEN_128 = 5'h1f == io_readAddress_1 ? reg_31 : _GEN_127; // @[Registers.scala 23:22 Registers.scala 23:22]
  assign io_readData_0 = io_readAddress_0 == 5'h0 ? 32'h0 : _GEN_95; // @[Registers.scala 20:37 Registers.scala 21:22 Registers.scala 23:22]
  assign io_readData_1 = io_readAddress_1 == 5'h0 ? 32'h0 : _GEN_128; // @[Registers.scala 20:37 Registers.scala 21:22 Registers.scala 23:22]
  always @(posedge clock) begin
    if (reset) begin // @[Registers.scala 14:20]
      reg_0 <= 32'h0; // @[Registers.scala 14:20]
    end else if (io_writeEnable) begin // @[Registers.scala 16:24]
      if (5'h0 == io_writeAddress) begin // @[Registers.scala 17:26]
        reg_0 <= io_writeData; // @[Registers.scala 17:26]
      end
    end
    if (reset) begin // @[Registers.scala 14:20]
      reg_1 <= 32'h0; // @[Registers.scala 14:20]
    end else if (io_writeEnable) begin // @[Registers.scala 16:24]
      if (5'h1 == io_writeAddress) begin // @[Registers.scala 17:26]
        reg_1 <= io_writeData; // @[Registers.scala 17:26]
      end
    end
    if (reset) begin // @[Registers.scala 14:20]
      reg_2 <= 32'h0; // @[Registers.scala 14:20]
    end else if (io_writeEnable) begin // @[Registers.scala 16:24]
      if (5'h2 == io_writeAddress) begin // @[Registers.scala 17:26]
        reg_2 <= io_writeData; // @[Registers.scala 17:26]
      end
    end
    if (reset) begin // @[Registers.scala 14:20]
      reg_3 <= 32'h0; // @[Registers.scala 14:20]
    end else if (io_writeEnable) begin // @[Registers.scala 16:24]
      if (5'h3 == io_writeAddress) begin // @[Registers.scala 17:26]
        reg_3 <= io_writeData; // @[Registers.scala 17:26]
      end
    end
    if (reset) begin // @[Registers.scala 14:20]
      reg_4 <= 32'h0; // @[Registers.scala 14:20]
    end else if (io_writeEnable) begin // @[Registers.scala 16:24]
      if (5'h4 == io_writeAddress) begin // @[Registers.scala 17:26]
        reg_4 <= io_writeData; // @[Registers.scala 17:26]
      end
    end
    if (reset) begin // @[Registers.scala 14:20]
      reg_5 <= 32'h0; // @[Registers.scala 14:20]
    end else if (io_writeEnable) begin // @[Registers.scala 16:24]
      if (5'h5 == io_writeAddress) begin // @[Registers.scala 17:26]
        reg_5 <= io_writeData; // @[Registers.scala 17:26]
      end
    end
    if (reset) begin // @[Registers.scala 14:20]
      reg_6 <= 32'h0; // @[Registers.scala 14:20]
    end else if (io_writeEnable) begin // @[Registers.scala 16:24]
      if (5'h6 == io_writeAddress) begin // @[Registers.scala 17:26]
        reg_6 <= io_writeData; // @[Registers.scala 17:26]
      end
    end
    if (reset) begin // @[Registers.scala 14:20]
      reg_7 <= 32'h0; // @[Registers.scala 14:20]
    end else if (io_writeEnable) begin // @[Registers.scala 16:24]
      if (5'h7 == io_writeAddress) begin // @[Registers.scala 17:26]
        reg_7 <= io_writeData; // @[Registers.scala 17:26]
      end
    end
    if (reset) begin // @[Registers.scala 14:20]
      reg_8 <= 32'h0; // @[Registers.scala 14:20]
    end else if (io_writeEnable) begin // @[Registers.scala 16:24]
      if (5'h8 == io_writeAddress) begin // @[Registers.scala 17:26]
        reg_8 <= io_writeData; // @[Registers.scala 17:26]
      end
    end
    if (reset) begin // @[Registers.scala 14:20]
      reg_9 <= 32'h0; // @[Registers.scala 14:20]
    end else if (io_writeEnable) begin // @[Registers.scala 16:24]
      if (5'h9 == io_writeAddress) begin // @[Registers.scala 17:26]
        reg_9 <= io_writeData; // @[Registers.scala 17:26]
      end
    end
    if (reset) begin // @[Registers.scala 14:20]
      reg_10 <= 32'h0; // @[Registers.scala 14:20]
    end else if (io_writeEnable) begin // @[Registers.scala 16:24]
      if (5'ha == io_writeAddress) begin // @[Registers.scala 17:26]
        reg_10 <= io_writeData; // @[Registers.scala 17:26]
      end
    end
    if (reset) begin // @[Registers.scala 14:20]
      reg_11 <= 32'h0; // @[Registers.scala 14:20]
    end else if (io_writeEnable) begin // @[Registers.scala 16:24]
      if (5'hb == io_writeAddress) begin // @[Registers.scala 17:26]
        reg_11 <= io_writeData; // @[Registers.scala 17:26]
      end
    end
    if (reset) begin // @[Registers.scala 14:20]
      reg_12 <= 32'h0; // @[Registers.scala 14:20]
    end else if (io_writeEnable) begin // @[Registers.scala 16:24]
      if (5'hc == io_writeAddress) begin // @[Registers.scala 17:26]
        reg_12 <= io_writeData; // @[Registers.scala 17:26]
      end
    end
    if (reset) begin // @[Registers.scala 14:20]
      reg_13 <= 32'h0; // @[Registers.scala 14:20]
    end else if (io_writeEnable) begin // @[Registers.scala 16:24]
      if (5'hd == io_writeAddress) begin // @[Registers.scala 17:26]
        reg_13 <= io_writeData; // @[Registers.scala 17:26]
      end
    end
    if (reset) begin // @[Registers.scala 14:20]
      reg_14 <= 32'h0; // @[Registers.scala 14:20]
    end else if (io_writeEnable) begin // @[Registers.scala 16:24]
      if (5'he == io_writeAddress) begin // @[Registers.scala 17:26]
        reg_14 <= io_writeData; // @[Registers.scala 17:26]
      end
    end
    if (reset) begin // @[Registers.scala 14:20]
      reg_15 <= 32'h0; // @[Registers.scala 14:20]
    end else if (io_writeEnable) begin // @[Registers.scala 16:24]
      if (5'hf == io_writeAddress) begin // @[Registers.scala 17:26]
        reg_15 <= io_writeData; // @[Registers.scala 17:26]
      end
    end
    if (reset) begin // @[Registers.scala 14:20]
      reg_16 <= 32'h0; // @[Registers.scala 14:20]
    end else if (io_writeEnable) begin // @[Registers.scala 16:24]
      if (5'h10 == io_writeAddress) begin // @[Registers.scala 17:26]
        reg_16 <= io_writeData; // @[Registers.scala 17:26]
      end
    end
    if (reset) begin // @[Registers.scala 14:20]
      reg_17 <= 32'h0; // @[Registers.scala 14:20]
    end else if (io_writeEnable) begin // @[Registers.scala 16:24]
      if (5'h11 == io_writeAddress) begin // @[Registers.scala 17:26]
        reg_17 <= io_writeData; // @[Registers.scala 17:26]
      end
    end
    if (reset) begin // @[Registers.scala 14:20]
      reg_18 <= 32'h0; // @[Registers.scala 14:20]
    end else if (io_writeEnable) begin // @[Registers.scala 16:24]
      if (5'h12 == io_writeAddress) begin // @[Registers.scala 17:26]
        reg_18 <= io_writeData; // @[Registers.scala 17:26]
      end
    end
    if (reset) begin // @[Registers.scala 14:20]
      reg_19 <= 32'h0; // @[Registers.scala 14:20]
    end else if (io_writeEnable) begin // @[Registers.scala 16:24]
      if (5'h13 == io_writeAddress) begin // @[Registers.scala 17:26]
        reg_19 <= io_writeData; // @[Registers.scala 17:26]
      end
    end
    if (reset) begin // @[Registers.scala 14:20]
      reg_20 <= 32'h0; // @[Registers.scala 14:20]
    end else if (io_writeEnable) begin // @[Registers.scala 16:24]
      if (5'h14 == io_writeAddress) begin // @[Registers.scala 17:26]
        reg_20 <= io_writeData; // @[Registers.scala 17:26]
      end
    end
    if (reset) begin // @[Registers.scala 14:20]
      reg_21 <= 32'h0; // @[Registers.scala 14:20]
    end else if (io_writeEnable) begin // @[Registers.scala 16:24]
      if (5'h15 == io_writeAddress) begin // @[Registers.scala 17:26]
        reg_21 <= io_writeData; // @[Registers.scala 17:26]
      end
    end
    if (reset) begin // @[Registers.scala 14:20]
      reg_22 <= 32'h0; // @[Registers.scala 14:20]
    end else if (io_writeEnable) begin // @[Registers.scala 16:24]
      if (5'h16 == io_writeAddress) begin // @[Registers.scala 17:26]
        reg_22 <= io_writeData; // @[Registers.scala 17:26]
      end
    end
    if (reset) begin // @[Registers.scala 14:20]
      reg_23 <= 32'h0; // @[Registers.scala 14:20]
    end else if (io_writeEnable) begin // @[Registers.scala 16:24]
      if (5'h17 == io_writeAddress) begin // @[Registers.scala 17:26]
        reg_23 <= io_writeData; // @[Registers.scala 17:26]
      end
    end
    if (reset) begin // @[Registers.scala 14:20]
      reg_24 <= 32'h0; // @[Registers.scala 14:20]
    end else if (io_writeEnable) begin // @[Registers.scala 16:24]
      if (5'h18 == io_writeAddress) begin // @[Registers.scala 17:26]
        reg_24 <= io_writeData; // @[Registers.scala 17:26]
      end
    end
    if (reset) begin // @[Registers.scala 14:20]
      reg_25 <= 32'h0; // @[Registers.scala 14:20]
    end else if (io_writeEnable) begin // @[Registers.scala 16:24]
      if (5'h19 == io_writeAddress) begin // @[Registers.scala 17:26]
        reg_25 <= io_writeData; // @[Registers.scala 17:26]
      end
    end
    if (reset) begin // @[Registers.scala 14:20]
      reg_26 <= 32'h0; // @[Registers.scala 14:20]
    end else if (io_writeEnable) begin // @[Registers.scala 16:24]
      if (5'h1a == io_writeAddress) begin // @[Registers.scala 17:26]
        reg_26 <= io_writeData; // @[Registers.scala 17:26]
      end
    end
    if (reset) begin // @[Registers.scala 14:20]
      reg_27 <= 32'h0; // @[Registers.scala 14:20]
    end else if (io_writeEnable) begin // @[Registers.scala 16:24]
      if (5'h1b == io_writeAddress) begin // @[Registers.scala 17:26]
        reg_27 <= io_writeData; // @[Registers.scala 17:26]
      end
    end
    if (reset) begin // @[Registers.scala 14:20]
      reg_28 <= 32'h0; // @[Registers.scala 14:20]
    end else if (io_writeEnable) begin // @[Registers.scala 16:24]
      if (5'h1c == io_writeAddress) begin // @[Registers.scala 17:26]
        reg_28 <= io_writeData; // @[Registers.scala 17:26]
      end
    end
    if (reset) begin // @[Registers.scala 14:20]
      reg_29 <= 32'h0; // @[Registers.scala 14:20]
    end else if (io_writeEnable) begin // @[Registers.scala 16:24]
      if (5'h1d == io_writeAddress) begin // @[Registers.scala 17:26]
        reg_29 <= io_writeData; // @[Registers.scala 17:26]
      end
    end
    if (reset) begin // @[Registers.scala 14:20]
      reg_30 <= 32'h0; // @[Registers.scala 14:20]
    end else if (io_writeEnable) begin // @[Registers.scala 16:24]
      if (5'h1e == io_writeAddress) begin // @[Registers.scala 17:26]
        reg_30 <= io_writeData; // @[Registers.scala 17:26]
      end
    end
    if (reset) begin // @[Registers.scala 14:20]
      reg_31 <= 32'h0; // @[Registers.scala 14:20]
    end else if (io_writeEnable) begin // @[Registers.scala 16:24]
      if (5'h1f == io_writeAddress) begin // @[Registers.scala 17:26]
        reg_31 <= io_writeData; // @[Registers.scala 17:26]
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  reg_0 = _RAND_0[31:0];
  _RAND_1 = {1{`RANDOM}};
  reg_1 = _RAND_1[31:0];
  _RAND_2 = {1{`RANDOM}};
  reg_2 = _RAND_2[31:0];
  _RAND_3 = {1{`RANDOM}};
  reg_3 = _RAND_3[31:0];
  _RAND_4 = {1{`RANDOM}};
  reg_4 = _RAND_4[31:0];
  _RAND_5 = {1{`RANDOM}};
  reg_5 = _RAND_5[31:0];
  _RAND_6 = {1{`RANDOM}};
  reg_6 = _RAND_6[31:0];
  _RAND_7 = {1{`RANDOM}};
  reg_7 = _RAND_7[31:0];
  _RAND_8 = {1{`RANDOM}};
  reg_8 = _RAND_8[31:0];
  _RAND_9 = {1{`RANDOM}};
  reg_9 = _RAND_9[31:0];
  _RAND_10 = {1{`RANDOM}};
  reg_10 = _RAND_10[31:0];
  _RAND_11 = {1{`RANDOM}};
  reg_11 = _RAND_11[31:0];
  _RAND_12 = {1{`RANDOM}};
  reg_12 = _RAND_12[31:0];
  _RAND_13 = {1{`RANDOM}};
  reg_13 = _RAND_13[31:0];
  _RAND_14 = {1{`RANDOM}};
  reg_14 = _RAND_14[31:0];
  _RAND_15 = {1{`RANDOM}};
  reg_15 = _RAND_15[31:0];
  _RAND_16 = {1{`RANDOM}};
  reg_16 = _RAND_16[31:0];
  _RAND_17 = {1{`RANDOM}};
  reg_17 = _RAND_17[31:0];
  _RAND_18 = {1{`RANDOM}};
  reg_18 = _RAND_18[31:0];
  _RAND_19 = {1{`RANDOM}};
  reg_19 = _RAND_19[31:0];
  _RAND_20 = {1{`RANDOM}};
  reg_20 = _RAND_20[31:0];
  _RAND_21 = {1{`RANDOM}};
  reg_21 = _RAND_21[31:0];
  _RAND_22 = {1{`RANDOM}};
  reg_22 = _RAND_22[31:0];
  _RAND_23 = {1{`RANDOM}};
  reg_23 = _RAND_23[31:0];
  _RAND_24 = {1{`RANDOM}};
  reg_24 = _RAND_24[31:0];
  _RAND_25 = {1{`RANDOM}};
  reg_25 = _RAND_25[31:0];
  _RAND_26 = {1{`RANDOM}};
  reg_26 = _RAND_26[31:0];
  _RAND_27 = {1{`RANDOM}};
  reg_27 = _RAND_27[31:0];
  _RAND_28 = {1{`RANDOM}};
  reg_28 = _RAND_28[31:0];
  _RAND_29 = {1{`RANDOM}};
  reg_29 = _RAND_29[31:0];
  _RAND_30 = {1{`RANDOM}};
  reg_30 = _RAND_30[31:0];
  _RAND_31 = {1{`RANDOM}};
  reg_31 = _RAND_31[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module ImmediateGen(
  input  [31:0] io_instruction,
  output [31:0] io_out
);
  wire [6:0] opcode = io_instruction[6:0]; // @[ImmediateGen.scala 11:30]
  wire  _T_10 = opcode == 7'h3 | opcode == 7'hf | opcode == 7'h13 | opcode == 7'h1b | opcode == 7'h67 | opcode == 7'h73; // @[ImmediateGen.scala 15:97]
  wire [11:0] lo = io_instruction[31:20]; // @[ImmediateGen.scala 17:31]
  wire [19:0] hi = lo[11] ? 20'hfffff : 20'h0; // @[Bitwise.scala 72:12]
  wire [31:0] _T_13 = {hi,lo}; // @[Cat.scala 30:58]
  wire [19:0] hi_1 = io_instruction[31:12]; // @[ImmediateGen.scala 24:33]
  wire [31:0] _T_17 = {hi_1,12'h0}; // @[Cat.scala 30:58]
  wire [6:0] hi_2 = io_instruction[31:25]; // @[ImmediateGen.scala 30:37]
  wire [4:0] lo_2 = io_instruction[11:7]; // @[ImmediateGen.scala 30:61]
  wire [11:0] lo_3 = {hi_2,lo_2}; // @[Cat.scala 30:58]
  wire [19:0] hi_3 = lo_3[11] ? 20'hfffff : 20'h0; // @[Bitwise.scala 72:12]
  wire [31:0] _T_21 = {hi_3,hi_2,lo_2}; // @[Cat.scala 30:58]
  wire  hi_hi = io_instruction[31]; // @[ImmediateGen.scala 37:23]
  wire  hi_lo = io_instruction[7]; // @[ImmediateGen.scala 38:23]
  wire [5:0] lo_hi = io_instruction[30:25]; // @[ImmediateGen.scala 39:23]
  wire [3:0] lo_lo = io_instruction[11:8]; // @[ImmediateGen.scala 40:23]
  wire [11:0] hi_lo_1 = {hi_hi,hi_lo,lo_hi,lo_lo}; // @[Cat.scala 30:58]
  wire [18:0] hi_hi_1 = hi_lo_1[11] ? 19'h7ffff : 19'h0; // @[Bitwise.scala 72:12]
  wire [31:0] _T_25 = {hi_hi_1,hi_hi,hi_lo,lo_hi,lo_lo,1'h0}; // @[Cat.scala 30:58]
  wire [7:0] hi_lo_2 = io_instruction[19:12]; // @[ImmediateGen.scala 50:21]
  wire  lo_hi_1 = io_instruction[20]; // @[ImmediateGen.scala 51:21]
  wire [9:0] lo_lo_1 = io_instruction[30:21]; // @[ImmediateGen.scala 52:21]
  wire [19:0] hi_lo_3 = {hi_hi,hi_lo_2,lo_hi_1,lo_lo_1}; // @[Cat.scala 30:58]
  wire [10:0] hi_hi_3 = hi_lo_3[19] ? 11'h7ff : 11'h0; // @[Bitwise.scala 72:12]
  wire [31:0] _T_28 = {hi_hi_3,hi_hi,hi_lo_2,lo_hi_1,lo_lo_1,1'h0}; // @[Cat.scala 30:58]
  wire [31:0] _GEN_0 = opcode == 7'h63 ? _T_25 : _T_28; // @[ImmediateGen.scala 35:32 ImmediateGen.scala 43:14 ImmediateGen.scala 55:12]
  wire [31:0] _GEN_1 = opcode == 7'h23 ? _T_21 : _GEN_0; // @[ImmediateGen.scala 29:32 ImmediateGen.scala 32:14]
  wire [31:0] _GEN_2 = opcode == 7'h17 | opcode == 7'h37 ? _T_17 : _GEN_1; // @[ImmediateGen.scala 23:51 ImmediateGen.scala 26:14]
  assign io_out = _T_10 ? _T_13 : _GEN_2; // @[ImmediateGen.scala 16:5 ImmediateGen.scala 19:12]
endmodule
module BranchUnit(
  input         io_branch,
  input  [2:0]  io_funct3,
  input  [31:0] io_rd1,
  input  [31:0] io_rd2,
  input         io_take_branch,
  output        io_taken
);
  wire  _T = 3'h0 == io_funct3; // @[Conditional.scala 37:30]
  wire  _T_2 = 3'h1 == io_funct3; // @[Conditional.scala 37:30]
  wire  _T_4 = 3'h4 == io_funct3; // @[Conditional.scala 37:30]
  wire  _T_8 = 3'h5 == io_funct3; // @[Conditional.scala 37:30]
  wire  _T_12 = 3'h6 == io_funct3; // @[Conditional.scala 37:30]
  wire  _T_15 = io_rd1 >= io_rd2; // @[BranchUnit.scala 28:32]
  wire  _GEN_1 = _T_12 ? io_rd1 < io_rd2 : _T_15; // @[Conditional.scala 39:67 BranchUnit.scala 27:21]
  wire  _GEN_2 = _T_8 ? $signed(io_rd1) >= $signed(io_rd2) : _GEN_1; // @[Conditional.scala 39:67 BranchUnit.scala 26:21]
  wire  _GEN_3 = _T_4 ? $signed(io_rd1) < $signed(io_rd2) : _GEN_2; // @[Conditional.scala 39:67 BranchUnit.scala 25:21]
  wire  _GEN_4 = _T_2 ? io_rd1 != io_rd2 : _GEN_3; // @[Conditional.scala 39:67 BranchUnit.scala 24:21]
  wire  check = _T ? io_rd1 == io_rd2 : _GEN_4; // @[Conditional.scala 40:58 BranchUnit.scala 23:21]
  assign io_taken = check & io_branch & io_take_branch; // @[BranchUnit.scala 31:33]
endmodule
module InstructionDecode(
  input         clock,
  input         reset,
  input  [31:0] io_id_instruction,
  input  [31:0] io_writeData,
  input  [4:0]  io_writeReg,
  input  [31:0] io_pcAddress,
  input         io_ctl_writeEnable,
  input         io_id_ex_mem_read,
  input         io_ex_mem_mem_read,
  input  [4:0]  io_id_ex_rd,
  input  [4:0]  io_ex_mem_rd,
  input         io_id_ex_branch,
  input  [31:0] io_ex_mem_ins,
  input  [31:0] io_mem_wb_ins,
  input  [31:0] io_ex_ins,
  input  [31:0] io_ex_result,
  input  [31:0] io_ex_mem_result,
  input  [31:0] io_mem_wb_result,
  output [31:0] io_immediate,
  output [4:0]  io_writeRegAddress,
  output [31:0] io_readData1,
  output [31:0] io_readData2,
  output [6:0]  io_func7,
  output [2:0]  io_func3,
  output        io_ctl_aluSrc,
  output [1:0]  io_ctl_memToReg,
  output        io_ctl_regWrite,
  output        io_ctl_memRead,
  output        io_ctl_memWrite,
  output        io_ctl_branch,
  output [1:0]  io_ctl_aluOp,
  output [1:0]  io_ctl_jump,
  output [1:0]  io_ctl_aluSrc1,
  output        io_hdu_pcWrite,
  output        io_hdu_if_reg_write,
  output        io_pcSrc,
  output [31:0] io_pcPlusOffset,
  output        io_ifid_flush,
  output        io_stall,
  output [4:0]  io_rs_addr_0,
  output [4:0]  io_rs_addr_1
);
  wire  hdu_io_id_ex_memRead; // @[InstructionDecode.scala 56:19]
  wire  hdu_io_ex_mem_memRead; // @[InstructionDecode.scala 56:19]
  wire  hdu_io_id_ex_branch; // @[InstructionDecode.scala 56:19]
  wire [4:0] hdu_io_id_ex_rd; // @[InstructionDecode.scala 56:19]
  wire [4:0] hdu_io_ex_mem_rd; // @[InstructionDecode.scala 56:19]
  wire [4:0] hdu_io_id_rs1; // @[InstructionDecode.scala 56:19]
  wire [4:0] hdu_io_id_rs2; // @[InstructionDecode.scala 56:19]
  wire  hdu_io_taken; // @[InstructionDecode.scala 56:19]
  wire [1:0] hdu_io_jump; // @[InstructionDecode.scala 56:19]
  wire  hdu_io_branch; // @[InstructionDecode.scala 56:19]
  wire  hdu_io_if_reg_write; // @[InstructionDecode.scala 56:19]
  wire  hdu_io_pc_write; // @[InstructionDecode.scala 56:19]
  wire  hdu_io_ctl_mux; // @[InstructionDecode.scala 56:19]
  wire  hdu_io_ifid_flush; // @[InstructionDecode.scala 56:19]
  wire  hdu_io_take_branch; // @[InstructionDecode.scala 56:19]
  wire [31:0] control_io_in; // @[InstructionDecode.scala 72:23]
  wire  control_io_aluSrc; // @[InstructionDecode.scala 72:23]
  wire [1:0] control_io_memToReg; // @[InstructionDecode.scala 72:23]
  wire  control_io_regWrite; // @[InstructionDecode.scala 72:23]
  wire  control_io_memRead; // @[InstructionDecode.scala 72:23]
  wire  control_io_memWrite; // @[InstructionDecode.scala 72:23]
  wire  control_io_branch; // @[InstructionDecode.scala 72:23]
  wire [1:0] control_io_aluOp; // @[InstructionDecode.scala 72:23]
  wire [1:0] control_io_jump; // @[InstructionDecode.scala 72:23]
  wire [1:0] control_io_aluSrc1; // @[InstructionDecode.scala 72:23]
  wire  registers_clock; // @[InstructionDecode.scala 91:25]
  wire  registers_reset; // @[InstructionDecode.scala 91:25]
  wire [4:0] registers_io_readAddress_0; // @[InstructionDecode.scala 91:25]
  wire [4:0] registers_io_readAddress_1; // @[InstructionDecode.scala 91:25]
  wire  registers_io_writeEnable; // @[InstructionDecode.scala 91:25]
  wire [4:0] registers_io_writeAddress; // @[InstructionDecode.scala 91:25]
  wire [31:0] registers_io_writeData; // @[InstructionDecode.scala 91:25]
  wire [31:0] registers_io_readData_0; // @[InstructionDecode.scala 91:25]
  wire [31:0] registers_io_readData_1; // @[InstructionDecode.scala 91:25]
  wire [31:0] immediate_io_instruction; // @[InstructionDecode.scala 122:25]
  wire [31:0] immediate_io_out; // @[InstructionDecode.scala 122:25]
  wire  bu_io_branch; // @[InstructionDecode.scala 148:18]
  wire [2:0] bu_io_funct3; // @[InstructionDecode.scala 148:18]
  wire [31:0] bu_io_rd1; // @[InstructionDecode.scala 148:18]
  wire [31:0] bu_io_rd2; // @[InstructionDecode.scala 148:18]
  wire  bu_io_take_branch; // @[InstructionDecode.scala 148:18]
  wire  bu_io_taken; // @[InstructionDecode.scala 148:18]
  wire [31:0] _GEN_2 = io_id_instruction[19:15] == 5'h0 ? 32'h0 : io_writeData; // @[InstructionDecode.scala 103:30 InstructionDecode.scala 104:20 InstructionDecode.scala 106:20]
  wire [31:0] _GEN_4 = io_id_instruction[24:20] == 5'h0 ? 32'h0 : io_writeData; // @[InstructionDecode.scala 112:30 InstructionDecode.scala 113:20 InstructionDecode.scala 115:20]
  wire  _T_11 = io_id_instruction[19:15] == io_ex_mem_ins[11:7]; // @[InstructionDecode.scala 130:20]
  wire  _T_13 = io_id_instruction[19:15] == io_mem_wb_ins[11:7]; // @[InstructionDecode.scala 132:26]
  wire [31:0] _GEN_6 = io_id_instruction[19:15] == io_mem_wb_ins[11:7] ? io_mem_wb_result : io_readData1; // @[InstructionDecode.scala 132:52 InstructionDecode.scala 133:14 InstructionDecode.scala 136:14]
  wire [31:0] _GEN_8 = io_id_instruction[24:20] == io_mem_wb_ins[11:7] ? io_mem_wb_result : io_readData2; // @[InstructionDecode.scala 140:52 InstructionDecode.scala 141:14 InstructionDecode.scala 144:14]
  wire  _T_20 = io_id_instruction[19:15] == io_ex_ins[11:7]; // @[InstructionDecode.scala 158:22]
  wire [31:0] _GEN_10 = _T_20 ? io_ex_result : io_readData1; // @[InstructionDecode.scala 164:47 InstructionDecode.scala 165:14 InstructionDecode.scala 167:16]
  wire [31:0] _GEN_11 = _T_13 ? io_mem_wb_result : _GEN_10; // @[InstructionDecode.scala 162:52 InstructionDecode.scala 163:14]
  wire [31:0] _GEN_12 = _T_11 ? io_ex_mem_result : _GEN_11; // @[InstructionDecode.scala 160:54 InstructionDecode.scala 161:14]
  wire [31:0] j_offset = io_id_instruction[19:15] == io_ex_ins[11:7] ? io_ex_result : _GEN_12; // @[InstructionDecode.scala 158:43 InstructionDecode.scala 159:16]
  wire [31:0] _T_29 = io_pcAddress + io_immediate; // @[InstructionDecode.scala 172:37]
  wire [31:0] _T_32 = j_offset + io_immediate; // @[InstructionDecode.scala 174:35]
  wire [31:0] _T_34 = io_pcAddress + immediate_io_out; // @[InstructionDecode.scala 177:39]
  wire [31:0] _GEN_14 = io_ctl_jump == 2'h2 ? _T_32 : _T_34; // @[InstructionDecode.scala 173:35 InstructionDecode.scala 174:23 InstructionDecode.scala 177:23]
  wire  _T_43 = io_func3 == 3'h5; // @[InstructionDecode.scala 191:107]
  HazardUnit hdu ( // @[InstructionDecode.scala 56:19]
    .io_id_ex_memRead(hdu_io_id_ex_memRead),
    .io_ex_mem_memRead(hdu_io_ex_mem_memRead),
    .io_id_ex_branch(hdu_io_id_ex_branch),
    .io_id_ex_rd(hdu_io_id_ex_rd),
    .io_ex_mem_rd(hdu_io_ex_mem_rd),
    .io_id_rs1(hdu_io_id_rs1),
    .io_id_rs2(hdu_io_id_rs2),
    .io_taken(hdu_io_taken),
    .io_jump(hdu_io_jump),
    .io_branch(hdu_io_branch),
    .io_if_reg_write(hdu_io_if_reg_write),
    .io_pc_write(hdu_io_pc_write),
    .io_ctl_mux(hdu_io_ctl_mux),
    .io_ifid_flush(hdu_io_ifid_flush),
    .io_take_branch(hdu_io_take_branch)
  );
  Control control ( // @[InstructionDecode.scala 72:23]
    .io_in(control_io_in),
    .io_aluSrc(control_io_aluSrc),
    .io_memToReg(control_io_memToReg),
    .io_regWrite(control_io_regWrite),
    .io_memRead(control_io_memRead),
    .io_memWrite(control_io_memWrite),
    .io_branch(control_io_branch),
    .io_aluOp(control_io_aluOp),
    .io_jump(control_io_jump),
    .io_aluSrc1(control_io_aluSrc1)
  );
  Registers registers ( // @[InstructionDecode.scala 91:25]
    .clock(registers_clock),
    .reset(registers_reset),
    .io_readAddress_0(registers_io_readAddress_0),
    .io_readAddress_1(registers_io_readAddress_1),
    .io_writeEnable(registers_io_writeEnable),
    .io_writeAddress(registers_io_writeAddress),
    .io_writeData(registers_io_writeData),
    .io_readData_0(registers_io_readData_0),
    .io_readData_1(registers_io_readData_1)
  );
  ImmediateGen immediate ( // @[InstructionDecode.scala 122:25]
    .io_instruction(immediate_io_instruction),
    .io_out(immediate_io_out)
  );
  BranchUnit bu ( // @[InstructionDecode.scala 148:18]
    .io_branch(bu_io_branch),
    .io_funct3(bu_io_funct3),
    .io_rd1(bu_io_rd1),
    .io_rd2(bu_io_rd2),
    .io_take_branch(bu_io_take_branch),
    .io_taken(bu_io_taken)
  );
  assign io_immediate = immediate_io_out; // @[InstructionDecode.scala 124:16]
  assign io_writeRegAddress = io_id_instruction[11:7]; // @[InstructionDecode.scala 189:42]
  assign io_readData1 = io_ctl_writeEnable & io_writeReg == io_id_instruction[19:15] ? _GEN_2 : registers_io_readData_0; // @[InstructionDecode.scala 102:60 InstructionDecode.scala 109:18]
  assign io_readData2 = io_ctl_writeEnable & io_writeReg == io_id_instruction[24:20] ? _GEN_4 : registers_io_readData_1; // @[InstructionDecode.scala 111:60 InstructionDecode.scala 118:18]
  assign io_func7 = io_id_instruction[6:0] == 7'h33 | io_id_instruction[6:0] == 7'h13 & io_func3 == 3'h5 ?
    io_id_instruction[31:25] : 7'h0; // @[InstructionDecode.scala 191:117 InstructionDecode.scala 192:14 InstructionDecode.scala 194:14]
  assign io_func3 = io_id_instruction[14:12]; // @[InstructionDecode.scala 190:32]
  assign io_ctl_aluSrc = control_io_aluSrc; // @[InstructionDecode.scala 75:17]
  assign io_ctl_memToReg = control_io_memToReg; // @[InstructionDecode.scala 79:19]
  assign io_ctl_regWrite = hdu_io_ctl_mux & io_id_instruction != 32'h13 & control_io_regWrite; // @[InstructionDecode.scala 81:57 InstructionDecode.scala 83:21 InstructionDecode.scala 87:21]
  assign io_ctl_memRead = control_io_memRead; // @[InstructionDecode.scala 78:18]
  assign io_ctl_memWrite = hdu_io_ctl_mux & io_id_instruction != 32'h13 & control_io_memWrite; // @[InstructionDecode.scala 81:57 InstructionDecode.scala 82:21 InstructionDecode.scala 86:21]
  assign io_ctl_branch = control_io_branch; // @[InstructionDecode.scala 77:17]
  assign io_ctl_aluOp = control_io_aluOp; // @[InstructionDecode.scala 74:16]
  assign io_ctl_jump = control_io_jump; // @[InstructionDecode.scala 80:15]
  assign io_ctl_aluSrc1 = control_io_aluSrc1; // @[InstructionDecode.scala 76:18]
  assign io_hdu_pcWrite = hdu_io_pc_write; // @[InstructionDecode.scala 68:18]
  assign io_hdu_if_reg_write = hdu_io_if_reg_write; // @[InstructionDecode.scala 69:23]
  assign io_pcSrc = bu_io_taken | io_ctl_jump != 2'h0; // @[InstructionDecode.scala 180:20]
  assign io_pcPlusOffset = io_ctl_jump == 2'h1 ? _T_29 : _GEN_14; // @[InstructionDecode.scala 171:29 InstructionDecode.scala 172:21]
  assign io_ifid_flush = hdu_io_ifid_flush; // @[InstructionDecode.scala 187:17]
  assign io_stall = io_func7 == 7'h1 & (io_func3 == 3'h4 | _T_43 | io_func3 == 3'h6 | io_func3 == 3'h7); // @[InstructionDecode.scala 197:32]
  assign io_rs_addr_0 = io_id_instruction[19:15]; // @[InstructionDecode.scala 93:38]
  assign io_rs_addr_1 = io_id_instruction[24:20]; // @[InstructionDecode.scala 94:38]
  assign hdu_io_id_ex_memRead = io_id_ex_mem_read; // @[InstructionDecode.scala 58:24]
  assign hdu_io_ex_mem_memRead = io_ex_mem_mem_read; // @[InstructionDecode.scala 60:25]
  assign hdu_io_id_ex_branch = io_id_ex_branch; // @[InstructionDecode.scala 62:23]
  assign hdu_io_id_ex_rd = io_id_ex_rd; // @[InstructionDecode.scala 61:19]
  assign hdu_io_ex_mem_rd = io_ex_mem_rd; // @[InstructionDecode.scala 63:20]
  assign hdu_io_id_rs1 = io_id_instruction[19:15]; // @[InstructionDecode.scala 64:37]
  assign hdu_io_id_rs2 = io_id_instruction[24:20]; // @[InstructionDecode.scala 65:37]
  assign hdu_io_taken = bu_io_taken; // @[InstructionDecode.scala 154:16]
  assign hdu_io_jump = io_ctl_jump; // @[InstructionDecode.scala 66:15]
  assign hdu_io_branch = io_ctl_branch; // @[InstructionDecode.scala 67:17]
  assign control_io_in = io_id_instruction; // @[InstructionDecode.scala 73:17]
  assign registers_clock = clock;
  assign registers_reset = reset;
  assign registers_io_readAddress_0 = io_id_instruction[19:15]; // @[InstructionDecode.scala 93:38]
  assign registers_io_readAddress_1 = io_id_instruction[24:20]; // @[InstructionDecode.scala 94:38]
  assign registers_io_writeEnable = io_ctl_writeEnable; // @[InstructionDecode.scala 97:28]
  assign registers_io_writeAddress = io_writeReg; // @[InstructionDecode.scala 98:29]
  assign registers_io_writeData = io_writeData; // @[InstructionDecode.scala 99:26]
  assign immediate_io_instruction = io_id_instruction; // @[InstructionDecode.scala 123:28]
  assign bu_io_branch = io_ctl_branch; // @[InstructionDecode.scala 149:16]
  assign bu_io_funct3 = io_id_instruction[14:12]; // @[InstructionDecode.scala 150:36]
  assign bu_io_rd1 = io_id_instruction[19:15] == io_ex_mem_ins[11:7] ? io_ex_mem_result : _GEN_6; // @[InstructionDecode.scala 130:46 InstructionDecode.scala 131:12]
  assign bu_io_rd2 = io_id_instruction[24:20] == io_ex_mem_ins[11:7] ? io_ex_mem_result : _GEN_8; // @[InstructionDecode.scala 138:46 InstructionDecode.scala 139:12]
  assign bu_io_take_branch = hdu_io_take_branch; // @[InstructionDecode.scala 153:21]
endmodule
module ALU(
  input  [31:0] io_input1,
  input  [31:0] io_input2,
  input  [3:0]  io_aluCtl,
  output [31:0] io_result
);
  wire  _T = io_aluCtl == 4'h0; // @[ALU.scala 17:18]
  wire [31:0] _T_1 = io_input1 & io_input2; // @[ALU.scala 17:41]
  wire  _T_2 = io_aluCtl == 4'h1; // @[ALU.scala 18:18]
  wire [31:0] _T_3 = io_input1 | io_input2; // @[ALU.scala 18:41]
  wire  _T_4 = io_aluCtl == 4'h2; // @[ALU.scala 19:18]
  wire [31:0] _T_6 = io_input1 + io_input2; // @[ALU.scala 19:41]
  wire  _T_7 = io_aluCtl == 4'h3; // @[ALU.scala 20:18]
  wire [31:0] _T_9 = io_input1 - io_input2; // @[ALU.scala 20:41]
  wire  _T_10 = io_aluCtl == 4'h4; // @[ALU.scala 21:18]
  wire  _T_13 = $signed(io_input1) < $signed(io_input2); // @[ALU.scala 21:48]
  wire  _T_14 = io_aluCtl == 4'h5; // @[ALU.scala 22:18]
  wire  _T_15 = io_input1 < io_input2; // @[ALU.scala 22:41]
  wire  _T_16 = io_aluCtl == 4'h6; // @[ALU.scala 23:18]
  wire [62:0] _GEN_0 = {{31'd0}, io_input1}; // @[ALU.scala 23:41]
  wire [62:0] _T_18 = _GEN_0 << io_input2[4:0]; // @[ALU.scala 23:41]
  wire  _T_19 = io_aluCtl == 4'h7; // @[ALU.scala 24:18]
  wire [31:0] _T_21 = io_input1 >> io_input2[4:0]; // @[ALU.scala 24:41]
  wire  _T_22 = io_aluCtl == 4'h8; // @[ALU.scala 25:18]
  wire [31:0] _T_26 = $signed(io_input1) >>> io_input2[4:0]; // @[ALU.scala 25:68]
  wire  _T_27 = io_aluCtl == 4'h9; // @[ALU.scala 26:18]
  wire [31:0] _T_28 = io_input1 ^ io_input2; // @[ALU.scala 26:41]
  wire [31:0] _T_29 = _T_27 ? _T_28 : 32'h0; // @[Mux.scala 98:16]
  wire [31:0] _T_30 = _T_22 ? _T_26 : _T_29; // @[Mux.scala 98:16]
  wire [31:0] _T_31 = _T_19 ? _T_21 : _T_30; // @[Mux.scala 98:16]
  wire [62:0] _T_32 = _T_16 ? _T_18 : {{31'd0}, _T_31}; // @[Mux.scala 98:16]
  wire [62:0] _T_33 = _T_14 ? {{62'd0}, _T_15} : _T_32; // @[Mux.scala 98:16]
  wire [62:0] _T_34 = _T_10 ? {{62'd0}, _T_13} : _T_33; // @[Mux.scala 98:16]
  wire [62:0] _T_35 = _T_7 ? {{31'd0}, _T_9} : _T_34; // @[Mux.scala 98:16]
  wire [62:0] _T_36 = _T_4 ? {{31'd0}, _T_6} : _T_35; // @[Mux.scala 98:16]
  wire [62:0] _T_37 = _T_2 ? {{31'd0}, _T_3} : _T_36; // @[Mux.scala 98:16]
  wire [62:0] _T_38 = _T ? {{31'd0}, _T_1} : _T_37; // @[Mux.scala 98:16]
  assign io_result = _T_38[31:0]; // @[ALU.scala 14:13]
endmodule
module AluControl(
  input  [1:0] io_aluOp,
  input        io_f7,
  input  [2:0] io_f3,
  input        io_aluSrc,
  output [3:0] io_out
);
  wire  _T_1 = 3'h0 == io_f3; // @[Conditional.scala 37:30]
  wire  _T_3 = ~io_f7; // @[AluControl.scala 38:34]
  wire [1:0] _GEN_0 = ~io_aluSrc | ~io_f7 ? 2'h2 : 2'h3; // @[AluControl.scala 38:43 AluControl.scala 39:18 AluControl.scala 42:20]
  wire  _T_5 = 3'h1 == io_f3; // @[Conditional.scala 37:30]
  wire  _T_6 = 3'h2 == io_f3; // @[Conditional.scala 37:30]
  wire  _T_7 = 3'h3 == io_f3; // @[Conditional.scala 37:30]
  wire  _T_8 = 3'h5 == io_f3; // @[Conditional.scala 37:30]
  wire [3:0] _GEN_1 = _T_3 ? 4'h7 : 4'h8; // @[AluControl.scala 55:29 AluControl.scala 56:18 AluControl.scala 58:18]
  wire  _T_10 = 3'h7 == io_f3; // @[Conditional.scala 37:30]
  wire  _T_11 = 3'h6 == io_f3; // @[Conditional.scala 37:30]
  wire  _T_12 = 3'h4 == io_f3; // @[Conditional.scala 37:30]
  wire [3:0] _GEN_2 = _T_12 ? 4'h9 : 4'hf; // @[Conditional.scala 39:67 AluControl.scala 68:16 AluControl.scala 31:10]
  wire [3:0] _GEN_3 = _T_11 ? 4'h1 : _GEN_2; // @[Conditional.scala 39:67 AluControl.scala 65:16]
  wire [3:0] _GEN_4 = _T_10 ? 4'h0 : _GEN_3; // @[Conditional.scala 39:67 AluControl.scala 62:16]
  wire [3:0] _GEN_5 = _T_8 ? _GEN_1 : _GEN_4; // @[Conditional.scala 39:67]
  wire [3:0] _GEN_6 = _T_7 ? 4'h5 : _GEN_5; // @[Conditional.scala 39:67 AluControl.scala 52:16]
  wire [3:0] _GEN_7 = _T_6 ? 4'h4 : _GEN_6; // @[Conditional.scala 39:67 AluControl.scala 49:16]
  wire [3:0] _GEN_8 = _T_5 ? 4'h6 : _GEN_7; // @[Conditional.scala 39:67 AluControl.scala 46:16]
  wire [3:0] _GEN_9 = _T_1 ? {{2'd0}, _GEN_0} : _GEN_8; // @[Conditional.scala 40:58]
  assign io_out = io_aluOp == 2'h0 ? 4'h2 : _GEN_9; // @[AluControl.scala 33:26 AluControl.scala 34:12]
endmodule
module ForwardingUnit(
  input  [4:0] io_ex_reg_rd,
  input  [4:0] io_mem_reg_rd,
  input  [4:0] io_reg_rs1,
  input  [4:0] io_reg_rs2,
  input        io_ex_regWrite,
  input        io_mem_regWrite,
  output [1:0] io_forwardA,
  output [1:0] io_forwardB
);
  wire  _T_1 = io_ex_reg_rd != 5'h0; // @[ForwardingUnit.scala 21:52]
  wire  _T_5 = io_mem_reg_rd != 5'h0; // @[ForwardingUnit.scala 24:53]
  wire  _T_7 = io_reg_rs1 == io_mem_reg_rd & io_mem_reg_rd != 5'h0 & io_mem_regWrite; // @[ForwardingUnit.scala 24:61]
  wire [1:0] _GEN_0 = _T_7 ? 2'h2 : 2'h0; // @[ForwardingUnit.scala 25:7 ForwardingUnit.scala 26:19 ForwardingUnit.scala 29:19]
  wire  _T_15 = io_reg_rs2 == io_mem_reg_rd & _T_5 & io_mem_regWrite; // @[ForwardingUnit.scala 35:61]
  wire [1:0] _GEN_2 = _T_15 ? 2'h2 : 2'h0; // @[ForwardingUnit.scala 36:7 ForwardingUnit.scala 37:19 ForwardingUnit.scala 40:19]
  assign io_forwardA = io_reg_rs1 == io_ex_reg_rd & io_ex_reg_rd != 5'h0 & io_ex_regWrite ? 2'h1 : _GEN_0; // @[ForwardingUnit.scala 21:79 ForwardingUnit.scala 22:17]
  assign io_forwardB = io_reg_rs2 == io_ex_reg_rd & _T_1 & io_ex_regWrite ? 2'h1 : _GEN_2; // @[ForwardingUnit.scala 32:79 ForwardingUnit.scala 33:17]
endmodule
module MDU(
  input         clock,
  input         reset,
  input  [31:0] io_src_a,
  input  [31:0] io_src_b,
  input  [4:0]  io_op,
  input         io_valid,
  output        io_ready,
  output        io_output_valid,
  output [31:0] io_output_bits
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
`endif // RANDOMIZE_REG_INIT
  wire  _T = io_op == 5'h0; // @[MDU.scala 34:16]
  wire  _T_1 = io_op == 5'h3; // @[MDU.scala 34:33]
  wire  _T_2 = io_op == 5'h0 | io_op == 5'h3; // @[MDU.scala 34:24]
  wire [63:0] _T_3 = io_src_a * io_src_b; // @[MDU.scala 34:58]
  wire  _T_4 = io_op == 5'h2; // @[MDU.scala 35:16]
  wire [32:0] _T_6 = {1'b0,$signed(io_src_b)}; // @[MDU.scala 35:66]
  wire [64:0] _T_7 = $signed(io_src_a) * $signed(_T_6); // @[MDU.scala 35:66]
  wire [63:0] _T_10 = _T_7[63:0]; // @[MDU.scala 35:78]
  wire  _T_11 = io_op == 5'h1; // @[MDU.scala 36:16]
  wire [63:0] _T_15 = $signed(io_src_a) * $signed(io_src_b); // @[MDU.scala 36:85]
  wire [63:0] _T_16 = _T_11 ? _T_15 : 64'h0; // @[Mux.scala 98:16]
  wire [63:0] _T_17 = _T_4 ? _T_10 : _T_16; // @[Mux.scala 98:16]
  wire [63:0] result = _T_2 ? _T_3 : _T_17; // @[Mux.scala 98:16]
  reg  r_ready; // @[MDU.scala 41:29]
  reg [5:0] r_counter; // @[MDU.scala 42:29]
  reg [31:0] r_dividend; // @[MDU.scala 43:29]
  reg [31:0] r_quotient; // @[MDU.scala 44:29]
  wire  _T_19 = io_op == 5'h5; // @[MDU.scala 48:39]
  wire  _T_20 = io_op == 5'h7; // @[MDU.scala 48:57]
  wire  is_div_rem_u = io_op == 5'h5 | io_op == 5'h7; // @[MDU.scala 48:48]
  wire  _T_22 = io_op == 5'h4; // @[MDU.scala 49:39]
  wire  _T_23 = io_op == 5'h6; // @[MDU.scala 49:56]
  wire  is_div_rem_s = io_op == 5'h4 | io_op == 5'h6; // @[MDU.scala 49:47]
  wire [31:0] _T_29 = 32'h0 - io_src_a; // @[MDU.scala 51:59]
  wire [31:0] _T_30 = is_div_rem_s & io_src_a[31] ? _T_29 : io_src_a; // @[MDU.scala 51:28]
  wire [31:0] _T_34 = 32'h0 - io_src_b; // @[MDU.scala 52:59]
  wire [31:0] _T_35 = is_div_rem_s & io_src_b[31] ? _T_34 : io_src_b; // @[MDU.scala 52:28]
  wire [5:0] _T_39 = r_counter - 6'h1; // @[MDU.scala 59:52]
  wire [94:0] _GEN_26 = {{63'd0}, _T_35}; // @[MDU.scala 59:40]
  wire [94:0] _T_40 = _GEN_26 << _T_39; // @[MDU.scala 59:40]
  wire [94:0] _GEN_27 = {{63'd0}, r_dividend}; // @[MDU.scala 59:29]
  wire [94:0] _T_46 = _GEN_27 - _T_40; // @[MDU.scala 60:45]
  wire [63:0] _T_49 = 64'h1 << _T_39; // @[MDU.scala 61:51]
  wire [63:0] _GEN_30 = {{32'd0}, r_quotient}; // @[MDU.scala 61:45]
  wire [63:0] _T_51 = _GEN_30 + _T_49; // @[MDU.scala 61:45]
  wire [94:0] _GEN_0 = _GEN_27 >= _T_40 ? _T_46 : {{63'd0}, r_dividend}; // @[MDU.scala 59:59 MDU.scala 60:31 MDU.scala 43:29]
  wire [63:0] _GEN_1 = _GEN_27 >= _T_40 ? _T_51 : {{32'd0}, r_quotient}; // @[MDU.scala 59:59 MDU.scala 61:31 MDU.scala 44:29]
  wire [94:0] _GEN_3 = r_counter != 6'h0 ? _GEN_0 : {{63'd0}, r_dividend}; // @[MDU.scala 58:38 MDU.scala 43:29]
  wire [63:0] _GEN_4 = r_counter != 6'h0 ? _GEN_1 : {{32'd0}, r_quotient}; // @[MDU.scala 58:38 MDU.scala 44:29]
  wire  _GEN_5 = r_counter != 6'h0 ? r_counter == 6'h1 : r_ready; // @[MDU.scala 58:38 MDU.scala 66:24 MDU.scala 41:29]
  wire  _GEN_7 = r_counter != 6'h0 ? 1'h0 : 1'h1; // @[MDU.scala 58:38 MDU.scala 46:21 MDU.scala 68:29]
  wire  _GEN_8 = io_valid ? 1'h0 : _GEN_5; // @[MDU.scala 53:32 MDU.scala 54:24]
  wire [94:0] _GEN_10 = io_valid ? {{63'd0}, _T_30} : _GEN_3; // @[MDU.scala 53:32 MDU.scala 56:24]
  wire [63:0] _GEN_11 = io_valid ? 64'h0 : _GEN_4; // @[MDU.scala 53:32 MDU.scala 57:24]
  wire  _GEN_12 = io_valid ? 1'h0 : _GEN_7; // @[MDU.scala 53:32 MDU.scala 46:21]
  wire  _GEN_13 = is_div_rem_s | is_div_rem_u ? _GEN_8 : r_ready; // @[MDU.scala 50:39 MDU.scala 41:29]
  wire [94:0] _GEN_15 = is_div_rem_s | is_div_rem_u ? _GEN_10 : {{63'd0}, r_dividend}; // @[MDU.scala 50:39 MDU.scala 43:29]
  wire [63:0] _GEN_16 = is_div_rem_s | is_div_rem_u ? _GEN_11 : {{32'd0}, r_quotient}; // @[MDU.scala 50:39 MDU.scala 44:29]
  wire  _GEN_17 = (is_div_rem_s | is_div_rem_u) & _GEN_12; // @[MDU.scala 50:39 MDU.scala 46:21]
  wire [31:0] _T_70 = 32'h0 - r_quotient; // @[MDU.scala 80:76]
  wire [31:0] _T_71 = io_src_a[31] != io_src_b[31] & |io_src_b ? _T_70 : r_quotient; // @[MDU.scala 80:30]
  wire [31:0] _T_76 = 32'h0 - r_dividend; // @[MDU.scala 84:44]
  wire [31:0] _T_77 = io_src_a[31] ? _T_76 : r_dividend; // @[MDU.scala 84:30]
  wire [31:0] _GEN_18 = _T_20 ? r_dividend : 32'h0; // @[MDU.scala 85:31 MDU.scala 86:24 MDU.scala 88:24]
  wire [31:0] _GEN_19 = _T_23 ? _T_77 : _GEN_18; // @[MDU.scala 83:30 MDU.scala 84:24]
  wire [31:0] _GEN_20 = _T_19 ? r_quotient : _GEN_19; // @[MDU.scala 81:31 MDU.scala 82:24]
  wire [31:0] _GEN_21 = _T_22 ? _T_71 : _GEN_20; // @[MDU.scala 79:30 MDU.scala 80:24]
  wire [31:0] _GEN_22 = _T_11 | _T_1 | _T_4 ? result[63:32] : _GEN_21; // @[MDU.scala 76:70 MDU.scala 77:24]
  wire  _GEN_23 = _T_11 | _T_1 | _T_4 | _GEN_17; // @[MDU.scala 76:70 MDU.scala 78:25]
  assign io_ready = r_ready; // @[MDU.scala 72:18]
  assign io_output_valid = _T | _GEN_23; // @[MDU.scala 73:24 MDU.scala 75:25]
  assign io_output_bits = _T ? result[31:0] : _GEN_22; // @[MDU.scala 73:24 MDU.scala 74:24]
  always @(posedge clock) begin
    r_ready <= reset | _GEN_13; // @[MDU.scala 41:29 MDU.scala 41:29]
    if (reset) begin // @[MDU.scala 42:29]
      r_counter <= 6'h20; // @[MDU.scala 42:29]
    end else if (is_div_rem_s | is_div_rem_u) begin // @[MDU.scala 50:39]
      if (io_valid) begin // @[MDU.scala 53:32]
        r_counter <= 6'h20; // @[MDU.scala 55:24]
      end else if (r_counter != 6'h0) begin // @[MDU.scala 58:38]
        r_counter <= _T_39; // @[MDU.scala 65:24]
      end
    end
    if (reset) begin // @[MDU.scala 43:29]
      r_dividend <= 32'h0; // @[MDU.scala 43:29]
    end else begin
      r_dividend <= _GEN_15[31:0];
    end
    if (reset) begin // @[MDU.scala 44:29]
      r_quotient <= 32'h0; // @[MDU.scala 44:29]
    end else begin
      r_quotient <= _GEN_16[31:0];
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  r_ready = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  r_counter = _RAND_1[5:0];
  _RAND_2 = {1{`RANDOM}};
  r_dividend = _RAND_2[31:0];
  _RAND_3 = {1{`RANDOM}};
  r_quotient = _RAND_3[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Execute(
  input         clock,
  input         reset,
  input  [31:0] io_immediate,
  input  [31:0] io_readData1,
  input  [31:0] io_readData2,
  input  [31:0] io_pcAddress,
  input  [6:0]  io_func7,
  input  [2:0]  io_func3,
  input  [31:0] io_mem_result,
  input  [31:0] io_wb_result,
  input         io_ex_mem_regWrite,
  input         io_mem_wb_regWrite,
  input  [31:0] io_id_ex_ins,
  input  [31:0] io_ex_mem_ins,
  input  [31:0] io_mem_wb_ins,
  input         io_ctl_aluSrc,
  input  [1:0]  io_ctl_aluOp,
  input  [1:0]  io_ctl_aluSrc1,
  output [31:0] io_writeData,
  output [31:0] io_ALUresult,
  output        io_stall
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
`endif // RANDOMIZE_REG_INIT
  wire [31:0] alu_io_input1; // @[Execute.scala 33:19]
  wire [31:0] alu_io_input2; // @[Execute.scala 33:19]
  wire [3:0] alu_io_aluCtl; // @[Execute.scala 33:19]
  wire [31:0] alu_io_result; // @[Execute.scala 33:19]
  wire [1:0] aluCtl_io_aluOp; // @[Execute.scala 34:22]
  wire  aluCtl_io_f7; // @[Execute.scala 34:22]
  wire [2:0] aluCtl_io_f3; // @[Execute.scala 34:22]
  wire  aluCtl_io_aluSrc; // @[Execute.scala 34:22]
  wire [3:0] aluCtl_io_out; // @[Execute.scala 34:22]
  wire [4:0] ForwardingUnit_io_ex_reg_rd; // @[Execute.scala 35:18]
  wire [4:0] ForwardingUnit_io_mem_reg_rd; // @[Execute.scala 35:18]
  wire [4:0] ForwardingUnit_io_reg_rs1; // @[Execute.scala 35:18]
  wire [4:0] ForwardingUnit_io_reg_rs2; // @[Execute.scala 35:18]
  wire  ForwardingUnit_io_ex_regWrite; // @[Execute.scala 35:18]
  wire  ForwardingUnit_io_mem_regWrite; // @[Execute.scala 35:18]
  wire [1:0] ForwardingUnit_io_forwardA; // @[Execute.scala 35:18]
  wire [1:0] ForwardingUnit_io_forwardB; // @[Execute.scala 35:18]
  wire  MDU_clock; // @[Execute.scala 83:22]
  wire  MDU_reset; // @[Execute.scala 83:22]
  wire [31:0] MDU_io_src_a; // @[Execute.scala 83:22]
  wire [31:0] MDU_io_src_b; // @[Execute.scala 83:22]
  wire [4:0] MDU_io_op; // @[Execute.scala 83:22]
  wire  MDU_io_valid; // @[Execute.scala 83:22]
  wire  MDU_io_ready; // @[Execute.scala 83:22]
  wire  MDU_io_output_valid; // @[Execute.scala 83:22]
  wire [31:0] MDU_io_output_bits; // @[Execute.scala 83:22]
  wire  _T_4 = ForwardingUnit_io_forwardA == 2'h0; // @[Execute.scala 49:20]
  wire  _T_5 = ForwardingUnit_io_forwardA == 2'h1; // @[Execute.scala 50:20]
  wire  _T_6 = ForwardingUnit_io_forwardA == 2'h2; // @[Execute.scala 51:20]
  wire [31:0] _T_7 = _T_6 ? io_wb_result : 32'h0; // @[Mux.scala 98:16]
  wire [31:0] _T_8 = _T_5 ? io_mem_result : _T_7; // @[Mux.scala 98:16]
  wire [31:0] inputMux1 = _T_4 ? io_readData1 : _T_8; // @[Mux.scala 98:16]
  wire  _T_9 = ForwardingUnit_io_forwardB == 2'h0; // @[Execute.scala 57:20]
  wire  _T_10 = ForwardingUnit_io_forwardB == 2'h1; // @[Execute.scala 58:20]
  wire  _T_11 = ForwardingUnit_io_forwardB == 2'h2; // @[Execute.scala 59:20]
  wire [31:0] _T_12 = _T_11 ? io_wb_result : 32'h0; // @[Mux.scala 98:16]
  wire [31:0] _T_13 = _T_10 ? io_mem_result : _T_12; // @[Mux.scala 98:16]
  wire [31:0] inputMux2 = _T_9 ? io_readData2 : _T_13; // @[Mux.scala 98:16]
  wire  _T_14 = io_ctl_aluSrc1 == 2'h1; // @[Execute.scala 66:23]
  wire  _T_15 = io_ctl_aluSrc1 == 2'h2; // @[Execute.scala 67:23]
  wire [31:0] _T_16 = _T_15 ? 32'h0 : inputMux1; // @[Mux.scala 98:16]
  wire [31:0] aluIn1 = _T_14 ? io_pcAddress : _T_16; // @[Mux.scala 98:16]
  wire [31:0] aluIn2 = io_ctl_aluSrc ? inputMux2 : io_immediate; // @[Execute.scala 70:19]
  reg [31:0] REG; // @[Execute.scala 90:28]
  reg [31:0] REG_1; // @[Execute.scala 91:28]
  reg [2:0] REG_2; // @[Execute.scala 92:28]
  reg  REG_3; // @[Execute.scala 93:28]
  reg [5:0] REG_4; // @[Execute.scala 94:28]
  reg [5:0] REG_5; // @[Execute.scala 95:28]
  wire  _T_18 = io_func7 == 7'h1; // @[Execute.scala 97:19]
  wire  _T_26 = io_func7 == 7'h1 & (io_func3 == 3'h0 | io_func3 == 3'h1 | io_func3 == 3'h2 | io_func3 == 3'h3); // @[Execute.scala 97:27]
  wire  _T_37 = _T_18 & ~REG_3 & (io_func3 == 3'h4 | io_func3 == 3'h5 | io_func3 == 3'h6 | io_func3 == 3'h7); // @[Execute.scala 103:38]
  wire  _GEN_1 = _T_18 & ~REG_3 & (io_func3 == 3'h4 | io_func3 == 3'h5 | io_func3 == 3'h6 | io_func3 == 3'h7) | _T_26; // @[Execute.scala 103:120 Execute.scala 104:20]
  wire  _GEN_2 = _T_18 & ~REG_3 & (io_func3 == 3'h4 | io_func3 == 3'h5 | io_func3 == 3'h6 | io_func3 == 3'h7) | REG_3; // @[Execute.scala 103:120 Execute.scala 105:14 Execute.scala 93:28]
  wire [6:0] _GEN_6 = _T_18 & ~REG_3 & (io_func3 == 3'h4 | io_func3 == 3'h5 | io_func3 == 3'h6 | io_func3 == 3'h7) ?
    io_func7 : {{1'd0}, REG_4}; // @[Execute.scala 103:120 Execute.scala 109:14 Execute.scala 94:28]
  wire [5:0] _T_40 = REG_5 + 6'h1; // @[Execute.scala 122:28]
  wire  _GEN_8 = REG_5 < 6'h20 | _T_37; // @[Execute.scala 116:28 Execute.scala 117:18]
  wire  _GEN_13 = REG_5 < 6'h20 & _GEN_1; // @[Execute.scala 116:28 Execute.scala 124:22]
  wire  _GEN_14 = REG_5 < 6'h20 & _GEN_2; // @[Execute.scala 116:28 Execute.scala 125:22]
  wire [2:0] _GEN_18 = REG_3 ? REG_2 : io_func3; // @[Execute.scala 114:17 Execute.scala 86:18]
  wire [31:0] _T_44 = MDU_io_output_valid ? MDU_io_output_bits : 32'h0; // @[Execute.scala 134:26]
  wire [31:0] _GEN_22 = _T_18 & MDU_io_ready ? _T_44 : alu_io_result; // @[Execute.scala 136:49 Execute.scala 137:20 Execute.scala 139:29]
  ALU alu ( // @[Execute.scala 33:19]
    .io_input1(alu_io_input1),
    .io_input2(alu_io_input2),
    .io_aluCtl(alu_io_aluCtl),
    .io_result(alu_io_result)
  );
  AluControl aluCtl ( // @[Execute.scala 34:22]
    .io_aluOp(aluCtl_io_aluOp),
    .io_f7(aluCtl_io_f7),
    .io_f3(aluCtl_io_f3),
    .io_aluSrc(aluCtl_io_aluSrc),
    .io_out(aluCtl_io_out)
  );
  ForwardingUnit ForwardingUnit ( // @[Execute.scala 35:18]
    .io_ex_reg_rd(ForwardingUnit_io_ex_reg_rd),
    .io_mem_reg_rd(ForwardingUnit_io_mem_reg_rd),
    .io_reg_rs1(ForwardingUnit_io_reg_rs1),
    .io_reg_rs2(ForwardingUnit_io_reg_rs2),
    .io_ex_regWrite(ForwardingUnit_io_ex_regWrite),
    .io_mem_regWrite(ForwardingUnit_io_mem_regWrite),
    .io_forwardA(ForwardingUnit_io_forwardA),
    .io_forwardB(ForwardingUnit_io_forwardB)
  );
  MDU MDU ( // @[Execute.scala 83:22]
    .clock(MDU_clock),
    .reset(MDU_reset),
    .io_src_a(MDU_io_src_a),
    .io_src_b(MDU_io_src_b),
    .io_op(MDU_io_op),
    .io_valid(MDU_io_valid),
    .io_ready(MDU_io_ready),
    .io_output_valid(MDU_io_output_valid),
    .io_output_bits(MDU_io_output_bits)
  );
  assign io_writeData = _T_9 ? io_readData2 : _T_13; // @[Mux.scala 98:16]
  assign io_ALUresult = REG_3 & REG_4 == 6'h1 & MDU_io_ready ? _T_44 : _GEN_22; // @[Execute.scala 133:51 Execute.scala 134:20]
  assign io_stall = REG_3 ? _GEN_8 : _T_37; // @[Execute.scala 114:17]
  assign alu_io_input1 = _T_14 ? io_pcAddress : _T_16; // @[Mux.scala 98:16]
  assign alu_io_input2 = io_ctl_aluSrc ? inputMux2 : io_immediate; // @[Execute.scala 70:19]
  assign alu_io_aluCtl = aluCtl_io_out; // @[Execute.scala 79:17]
  assign aluCtl_io_aluOp = io_ctl_aluOp; // @[Execute.scala 74:19]
  assign aluCtl_io_f7 = io_func7[5]; // @[Execute.scala 73:27]
  assign aluCtl_io_f3 = io_func3; // @[Execute.scala 72:16]
  assign aluCtl_io_aluSrc = io_ctl_aluSrc; // @[Execute.scala 75:20]
  assign ForwardingUnit_io_ex_reg_rd = io_ex_mem_ins[11:7]; // @[Execute.scala 41:32]
  assign ForwardingUnit_io_mem_reg_rd = io_mem_wb_ins[11:7]; // @[Execute.scala 42:33]
  assign ForwardingUnit_io_reg_rs1 = io_id_ex_ins[19:15]; // @[Execute.scala 43:29]
  assign ForwardingUnit_io_reg_rs2 = io_id_ex_ins[24:20]; // @[Execute.scala 44:29]
  assign ForwardingUnit_io_ex_regWrite = io_ex_mem_regWrite; // @[Execute.scala 39:18]
  assign ForwardingUnit_io_mem_regWrite = io_mem_wb_regWrite; // @[Execute.scala 40:19]
  assign MDU_clock = clock;
  assign MDU_reset = reset;
  assign MDU_io_src_a = REG_3 ? REG : aluIn1; // @[Execute.scala 114:17 Execute.scala 84:18]
  assign MDU_io_src_b = REG_3 ? REG_1 : aluIn2; // @[Execute.scala 114:17 Execute.scala 85:18]
  assign MDU_io_op = {{2'd0}, _GEN_18}; // @[Execute.scala 114:17 Execute.scala 86:18]
  assign MDU_io_valid = REG_3 ? _GEN_13 : _GEN_1; // @[Execute.scala 114:17]
  always @(posedge clock) begin
    if (reset) begin // @[Execute.scala 90:28]
      REG <= 32'h0; // @[Execute.scala 90:28]
    end else if (_T_18 & ~REG_3 & (io_func3 == 3'h4 | io_func3 == 3'h5 | io_func3 == 3'h6 | io_func3 == 3'h7)) begin // @[Execute.scala 103:120]
      if (_T_14) begin // @[Mux.scala 98:16]
        REG <= io_pcAddress;
      end else if (_T_15) begin // @[Mux.scala 98:16]
        REG <= 32'h0;
      end else begin
        REG <= inputMux1;
      end
    end
    if (reset) begin // @[Execute.scala 91:28]
      REG_1 <= 32'h0; // @[Execute.scala 91:28]
    end else if (_T_18 & ~REG_3 & (io_func3 == 3'h4 | io_func3 == 3'h5 | io_func3 == 3'h6 | io_func3 == 3'h7)) begin // @[Execute.scala 103:120]
      if (io_ctl_aluSrc) begin // @[Execute.scala 70:19]
        if (_T_9) begin // @[Mux.scala 98:16]
          REG_1 <= io_readData2;
        end else begin
          REG_1 <= _T_13;
        end
      end else begin
        REG_1 <= io_immediate;
      end
    end
    if (reset) begin // @[Execute.scala 92:28]
      REG_2 <= 3'h0; // @[Execute.scala 92:28]
    end else if (_T_18 & ~REG_3 & (io_func3 == 3'h4 | io_func3 == 3'h5 | io_func3 == 3'h6 | io_func3 == 3'h7)) begin // @[Execute.scala 103:120]
      REG_2 <= io_func3; // @[Execute.scala 108:14]
    end
    if (reset) begin // @[Execute.scala 93:28]
      REG_3 <= 1'h0; // @[Execute.scala 93:28]
    end else if (REG_3) begin // @[Execute.scala 114:17]
      REG_3 <= _GEN_14;
    end else begin
      REG_3 <= _GEN_2;
    end
    if (reset) begin // @[Execute.scala 94:28]
      REG_4 <= 6'h0; // @[Execute.scala 94:28]
    end else begin
      REG_4 <= _GEN_6[5:0];
    end
    if (reset) begin // @[Execute.scala 95:28]
      REG_5 <= 6'h0; // @[Execute.scala 95:28]
    end else if (REG_3) begin // @[Execute.scala 114:17]
      if (REG_5 < 6'h20) begin // @[Execute.scala 116:28]
        REG_5 <= _T_40; // @[Execute.scala 122:17]
      end else begin
        REG_5 <= 6'h0; // @[Execute.scala 129:17]
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  REG = _RAND_0[31:0];
  _RAND_1 = {1{`RANDOM}};
  REG_1 = _RAND_1[31:0];
  _RAND_2 = {1{`RANDOM}};
  REG_2 = _RAND_2[2:0];
  _RAND_3 = {1{`RANDOM}};
  REG_3 = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  REG_4 = _RAND_4[5:0];
  _RAND_5 = {1{`RANDOM}};
  REG_5 = _RAND_5[5:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module MemoryFetch(
  input         clock,
  input         reset,
  input  [31:0] io_aluResultIn,
  input  [31:0] io_writeData,
  input         io_writeEnable,
  input         io_readEnable,
  output [31:0] io_readData,
  input  [2:0]  io_f3,
  output        io_dccmReq_valid,
  output [31:0] io_dccmReq_bits_addrRequest,
  output [31:0] io_dccmReq_bits_dataRequest,
  output [3:0]  io_dccmReq_bits_activeByteLane,
  output        io_dccmReq_bits_isWrite,
  input         io_dccmRsp_valid,
  input  [31:0] io_dccmRsp_bits_dataResponse
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  reg [1:0] offset; // @[MemoryFetch.scala 26:23]
  reg [2:0] funct3; // @[MemoryFetch.scala 27:23]
  wire [1:0] offsetSW = io_aluResultIn[1:0]; // @[MemoryFetch.scala 28:32]
  wire  _T_8 = offsetSW == 2'h0; // @[MemoryFetch.scala 45:19]
  wire  _T_9 = offsetSW == 2'h1; // @[MemoryFetch.scala 47:25]
  wire [7:0] _GEN_2 = offsetSW == 2'h2 ? io_writeData[15:8] : io_writeData[15:8]; // @[MemoryFetch.scala 53:33 MemoryFetch.scala 54:16 MemoryFetch.scala 60:16]
  wire [7:0] _GEN_3 = offsetSW == 2'h2 ? io_writeData[23:16] : io_writeData[23:16]; // @[MemoryFetch.scala 53:33 MemoryFetch.scala 55:16 MemoryFetch.scala 61:16]
  wire [7:0] _GEN_4 = offsetSW == 2'h2 ? io_writeData[7:0] : io_writeData[31:24]; // @[MemoryFetch.scala 53:33 MemoryFetch.scala 56:16 MemoryFetch.scala 62:16]
  wire [7:0] _GEN_5 = offsetSW == 2'h2 ? io_writeData[31:24] : io_writeData[7:0]; // @[MemoryFetch.scala 53:33 MemoryFetch.scala 57:16 MemoryFetch.scala 63:16]
  wire [3:0] _GEN_6 = offsetSW == 2'h2 ? 4'h4 : 4'h8; // @[MemoryFetch.scala 53:33 MemoryFetch.scala 58:38 MemoryFetch.scala 64:38]
  wire [7:0] _GEN_7 = offsetSW == 2'h1 ? io_writeData[15:8] : _GEN_2; // @[MemoryFetch.scala 47:33 MemoryFetch.scala 48:16]
  wire [7:0] _GEN_8 = offsetSW == 2'h1 ? io_writeData[7:0] : _GEN_3; // @[MemoryFetch.scala 47:33 MemoryFetch.scala 49:16]
  wire [7:0] _GEN_9 = offsetSW == 2'h1 ? io_writeData[23:16] : _GEN_4; // @[MemoryFetch.scala 47:33 MemoryFetch.scala 50:16]
  wire [7:0] _GEN_10 = offsetSW == 2'h1 ? io_writeData[31:24] : _GEN_5; // @[MemoryFetch.scala 47:33 MemoryFetch.scala 51:16]
  wire [3:0] _GEN_11 = offsetSW == 2'h1 ? 4'h2 : _GEN_6; // @[MemoryFetch.scala 47:33 MemoryFetch.scala 52:38]
  wire [3:0] _GEN_12 = offsetSW == 2'h0 ? 4'h1 : _GEN_11; // @[MemoryFetch.scala 45:27 MemoryFetch.scala 46:38]
  wire [7:0] _GEN_13 = offsetSW == 2'h0 ? io_writeData[7:0] : _GEN_7; // @[MemoryFetch.scala 45:27 MemoryFetch.scala 38:12]
  wire [7:0] _GEN_14 = offsetSW == 2'h0 ? io_writeData[15:8] : _GEN_8; // @[MemoryFetch.scala 45:27 MemoryFetch.scala 39:12]
  wire [7:0] _GEN_15 = offsetSW == 2'h0 ? io_writeData[23:16] : _GEN_9; // @[MemoryFetch.scala 45:27 MemoryFetch.scala 40:12]
  wire [7:0] _GEN_16 = offsetSW == 2'h0 ? io_writeData[31:24] : _GEN_10; // @[MemoryFetch.scala 45:27 MemoryFetch.scala 41:12]
  wire [3:0] _GEN_17 = _T_9 ? 4'h6 : 4'hc; // @[MemoryFetch.scala 73:33 MemoryFetch.scala 75:38 MemoryFetch.scala 82:38]
  wire [7:0] _GEN_18 = _T_9 ? io_writeData[23:16] : io_writeData[23:16]; // @[MemoryFetch.scala 73:33 MemoryFetch.scala 76:16 MemoryFetch.scala 85:16]
  wire [7:0] _GEN_19 = _T_9 ? io_writeData[7:0] : io_writeData[31:24]; // @[MemoryFetch.scala 73:33 MemoryFetch.scala 77:16 MemoryFetch.scala 86:16]
  wire [7:0] _GEN_20 = _T_9 ? io_writeData[15:8] : io_writeData[7:0]; // @[MemoryFetch.scala 73:33 MemoryFetch.scala 78:16 MemoryFetch.scala 83:16]
  wire [7:0] _GEN_21 = _T_9 ? io_writeData[31:24] : io_writeData[15:8]; // @[MemoryFetch.scala 73:33 MemoryFetch.scala 79:16 MemoryFetch.scala 84:16]
  wire [3:0] _GEN_22 = _T_8 ? 4'h3 : _GEN_17; // @[MemoryFetch.scala 70:27 MemoryFetch.scala 72:38]
  wire [7:0] _GEN_23 = _T_8 ? io_writeData[7:0] : _GEN_18; // @[MemoryFetch.scala 70:27 MemoryFetch.scala 38:12]
  wire [7:0] _GEN_24 = _T_8 ? io_writeData[15:8] : _GEN_19; // @[MemoryFetch.scala 70:27 MemoryFetch.scala 39:12]
  wire [7:0] _GEN_25 = _T_8 ? io_writeData[23:16] : _GEN_20; // @[MemoryFetch.scala 70:27 MemoryFetch.scala 40:12]
  wire [7:0] _GEN_26 = _T_8 ? io_writeData[31:24] : _GEN_21; // @[MemoryFetch.scala 70:27 MemoryFetch.scala 41:12]
  wire [3:0] _GEN_27 = io_writeEnable & io_f3 == 3'h1 ? _GEN_22 : 4'hf; // @[MemoryFetch.scala 68:52 MemoryFetch.scala 91:36]
  wire [7:0] _GEN_28 = io_writeEnable & io_f3 == 3'h1 ? _GEN_23 : io_writeData[7:0]; // @[MemoryFetch.scala 68:52 MemoryFetch.scala 38:12]
  wire [7:0] _GEN_29 = io_writeEnable & io_f3 == 3'h1 ? _GEN_24 : io_writeData[15:8]; // @[MemoryFetch.scala 68:52 MemoryFetch.scala 39:12]
  wire [7:0] _GEN_30 = io_writeEnable & io_f3 == 3'h1 ? _GEN_25 : io_writeData[23:16]; // @[MemoryFetch.scala 68:52 MemoryFetch.scala 40:12]
  wire [7:0] _GEN_31 = io_writeEnable & io_f3 == 3'h1 ? _GEN_26 : io_writeData[31:24]; // @[MemoryFetch.scala 68:52 MemoryFetch.scala 41:12]
  wire [7:0] wdata_0 = io_writeEnable & io_f3 == 3'h0 ? _GEN_13 : _GEN_28; // @[MemoryFetch.scala 44:45]
  wire [7:0] wdata_1 = io_writeEnable & io_f3 == 3'h0 ? _GEN_14 : _GEN_29; // @[MemoryFetch.scala 44:45]
  wire [7:0] wdata_2 = io_writeEnable & io_f3 == 3'h0 ? _GEN_15 : _GEN_30; // @[MemoryFetch.scala 44:45]
  wire [7:0] wdata_3 = io_writeEnable & io_f3 == 3'h0 ? _GEN_16 : _GEN_31; // @[MemoryFetch.scala 44:45]
  wire [15:0] lo = {wdata_1,wdata_0}; // @[MemoryFetch.scala 94:46]
  wire [15:0] hi = {wdata_3,wdata_2}; // @[MemoryFetch.scala 94:46]
  wire [31:0] _T_36 = io_aluResultIn & 32'h1fff; // @[MemoryFetch.scala 95:50]
  wire [31:0] rdata = io_dccmRsp_valid ? io_dccmRsp_bits_dataResponse : 32'h0; // @[MemoryFetch.scala 101:15]
  wire  _T_46 = offset == 2'h0; // @[MemoryFetch.scala 111:21]
  wire [23:0] hi_1 = rdata[7] ? 24'hffffff : 24'h0; // @[Bitwise.scala 72:12]
  wire [7:0] lo_1 = rdata[7:0]; // @[MemoryFetch.scala 113:53]
  wire [31:0] _T_49 = {hi_1,lo_1}; // @[Cat.scala 30:58]
  wire  _T_50 = offset == 2'h1; // @[MemoryFetch.scala 114:28]
  wire [23:0] hi_2 = rdata[15] ? 24'hffffff : 24'h0; // @[Bitwise.scala 72:12]
  wire [7:0] lo_2 = rdata[15:8]; // @[MemoryFetch.scala 116:55]
  wire [31:0] _T_53 = {hi_2,lo_2}; // @[Cat.scala 30:58]
  wire  _T_54 = offset == 2'h2; // @[MemoryFetch.scala 117:28]
  wire [23:0] hi_3 = rdata[23] ? 24'hffffff : 24'h0; // @[Bitwise.scala 72:12]
  wire [7:0] lo_3 = rdata[23:16]; // @[MemoryFetch.scala 119:55]
  wire [31:0] _T_57 = {hi_3,lo_3}; // @[Cat.scala 30:58]
  wire [23:0] hi_4 = rdata[31] ? 24'hffffff : 24'h0; // @[Bitwise.scala 72:12]
  wire [7:0] lo_4 = rdata[31:24]; // @[MemoryFetch.scala 122:55]
  wire [31:0] _T_61 = {hi_4,lo_4}; // @[Cat.scala 30:58]
  wire [31:0] _GEN_38 = offset == 2'h2 ? _T_57 : _T_61; // @[MemoryFetch.scala 117:41 MemoryFetch.scala 119:23]
  wire [31:0] _GEN_39 = offset == 2'h1 ? _T_53 : _GEN_38; // @[MemoryFetch.scala 114:41 MemoryFetch.scala 116:23]
  wire [31:0] _GEN_40 = offset == 2'h0 ? _T_49 : _GEN_39; // @[MemoryFetch.scala 111:34 MemoryFetch.scala 113:23]
  wire [31:0] _T_64 = {24'h0,lo_1}; // @[Cat.scala 30:58]
  wire [31:0] _T_66 = {24'h0,lo_2}; // @[Cat.scala 30:58]
  wire [31:0] _T_68 = {24'h0,lo_3}; // @[Cat.scala 30:58]
  wire [31:0] _T_70 = {24'h0,lo_4}; // @[Cat.scala 30:58]
  wire [31:0] _GEN_42 = _T_54 ? _T_68 : _T_70; // @[MemoryFetch.scala 136:40 MemoryFetch.scala 138:23]
  wire [31:0] _GEN_43 = _T_50 ? _T_66 : _GEN_42; // @[MemoryFetch.scala 133:40 MemoryFetch.scala 135:23]
  wire [31:0] _GEN_44 = _T_46 ? _T_64 : _GEN_43; // @[MemoryFetch.scala 130:34 MemoryFetch.scala 132:23]
  wire [15:0] lo_9 = rdata[15:0]; // @[MemoryFetch.scala 151:49]
  wire [31:0] _T_73 = {16'h0,lo_9}; // @[Cat.scala 30:58]
  wire [15:0] lo_10 = rdata[23:8]; // @[MemoryFetch.scala 154:49]
  wire [31:0] _T_75 = {16'h0,lo_10}; // @[Cat.scala 30:58]
  wire [15:0] lo_11 = rdata[31:16]; // @[MemoryFetch.scala 157:49]
  wire [31:0] _T_77 = {16'h0,lo_11}; // @[Cat.scala 30:58]
  wire [31:0] _GEN_46 = _T_50 ? _T_75 : _T_77; // @[MemoryFetch.scala 152:41 MemoryFetch.scala 154:23]
  wire [31:0] _GEN_47 = _T_46 ? _T_73 : _GEN_46; // @[MemoryFetch.scala 149:34 MemoryFetch.scala 151:23]
  wire [15:0] hi_12 = rdata[15] ? 16'hffff : 16'h0; // @[Bitwise.scala 72:12]
  wire [31:0] _T_82 = {hi_12,lo_9}; // @[Cat.scala 30:58]
  wire [15:0] hi_13 = rdata[23] ? 16'hffff : 16'h0; // @[Bitwise.scala 72:12]
  wire [31:0] _T_86 = {hi_13,lo_10}; // @[Cat.scala 30:58]
  wire [15:0] hi_14 = rdata[31] ? 16'hffff : 16'h0; // @[Bitwise.scala 72:12]
  wire [31:0] _T_90 = {hi_14,lo_11}; // @[Cat.scala 30:58]
  wire [31:0] _GEN_49 = _T_50 ? _T_86 : _T_90; // @[MemoryFetch.scala 168:41 MemoryFetch.scala 170:23]
  wire [31:0] _GEN_50 = _T_46 ? _T_82 : _GEN_49; // @[MemoryFetch.scala 165:34 MemoryFetch.scala 167:23]
  wire [31:0] _GEN_52 = funct3 == 3'h5 ? _GEN_47 : _GEN_50; // @[MemoryFetch.scala 147:38]
  wire [31:0] _GEN_53 = funct3 == 3'h4 ? _GEN_44 : _GEN_52; // @[MemoryFetch.scala 128:38]
  wire [31:0] _GEN_54 = funct3 == 3'h0 ? _GEN_40 : _GEN_53; // @[MemoryFetch.scala 109:38]
  wire  _T_93 = io_writeEnable & io_aluResultIn[31:28] == 4'h8; // @[MemoryFetch.scala 188:23]
  assign io_readData = funct3 == 3'h2 ? rdata : _GEN_54; // @[MemoryFetch.scala 105:31 MemoryFetch.scala 107:19]
  assign io_dccmReq_valid = io_writeEnable | io_readEnable; // @[MemoryFetch.scala 97:42]
  assign io_dccmReq_bits_addrRequest = {{2'd0}, _T_36[31:2]}; // @[MemoryFetch.scala 95:67]
  assign io_dccmReq_bits_dataRequest = {hi,lo}; // @[MemoryFetch.scala 94:46]
  assign io_dccmReq_bits_activeByteLane = io_writeEnable & io_f3 == 3'h0 ? _GEN_12 : _GEN_27; // @[MemoryFetch.scala 44:45]
  assign io_dccmReq_bits_isWrite = io_writeEnable; // @[MemoryFetch.scala 96:27]
  always @(posedge clock) begin
    if (reset) begin // @[MemoryFetch.scala 26:23]
      offset <= 2'h0; // @[MemoryFetch.scala 26:23]
    end else if (~io_dccmRsp_valid) begin // @[MemoryFetch.scala 30:26]
      offset <= offsetSW; // @[MemoryFetch.scala 32:12]
    end
    if (reset) begin // @[MemoryFetch.scala 27:23]
      funct3 <= 3'h0; // @[MemoryFetch.scala 27:23]
    end else if (~io_dccmRsp_valid) begin // @[MemoryFetch.scala 30:26]
      funct3 <= io_f3; // @[MemoryFetch.scala 31:12]
    end
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_93 & ~reset) begin
          $fwrite(32'h80000002,"%x\n",io_writeData); // @[MemoryFetch.scala 189:11]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  offset = _RAND_0[1:0];
  _RAND_1 = {1{`RANDOM}};
  funct3 = _RAND_1[2:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module PC(
  input         clock,
  input         reset,
  input  [31:0] io_in,
  input         io_halt,
  output [31:0] io_out,
  output [31:0] io_pc4,
  output [31:0] io_pc2
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] pc_reg; // @[PC.scala 13:23]
  wire [31:0] _T_2 = $signed(pc_reg) + 32'sh4; // @[PC.scala 16:41]
  wire [31:0] _T_6 = $signed(pc_reg) + 32'sh2; // @[PC.scala 17:41]
  assign io_out = pc_reg; // @[PC.scala 15:10]
  assign io_pc4 = io_halt ? $signed(pc_reg) : $signed(_T_2); // @[PC.scala 16:16]
  assign io_pc2 = io_halt ? $signed(pc_reg) : $signed(_T_6); // @[PC.scala 17:16]
  always @(posedge clock) begin
    if (reset) begin // @[PC.scala 13:23]
      pc_reg <= -32'sh4; // @[PC.scala 13:23]
    end else begin
      pc_reg <= io_in; // @[PC.scala 14:10]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  pc_reg = _RAND_0[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Realigner(
  input         clock,
  input         reset,
  input  [31:0] io_ral_address_i,
  input  [31:0] io_ral_instruction_i,
  input         io_ral_jmp,
  output [31:0] io_ral_address_o,
  output [31:0] io_ral_instruction_o,
  output        io_ral_halt_o
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  wire  addri = io_ral_address_i[1]; // @[Realigner.scala 36:31]
  reg [15:0] lhw_reg; // @[Realigner.scala 49:24]
  wire [15:0] hi = io_ral_instruction_i[15:0]; // @[Realigner.scala 53:41]
  wire [31:0] conc_instr = {hi,lhw_reg}; // @[Cat.scala 30:58]
  wire [31:0] _T_3 = io_ral_address_i + 32'h4; // @[Realigner.scala 56:53]
  reg [1:0] stateReg; // @[Realigner.scala 68:25]
  wire  _T_11 = stateReg == 2'h1; // @[Realigner.scala 101:30]
  wire  pc4_sel = stateReg == 2'h1 & addri & ~io_ral_jmp; // @[Realigner.scala 101:50]
  wire  conc_sel = stateReg == 2'h2; // @[Realigner.scala 103:30]
  wire [31:0] _T_5 = conc_sel ? conc_instr : io_ral_instruction_i; // @[Realigner.scala 59:69]
  wire  _T_7 = 2'h0 == stateReg; // @[Conditional.scala 37:30]
  wire [1:0] _GEN_0 = addri ? 2'h1 : 2'h0; // @[Realigner.scala 73:20 Realigner.scala 74:18 Realigner.scala 76:18]
  wire  _T_8 = 2'h1 == stateReg; // @[Conditional.scala 37:30]
  wire [1:0] _GEN_1 = io_ral_jmp ? 2'h1 : 2'h2; // @[Realigner.scala 81:27 Realigner.scala 82:20 Realigner.scala 84:20]
  wire  _T_9 = 2'h2 == stateReg; // @[Conditional.scala 37:30]
  assign io_ral_address_o = pc4_sel ? _T_3 : io_ral_address_i; // @[Realigner.scala 56:26]
  assign io_ral_instruction_o = _T_11 ? 32'h13 : _T_5; // @[Realigner.scala 59:30]
  assign io_ral_halt_o = stateReg == 2'h1; // @[Realigner.scala 100:30]
  always @(posedge clock) begin
    if (reset) begin // @[Realigner.scala 49:24]
      lhw_reg <= 16'h0; // @[Realigner.scala 49:24]
    end else begin
      lhw_reg <= io_ral_instruction_i[31:16]; // @[Realigner.scala 51:11]
    end
    if (reset) begin // @[Realigner.scala 68:25]
      stateReg <= 2'h0; // @[Realigner.scala 68:25]
    end else if (_T_7) begin // @[Conditional.scala 40:58]
      stateReg <= _GEN_0;
    end else if (_T_8) begin // @[Conditional.scala 39:67]
      if (addri) begin // @[Realigner.scala 80:18]
        stateReg <= _GEN_1;
      end else begin
        stateReg <= 2'h0; // @[Realigner.scala 87:18]
      end
    end else if (_T_9) begin // @[Conditional.scala 39:67]
      stateReg <= _GEN_0;
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  lhw_reg = _RAND_0[15:0];
  _RAND_1 = {1{`RANDOM}};
  stateReg = _RAND_1[1:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module CompressedDecoder(
  input  [31:0] io_instruction_i,
  output        io_is_comp,
  output [31:0] io_instruction_o
);
  wire  _T_1 = 2'h0 == io_instruction_i[1:0]; // @[Conditional.scala 37:30]
  wire  _T_3 = 2'h0 == io_instruction_i[15:14]; // @[Conditional.scala 37:30]
  wire [3:0] hi_hi_hi_lo = io_instruction_i[10:7]; // @[CompressedDecoder.scala 47:70]
  wire [1:0] hi_hi_lo = io_instruction_i[12:11]; // @[CompressedDecoder.scala 47:95]
  wire  hi_lo_hi_hi = io_instruction_i[5]; // @[CompressedDecoder.scala 47:121]
  wire  hi_lo_hi_lo = io_instruction_i[6]; // @[CompressedDecoder.scala 48:47]
  wire [2:0] lo_lo_hi = io_instruction_i[4:2]; // @[CompressedDecoder.scala 48:143]
  wire [31:0] _T_4 = {2'h0,hi_hi_hi_lo,hi_hi_lo,hi_lo_hi_hi,hi_lo_hi_lo,2'h0,10'h41,lo_lo_hi,7'h13}; // @[Cat.scala 30:58]
  wire  _T_5 = 2'h1 == io_instruction_i[15:14]; // @[Conditional.scala 37:30]
  wire [2:0] hi_hi_lo_1 = io_instruction_i[12:10]; // @[CompressedDecoder.scala 54:88]
  wire [2:0] lo_hi_hi_hi = io_instruction_i[9:7]; // @[CompressedDecoder.scala 55:68]
  wire [31:0] _T_6 = {5'h0,hi_lo_hi_hi,hi_hi_lo_1,hi_lo_hi_lo,4'h1,lo_hi_hi_hi,3'h2,2'h1,lo_lo_hi,7'h3}; // @[Cat.scala 30:58]
  wire  _T_7 = 2'h3 == io_instruction_i[15:14]; // @[Conditional.scala 37:30]
  wire  hi_hi_lo_2 = io_instruction_i[12]; // @[CompressedDecoder.scala 61:88]
  wire [1:0] lo_hi_lo = io_instruction_i[11:10]; // @[CompressedDecoder.scala 62:108]
  wire [17:0] lo_2 = {lo_hi_hi_hi,3'h2,lo_hi_lo,hi_lo_hi_lo,2'h0,7'h23}; // @[Cat.scala 30:58]
  wire [31:0] _T_8 = {5'h0,hi_lo_hi_hi,hi_hi_lo_2,2'h1,lo_lo_hi,2'h1,lo_2}; // @[Cat.scala 30:58]
  wire  _T_9 = 2'h2 == io_instruction_i[15:14]; // @[Conditional.scala 37:30]
  wire [31:0] _GEN_3 = _T_7 ? _T_8 : io_instruction_i; // @[Conditional.scala 39:67 CompressedDecoder.scala 61:28]
  wire  _GEN_4 = _T_5 | _T_7; // @[Conditional.scala 39:67 CompressedDecoder.scala 53:22]
  wire [31:0] _GEN_5 = _T_5 ? _T_6 : _GEN_3; // @[Conditional.scala 39:67 CompressedDecoder.scala 54:28]
  wire  _GEN_6 = _T_3 | _GEN_4; // @[Conditional.scala 40:58 CompressedDecoder.scala 46:22]
  wire [31:0] _GEN_7 = _T_3 ? _T_4 : _GEN_5; // @[Conditional.scala 40:58 CompressedDecoder.scala 47:28]
  wire  _T_10 = 2'h1 == io_instruction_i[1:0]; // @[Conditional.scala 37:30]
  wire  _T_12 = 3'h0 == io_instruction_i[15:13]; // @[Conditional.scala 37:30]
  wire [5:0] hi_hi_hi_3 = hi_hi_lo_2 ? 6'h3f : 6'h0; // @[Bitwise.scala 72:12]
  wire [4:0] hi_lo_hi_3 = io_instruction_i[6:2]; // @[CompressedDecoder.scala 86:103]
  wire [4:0] hi_lo_lo = io_instruction_i[11:7]; // @[CompressedDecoder.scala 87:47]
  wire [31:0] _T_15 = {hi_hi_hi_3,hi_hi_lo_2,hi_lo_hi_3,hi_lo_lo,3'h0,hi_lo_lo,7'h13}; // @[Cat.scala 30:58]
  wire  _T_16 = 3'h1 == io_instruction_i[15:13]; // @[Conditional.scala 37:30]
  wire  hi_hi_hi_lo_3 = io_instruction_i[8]; // @[CompressedDecoder.scala 93:73]
  wire [1:0] hi_hi_lo_4 = io_instruction_i[10:9]; // @[CompressedDecoder.scala 93:94]
  wire  hi_lo_hi_lo_2 = io_instruction_i[7]; // @[CompressedDecoder.scala 94:47]
  wire  hi_lo_lo_1 = io_instruction_i[2]; // @[CompressedDecoder.scala 94:67]
  wire  lo_hi_hi_hi_2 = io_instruction_i[11]; // @[CompressedDecoder.scala 94:88]
  wire [2:0] lo_hi_hi_lo = io_instruction_i[5:3]; // @[CompressedDecoder.scala 94:110]
  wire [8:0] lo_hi_lo_2 = hi_hi_lo_2 ? 9'h1ff : 9'h0; // @[Bitwise.scala 72:12]
  wire  lo_lo_hi_lo = ~io_instruction_i[15]; // @[CompressedDecoder.scala 95:82]
  wire [24:0] lo_4 = {lo_hi_hi_hi_2,lo_hi_hi_lo,lo_hi_lo_2,4'h0,lo_lo_hi_lo,7'h6f}; // @[Cat.scala 30:58]
  wire [31:0] _T_20 = {hi_hi_lo_2,hi_hi_hi_lo_3,hi_hi_lo_4,hi_lo_hi_lo,hi_lo_hi_lo_2,hi_lo_lo_1,lo_4}; // @[Cat.scala 30:58]
  wire  _T_21 = 3'h5 == io_instruction_i[15:13]; // @[Conditional.scala 37:30]
  wire  _T_26 = 3'h2 == io_instruction_i[15:13]; // @[Conditional.scala 37:30]
  wire [31:0] _T_29 = {hi_hi_hi_3,hi_hi_lo_2,hi_lo_hi_3,5'h0,3'h0,hi_lo_lo,7'h13}; // @[Cat.scala 30:58]
  wire  _T_30 = 3'h3 == io_instruction_i[15:13]; // @[Conditional.scala 37:30]
  wire [14:0] hi_hi_7 = hi_hi_lo_2 ? 15'h7fff : 15'h0; // @[Bitwise.scala 72:12]
  wire [31:0] _T_33 = {hi_hi_7,hi_lo_hi_3,hi_lo_lo,7'h37}; // @[Cat.scala 30:58]
  wire [2:0] hi_hi_hi_hi_4 = hi_hi_lo_2 ? 3'h7 : 3'h0; // @[Bitwise.scala 72:12]
  wire [1:0] hi_hi_hi_lo_5 = io_instruction_i[4:3]; // @[CompressedDecoder.scala 122:84]
  wire [31:0] _T_38 = {hi_hi_hi_hi_4,hi_hi_hi_lo_5,hi_lo_hi_hi,hi_lo_lo_1,hi_lo_hi_lo,24'h10113}; // @[Cat.scala 30:58]
  wire [31:0] _GEN_8 = hi_lo_lo == 5'h2 ? _T_38 : _T_33; // @[CompressedDecoder.scala 120:62 CompressedDecoder.scala 122:31 CompressedDecoder.scala 118:28]
  wire  _T_39 = 3'h4 == io_instruction_i[15:13]; // @[Conditional.scala 37:30]
  wire  _T_41 = 2'h0 == lo_hi_lo; // @[Conditional.scala 37:30]
  wire  hi_hi_hi_lo_6 = io_instruction_i[10]; // @[CompressedDecoder.scala 134:63]
  wire [31:0] _T_42 = {1'h0,hi_hi_hi_lo_6,5'h0,hi_lo_hi_3,2'h1,lo_hi_hi_hi,3'h5,2'h1,lo_hi_hi_hi,7'h13}; // @[Cat.scala 30:58]
  wire  _T_43 = 2'h1 == lo_hi_lo; // @[Conditional.scala 37:30]
  wire  _T_45 = 2'h2 == lo_hi_lo; // @[Conditional.scala 37:30]
  wire [31:0] _T_48 = {hi_hi_hi_3,hi_hi_lo_2,hi_lo_hi_3,2'h1,lo_hi_hi_hi,5'h1d,lo_hi_hi_hi,7'h13}; // @[Cat.scala 30:58]
  wire  _T_49 = 2'h3 == lo_hi_lo; // @[Conditional.scala 37:30]
  wire  _T_51 = 2'h0 == io_instruction_i[6:5]; // @[Conditional.scala 37:30]
  wire [31:0] _T_52 = {9'h81,lo_lo_hi,2'h1,lo_hi_hi_hi,3'h0,2'h1,lo_hi_hi_hi,7'h33}; // @[Cat.scala 30:58]
  wire  _T_53 = 2'h1 == io_instruction_i[6:5]; // @[Conditional.scala 37:30]
  wire [31:0] _T_54 = {9'h1,lo_lo_hi,2'h1,lo_hi_hi_hi,5'h11,lo_hi_hi_hi,7'h33}; // @[Cat.scala 30:58]
  wire  _T_55 = 2'h2 == io_instruction_i[6:5]; // @[Conditional.scala 37:30]
  wire [31:0] _T_56 = {9'h1,lo_lo_hi,2'h1,lo_hi_hi_hi,5'h19,lo_hi_hi_hi,7'h33}; // @[Cat.scala 30:58]
  wire  _T_57 = 2'h3 == io_instruction_i[6:5]; // @[Conditional.scala 37:30]
  wire [31:0] _T_58 = {9'h1,lo_lo_hi,2'h1,lo_hi_hi_hi,5'h1d,lo_hi_hi_hi,7'h33}; // @[Cat.scala 30:58]
  wire [31:0] _GEN_10 = _T_57 ? _T_58 : io_instruction_i; // @[Conditional.scala 39:67 CompressedDecoder.scala 180:36 CompressedDecoder.scala 35:20]
  wire  _GEN_11 = _T_55 | _T_57; // @[Conditional.scala 39:67 CompressedDecoder.scala 172:30]
  wire [31:0] _GEN_12 = _T_55 ? _T_56 : _GEN_10; // @[Conditional.scala 39:67 CompressedDecoder.scala 173:36]
  wire  _GEN_13 = _T_53 | _GEN_11; // @[Conditional.scala 39:67 CompressedDecoder.scala 165:30]
  wire [31:0] _GEN_14 = _T_53 ? _T_54 : _GEN_12; // @[Conditional.scala 39:67 CompressedDecoder.scala 166:36]
  wire  _GEN_15 = _T_51 | _GEN_13; // @[Conditional.scala 40:58 CompressedDecoder.scala 158:30]
  wire [31:0] _GEN_16 = _T_51 ? _T_52 : _GEN_14; // @[Conditional.scala 40:58 CompressedDecoder.scala 159:36]
  wire  _GEN_17 = _T_49 & _GEN_15; // @[Conditional.scala 39:67 CompressedDecoder.scala 34:14]
  wire [31:0] _GEN_18 = _T_49 ? _GEN_16 : io_instruction_i; // @[Conditional.scala 39:67 CompressedDecoder.scala 35:20]
  wire  _GEN_19 = _T_45 | _GEN_17; // @[Conditional.scala 39:67 CompressedDecoder.scala 147:26]
  wire [31:0] _GEN_20 = _T_45 ? _T_48 : _GEN_18; // @[Conditional.scala 39:67 CompressedDecoder.scala 148:32]
  wire  _GEN_21 = _T_43 | _GEN_19; // @[Conditional.scala 39:67 CompressedDecoder.scala 140:26]
  wire [31:0] _GEN_22 = _T_43 ? _T_42 : _GEN_20; // @[Conditional.scala 39:67 CompressedDecoder.scala 141:32]
  wire  _GEN_23 = _T_41 | _GEN_21; // @[Conditional.scala 40:58 CompressedDecoder.scala 133:26]
  wire [31:0] _GEN_24 = _T_41 ? _T_42 : _GEN_22; // @[Conditional.scala 40:58 CompressedDecoder.scala 134:32]
  wire  _T_59 = 3'h6 == io_instruction_i[15:13]; // @[Conditional.scala 37:30]
  wire [3:0] hi_hi_hi_hi_9 = hi_hi_lo_2 ? 4'hf : 4'h0; // @[Bitwise.scala 72:12]
  wire  lo_hi_hi_lo_2 = io_instruction_i[13]; // @[CompressedDecoder.scala 192:89]
  wire [14:0] lo_16 = {2'h0,lo_hi_hi_lo_2,lo_hi_lo,hi_hi_hi_lo_5,hi_hi_lo_2,7'h63}; // @[Cat.scala 30:58]
  wire [31:0] _T_62 = {hi_hi_hi_hi_9,io_instruction_i[6:5],hi_lo_lo_1,7'h1,lo_hi_hi_hi,lo_16}; // @[Cat.scala 30:58]
  wire  _T_63 = 3'h7 == io_instruction_i[15:13]; // @[Conditional.scala 37:30]
  wire [31:0] _GEN_26 = _T_63 ? _T_62 : io_instruction_i; // @[Conditional.scala 39:67 CompressedDecoder.scala 199:28 CompressedDecoder.scala 35:20]
  wire  _GEN_27 = _T_59 | _T_63; // @[Conditional.scala 39:67 CompressedDecoder.scala 190:22]
  wire [31:0] _GEN_28 = _T_59 ? _T_62 : _GEN_26; // @[Conditional.scala 39:67 CompressedDecoder.scala 191:28]
  wire  _GEN_29 = _T_39 ? _GEN_23 : _GEN_27; // @[Conditional.scala 39:67]
  wire [31:0] _GEN_30 = _T_39 ? _GEN_24 : _GEN_28; // @[Conditional.scala 39:67]
  wire  _GEN_31 = _T_30 | _GEN_29; // @[Conditional.scala 39:67 CompressedDecoder.scala 117:22]
  wire [31:0] _GEN_32 = _T_30 ? _GEN_8 : _GEN_30; // @[Conditional.scala 39:67]
  wire  _GEN_33 = _T_26 | _GEN_31; // @[Conditional.scala 39:67 CompressedDecoder.scala 109:22]
  wire [31:0] _GEN_34 = _T_26 ? _T_29 : _GEN_32; // @[Conditional.scala 39:67 CompressedDecoder.scala 110:28]
  wire  _GEN_35 = _T_21 | _GEN_33; // @[Conditional.scala 39:67 CompressedDecoder.scala 100:22]
  wire [31:0] _GEN_36 = _T_21 ? _T_20 : _GEN_34; // @[Conditional.scala 39:67 CompressedDecoder.scala 101:28]
  wire  _GEN_37 = _T_16 | _GEN_35; // @[Conditional.scala 39:67 CompressedDecoder.scala 92:22]
  wire [31:0] _GEN_38 = _T_16 ? _T_20 : _GEN_36; // @[Conditional.scala 39:67 CompressedDecoder.scala 93:28]
  wire  _GEN_39 = _T_12 | _GEN_37; // @[Conditional.scala 40:58 CompressedDecoder.scala 85:22]
  wire [31:0] _GEN_40 = _T_12 ? _T_15 : _GEN_38; // @[Conditional.scala 40:58 CompressedDecoder.scala 86:28]
  wire  _T_67 = 2'h2 == io_instruction_i[1:0]; // @[Conditional.scala 37:30]
  wire [31:0] _T_70 = {7'h0,hi_lo_hi_3,hi_lo_lo,3'h1,hi_lo_lo,7'h13}; // @[Cat.scala 30:58]
  wire [1:0] hi_hi_hi_lo_11 = io_instruction_i[3:2]; // @[CompressedDecoder.scala 227:67]
  wire [2:0] hi_lo_hi_13 = io_instruction_i[6:4]; // @[CompressedDecoder.scala 227:112]
  wire [31:0] _T_72 = {4'h0,hi_hi_hi_lo_11,hi_hi_lo_2,hi_lo_hi_13,2'h0,8'h12,hi_lo_lo,7'h3}; // @[Cat.scala 30:58]
  wire  _T_77 = hi_lo_hi_3 != 5'h0; // @[CompressedDecoder.scala 235:40]
  wire [31:0] _T_78 = {7'h0,hi_lo_hi_3,8'h0,hi_lo_lo,7'h33}; // @[Cat.scala 30:58]
  wire [31:0] _T_79 = {12'h0,hi_lo_lo,15'h67}; // @[Cat.scala 30:58]
  wire [31:0] _GEN_42 = hi_lo_hi_3 != 5'h0 ? _T_78 : _T_79; // @[CompressedDecoder.scala 235:62 CompressedDecoder.scala 240:32 CompressedDecoder.scala 245:32]
  wire [31:0] _T_82 = {7'h0,hi_lo_hi_3,hi_lo_lo,3'h0,hi_lo_lo,7'h33}; // @[Cat.scala 30:58]
  wire [31:0] _T_85 = {12'h0,hi_lo_lo,7'h0,8'he7}; // @[Cat.scala 30:58]
  wire [31:0] _GEN_44 = hi_lo_lo == 5'h0 ? 32'h100073 : _T_85; // @[CompressedDecoder.scala 256:65 CompressedDecoder.scala 259:34 CompressedDecoder.scala 263:34]
  wire [31:0] _GEN_46 = _T_77 ? _T_82 : _GEN_44; // @[CompressedDecoder.scala 249:62 CompressedDecoder.scala 253:32]
  wire [31:0] _GEN_48 = ~hi_hi_lo_2 ? _GEN_42 : _GEN_46; // @[CompressedDecoder.scala 233:50]
  wire [1:0] hi_hi_hi_lo_12 = io_instruction_i[8:7]; // @[CompressedDecoder.scala 272:67]
  wire [2:0] lo_hi_lo_9 = io_instruction_i[11:9]; // @[CompressedDecoder.scala 273:47]
  wire [31:0] _T_87 = {4'h0,hi_hi_hi_lo_12,hi_hi_lo_2,hi_lo_hi_3,5'h2,3'h2,lo_hi_lo_9,9'h23}; // @[Cat.scala 30:58]
  wire [31:0] _GEN_50 = _T_7 ? _T_87 : io_instruction_i; // @[Conditional.scala 39:67 CompressedDecoder.scala 272:28 CompressedDecoder.scala 35:20]
  wire [31:0] _GEN_52 = _T_9 ? _GEN_48 : _GEN_50; // @[Conditional.scala 39:67]
  wire  _GEN_53 = _T_5 | (_T_9 | _T_7); // @[Conditional.scala 39:67 CompressedDecoder.scala 226:22]
  wire [31:0] _GEN_54 = _T_5 ? _T_72 : _GEN_52; // @[Conditional.scala 39:67 CompressedDecoder.scala 227:28]
  wire  _GEN_55 = _T_3 | _GEN_53; // @[Conditional.scala 40:58 CompressedDecoder.scala 219:22]
  wire [31:0] _GEN_56 = _T_3 ? _T_70 : _GEN_54; // @[Conditional.scala 40:58 CompressedDecoder.scala 220:28]
  wire [31:0] _GEN_60 = _T_67 ? _GEN_56 : io_instruction_i; // @[Conditional.scala 39:67]
  wire  _GEN_61 = _T_10 ? _GEN_39 : _T_67 & _GEN_55; // @[Conditional.scala 39:67]
  wire [31:0] _GEN_62 = _T_10 ? _GEN_40 : _GEN_60; // @[Conditional.scala 39:67]
  wire  _GEN_63 = _T_1 ? _GEN_6 : _GEN_61; // @[Conditional.scala 40:58]
  wire [31:0] _GEN_64 = _T_1 ? _GEN_7 : _GEN_62; // @[Conditional.scala 40:58]
  assign io_is_comp = io_instruction_i == 32'h0 ? 1'h0 : _GEN_63; // @[CompressedDecoder.scala 285:47 CompressedDecoder.scala 287:18]
  assign io_instruction_o = io_instruction_i == 32'h0 ? io_instruction_i : _GEN_64; // @[CompressedDecoder.scala 285:47 CompressedDecoder.scala 288:24]
endmodule
module Core(
  input         clock,
  input         reset,
  output [31:0] io_pin,
  output        io_dmemReq_valid,
  output [31:0] io_dmemReq_bits_addrRequest,
  output [31:0] io_dmemReq_bits_dataRequest,
  output [3:0]  io_dmemReq_bits_activeByteLane,
  output        io_dmemReq_bits_isWrite,
  input         io_dmemRsp_valid,
  input  [31:0] io_dmemRsp_bits_dataResponse,
  output        io_imemReq_valid,
  output [31:0] io_imemReq_bits_addrRequest,
  input         io_imemRsp_valid,
  input  [31:0] io_imemRsp_bits_dataResponse,
  output [31:0] io_rvfiUInt_0,
  output [31:0] io_rvfiUInt_1,
  output [31:0] io_rvfiUInt_2,
  output [31:0] io_rvfiUInt_3,
  output [31:0] io_rvfiSInt_0,
  output [31:0] io_rvfiSInt_1,
  output [31:0] io_rvfiSInt_2,
  output [31:0] io_rvfiSInt_3,
  output [31:0] io_rvfiSInt_4,
  output        io_rvfiBool_0,
  output [4:0]  io_rvfiRegAddr_0,
  output [4:0]  io_rvfiRegAddr_1,
  output [4:0]  io_rvfiRegAddr_2
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_15;
  reg [31:0] _RAND_16;
  reg [31:0] _RAND_17;
  reg [31:0] _RAND_18;
  reg [31:0] _RAND_19;
  reg [31:0] _RAND_20;
  reg [31:0] _RAND_21;
  reg [31:0] _RAND_22;
  reg [31:0] _RAND_23;
  reg [31:0] _RAND_24;
  reg [31:0] _RAND_25;
  reg [31:0] _RAND_26;
  reg [31:0] _RAND_27;
  reg [31:0] _RAND_28;
  reg [31:0] _RAND_29;
  reg [31:0] _RAND_30;
  reg [31:0] _RAND_31;
  reg [31:0] _RAND_32;
  reg [31:0] _RAND_33;
  reg [31:0] _RAND_34;
  reg [31:0] _RAND_35;
  reg [31:0] _RAND_36;
  reg [31:0] _RAND_37;
  reg [31:0] _RAND_38;
  reg [31:0] _RAND_39;
  reg [31:0] _RAND_40;
  reg [31:0] _RAND_41;
  reg [31:0] _RAND_42;
  reg [31:0] _RAND_43;
  reg [31:0] _RAND_44;
  reg [31:0] _RAND_45;
  reg [31:0] _RAND_46;
  reg [31:0] _RAND_47;
  reg [31:0] _RAND_48;
  reg [31:0] _RAND_49;
  reg [31:0] _RAND_50;
  reg [31:0] _RAND_51;
`endif // RANDOMIZE_REG_INIT
  wire  InstructionFetch_reset; // @[Core.scala 79:18]
  wire [31:0] InstructionFetch_io_address; // @[Core.scala 79:18]
  wire [31:0] InstructionFetch_io_instruction; // @[Core.scala 79:18]
  wire  InstructionFetch_io_stall; // @[Core.scala 79:18]
  wire  InstructionFetch_io_coreInstrReq_valid; // @[Core.scala 79:18]
  wire [31:0] InstructionFetch_io_coreInstrReq_bits_addrRequest; // @[Core.scala 79:18]
  wire  InstructionFetch_io_coreInstrResp_valid; // @[Core.scala 79:18]
  wire [31:0] InstructionFetch_io_coreInstrResp_bits_dataResponse; // @[Core.scala 79:18]
  wire  InstructionDecode_clock; // @[Core.scala 80:18]
  wire  InstructionDecode_reset; // @[Core.scala 80:18]
  wire [31:0] InstructionDecode_io_id_instruction; // @[Core.scala 80:18]
  wire [31:0] InstructionDecode_io_writeData; // @[Core.scala 80:18]
  wire [4:0] InstructionDecode_io_writeReg; // @[Core.scala 80:18]
  wire [31:0] InstructionDecode_io_pcAddress; // @[Core.scala 80:18]
  wire  InstructionDecode_io_ctl_writeEnable; // @[Core.scala 80:18]
  wire  InstructionDecode_io_id_ex_mem_read; // @[Core.scala 80:18]
  wire  InstructionDecode_io_ex_mem_mem_read; // @[Core.scala 80:18]
  wire [4:0] InstructionDecode_io_id_ex_rd; // @[Core.scala 80:18]
  wire [4:0] InstructionDecode_io_ex_mem_rd; // @[Core.scala 80:18]
  wire  InstructionDecode_io_id_ex_branch; // @[Core.scala 80:18]
  wire [31:0] InstructionDecode_io_ex_mem_ins; // @[Core.scala 80:18]
  wire [31:0] InstructionDecode_io_mem_wb_ins; // @[Core.scala 80:18]
  wire [31:0] InstructionDecode_io_ex_ins; // @[Core.scala 80:18]
  wire [31:0] InstructionDecode_io_ex_result; // @[Core.scala 80:18]
  wire [31:0] InstructionDecode_io_ex_mem_result; // @[Core.scala 80:18]
  wire [31:0] InstructionDecode_io_mem_wb_result; // @[Core.scala 80:18]
  wire [31:0] InstructionDecode_io_immediate; // @[Core.scala 80:18]
  wire [4:0] InstructionDecode_io_writeRegAddress; // @[Core.scala 80:18]
  wire [31:0] InstructionDecode_io_readData1; // @[Core.scala 80:18]
  wire [31:0] InstructionDecode_io_readData2; // @[Core.scala 80:18]
  wire [6:0] InstructionDecode_io_func7; // @[Core.scala 80:18]
  wire [2:0] InstructionDecode_io_func3; // @[Core.scala 80:18]
  wire  InstructionDecode_io_ctl_aluSrc; // @[Core.scala 80:18]
  wire [1:0] InstructionDecode_io_ctl_memToReg; // @[Core.scala 80:18]
  wire  InstructionDecode_io_ctl_regWrite; // @[Core.scala 80:18]
  wire  InstructionDecode_io_ctl_memRead; // @[Core.scala 80:18]
  wire  InstructionDecode_io_ctl_memWrite; // @[Core.scala 80:18]
  wire  InstructionDecode_io_ctl_branch; // @[Core.scala 80:18]
  wire [1:0] InstructionDecode_io_ctl_aluOp; // @[Core.scala 80:18]
  wire [1:0] InstructionDecode_io_ctl_jump; // @[Core.scala 80:18]
  wire [1:0] InstructionDecode_io_ctl_aluSrc1; // @[Core.scala 80:18]
  wire  InstructionDecode_io_hdu_pcWrite; // @[Core.scala 80:18]
  wire  InstructionDecode_io_hdu_if_reg_write; // @[Core.scala 80:18]
  wire  InstructionDecode_io_pcSrc; // @[Core.scala 80:18]
  wire [31:0] InstructionDecode_io_pcPlusOffset; // @[Core.scala 80:18]
  wire  InstructionDecode_io_ifid_flush; // @[Core.scala 80:18]
  wire  InstructionDecode_io_stall; // @[Core.scala 80:18]
  wire [4:0] InstructionDecode_io_rs_addr_0; // @[Core.scala 80:18]
  wire [4:0] InstructionDecode_io_rs_addr_1; // @[Core.scala 80:18]
  wire  Execute_clock; // @[Core.scala 81:18]
  wire  Execute_reset; // @[Core.scala 81:18]
  wire [31:0] Execute_io_immediate; // @[Core.scala 81:18]
  wire [31:0] Execute_io_readData1; // @[Core.scala 81:18]
  wire [31:0] Execute_io_readData2; // @[Core.scala 81:18]
  wire [31:0] Execute_io_pcAddress; // @[Core.scala 81:18]
  wire [6:0] Execute_io_func7; // @[Core.scala 81:18]
  wire [2:0] Execute_io_func3; // @[Core.scala 81:18]
  wire [31:0] Execute_io_mem_result; // @[Core.scala 81:18]
  wire [31:0] Execute_io_wb_result; // @[Core.scala 81:18]
  wire  Execute_io_ex_mem_regWrite; // @[Core.scala 81:18]
  wire  Execute_io_mem_wb_regWrite; // @[Core.scala 81:18]
  wire [31:0] Execute_io_id_ex_ins; // @[Core.scala 81:18]
  wire [31:0] Execute_io_ex_mem_ins; // @[Core.scala 81:18]
  wire [31:0] Execute_io_mem_wb_ins; // @[Core.scala 81:18]
  wire  Execute_io_ctl_aluSrc; // @[Core.scala 81:18]
  wire [1:0] Execute_io_ctl_aluOp; // @[Core.scala 81:18]
  wire [1:0] Execute_io_ctl_aluSrc1; // @[Core.scala 81:18]
  wire [31:0] Execute_io_writeData; // @[Core.scala 81:18]
  wire [31:0] Execute_io_ALUresult; // @[Core.scala 81:18]
  wire  Execute_io_stall; // @[Core.scala 81:18]
  wire  MEM_clock; // @[Core.scala 82:19]
  wire  MEM_reset; // @[Core.scala 82:19]
  wire [31:0] MEM_io_aluResultIn; // @[Core.scala 82:19]
  wire [31:0] MEM_io_writeData; // @[Core.scala 82:19]
  wire  MEM_io_writeEnable; // @[Core.scala 82:19]
  wire  MEM_io_readEnable; // @[Core.scala 82:19]
  wire [31:0] MEM_io_readData; // @[Core.scala 82:19]
  wire [2:0] MEM_io_f3; // @[Core.scala 82:19]
  wire  MEM_io_dccmReq_valid; // @[Core.scala 82:19]
  wire [31:0] MEM_io_dccmReq_bits_addrRequest; // @[Core.scala 82:19]
  wire [31:0] MEM_io_dccmReq_bits_dataRequest; // @[Core.scala 82:19]
  wire [3:0] MEM_io_dccmReq_bits_activeByteLane; // @[Core.scala 82:19]
  wire  MEM_io_dccmReq_bits_isWrite; // @[Core.scala 82:19]
  wire  MEM_io_dccmRsp_valid; // @[Core.scala 82:19]
  wire [31:0] MEM_io_dccmRsp_bits_dataResponse; // @[Core.scala 82:19]
  wire  pc_clock; // @[Core.scala 88:18]
  wire  pc_reset; // @[Core.scala 88:18]
  wire [31:0] pc_io_in; // @[Core.scala 88:18]
  wire  pc_io_halt; // @[Core.scala 88:18]
  wire [31:0] pc_io_out; // @[Core.scala 88:18]
  wire [31:0] pc_io_pc4; // @[Core.scala 88:18]
  wire [31:0] pc_io_pc2; // @[Core.scala 88:18]
  wire  Realigner_clock; // @[Core.scala 103:20]
  wire  Realigner_reset; // @[Core.scala 103:20]
  wire [31:0] Realigner_io_ral_address_i; // @[Core.scala 103:20]
  wire [31:0] Realigner_io_ral_instruction_i; // @[Core.scala 103:20]
  wire  Realigner_io_ral_jmp; // @[Core.scala 103:20]
  wire [31:0] Realigner_io_ral_address_o; // @[Core.scala 103:20]
  wire [31:0] Realigner_io_ral_instruction_o; // @[Core.scala 103:20]
  wire  Realigner_io_ral_halt_o; // @[Core.scala 103:20]
  wire [31:0] CompressedDecoder_io_instruction_i; // @[Core.scala 117:20]
  wire  CompressedDecoder_io_is_comp; // @[Core.scala 117:20]
  wire [31:0] CompressedDecoder_io_instruction_o; // @[Core.scala 117:20]
  reg [31:0] if_reg_pc; // @[Core.scala 32:26]
  reg [31:0] if_reg_ins; // @[Core.scala 33:27]
  reg [31:0] id_reg_pc; // @[Core.scala 36:26]
  reg [31:0] id_reg_rd1; // @[Core.scala 37:27]
  reg [31:0] id_reg_rd2; // @[Core.scala 38:27]
  reg [31:0] id_reg_imm; // @[Core.scala 39:27]
  reg [4:0] id_reg_wra; // @[Core.scala 40:27]
  reg [6:0] id_reg_f7; // @[Core.scala 41:26]
  reg [2:0] id_reg_f3; // @[Core.scala 42:26]
  reg [31:0] id_reg_ins; // @[Core.scala 43:27]
  reg  id_reg_ctl_aluSrc; // @[Core.scala 44:34]
  reg [1:0] id_reg_ctl_aluSrc1; // @[Core.scala 45:35]
  reg [1:0] id_reg_ctl_memToReg; // @[Core.scala 46:36]
  reg  id_reg_ctl_regWrite; // @[Core.scala 47:36]
  reg  id_reg_ctl_memRead; // @[Core.scala 48:35]
  reg  id_reg_ctl_memWrite; // @[Core.scala 49:36]
  reg [1:0] id_reg_ctl_aluOp; // @[Core.scala 51:33]
  reg [31:0] ex_reg_result; // @[Core.scala 57:30]
  reg [31:0] ex_reg_wd; // @[Core.scala 58:26]
  reg [4:0] ex_reg_wra; // @[Core.scala 59:27]
  reg [31:0] ex_reg_ins; // @[Core.scala 60:27]
  reg [1:0] ex_reg_ctl_memToReg; // @[Core.scala 61:36]
  reg  ex_reg_ctl_regWrite; // @[Core.scala 62:36]
  reg  ex_reg_ctl_memRead; // @[Core.scala 63:35]
  reg  ex_reg_ctl_memWrite; // @[Core.scala 64:36]
  reg [31:0] ex_reg_pc; // @[Core.scala 66:26]
  reg [31:0] mem_reg_ins; // @[Core.scala 70:28]
  reg [31:0] mem_reg_result; // @[Core.scala 71:31]
  reg [4:0] mem_reg_wra; // @[Core.scala 73:28]
  reg [1:0] mem_reg_ctl_memToReg; // @[Core.scala 74:37]
  reg  mem_reg_ctl_regWrite; // @[Core.scala 75:37]
  reg [31:0] mem_reg_pc; // @[Core.scala 76:27]
  wire [31:0] instruction = CompressedDecoder_io_instruction_o; // @[Core.scala 93:25 Core.scala 120:18]
  wire [2:0] func3 = instruction[14:12]; // @[Core.scala 132:26]
  wire [6:0] _GEN_0 = instruction[6:0] == 7'h33 ? instruction[31:25] : 7'h0; // @[Core.scala 134:42 Core.scala 135:11 Core.scala 137:11]
  wire [5:0] func7 = _GEN_0[5:0]; // @[Core.scala 133:19]
  wire  IF_stall = func7 == 6'h1 & (func3 == 3'h4 | func3 == 3'h5 | func3 == 3'h6 | func3 == 3'h7); // @[Core.scala 140:32]
  wire  ral_halt_o = Realigner_io_ral_halt_o;
  wire  is_comp = CompressedDecoder_io_is_comp;
  wire [31:0] _T_22 = is_comp ? $signed(pc_io_pc2) : $signed(pc_io_pc4); // @[Core.scala 146:76]
  wire [31:0] _T_23 = InstructionDecode_io_pcSrc ? $signed(InstructionDecode_io_pcPlusOffset) : $signed(_T_22); // @[Core.scala 146:36]
  wire [31:0] _T_34 = mem_reg_pc + 32'h4; // @[Core.scala 294:28]
  wire [31:0] _GEN_6 = mem_reg_ctl_memToReg == 2'h2 ? _T_34 : mem_reg_result; // @[Core.scala 293:44 Core.scala 294:15 Core.scala 298:15]
  reg [31:0] REG__0; // @[Core.scala 314:23]
  reg [31:0] REG__1; // @[Core.scala 314:23]
  reg [31:0] REG__2; // @[Core.scala 314:23]
  reg [31:0] REG__3; // @[Core.scala 314:23]
  reg [4:0] REG_1_0; // @[Core.scala 315:53]
  reg [4:0] REG_1_1; // @[Core.scala 315:53]
  reg [4:0] REG_1_2; // @[Core.scala 315:53]
  reg [4:0] REG_2_0; // @[Core.scala 315:53]
  reg [4:0] REG_2_1; // @[Core.scala 315:53]
  reg [4:0] REG_2_2; // @[Core.scala 315:53]
  reg [31:0] REG_3_0; // @[Core.scala 316:53]
  reg [31:0] REG_3_1; // @[Core.scala 316:53]
  reg [31:0] REG_4_0; // @[Core.scala 316:53]
  reg [31:0] REG_4_1; // @[Core.scala 316:53]
  reg [31:0] REG_5; // @[Core.scala 317:31]
  reg [31:0] REG_6; // @[Core.scala 318:32]
  reg  REG_7_0; // @[Core.scala 319:25]
  reg  REG_7_1; // @[Core.scala 319:25]
  reg  REG_7_2; // @[Core.scala 319:25]
  reg  REG_7_3; // @[Core.scala 319:25]
  InstructionFetch InstructionFetch ( // @[Core.scala 79:18]
    .reset(InstructionFetch_reset),
    .io_address(InstructionFetch_io_address),
    .io_instruction(InstructionFetch_io_instruction),
    .io_stall(InstructionFetch_io_stall),
    .io_coreInstrReq_valid(InstructionFetch_io_coreInstrReq_valid),
    .io_coreInstrReq_bits_addrRequest(InstructionFetch_io_coreInstrReq_bits_addrRequest),
    .io_coreInstrResp_valid(InstructionFetch_io_coreInstrResp_valid),
    .io_coreInstrResp_bits_dataResponse(InstructionFetch_io_coreInstrResp_bits_dataResponse)
  );
  InstructionDecode InstructionDecode ( // @[Core.scala 80:18]
    .clock(InstructionDecode_clock),
    .reset(InstructionDecode_reset),
    .io_id_instruction(InstructionDecode_io_id_instruction),
    .io_writeData(InstructionDecode_io_writeData),
    .io_writeReg(InstructionDecode_io_writeReg),
    .io_pcAddress(InstructionDecode_io_pcAddress),
    .io_ctl_writeEnable(InstructionDecode_io_ctl_writeEnable),
    .io_id_ex_mem_read(InstructionDecode_io_id_ex_mem_read),
    .io_ex_mem_mem_read(InstructionDecode_io_ex_mem_mem_read),
    .io_id_ex_rd(InstructionDecode_io_id_ex_rd),
    .io_ex_mem_rd(InstructionDecode_io_ex_mem_rd),
    .io_id_ex_branch(InstructionDecode_io_id_ex_branch),
    .io_ex_mem_ins(InstructionDecode_io_ex_mem_ins),
    .io_mem_wb_ins(InstructionDecode_io_mem_wb_ins),
    .io_ex_ins(InstructionDecode_io_ex_ins),
    .io_ex_result(InstructionDecode_io_ex_result),
    .io_ex_mem_result(InstructionDecode_io_ex_mem_result),
    .io_mem_wb_result(InstructionDecode_io_mem_wb_result),
    .io_immediate(InstructionDecode_io_immediate),
    .io_writeRegAddress(InstructionDecode_io_writeRegAddress),
    .io_readData1(InstructionDecode_io_readData1),
    .io_readData2(InstructionDecode_io_readData2),
    .io_func7(InstructionDecode_io_func7),
    .io_func3(InstructionDecode_io_func3),
    .io_ctl_aluSrc(InstructionDecode_io_ctl_aluSrc),
    .io_ctl_memToReg(InstructionDecode_io_ctl_memToReg),
    .io_ctl_regWrite(InstructionDecode_io_ctl_regWrite),
    .io_ctl_memRead(InstructionDecode_io_ctl_memRead),
    .io_ctl_memWrite(InstructionDecode_io_ctl_memWrite),
    .io_ctl_branch(InstructionDecode_io_ctl_branch),
    .io_ctl_aluOp(InstructionDecode_io_ctl_aluOp),
    .io_ctl_jump(InstructionDecode_io_ctl_jump),
    .io_ctl_aluSrc1(InstructionDecode_io_ctl_aluSrc1),
    .io_hdu_pcWrite(InstructionDecode_io_hdu_pcWrite),
    .io_hdu_if_reg_write(InstructionDecode_io_hdu_if_reg_write),
    .io_pcSrc(InstructionDecode_io_pcSrc),
    .io_pcPlusOffset(InstructionDecode_io_pcPlusOffset),
    .io_ifid_flush(InstructionDecode_io_ifid_flush),
    .io_stall(InstructionDecode_io_stall),
    .io_rs_addr_0(InstructionDecode_io_rs_addr_0),
    .io_rs_addr_1(InstructionDecode_io_rs_addr_1)
  );
  Execute Execute ( // @[Core.scala 81:18]
    .clock(Execute_clock),
    .reset(Execute_reset),
    .io_immediate(Execute_io_immediate),
    .io_readData1(Execute_io_readData1),
    .io_readData2(Execute_io_readData2),
    .io_pcAddress(Execute_io_pcAddress),
    .io_func7(Execute_io_func7),
    .io_func3(Execute_io_func3),
    .io_mem_result(Execute_io_mem_result),
    .io_wb_result(Execute_io_wb_result),
    .io_ex_mem_regWrite(Execute_io_ex_mem_regWrite),
    .io_mem_wb_regWrite(Execute_io_mem_wb_regWrite),
    .io_id_ex_ins(Execute_io_id_ex_ins),
    .io_ex_mem_ins(Execute_io_ex_mem_ins),
    .io_mem_wb_ins(Execute_io_mem_wb_ins),
    .io_ctl_aluSrc(Execute_io_ctl_aluSrc),
    .io_ctl_aluOp(Execute_io_ctl_aluOp),
    .io_ctl_aluSrc1(Execute_io_ctl_aluSrc1),
    .io_writeData(Execute_io_writeData),
    .io_ALUresult(Execute_io_ALUresult),
    .io_stall(Execute_io_stall)
  );
  MemoryFetch MEM ( // @[Core.scala 82:19]
    .clock(MEM_clock),
    .reset(MEM_reset),
    .io_aluResultIn(MEM_io_aluResultIn),
    .io_writeData(MEM_io_writeData),
    .io_writeEnable(MEM_io_writeEnable),
    .io_readEnable(MEM_io_readEnable),
    .io_readData(MEM_io_readData),
    .io_f3(MEM_io_f3),
    .io_dccmReq_valid(MEM_io_dccmReq_valid),
    .io_dccmReq_bits_addrRequest(MEM_io_dccmReq_bits_addrRequest),
    .io_dccmReq_bits_dataRequest(MEM_io_dccmReq_bits_dataRequest),
    .io_dccmReq_bits_activeByteLane(MEM_io_dccmReq_bits_activeByteLane),
    .io_dccmReq_bits_isWrite(MEM_io_dccmReq_bits_isWrite),
    .io_dccmRsp_valid(MEM_io_dccmRsp_valid),
    .io_dccmRsp_bits_dataResponse(MEM_io_dccmRsp_bits_dataResponse)
  );
  PC pc ( // @[Core.scala 88:18]
    .clock(pc_clock),
    .reset(pc_reset),
    .io_in(pc_io_in),
    .io_halt(pc_io_halt),
    .io_out(pc_io_out),
    .io_pc4(pc_io_pc4),
    .io_pc2(pc_io_pc2)
  );
  Realigner Realigner ( // @[Core.scala 103:20]
    .clock(Realigner_clock),
    .reset(Realigner_reset),
    .io_ral_address_i(Realigner_io_ral_address_i),
    .io_ral_instruction_i(Realigner_io_ral_instruction_i),
    .io_ral_jmp(Realigner_io_ral_jmp),
    .io_ral_address_o(Realigner_io_ral_address_o),
    .io_ral_instruction_o(Realigner_io_ral_instruction_o),
    .io_ral_halt_o(Realigner_io_ral_halt_o)
  );
  CompressedDecoder CompressedDecoder ( // @[Core.scala 117:20]
    .io_instruction_i(CompressedDecoder_io_instruction_i),
    .io_is_comp(CompressedDecoder_io_is_comp),
    .io_instruction_o(CompressedDecoder_io_instruction_o)
  );
  assign io_pin = mem_reg_ctl_memToReg == 2'h1 ? MEM_io_readData : _GEN_6; // @[Core.scala 290:38 Core.scala 291:13]
  assign io_dmemReq_valid = MEM_io_dccmReq_valid; // @[Core.scala 239:14]
  assign io_dmemReq_bits_addrRequest = MEM_io_dccmReq_bits_addrRequest; // @[Core.scala 239:14]
  assign io_dmemReq_bits_dataRequest = MEM_io_dccmReq_bits_dataRequest; // @[Core.scala 239:14]
  assign io_dmemReq_bits_activeByteLane = MEM_io_dccmReq_bits_activeByteLane; // @[Core.scala 239:14]
  assign io_dmemReq_bits_isWrite = MEM_io_dccmReq_bits_isWrite; // @[Core.scala 239:14]
  assign io_imemReq_valid = InstructionFetch_io_coreInstrReq_valid; // @[Core.scala 90:14]
  assign io_imemReq_bits_addrRequest = InstructionFetch_io_coreInstrReq_bits_addrRequest; // @[Core.scala 90:14]
  assign io_rvfiUInt_0 = mem_reg_pc; // @[Core.scala 360:19]
  assign io_rvfiUInt_1 = REG__3; // @[Core.scala 360:19]
  assign io_rvfiUInt_2 = mem_reg_ins; // @[Core.scala 360:19]
  assign io_rvfiUInt_3 = REG_5; // @[Core.scala 360:19]
  assign io_rvfiSInt_0 = mem_reg_ctl_memToReg == 2'h1 ? MEM_io_readData : _GEN_6; // @[Core.scala 354:36]
  assign io_rvfiSInt_1 = REG_3_1; // @[Core.scala 329:30]
  assign io_rvfiSInt_2 = REG_4_1; // @[Core.scala 329:30]
  assign io_rvfiSInt_3 = MEM_io_readData; // @[Core.scala 355:44]
  assign io_rvfiSInt_4 = REG_6; // @[Core.scala 360:19]
  assign io_rvfiBool_0 = REG_7_3; // @[Core.scala 360:19]
  assign io_rvfiRegAddr_0 = mem_reg_wra; // @[Core.scala 290:38 Core.scala 292:13]
  assign io_rvfiRegAddr_1 = REG_1_2; // @[Core.scala 326:33]
  assign io_rvfiRegAddr_2 = REG_2_2; // @[Core.scala 326:33]
  assign InstructionFetch_reset = reset;
  assign InstructionFetch_io_address = Realigner_io_ral_address_o; // @[Core.scala 109:26]
  assign InstructionFetch_io_stall = Execute_io_stall | InstructionDecode_io_stall | IF_stall; // @[Core.scala 142:48]
  assign InstructionFetch_io_coreInstrResp_valid = io_imemRsp_valid; // @[Core.scala 91:20]
  assign InstructionFetch_io_coreInstrResp_bits_dataResponse = io_imemRsp_bits_dataResponse; // @[Core.scala 91:20]
  assign InstructionDecode_clock = clock;
  assign InstructionDecode_reset = reset;
  assign InstructionDecode_io_id_instruction = if_reg_ins; // @[Core.scala 180:21]
  assign InstructionDecode_io_writeData = mem_reg_ctl_memToReg == 2'h1 ? MEM_io_readData : _GEN_6; // @[Core.scala 290:38 Core.scala 291:13]
  assign InstructionDecode_io_writeReg = mem_reg_wra; // @[Core.scala 290:38 Core.scala 292:13]
  assign InstructionDecode_io_pcAddress = if_reg_pc; // @[Core.scala 181:16]
  assign InstructionDecode_io_ctl_writeEnable = mem_reg_ctl_regWrite; // @[Core.scala 307:22]
  assign InstructionDecode_io_id_ex_mem_read = id_reg_ctl_memRead; // @[Core.scala 217:21]
  assign InstructionDecode_io_ex_mem_mem_read = ex_reg_ctl_memRead; // @[Core.scala 218:22]
  assign InstructionDecode_io_id_ex_rd = id_reg_ins[11:7]; // @[Core.scala 225:28]
  assign InstructionDecode_io_ex_mem_rd = ex_reg_ins[11:7]; // @[Core.scala 227:29]
  assign InstructionDecode_io_id_ex_branch = id_reg_ins[6:0] == 7'h63; // @[Core.scala 226:42]
  assign InstructionDecode_io_ex_mem_ins = ex_reg_ins; // @[Core.scala 186:17]
  assign InstructionDecode_io_mem_wb_ins = mem_reg_ins; // @[Core.scala 187:17]
  assign InstructionDecode_io_ex_ins = id_reg_ins; // @[Core.scala 185:13]
  assign InstructionDecode_io_ex_result = Execute_io_ALUresult; // @[Core.scala 228:16]
  assign InstructionDecode_io_ex_mem_result = ex_reg_result; // @[Core.scala 188:20]
  assign InstructionDecode_io_mem_wb_result = mem_reg_ctl_memToReg == 2'h1 ? MEM_io_readData : _GEN_6; // @[Core.scala 290:38 Core.scala 291:13]
  assign Execute_clock = clock;
  assign Execute_reset = reset;
  assign Execute_io_immediate = id_reg_imm; // @[Core.scala 199:16]
  assign Execute_io_readData1 = id_reg_rd1; // @[Core.scala 200:16]
  assign Execute_io_readData2 = id_reg_rd2; // @[Core.scala 201:16]
  assign Execute_io_pcAddress = id_reg_pc; // @[Core.scala 202:16]
  assign Execute_io_func7 = id_reg_f7; // @[Core.scala 204:12]
  assign Execute_io_func3 = id_reg_f3; // @[Core.scala 203:12]
  assign Execute_io_mem_result = ex_reg_result; // @[Core.scala 281:17]
  assign Execute_io_wb_result = mem_reg_ctl_memToReg == 2'h1 ? MEM_io_readData : _GEN_6; // @[Core.scala 290:38 Core.scala 291:13]
  assign Execute_io_ex_mem_regWrite = ex_reg_ctl_regWrite; // @[Core.scala 275:22]
  assign Execute_io_mem_wb_regWrite = mem_reg_ctl_regWrite; // @[Core.scala 305:22]
  assign Execute_io_id_ex_ins = id_reg_ins; // @[Core.scala 222:16]
  assign Execute_io_ex_mem_ins = ex_reg_ins; // @[Core.scala 223:17]
  assign Execute_io_mem_wb_ins = mem_reg_ins; // @[Core.scala 224:17]
  assign Execute_io_ctl_aluSrc = id_reg_ctl_aluSrc; // @[Core.scala 205:17]
  assign Execute_io_ctl_aluOp = id_reg_ctl_aluOp; // @[Core.scala 206:16]
  assign Execute_io_ctl_aluSrc1 = id_reg_ctl_aluSrc1; // @[Core.scala 207:18]
  assign MEM_clock = clock;
  assign MEM_reset = reset;
  assign MEM_io_aluResultIn = ex_reg_result; // @[Core.scala 276:22]
  assign MEM_io_writeData = ex_reg_wd; // @[Core.scala 277:20]
  assign MEM_io_writeEnable = ex_reg_ctl_memWrite; // @[Core.scala 279:22]
  assign MEM_io_readEnable = ex_reg_ctl_memRead; // @[Core.scala 278:21]
  assign MEM_io_f3 = ex_reg_ins[14:12]; // @[Core.scala 280:26]
  assign MEM_io_dccmRsp_valid = io_dmemRsp_valid; // @[Core.scala 240:18]
  assign MEM_io_dccmRsp_bits_dataResponse = io_dmemRsp_bits_dataResponse; // @[Core.scala 240:18]
  assign pc_clock = clock;
  assign pc_reset = reset;
  assign pc_io_in = InstructionDecode_io_hdu_pcWrite ? $signed(_T_23) : $signed(pc_io_out); // @[Core.scala 146:16]
  assign pc_io_halt = Execute_io_stall | InstructionDecode_io_stall | IF_stall | ~io_imemReq_valid | ral_halt_o; // @[Core.scala 145:78]
  assign Realigner_clock = clock;
  assign Realigner_reset = reset;
  assign Realigner_io_ral_address_i = pc_io_in; // @[Core.scala 105:44]
  assign Realigner_io_ral_instruction_i = InstructionFetch_io_instruction; // @[Core.scala 106:26]
  assign Realigner_io_ral_jmp = InstructionDecode_io_pcSrc; // @[Core.scala 107:26]
  assign CompressedDecoder_io_instruction_i = Realigner_io_ral_instruction_o; // @[Core.scala 119:22]
  always @(posedge clock) begin
    if (reset) begin // @[Core.scala 32:26]
      if_reg_pc <= 32'h0; // @[Core.scala 32:26]
    end else if (InstructionDecode_io_hdu_if_reg_write) begin // @[Core.scala 149:29]
      if_reg_pc <= pc_io_out; // @[Core.scala 150:15]
    end
    if (reset) begin // @[Core.scala 33:27]
      if_reg_ins <= 32'h0; // @[Core.scala 33:27]
    end else if (InstructionDecode_io_ifid_flush) begin // @[Core.scala 153:23]
      if_reg_ins <= 32'h0; // @[Core.scala 154:16]
    end else if (InstructionDecode_io_hdu_if_reg_write) begin // @[Core.scala 149:29]
      if_reg_ins <= instruction; // @[Core.scala 151:16]
    end
    if (reset) begin // @[Core.scala 36:26]
      id_reg_pc <= 32'h0; // @[Core.scala 36:26]
    end else begin
      id_reg_pc <= if_reg_pc; // @[Core.scala 169:13]
    end
    if (reset) begin // @[Core.scala 37:27]
      id_reg_rd1 <= 32'h0; // @[Core.scala 37:27]
    end else begin
      id_reg_rd1 <= InstructionDecode_io_readData1; // @[Core.scala 162:14]
    end
    if (reset) begin // @[Core.scala 38:27]
      id_reg_rd2 <= 32'h0; // @[Core.scala 38:27]
    end else begin
      id_reg_rd2 <= InstructionDecode_io_readData2; // @[Core.scala 163:14]
    end
    if (reset) begin // @[Core.scala 39:27]
      id_reg_imm <= 32'h0; // @[Core.scala 39:27]
    end else begin
      id_reg_imm <= InstructionDecode_io_immediate; // @[Core.scala 164:14]
    end
    if (reset) begin // @[Core.scala 40:27]
      id_reg_wra <= 5'h0; // @[Core.scala 40:27]
    end else if (!(Execute_io_stall)) begin // @[Core.scala 230:17]
      id_reg_wra <= InstructionDecode_io_writeRegAddress; // @[Core.scala 165:14]
    end
    if (reset) begin // @[Core.scala 41:26]
      id_reg_f7 <= 7'h0; // @[Core.scala 41:26]
    end else begin
      id_reg_f7 <= InstructionDecode_io_func7; // @[Core.scala 167:13]
    end
    if (reset) begin // @[Core.scala 42:26]
      id_reg_f3 <= 3'h0; // @[Core.scala 42:26]
    end else begin
      id_reg_f3 <= InstructionDecode_io_func3; // @[Core.scala 166:13]
    end
    if (reset) begin // @[Core.scala 43:27]
      id_reg_ins <= 32'h0; // @[Core.scala 43:27]
    end else begin
      id_reg_ins <= if_reg_ins; // @[Core.scala 168:14]
    end
    if (reset) begin // @[Core.scala 44:34]
      id_reg_ctl_aluSrc <= 1'h0; // @[Core.scala 44:34]
    end else begin
      id_reg_ctl_aluSrc <= InstructionDecode_io_ctl_aluSrc; // @[Core.scala 170:21]
    end
    if (reset) begin // @[Core.scala 45:35]
      id_reg_ctl_aluSrc1 <= 2'h0; // @[Core.scala 45:35]
    end else begin
      id_reg_ctl_aluSrc1 <= InstructionDecode_io_ctl_aluSrc1; // @[Core.scala 178:22]
    end
    if (reset) begin // @[Core.scala 46:36]
      id_reg_ctl_memToReg <= 2'h0; // @[Core.scala 46:36]
    end else begin
      id_reg_ctl_memToReg <= InstructionDecode_io_ctl_memToReg; // @[Core.scala 171:23]
    end
    if (reset) begin // @[Core.scala 47:36]
      id_reg_ctl_regWrite <= 1'h0; // @[Core.scala 47:36]
    end else if (!(Execute_io_stall)) begin // @[Core.scala 230:17]
      id_reg_ctl_regWrite <= InstructionDecode_io_ctl_regWrite; // @[Core.scala 172:23]
    end
    if (reset) begin // @[Core.scala 48:35]
      id_reg_ctl_memRead <= 1'h0; // @[Core.scala 48:35]
    end else begin
      id_reg_ctl_memRead <= InstructionDecode_io_ctl_memRead; // @[Core.scala 173:22]
    end
    if (reset) begin // @[Core.scala 49:36]
      id_reg_ctl_memWrite <= 1'h0; // @[Core.scala 49:36]
    end else begin
      id_reg_ctl_memWrite <= InstructionDecode_io_ctl_memWrite; // @[Core.scala 174:23]
    end
    if (reset) begin // @[Core.scala 51:33]
      id_reg_ctl_aluOp <= 2'h0; // @[Core.scala 51:33]
    end else begin
      id_reg_ctl_aluOp <= InstructionDecode_io_ctl_aluOp; // @[Core.scala 176:20]
    end
    if (reset) begin // @[Core.scala 57:30]
      ex_reg_result <= 32'h0; // @[Core.scala 57:30]
    end else begin
      ex_reg_result <= Execute_io_ALUresult; // @[Core.scala 271:19]
    end
    if (reset) begin // @[Core.scala 58:26]
      ex_reg_wd <= 32'h0; // @[Core.scala 58:26]
    end else begin
      ex_reg_wd <= Execute_io_writeData; // @[Core.scala 270:15]
    end
    if (reset) begin // @[Core.scala 59:27]
      ex_reg_wra <= 5'h0; // @[Core.scala 59:27]
    end else begin
      ex_reg_wra <= id_reg_wra; // @[Core.scala 211:14]
    end
    if (reset) begin // @[Core.scala 60:27]
      ex_reg_ins <= 32'h0; // @[Core.scala 60:27]
    end else begin
      ex_reg_ins <= id_reg_ins; // @[Core.scala 212:14]
    end
    if (reset) begin // @[Core.scala 61:36]
      ex_reg_ctl_memToReg <= 2'h0; // @[Core.scala 61:36]
    end else begin
      ex_reg_ctl_memToReg <= id_reg_ctl_memToReg; // @[Core.scala 213:23]
    end
    if (reset) begin // @[Core.scala 62:36]
      ex_reg_ctl_regWrite <= 1'h0; // @[Core.scala 62:36]
    end else begin
      ex_reg_ctl_regWrite <= id_reg_ctl_regWrite; // @[Core.scala 214:23]
    end
    if (reset) begin // @[Core.scala 63:35]
      ex_reg_ctl_memRead <= 1'h0; // @[Core.scala 63:35]
    end else begin
      ex_reg_ctl_memRead <= id_reg_ctl_memRead; // @[Core.scala 268:24]
    end
    if (reset) begin // @[Core.scala 64:36]
      ex_reg_ctl_memWrite <= 1'h0; // @[Core.scala 64:36]
    end else begin
      ex_reg_ctl_memWrite <= id_reg_ctl_memWrite; // @[Core.scala 269:25]
    end
    if (reset) begin // @[Core.scala 66:26]
      ex_reg_pc <= 32'h0; // @[Core.scala 66:26]
    end else begin
      ex_reg_pc <= id_reg_pc; // @[Core.scala 210:13]
    end
    if (reset) begin // @[Core.scala 70:28]
      mem_reg_ins <= 32'h0; // @[Core.scala 70:28]
    end else begin
      mem_reg_ins <= ex_reg_ins; // @[Core.scala 265:17]
    end
    if (reset) begin // @[Core.scala 71:31]
      mem_reg_result <= 32'h0; // @[Core.scala 71:31]
    end else begin
      mem_reg_result <= ex_reg_result; // @[Core.scala 262:20]
    end
    if (reset) begin // @[Core.scala 73:28]
      mem_reg_wra <= 5'h0; // @[Core.scala 73:28]
    end else begin
      mem_reg_wra <= ex_reg_wra; // @[Core.scala 273:15]
    end
    if (reset) begin // @[Core.scala 74:37]
      mem_reg_ctl_memToReg <= 2'h0; // @[Core.scala 74:37]
    end else begin
      mem_reg_ctl_memToReg <= ex_reg_ctl_memToReg; // @[Core.scala 274:24]
    end
    if (reset) begin // @[Core.scala 75:37]
      mem_reg_ctl_regWrite <= 1'h0; // @[Core.scala 75:37]
    end else begin
      mem_reg_ctl_regWrite <= ex_reg_ctl_regWrite; // @[Core.scala 264:26]
    end
    if (reset) begin // @[Core.scala 76:27]
      mem_reg_pc <= 32'h0; // @[Core.scala 76:27]
    end else begin
      mem_reg_pc <= ex_reg_pc; // @[Core.scala 266:16]
    end
    REG__0 <= InstructionDecode_io_hdu_pcWrite ? $signed(_T_23) : $signed(pc_io_out); // @[Core.scala 338:25]
    REG__1 <= REG__0; // @[Core.scala 332:23]
    REG__2 <= REG__1; // @[Core.scala 332:23]
    REG__3 <= REG__2; // @[Core.scala 332:23]
    REG_1_0 <= InstructionDecode_io_rs_addr_0; // @[Core.scala 325:25]
    REG_1_1 <= REG_1_0; // @[Core.scala 323:31]
    REG_1_2 <= REG_1_1; // @[Core.scala 323:31]
    REG_2_0 <= InstructionDecode_io_rs_addr_1; // @[Core.scala 325:25]
    REG_2_1 <= REG_2_0; // @[Core.scala 323:31]
    REG_2_2 <= REG_2_1; // @[Core.scala 323:31]
    REG_3_0 <= id_reg_rd1; // @[Core.scala 340:38]
    REG_3_1 <= REG_3_0; // @[Core.scala 328:25]
    REG_4_0 <= id_reg_rd2; // @[Core.scala 341:38]
    REG_4_1 <= REG_4_0; // @[Core.scala 328:25]
    if (reset) begin // @[Core.scala 317:31]
      REG_5 <= 32'h0; // @[Core.scala 317:31]
    end else begin
      REG_5 <= ex_reg_result; // @[Core.scala 360:19]
    end
    if (reset) begin // @[Core.scala 318:32]
      REG_6 <= 32'sh0; // @[Core.scala 318:32]
    end else begin
      REG_6 <= ex_reg_wd; // @[Core.scala 360:19]
    end
    REG_7_0 <= InstructionDecode_io_hdu_if_reg_write; // @[Core.scala 360:19]
    REG_7_1 <= REG_7_0; // @[Core.scala 333:25]
    REG_7_2 <= REG_7_1; // @[Core.scala 333:25]
    REG_7_3 <= REG_7_2; // @[Core.scala 333:25]
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  if_reg_pc = _RAND_0[31:0];
  _RAND_1 = {1{`RANDOM}};
  if_reg_ins = _RAND_1[31:0];
  _RAND_2 = {1{`RANDOM}};
  id_reg_pc = _RAND_2[31:0];
  _RAND_3 = {1{`RANDOM}};
  id_reg_rd1 = _RAND_3[31:0];
  _RAND_4 = {1{`RANDOM}};
  id_reg_rd2 = _RAND_4[31:0];
  _RAND_5 = {1{`RANDOM}};
  id_reg_imm = _RAND_5[31:0];
  _RAND_6 = {1{`RANDOM}};
  id_reg_wra = _RAND_6[4:0];
  _RAND_7 = {1{`RANDOM}};
  id_reg_f7 = _RAND_7[6:0];
  _RAND_8 = {1{`RANDOM}};
  id_reg_f3 = _RAND_8[2:0];
  _RAND_9 = {1{`RANDOM}};
  id_reg_ins = _RAND_9[31:0];
  _RAND_10 = {1{`RANDOM}};
  id_reg_ctl_aluSrc = _RAND_10[0:0];
  _RAND_11 = {1{`RANDOM}};
  id_reg_ctl_aluSrc1 = _RAND_11[1:0];
  _RAND_12 = {1{`RANDOM}};
  id_reg_ctl_memToReg = _RAND_12[1:0];
  _RAND_13 = {1{`RANDOM}};
  id_reg_ctl_regWrite = _RAND_13[0:0];
  _RAND_14 = {1{`RANDOM}};
  id_reg_ctl_memRead = _RAND_14[0:0];
  _RAND_15 = {1{`RANDOM}};
  id_reg_ctl_memWrite = _RAND_15[0:0];
  _RAND_16 = {1{`RANDOM}};
  id_reg_ctl_aluOp = _RAND_16[1:0];
  _RAND_17 = {1{`RANDOM}};
  ex_reg_result = _RAND_17[31:0];
  _RAND_18 = {1{`RANDOM}};
  ex_reg_wd = _RAND_18[31:0];
  _RAND_19 = {1{`RANDOM}};
  ex_reg_wra = _RAND_19[4:0];
  _RAND_20 = {1{`RANDOM}};
  ex_reg_ins = _RAND_20[31:0];
  _RAND_21 = {1{`RANDOM}};
  ex_reg_ctl_memToReg = _RAND_21[1:0];
  _RAND_22 = {1{`RANDOM}};
  ex_reg_ctl_regWrite = _RAND_22[0:0];
  _RAND_23 = {1{`RANDOM}};
  ex_reg_ctl_memRead = _RAND_23[0:0];
  _RAND_24 = {1{`RANDOM}};
  ex_reg_ctl_memWrite = _RAND_24[0:0];
  _RAND_25 = {1{`RANDOM}};
  ex_reg_pc = _RAND_25[31:0];
  _RAND_26 = {1{`RANDOM}};
  mem_reg_ins = _RAND_26[31:0];
  _RAND_27 = {1{`RANDOM}};
  mem_reg_result = _RAND_27[31:0];
  _RAND_28 = {1{`RANDOM}};
  mem_reg_wra = _RAND_28[4:0];
  _RAND_29 = {1{`RANDOM}};
  mem_reg_ctl_memToReg = _RAND_29[1:0];
  _RAND_30 = {1{`RANDOM}};
  mem_reg_ctl_regWrite = _RAND_30[0:0];
  _RAND_31 = {1{`RANDOM}};
  mem_reg_pc = _RAND_31[31:0];
  _RAND_32 = {1{`RANDOM}};
  REG__0 = _RAND_32[31:0];
  _RAND_33 = {1{`RANDOM}};
  REG__1 = _RAND_33[31:0];
  _RAND_34 = {1{`RANDOM}};
  REG__2 = _RAND_34[31:0];
  _RAND_35 = {1{`RANDOM}};
  REG__3 = _RAND_35[31:0];
  _RAND_36 = {1{`RANDOM}};
  REG_1_0 = _RAND_36[4:0];
  _RAND_37 = {1{`RANDOM}};
  REG_1_1 = _RAND_37[4:0];
  _RAND_38 = {1{`RANDOM}};
  REG_1_2 = _RAND_38[4:0];
  _RAND_39 = {1{`RANDOM}};
  REG_2_0 = _RAND_39[4:0];
  _RAND_40 = {1{`RANDOM}};
  REG_2_1 = _RAND_40[4:0];
  _RAND_41 = {1{`RANDOM}};
  REG_2_2 = _RAND_41[4:0];
  _RAND_42 = {1{`RANDOM}};
  REG_3_0 = _RAND_42[31:0];
  _RAND_43 = {1{`RANDOM}};
  REG_3_1 = _RAND_43[31:0];
  _RAND_44 = {1{`RANDOM}};
  REG_4_0 = _RAND_44[31:0];
  _RAND_45 = {1{`RANDOM}};
  REG_4_1 = _RAND_45[31:0];
  _RAND_46 = {1{`RANDOM}};
  REG_5 = _RAND_46[31:0];
  _RAND_47 = {1{`RANDOM}};
  REG_6 = _RAND_47[31:0];
  _RAND_48 = {1{`RANDOM}};
  REG_7_0 = _RAND_48[0:0];
  _RAND_49 = {1{`RANDOM}};
  REG_7_1 = _RAND_49[0:0];
  _RAND_50 = {1{`RANDOM}};
  REG_7_2 = _RAND_50[0:0];
  _RAND_51 = {1{`RANDOM}};
  REG_7_3 = _RAND_51[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module SRamTop(
  input         clock,
  input         reset,
  input         io_req_valid,
  input  [31:0] io_req_bits_addrRequest,
  input  [31:0] io_req_bits_dataRequest,
  input  [3:0]  io_req_bits_activeByteLane,
  input         io_req_bits_isWrite,
  output        io_rsp_valid,
  output [31:0] io_rsp_bits_dataResponse
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  wire  sram_clk_i; // @[SRamTop.scala 21:22]
  wire  sram_rst_i; // @[SRamTop.scala 21:22]
  wire  sram_csb_i; // @[SRamTop.scala 21:22]
  wire  sram_we_i; // @[SRamTop.scala 21:22]
  wire [3:0] sram_wmask_i; // @[SRamTop.scala 21:22]
  wire [12:0] sram_addr_i; // @[SRamTop.scala 21:22]
  wire [31:0] sram_wdata_i; // @[SRamTop.scala 21:22]
  wire [31:0] sram_rdata_o; // @[SRamTop.scala 21:22]
  reg  validReg; // @[SRamTop.scala 14:27]
  wire  _T_5 = io_req_valid & io_req_bits_isWrite; // @[SRamTop.scala 49:34]
  wire  _GEN_0 = io_req_valid & io_req_bits_isWrite ? 1'h0 : 1'h1; // @[SRamTop.scala 49:58 SRamTop.scala 54:27 SRamTop.scala 29:19]
  wire  _GEN_6 = io_req_valid & ~io_req_bits_isWrite | _T_5; // @[SRamTop.scala 40:52 SRamTop.scala 43:22]
  sram_top #(.IFILE_IN("")) sram ( // @[SRamTop.scala 21:22]
    .clk_i(sram_clk_i),
    .rst_i(sram_rst_i),
    .csb_i(sram_csb_i),
    .we_i(sram_we_i),
    .wmask_i(sram_wmask_i),
    .addr_i(sram_addr_i),
    .wdata_i(sram_wdata_i),
    .rdata_o(sram_rdata_o)
  );
  assign io_rsp_valid = validReg; // @[SRamTop.scala 15:18]
  assign io_rsp_bits_dataResponse = sram_rdata_o; // @[SRamTop.scala 67:30]
  assign sram_clk_i = clock; // @[SRamTop.scala 23:36]
  assign sram_rst_i = reset; // @[SRamTop.scala 25:24]
  assign sram_csb_i = io_req_valid & ~io_req_bits_isWrite ? 1'h0 : _GEN_0; // @[SRamTop.scala 40:52 SRamTop.scala 44:27]
  assign sram_we_i = io_req_valid & ~io_req_bits_isWrite; // @[SRamTop.scala 40:27]
  assign sram_wmask_i = io_req_bits_activeByteLane; // @[SRamTop.scala 49:58 SRamTop.scala 56:29]
  assign sram_addr_i = io_req_bits_addrRequest[12:0];
  assign sram_wdata_i = io_req_bits_dataRequest; // @[SRamTop.scala 49:58 SRamTop.scala 58:29]
  always @(posedge clock) begin
    if (reset) begin // @[SRamTop.scala 14:27]
      validReg <= 1'h0; // @[SRamTop.scala 14:27]
    end else begin
      validReg <= _GEN_6;
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  validReg = _RAND_0[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module SRamTop_1(
  input         clock,
  input         reset,
  input         io_req_valid,
  input  [31:0] io_req_bits_addrRequest,
  output        io_rsp_valid,
  output [31:0] io_rsp_bits_dataResponse
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  wire  sram_clk_i; // @[SRamTop.scala 21:22]
  wire  sram_rst_i; // @[SRamTop.scala 21:22]
  wire  sram_csb_i; // @[SRamTop.scala 21:22]
  wire  sram_we_i; // @[SRamTop.scala 21:22]
  wire [3:0] sram_wmask_i; // @[SRamTop.scala 21:22]
  wire [12:0] sram_addr_i; // @[SRamTop.scala 21:22]
  wire [31:0] sram_wdata_i; // @[SRamTop.scala 21:22]
  wire [31:0] sram_rdata_o; // @[SRamTop.scala 21:22]
  reg  validReg; // @[SRamTop.scala 14:27]
  sram_top #(.IFILE_IN("/home/zain/Desktop/projects/nrv/out/program.hex")) sram ( // @[SRamTop.scala 21:22]
    .clk_i(sram_clk_i),
    .rst_i(sram_rst_i),
    .csb_i(sram_csb_i),
    .we_i(sram_we_i),
    .wmask_i(sram_wmask_i),
    .addr_i(sram_addr_i),
    .wdata_i(sram_wdata_i),
    .rdata_o(sram_rdata_o)
  );
  assign io_rsp_valid = validReg; // @[SRamTop.scala 15:18]
  assign io_rsp_bits_dataResponse = sram_rdata_o; // @[SRamTop.scala 67:30]
  assign sram_clk_i = clock; // @[SRamTop.scala 23:36]
  assign sram_rst_i = reset; // @[SRamTop.scala 25:24]
  assign sram_csb_i = io_req_valid ? 1'h0 : 1'h1; // @[SRamTop.scala 40:52 SRamTop.scala 44:27]
  assign sram_we_i = io_req_valid; // @[SRamTop.scala 40:27]
  assign sram_wmask_i = 4'hf; // @[SRamTop.scala 49:58 SRamTop.scala 56:29]
  assign sram_addr_i = io_req_bits_addrRequest[12:0];
  assign sram_wdata_i = 32'h0; // @[SRamTop.scala 49:58 SRamTop.scala 58:29]
  always @(posedge clock) begin
    if (reset) begin // @[SRamTop.scala 14:27]
      validReg <= 1'h0; // @[SRamTop.scala 14:27]
    end else begin
      validReg <= io_req_valid;
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  validReg = _RAND_0[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Tracer(
  input         clock,
  input         reset,
  input  [31:0] io_rvfiUInt_0,
  input  [31:0] io_rvfiUInt_1,
  input  [31:0] io_rvfiUInt_2,
  input  [31:0] io_rvfiUInt_3,
  input  [31:0] io_rvfiSInt_0,
  input  [31:0] io_rvfiSInt_1,
  input  [31:0] io_rvfiSInt_2,
  input  [31:0] io_rvfiSInt_3,
  input  [31:0] io_rvfiSInt_4,
  input         io_rvfiBool_0,
  input  [4:0]  io_rvfiRegAddr_0,
  input  [4:0]  io_rvfiRegAddr_1,
  input  [4:0]  io_rvfiRegAddr_2
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] clkCycle; // @[Tracer.scala 18:31]
  wire [31:0] _T_1 = clkCycle + 32'h1; // @[Tracer.scala 19:24]
  wire  _T_3 = io_rvfiBool_0 & io_rvfiUInt_2 != 32'h0; // @[Tracer.scala 44:28]
  always @(posedge clock) begin
    if (reset) begin // @[Tracer.scala 18:31]
      clkCycle <= 32'h0; // @[Tracer.scala 18:31]
    end else begin
      clkCycle <= _T_1; // @[Tracer.scala 19:12]
    end
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_T_3 & ~reset) begin
          $fwrite(32'h80000002,
            "ClkCycle: %d, pc_rdata: %x, pc_wdata: %x, insn: %x, mode: %d, rs1_addr: %d, rs1_rdata: %x, rs2_addr: %d, rs2_rdata: %x, rd_addr: %d, rd_wdata: %x, mem_addr: %x, mem_rdata: %x, mem_wdata: %x\n"
            ,clkCycle,io_rvfiUInt_0,io_rvfiUInt_1,io_rvfiUInt_2,2'h3,io_rvfiRegAddr_1,io_rvfiSInt_1,io_rvfiRegAddr_2,
            io_rvfiSInt_2,io_rvfiRegAddr_0,io_rvfiSInt_0,io_rvfiUInt_3,io_rvfiSInt_3,io_rvfiSInt_4); // @[Tracer.scala 45:11]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  clkCycle = _RAND_0[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Top(
  input         clock,
  input         reset,
  output [31:0] io_pin
);
  wire  core_clock; // @[Top.scala 14:26]
  wire  core_reset; // @[Top.scala 14:26]
  wire [31:0] core_io_pin; // @[Top.scala 14:26]
  wire  core_io_dmemReq_valid; // @[Top.scala 14:26]
  wire [31:0] core_io_dmemReq_bits_addrRequest; // @[Top.scala 14:26]
  wire [31:0] core_io_dmemReq_bits_dataRequest; // @[Top.scala 14:26]
  wire [3:0] core_io_dmemReq_bits_activeByteLane; // @[Top.scala 14:26]
  wire  core_io_dmemReq_bits_isWrite; // @[Top.scala 14:26]
  wire  core_io_dmemRsp_valid; // @[Top.scala 14:26]
  wire [31:0] core_io_dmemRsp_bits_dataResponse; // @[Top.scala 14:26]
  wire  core_io_imemReq_valid; // @[Top.scala 14:26]
  wire [31:0] core_io_imemReq_bits_addrRequest; // @[Top.scala 14:26]
  wire  core_io_imemRsp_valid; // @[Top.scala 14:26]
  wire [31:0] core_io_imemRsp_bits_dataResponse; // @[Top.scala 14:26]
  wire [31:0] core_io_rvfiUInt_0; // @[Top.scala 14:26]
  wire [31:0] core_io_rvfiUInt_1; // @[Top.scala 14:26]
  wire [31:0] core_io_rvfiUInt_2; // @[Top.scala 14:26]
  wire [31:0] core_io_rvfiUInt_3; // @[Top.scala 14:26]
  wire [31:0] core_io_rvfiSInt_0; // @[Top.scala 14:26]
  wire [31:0] core_io_rvfiSInt_1; // @[Top.scala 14:26]
  wire [31:0] core_io_rvfiSInt_2; // @[Top.scala 14:26]
  wire [31:0] core_io_rvfiSInt_3; // @[Top.scala 14:26]
  wire [31:0] core_io_rvfiSInt_4; // @[Top.scala 14:26]
  wire  core_io_rvfiBool_0; // @[Top.scala 14:26]
  wire [4:0] core_io_rvfiRegAddr_0; // @[Top.scala 14:26]
  wire [4:0] core_io_rvfiRegAddr_1; // @[Top.scala 14:26]
  wire [4:0] core_io_rvfiRegAddr_2; // @[Top.scala 14:26]
  wire  dmem_clock; // @[Top.scala 17:20]
  wire  dmem_reset; // @[Top.scala 17:20]
  wire  dmem_io_req_valid; // @[Top.scala 17:20]
  wire [31:0] dmem_io_req_bits_addrRequest; // @[Top.scala 17:20]
  wire [31:0] dmem_io_req_bits_dataRequest; // @[Top.scala 17:20]
  wire [3:0] dmem_io_req_bits_activeByteLane; // @[Top.scala 17:20]
  wire  dmem_io_req_bits_isWrite; // @[Top.scala 17:20]
  wire  dmem_io_rsp_valid; // @[Top.scala 17:20]
  wire [31:0] dmem_io_rsp_bits_dataResponse; // @[Top.scala 17:20]
  wire  imem_clock; // @[Top.scala 18:20]
  wire  imem_reset; // @[Top.scala 18:20]
  wire  imem_io_req_valid; // @[Top.scala 18:20]
  wire [31:0] imem_io_req_bits_addrRequest; // @[Top.scala 18:20]
  wire  imem_io_rsp_valid; // @[Top.scala 18:20]
  wire [31:0] imem_io_rsp_bits_dataResponse; // @[Top.scala 18:20]
  wire  Tracer_clock; // @[Top.scala 32:24]
  wire  Tracer_reset; // @[Top.scala 32:24]
  wire [31:0] Tracer_io_rvfiUInt_0; // @[Top.scala 32:24]
  wire [31:0] Tracer_io_rvfiUInt_1; // @[Top.scala 32:24]
  wire [31:0] Tracer_io_rvfiUInt_2; // @[Top.scala 32:24]
  wire [31:0] Tracer_io_rvfiUInt_3; // @[Top.scala 32:24]
  wire [31:0] Tracer_io_rvfiSInt_0; // @[Top.scala 32:24]
  wire [31:0] Tracer_io_rvfiSInt_1; // @[Top.scala 32:24]
  wire [31:0] Tracer_io_rvfiSInt_2; // @[Top.scala 32:24]
  wire [31:0] Tracer_io_rvfiSInt_3; // @[Top.scala 32:24]
  wire [31:0] Tracer_io_rvfiSInt_4; // @[Top.scala 32:24]
  wire  Tracer_io_rvfiBool_0; // @[Top.scala 32:24]
  wire [4:0] Tracer_io_rvfiRegAddr_0; // @[Top.scala 32:24]
  wire [4:0] Tracer_io_rvfiRegAddr_1; // @[Top.scala 32:24]
  wire [4:0] Tracer_io_rvfiRegAddr_2; // @[Top.scala 32:24]
  Core core ( // @[Top.scala 14:26]
    .clock(core_clock),
    .reset(core_reset),
    .io_pin(core_io_pin),
    .io_dmemReq_valid(core_io_dmemReq_valid),
    .io_dmemReq_bits_addrRequest(core_io_dmemReq_bits_addrRequest),
    .io_dmemReq_bits_dataRequest(core_io_dmemReq_bits_dataRequest),
    .io_dmemReq_bits_activeByteLane(core_io_dmemReq_bits_activeByteLane),
    .io_dmemReq_bits_isWrite(core_io_dmemReq_bits_isWrite),
    .io_dmemRsp_valid(core_io_dmemRsp_valid),
    .io_dmemRsp_bits_dataResponse(core_io_dmemRsp_bits_dataResponse),
    .io_imemReq_valid(core_io_imemReq_valid),
    .io_imemReq_bits_addrRequest(core_io_imemReq_bits_addrRequest),
    .io_imemRsp_valid(core_io_imemRsp_valid),
    .io_imemRsp_bits_dataResponse(core_io_imemRsp_bits_dataResponse),
    .io_rvfiUInt_0(core_io_rvfiUInt_0),
    .io_rvfiUInt_1(core_io_rvfiUInt_1),
    .io_rvfiUInt_2(core_io_rvfiUInt_2),
    .io_rvfiUInt_3(core_io_rvfiUInt_3),
    .io_rvfiSInt_0(core_io_rvfiSInt_0),
    .io_rvfiSInt_1(core_io_rvfiSInt_1),
    .io_rvfiSInt_2(core_io_rvfiSInt_2),
    .io_rvfiSInt_3(core_io_rvfiSInt_3),
    .io_rvfiSInt_4(core_io_rvfiSInt_4),
    .io_rvfiBool_0(core_io_rvfiBool_0),
    .io_rvfiRegAddr_0(core_io_rvfiRegAddr_0),
    .io_rvfiRegAddr_1(core_io_rvfiRegAddr_1),
    .io_rvfiRegAddr_2(core_io_rvfiRegAddr_2)
  );
  SRamTop dmem ( // @[Top.scala 17:20]
    .clock(dmem_clock),
    .reset(dmem_reset),
    .io_req_valid(dmem_io_req_valid),
    .io_req_bits_addrRequest(dmem_io_req_bits_addrRequest),
    .io_req_bits_dataRequest(dmem_io_req_bits_dataRequest),
    .io_req_bits_activeByteLane(dmem_io_req_bits_activeByteLane),
    .io_req_bits_isWrite(dmem_io_req_bits_isWrite),
    .io_rsp_valid(dmem_io_rsp_valid),
    .io_rsp_bits_dataResponse(dmem_io_rsp_bits_dataResponse)
  );
  SRamTop_1 imem ( // @[Top.scala 18:20]
    .clock(imem_clock),
    .reset(imem_reset),
    .io_req_valid(imem_io_req_valid),
    .io_req_bits_addrRequest(imem_io_req_bits_addrRequest),
    .io_rsp_valid(imem_io_rsp_valid),
    .io_rsp_bits_dataResponse(imem_io_rsp_bits_dataResponse)
  );
  Tracer Tracer ( // @[Top.scala 32:24]
    .clock(Tracer_clock),
    .reset(Tracer_reset),
    .io_rvfiUInt_0(Tracer_io_rvfiUInt_0),
    .io_rvfiUInt_1(Tracer_io_rvfiUInt_1),
    .io_rvfiUInt_2(Tracer_io_rvfiUInt_2),
    .io_rvfiUInt_3(Tracer_io_rvfiUInt_3),
    .io_rvfiSInt_0(Tracer_io_rvfiSInt_0),
    .io_rvfiSInt_1(Tracer_io_rvfiSInt_1),
    .io_rvfiSInt_2(Tracer_io_rvfiSInt_2),
    .io_rvfiSInt_3(Tracer_io_rvfiSInt_3),
    .io_rvfiSInt_4(Tracer_io_rvfiSInt_4),
    .io_rvfiBool_0(Tracer_io_rvfiBool_0),
    .io_rvfiRegAddr_0(Tracer_io_rvfiRegAddr_0),
    .io_rvfiRegAddr_1(Tracer_io_rvfiRegAddr_1),
    .io_rvfiRegAddr_2(Tracer_io_rvfiRegAddr_2)
  );
  assign io_pin = core_io_pin; // @[Top.scala 29:10]
  assign core_clock = clock;
  assign core_reset = reset;
  assign core_io_dmemRsp_valid = dmem_io_rsp_valid; // @[Top.scala 26:19]
  assign core_io_dmemRsp_bits_dataResponse = dmem_io_rsp_bits_dataResponse; // @[Top.scala 26:19]
  assign core_io_imemRsp_valid = imem_io_rsp_valid; // @[Top.scala 21:19]
  assign core_io_imemRsp_bits_dataResponse = imem_io_rsp_bits_dataResponse; // @[Top.scala 21:19]
  assign dmem_clock = clock;
  assign dmem_reset = reset;
  assign dmem_io_req_valid = core_io_dmemReq_valid; // @[Top.scala 27:15]
  assign dmem_io_req_bits_addrRequest = core_io_dmemReq_bits_addrRequest; // @[Top.scala 27:15]
  assign dmem_io_req_bits_dataRequest = core_io_dmemReq_bits_dataRequest; // @[Top.scala 27:15]
  assign dmem_io_req_bits_activeByteLane = core_io_dmemReq_bits_activeByteLane; // @[Top.scala 27:15]
  assign dmem_io_req_bits_isWrite = core_io_dmemReq_bits_isWrite; // @[Top.scala 27:15]
  assign imem_clock = clock;
  assign imem_reset = reset;
  assign imem_io_req_valid = core_io_imemReq_valid; // @[Top.scala 22:15]
  assign imem_io_req_bits_addrRequest = core_io_imemReq_bits_addrRequest; // @[Top.scala 22:15]
  assign Tracer_clock = clock;
  assign Tracer_reset = reset;
  assign Tracer_io_rvfiUInt_0 = core_io_rvfiUInt_0; // @[Top.scala 40:19]
  assign Tracer_io_rvfiUInt_1 = core_io_rvfiUInt_1; // @[Top.scala 40:19]
  assign Tracer_io_rvfiUInt_2 = core_io_rvfiUInt_2; // @[Top.scala 40:19]
  assign Tracer_io_rvfiUInt_3 = core_io_rvfiUInt_3; // @[Top.scala 40:19]
  assign Tracer_io_rvfiSInt_0 = core_io_rvfiSInt_0; // @[Top.scala 40:19]
  assign Tracer_io_rvfiSInt_1 = core_io_rvfiSInt_1; // @[Top.scala 40:19]
  assign Tracer_io_rvfiSInt_2 = core_io_rvfiSInt_2; // @[Top.scala 40:19]
  assign Tracer_io_rvfiSInt_3 = core_io_rvfiSInt_3; // @[Top.scala 40:19]
  assign Tracer_io_rvfiSInt_4 = core_io_rvfiSInt_4; // @[Top.scala 40:19]
  assign Tracer_io_rvfiBool_0 = core_io_rvfiBool_0; // @[Top.scala 40:19]
  assign Tracer_io_rvfiRegAddr_0 = core_io_rvfiRegAddr_0; // @[Top.scala 40:19]
  assign Tracer_io_rvfiRegAddr_1 = core_io_rvfiRegAddr_1; // @[Top.scala 40:19]
  assign Tracer_io_rvfiRegAddr_2 = core_io_rvfiRegAddr_2; // @[Top.scala 40:19]
endmodule
