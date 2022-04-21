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
localparam integer LP_DW_BYTES             = C_M_AXI_DATA_WIDTH/8;
localparam integer LP_AXI_BURST_LEN        = 4096/LP_DW_BYTES < 256 ? 4096/LP_DW_BYTES : 256;
localparam integer LP_LOG_BURST_LEN        = $clog2(LP_AXI_BURST_LEN);
localparam integer LP_BRAM_DEPTH           = 512;
localparam integer LP_RD_MAX_OUTSTANDING   = LP_BRAM_DEPTH / LP_AXI_BURST_LEN;
localparam integer LP_WR_MAX_OUTSTANDING   = 32;

///////////////////////////////////////////////////////////////////////////////
// Wires and Variables
///////////////////////////////////////////////////////////////////////////////

// Control logic
logic                          done = 1'b0;


logic                          output_tvalid;
// logic                          output_tready;
logic [31:0]                   trig_i;
// AXI write master stage
logic                          write_done;
logic [1:0]                    puf_state;
logic [C_M_AXI_DATA_WIDTH-1:0] puf_output_id;

///////////////////////////////////////////////////////////////////////////////
// Begin RTL
///////////////////////////////////////////////////////////////////////////////

fpga_puf_module fpga_osci_puf ( 
    .clk_i               ( aclk          ),
    .rstn_i              ( areset        ),
    .trig_i              ( trig          ),
    .busy_o              ( puf_state     ),
    .id_o                ( puf_output_id )
);

always @(posedge aclk) begin 
    trig_i <= trig;
end 

always @(negedge puf_state ) begin
  //data[63-1:0] <= 64'd886;
  //puf_state  <= 2'b01;
  output_tvalid <= 1'b1;
end 

//always @(posedge aclk) begin 
//  if (puf_state == 2'b01) begin 
//    // Set valid & Reset trig_i
//    output_tvalid <= 1'b1;
//    //trig_i <= 0;
//  end else if(puf_state == 2'b11)  begin 
//    // Just for debug
//    output_tvalid <= 1'b1;
//    //trig_i <= 0;
//  end
//end

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
  // 管理这3个接口和信号即可
  // 其中 ready没人用，不用管
  .s_axis_tvalid           ( output_tvalid           ) ,
  .s_axis_tready           ( /*output_tready*/       ) ,
  .s_axis_tdata            ( puf_output_id           )
);

assign ap_done = write_done;

endmodule : FPGA_PUF
`default_nettype wire

