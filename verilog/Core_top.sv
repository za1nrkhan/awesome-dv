module Core_top (
    input               clock,
    input               reset,
    output logic [31:0] io_pin
);

    Core u_nucleusrv_core (
        // Clock and reset
        .clock  ( clock  ),
        .reset  ( reset  ),
        .io_pin ( io_pin ),
        // Data memory interface
        .io_dmemReq_valid               (  ),
        .io_dmemReq_bits_addrRequest    (  ),
        .io_dmemReq_bits_dataRequest    (  ),
        .io_dmemReq_bits_activeByteLane (  ),
        .io_dmemReq_bits_isWrite        (  ),
        .io_dmemRsp_valid               (  ),
        .io_dmemRsp_bits_dataResponse   (  ),
        // Instruction memory interface
        .io_imemReq_valid             (  ),        
        .io_imemReq_bits_addrRequest  (  ),
        .io_imemRsp_valid             (  ),
        .io_imemRsp_bits_dataResponse (  ),
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

endmodule