// This is a generated file. Use and modify at your own risk.
////////////////////////////////////////////////////////////////////////////////
// default_nettype of none prevents implicit wire declaration.
`default_nettype none
module fpga_puf_impl
(
  input wire                                    clk                   ,
  input wire                                    reset                 ,
  input wire                                    puf_trig              ,
  output reg [2:0]                              puf_state             ,
  output wire [96-1:0]                          puf_out              
);
    
    typedef enum logic[1:0] { S_IDLE, S_START, S_RUN, S_SAMPLE } puf_state_t;
    typedef struct {
        puf_state_t            state;
        logic	[95+1:0]		     sreg;
        logic 				         sample;
    } arbiter_t;
    arbiter_t arbiter ='{S_IDLE, 96'b0, 1'b0};

    always @(posedge clk) begin
    
        arbiter.sreg[1+:96] <= arbiter.sreg[0+:96];

        if (arbiter.state == S_START) begin
            arbiter.sreg[0] <= 1'b1;
        end else begin 
            arbiter.sreg[0] <= 1'b0;
        end 
            
        if (reset == 1'b0) begin 
            arbiter.state <= S_IDLE;
        end else begin
            case( arbiter.state )
            S_IDLE: 
                begin
                    arbiter.sample <= 1'b0;
                    puf_state <= 3'b001;       
                    if (puf_trig  == 1'b1) begin 
                        arbiter.state <= S_START;
                    end 
                 end
            S_START: 
                begin
                    arbiter.sample <= 1'b0;
                    puf_state <= 3'b010;                
                    arbiter.state <= S_RUN;
                end
            S_RUN:
               begin
                    arbiter.sample <= 1'b0;
                    puf_state <= 3'b011; 
                    if (arbiter.sreg[96] == 1'b1) begin
                        arbiter.state <= S_SAMPLE;
                    end
               end
            S_SAMPLE:
                begin 
                    arbiter.state <= S_IDLE;
                    arbiter.sample <= 1'b1;
                    puf_state <= 3'b100; 
                end
            default:
                begin
                    arbiter.state <= S_IDLE;
                    arbiter.sample <= 1'b0;
                    puf_state <= 3'b111; 
                end
            endcase
        end 
    end 

    genvar i;
    generate
    for(i = 0; i < 96; i++ ) begin 
        fpga_puf_cell FPGA_puf_cell_n (
            .clk_i                         ( clk                  ),
            .reset_i                       ( arbiter.sreg[i]      ),
            .latch_i                       ( arbiter.sreg[i+1]    ),
            .sample_i                      ( arbiter.sample       ),
            .data_o                        ( puf_out[i]           )
        );
    end
    endgenerate

endmodule
`default_nettype wire


