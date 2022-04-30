// This is a generated file. Use and modify at your own risk.
////////////////////////////////////////////////////////////////////////////////
// default_nettype of none prevents implicit wire declaration.
`default_nettype none

module FPGA_PUF #(
  parameter integer C_M_AXI_ADDR_WIDTH       = 64 ,
  parameter integer C_M_AXI_DATA_WIDTH       = 512,
  parameter integer C_XFER_SIZE_WIDTH        = 32,
  parameter integer C_ADDER_BIT_WIDTH        = 32
)
(
  // System Signals
  input  wire                                    aclk               ,
  input  wire                                    areset             ,
  // Extra clocks
  input  wire                                    kernel_clk         ,
  input  wire                                    kernel_rst         ,
  
  input  wire [C_M_AXI_ADDR_WIDTH-1:0]           ctrl_addr_offset   ,
  input  wire [C_XFER_SIZE_WIDTH-1:0]            ctrl_xfer_size_in_bytes,
  input  wire [C_ADDER_BIT_WIDTH-1:0]            ctrl_constant      ,
  
  input  wire                                    ap_start           ,
  output wire                                    ap_done            ,
  // AXI4 master interface
  output wire                                    m_axi_awvalid      ,
  input  wire                                    m_axi_awready      ,
  output wire [C_M_AXI_ADDR_WIDTH-1:0]           m_axi_awaddr       ,
  output wire [8-1:0]                            m_axi_awlen        ,
  output wire                                    m_axi_wvalid       ,
  input  wire                                    m_axi_wready       ,
  output wire [C_M_AXI_DATA_WIDTH-1:0]           m_axi_wdata        ,
  output wire [C_M_AXI_DATA_WIDTH/8-1:0]         m_axi_wstrb        ,
  output wire                                    m_axi_wlast        ,
  output wire                                    m_axi_arvalid      ,
  input  wire                                    m_axi_arready      ,
  output wire [C_M_AXI_ADDR_WIDTH-1:0]           m_axi_araddr       ,
  output wire [8-1:0]                            m_axi_arlen        ,
  input  wire                                    m_axi_rvalid       ,
  output wire                                    m_axi_rready       ,
  input  wire [C_M_AXI_DATA_WIDTH-1:0]           m_axi_rdata        ,
  input  wire                                    m_axi_rlast        ,
  input  wire                                    m_axi_bvalid       ,
  output wire                                    m_axi_bready       ,
  input  wire [32-1:0]                           trig 
);

timeunit 1ps;
timeprecision 1ps;


///////////////////////////////////////////////////////////////////////////////
// Local Parameters
///////////////////////////////////////////////////////////////////////////////
localparam integer LP_WR_MAX_OUTSTANDING   = 32;

///////////////////////////////////////////////////////////////////////////////
// Wires and Variables
///////////////////////////////////////////////////////////////////////////////

// Control logic
logic                          write_done                  ;
logic                          output_tvalid               ;
logic [96-1:0]                 data                        ;
logic                          trig_i = 1'b1               ;
// Output
logic [2:0]                    state                       ;
logic [C_M_AXI_DATA_WIDTH-1:0] puf_output_id               ;

///////////////////////////////////////////////////////////////////////////////
// Begin RTL
///////////////////////////////////////////////////////////////////////////////

always @(posedge aclk ) begin 
    
    if(state == 3'b100)  begin
        trig_i <= 1'b0;
        output_tvalid <= 1'b1;
    end 
end 

assign puf_output_id[96-1:0] = data[96-1:0];

fpga_puf_impl fpga_osci_puf ( 
    .clk               ( aclk          ),
    .reset             ( 1'b1          ),
    .puf_trig          ( trig_i        ),
    .puf_state         ( state         ),
    .puf_out           ( data          )
);

// -- AXI4 Write Master ----------------------------------------------------------------------
// -- ----------------- ----------------------------------------------------------------------
fpga_puf_axi_write_master #(
  .C_M_AXI_ADDR_WIDTH  ( C_M_AXI_ADDR_WIDTH    ) ,
  .C_M_AXI_DATA_WIDTH  ( C_M_AXI_DATA_WIDTH    ) ,
  .C_XFER_SIZE_WIDTH   ( C_XFER_SIZE_WIDTH     ) ,
  .C_MAX_OUTSTANDING   ( LP_WR_MAX_OUTSTANDING ) ,
  .C_INCLUDE_DATA_FIFO ( 1                     )
)
inst_axi_write_master (
  .aclk                    ( aclk                    ) ,
  .areset                  ( areset                  ) ,
  .ctrl_start              ( ap_start                ) ,
  .ctrl_done               ( write_done              ) ,
  .ctrl_addr_offset        ( ctrl_addr_offset        ) ,
  .ctrl_xfer_size_in_bytes ( ctrl_xfer_size_in_bytes ) ,
  .m_axi_awvalid           ( m_axi_awvalid           ) ,
  .m_axi_awready           ( m_axi_awready           ) ,
  .m_axi_awaddr            ( m_axi_awaddr            ) ,
  .m_axi_awlen             ( m_axi_awlen             ) ,
  .m_axi_wvalid            ( m_axi_wvalid            ) ,
  .m_axi_wready            ( m_axi_wready            ) ,
  .m_axi_wdata             ( m_axi_wdata             ) ,
  .m_axi_wstrb             ( m_axi_wstrb             ) ,
  .m_axi_wlast             ( m_axi_wlast             ) ,
  .m_axi_bvalid            ( m_axi_bvalid            ) ,
  .m_axi_bready            ( m_axi_bready            ) , 
  .s_axis_aclk             ( kernel_clk              ) ,
  .s_axis_areset           ( kernel_rst              ) ,
  .s_axis_tvalid           ( output_tvalid           ) ,
  .s_axis_tready           ( /*output_tready*/       ) ,
  .s_axis_tdata            ( puf_output_id           )
);

assign ap_done = write_done;

endmodule : FPGA_PUF
`default_nettype wire