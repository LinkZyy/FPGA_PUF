`default_nettype none
`timescale 1 ns / 1 ps
// Top level of the kernel. Do not modify module name, parameters or ports.
module fpga_kernel_rtl_kernel #(
  parameter integer C_S_AXI_CONTROL_ADDR_WIDTH = 12 ,
  parameter integer C_S_AXI_CONTROL_DATA_WIDTH = 32 ,
  parameter integer C_M00_AXI_ADDR_WIDTH       = 64 ,
  parameter integer C_M00_AXI_DATA_WIDTH       = 512
)

(
  // System Signals
  input  wire                                    ap_clk               ,
 
  // AXI4 master interface m00_axi
  // 由于只用到了写，故有些端口可以tie up
  output wire                                    m00_axi_awvalid      ,
  input  wire                                    m00_axi_awready      ,
  output wire [C_M00_AXI_ADDR_WIDTH-1:0]         m00_axi_awaddr       ,
  output wire [8-1:0]                            m00_axi_awlen        ,
  output wire                                    m00_axi_wvalid       ,
  input  wire                                    m00_axi_wready       ,
  output wire [C_M00_AXI_DATA_WIDTH-1:0]         m00_axi_wdata        ,
  output wire [C_M00_AXI_DATA_WIDTH/8-1:0]       m00_axi_wstrb        ,
  output wire                                    m00_axi_wlast        ,
  input  wire                                    m00_axi_bvalid       ,
  output wire                                    m00_axi_bready       ,
  output wire                                    m00_axi_arvalid      ,
  input  wire                                    m00_axi_arready      ,
  output wire [C_M00_AXI_ADDR_WIDTH-1:0]         m00_axi_araddr       ,
  output wire [8-1:0]                            m00_axi_arlen        ,
  input  wire                                    m00_axi_rvalid       ,
  output wire                                    m00_axi_rready       ,
  input  wire [C_M00_AXI_DATA_WIDTH-1:0]         m00_axi_rdata        ,
  input  wire                                    m00_axi_rlast        ,
  
  // AXI4-Lite slave interface
  // 都是控制信号，基本不用修改
  input  wire                                    s_axi_control_awvalid,
  output wire                                    s_axi_control_awready,
  input  wire [C_S_AXI_CONTROL_ADDR_WIDTH-1:0]   s_axi_control_awaddr ,
  input  wire                                    s_axi_control_wvalid ,
  output wire                                    s_axi_control_wready ,
  input  wire [C_S_AXI_CONTROL_DATA_WIDTH-1:0]   s_axi_control_wdata  ,
  input  wire [C_S_AXI_CONTROL_DATA_WIDTH/8-1:0] s_axi_control_wstrb  ,
  input  wire                                    s_axi_control_arvalid,
  output wire                                    s_axi_control_arready,
  input  wire [C_S_AXI_CONTROL_ADDR_WIDTH-1:0]   s_axi_control_araddr ,
  output wire                                    s_axi_control_rvalid ,
  input  wire                                    s_axi_control_rready ,
  output wire [C_S_AXI_CONTROL_DATA_WIDTH-1:0]   s_axi_control_rdata  ,
  output wire [2-1:0]                            s_axi_control_rresp  ,
  output wire                                    s_axi_control_bvalid ,
  input  wire                                    s_axi_control_bready ,
  output wire [2-1:0]                            s_axi_control_bresp  ,
  output wire                                    interrupt            
);

///////////////////////////////////////////////////////////////////////////////
// Wires and Variables
///////////////////////////////////////////////////////////////////////////////\

wire                                ap_start                      ;
wire                                ap_idle                       ;
wire                                ap_done                       ;
wire                                ap_ready                      ;
wire [32-1:0]                       trig_i                        ;
wire [64-1:0]                       id_o                          ;
    
///////////////////////////////////////////////////////////////////////////////
// Begin control interface RTL.  Modifying not recommended.
///////////////////////////////////////////////////////////////////////////////


// AXI4-Lite slave interface
// In fpga_puf_control_s_axi.v
fpga_puf_kernel_0_control_s_axi #(
  .C_S_AXI_ADDR_WIDTH ( C_S_AXI_CONTROL_ADDR_WIDTH ),
  .C_S_AXI_DATA_WIDTH ( C_S_AXI_CONTROL_DATA_WIDTH )
)
inst_control_s_axi (
  .ACLK      ( ap_clk                ),
  .ARESET    ( 1'b0                  ),
  .ACLK_EN   ( 1'b1                  ),
  .AWVALID   ( s_axi_control_awvalid ),
  .AWREADY   ( s_axi_control_awready ),
  .AWADDR    ( s_axi_control_awaddr  ),
  .WVALID    ( s_axi_control_wvalid  ),
  .WREADY    ( s_axi_control_wready  ),
  .WDATA     ( s_axi_control_wdata   ),
  .WSTRB     ( s_axi_control_wstrb   ),
  .ARVALID   ( s_axi_control_arvalid ),
  .ARREADY   ( s_axi_control_arready ),
  .ARADDR    ( s_axi_control_araddr  ),
  .RVALID    ( s_axi_control_rvalid  ),
  .RREADY    ( s_axi_control_rready  ),
  .RDATA     ( s_axi_control_rdata   ),
  .RRESP     ( s_axi_control_rresp   ),
  .BVALID    ( s_axi_control_bvalid  ),
  .BREADY    ( s_axi_control_bready  ),
  .BRESP     ( s_axi_control_bresp   ),
  .interrupt ( interrupt             ),
  .ap_start  ( ap_start              ),
  .ap_done   ( ap_done               ),
  .ap_idle   ( ap_idle               ),
  .ap_ready  ( ap_ready               ),
  .trig_i    ( trig_i                ),
  .id_o      ( id_o                  )
);

// In fpga_puf_example.sv
// 直接修改
Top_wrapper #(
  .C_M00_AXI_ADDR_WIDTH ( C_M00_AXI_ADDR_WIDTH ),
  .C_M00_AXI_DATA_WIDTH ( C_M00_AXI_DATA_WIDTH )
)
inst_example (
  .ap_clk          ( ap_clk          ),
  .ap_rst_n        ( 1'b1            ),
  .m00_axi_awvalid ( m00_axi_awvalid ),
  .m00_axi_awready ( m00_axi_awready ),
  .m00_axi_awaddr  ( m00_axi_awaddr  ),
  .m00_axi_awlen   ( m00_axi_awlen   ),
  .m00_axi_wvalid  ( m00_axi_wvalid  ),
  .m00_axi_wready  ( m00_axi_wready  ),
  .m00_axi_wdata   ( m00_axi_wdata   ),
  .m00_axi_wstrb   ( m00_axi_wstrb   ),
  .m00_axi_wlast   ( m00_axi_wlast   ),
  .m00_axi_bvalid  ( m00_axi_bvalid  ),
  .m00_axi_bready  ( m00_axi_bready  ),
  .m00_axi_arvalid ( m00_axi_arvalid ),
  .m00_axi_arready ( m00_axi_arready ),
  .m00_axi_araddr  ( m00_axi_araddr  ),
  .m00_axi_arlen   ( m00_axi_arlen   ),
  .m00_axi_rvalid  ( m00_axi_rvalid  ),
  .m00_axi_rready  ( m00_axi_rready  ),
  .m00_axi_rdata   ( m00_axi_rdata   ),
  .m00_axi_rlast   ( m00_axi_rlast   ),
  .ap_start        ( ap_start        ),
  .ap_done         ( ap_done         ),
  .ap_idle         ( ap_idle         ),
  .ap_ready        ( ap_ready        ),
  .trig_i          ( trig_i          ),
  .id_o            ( id_o            )
);

endmodule
`default_nettype wire
