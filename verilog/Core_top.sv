module Core_top (
    input               clock,
    input               reset,
    output logic [31:0] io_pin
);

    logic        data_req;
    logic [31:0] data_addr;
    logic [31:0] data_wdata;
    logic [ 3:0] data_be;
    logic        data_we;
    logic        data_valid;
    logic [31:0] data_rdata;

    logic        instr_req;
    logic [31:0] instr_addr;
    logic        instr_valid;
    logic [31:0] instr_rdata; 

    Core u_nucleusrv_core (
        // Clock and reset
        .clock  ( clock  ),
        .reset  ( reset  ),
        .io_pin ( io_pin ),
        // Data memory interface
        .io_dmemReq_valid               ( data_req   ),
        .io_dmemReq_bits_addrRequest    ( data_addr  ),
        .io_dmemReq_bits_dataRequest    ( data_wdata ),
        .io_dmemReq_bits_activeByteLane ( data_be    ),
        .io_dmemReq_bits_isWrite        ( data_we    ),
        .io_dmemRsp_valid               ( data_valid ),
        .io_dmemRsp_bits_dataResponse   ( data_rdata ),
        // Instruction memory interface
        .io_imemReq_valid             ( instr_req   ),        
        .io_imemReq_bits_addrRequest  ( instr_addr  ),
        .io_imemRsp_valid             ( instr_valid ),
        .io_imemRsp_bits_dataResponse ( instr_rdata ),
        // RVFI
        .io_rvfiUInt_0    (  ),
        .io_rvfiUInt_1    (  ),
        .io_rvfiUInt_2    (  ),
        .io_rvfiUInt_3    (  ),
        .io_rvfiSInt_0    (  ),
        .io_rvfiSInt_1    (  ),
        .io_rvfiSInt_2    (  ),
        .io_rvfiSInt_3    (  ),
        .io_rvfiSInt_4    (  ),
        .io_rvfiBool_0    (  ),
        .io_rvfiRegAddr_0 (  ),
        .io_rvfiRegAddr_1 (  ),
        .io_rvfiRegAddr_2 (  )
    );

    SRamTop dmem (
        // Clock and reset
        .clock ( clock ),
        .reset ( reset ),
        // Memory interface
        .io_req_valid               ( data_req   ),
        .io_req_bits_addrRequest    ( data_addr  ),
        .io_req_bits_dataRequest    ( data_wdata ),
        .io_req_bits_activeByteLane ( data_be    ),
        .io_req_bits_isWrite        ( data_we    ).
        .io_rsp_valid               ( data_valid ),
        .io_rsp_bits_dataResponse   ( data_rdata )
    );

    SRamTop_1 imem (
        // Clock and reset
        .clock ( clock ),
        .reset ( reset ),
        // Memory interface
        .io_req_valid             ( instr_req   ),
        .io_req_bits_addrRequest  ( instr_addr  ),
        .io_rsp_valid             ( instr_valid ),
        .io_rsp_bits_dataResponse ( instr_rdata )
    );
endmodule