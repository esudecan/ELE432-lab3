//module mainfsm(
//    input logic clk,
//    input logic reset,
//    input logic [6:0] op,
//    input logic Zero,
//
//    output logic [1:0] ALUSrcA,
//    output logic [1:0] ALUSrcB,
//    output logic [1:0] ResultSrc,
//    output logic AdrSrc,
//    output logic [1:0] ALUOp,
//    output logic IRWrite,
//    output logic PCWrite,
//    output logic RegWrite,
//    output logic MemWrite,
//    output logic [1:0] ImmSrc
//);
//
//typedef enum logic [3:0] {
//    S0_FETCH     = 4'd0,
//    S1_DECODE    = 4'd1,
//    S2_MEMADR    = 4'd2,
//    S3_MEMREAD   = 4'd3,
//    S4_MEMWB     = 4'd4,
//    S5_MEMWRITE  = 4'd5,
//    S6_EXECUTER  = 4'd6,
//    S7_ALUWB     = 4'd7,
//    S8_EXECUTEI  = 4'd8,
//    S9_JAL       = 4'd9,
//    S10_BRANCH   = 4'd10
//} state_t;
//
//state_t state, nextstate;
//
//always_ff @(posedge clk or posedge reset)
//begin
//    if (reset)
//        state <= S0_FETCH;
//    else
//        state <= nextstate;
//end
//
//always_comb
//begin
//    nextstate = state;
//
//    ALUSrcA = 2'b00;
//    ALUSrcB = 2'b00;
//    ResultSrc = 2'b00;
//    AdrSrc = 1'b0;
//    ALUOp = 2'b00;
//    IRWrite = 1'b0;
//    PCWrite = 1'b0;
//    RegWrite = 1'b0;
//    MemWrite = 1'b0;
//    ImmSrc = 2'b00;
//
//    case(state)
//
//        S0_FETCH:
//        begin
//            ALUSrcA = 2'b00;
//            ALUSrcB = 2'b10;
//            ResultSrc = 2'b10;
//            IRWrite = 1'b1;
//            PCWrite = 1'b1;
//            nextstate = S1_DECODE;
//        end
//
////        S1_DECODE:
////        begin
////            ALUSrcA = 2'b01;
////            ALUSrcB = 2'b01;
////
////            case(op)
////                7'b0000011: nextstate = S2_MEMADR;
////                7'b0100011: nextstate = S2_MEMADR;
////                7'b0110011: nextstate = S6_EXECUTER;
////                7'b0010011: nextstate = S8_EXECUTEI;
////                7'b1101111: nextstate = S9_JAL;
////                7'b1100011: nextstate = S10_BRANCH;
////                default:    nextstate = S0_FETCH;
////            endcase
////        end
//				S1_DECODE:
//				begin
//					 ALUSrcA = 2'b01;
//					 ALUSrcB = 2'b01;
//					 ALUOp = 2'b00;
//
//					 case(op)
//
//						  7'b0000011:
//						  begin
//								ImmSrc = 2'b00;
//								nextstate = S2_MEMADR;
//						  end
//
//						  7'b0100011:
//						  begin
//								ImmSrc = 2'b01;
//								nextstate = S2_MEMADR;
//						  end
//
//						  7'b0110011:
//						  begin
//								nextstate = S6_EXECUTER;
//						  end
//
//						  7'b0010011:
//						  begin
//								ImmSrc = 2'b00;
//								nextstate = S8_EXECUTEI;
//						  end
//
//						  7'b1101111:
//						  begin
//								ImmSrc = 2'b11;
//								nextstate = S9_JAL;
//						  end
//
//						  7'b1100011:
//						  begin
//								ImmSrc = 2'b10;
//								nextstate = S10_BRANCH;
//						  end
//
//						  default:
//								nextstate = S0_FETCH;
//					 endcase
//				end
//		  
//		  S2_MEMADR:
//		  begin
//				 ALUSrcA = 2'b10;
//				 ALUSrcB = 2'b01;
//				 ALUOp = 2'b00;
//
//				if (op == 7'b0000011)
//					 ImmSrc = 2'b00;
//				else
//					 ImmSrc = 2'b01;
//					 
//				if (op == 7'b0000011)
//					  nextstate = S3_MEMREAD;
//				else
//					  nextstate = S5_MEMWRITE;
//			end
//		  
//		  S3_MEMREAD:
//			begin
//				 AdrSrc = 1'b1;
//				 ResultSrc = 2'b00;
//				 nextstate = S4_MEMWB;
//			end
//		  
//		  S4_MEMWB:
//			begin
//				 ResultSrc = 2'b01;
//				 RegWrite = 1'b1;
//				 nextstate = S0_FETCH;
//			end
//					  
//			S5_MEMWRITE:
//			begin
//				 AdrSrc = 1'b1;
//				 MemWrite = 1'b1;
//				 nextstate = S0_FETCH;
//			end			
//						
//			S6_EXECUTER:
//			begin
//				 ALUSrcA = 2'b10;
//				 ALUSrcB = 2'b00;
//				 ALUOp = 2'b10;
//				 nextstate = S7_ALUWB;
//			end			
//			
//			S9_JAL:
//			begin
//				 ALUSrcA = 2'b01;
//				 ALUSrcB = 2'b10;
//				 ResultSrc = 2'b10;
//				 PCWrite = 1'b1;
//				 RegWrite = 1'b1;
//				 ImmSrc = 2'b11;
//				 nextstate = S0_FETCH;
//			end
//							
//			S10_BRANCH:
//			begin
//				 ALUSrcA = 2'b10;
//				 ALUSrcB = 2'b00;
//				 ALUOp = 2'b01;
//				 if (Zero)
//					  PCWrite = 1'b1;
//				 ImmSrc = 2'b10;
//				 ResultSrc = 2'b00;
//				 nextstate = S0_FETCH;
//			end		
//			
//		  S8_EXECUTEI:
//			begin
//				 ALUSrcA = 2'b10;
//				 ALUSrcB = 2'b01;
//				 ALUOp = 2'b10;
//				 nextstate = S7_ALUWB;
//			end
//
//			S7_ALUWB:
//			begin
//				 ResultSrc = 2'b00;
//				 RegWrite = 1'b1;
//				 nextstate = S0_FETCH;
//			end
//
//        default:
//            nextstate = S0_FETCH;
//
//    endcase
//end
//
//endmodule

module mainfsm(
    input logic clk,
    input logic reset,
    input logic [6:0] op,
    input logic Zero,

    output logic [1:0] ALUSrcA,
    output logic [1:0] ALUSrcB,
    output logic [1:0] ResultSrc,
    output logic AdrSrc,
    output logic [1:0] ALUOp,
    output logic IRWrite,
    output logic PCWrite,
    output logic RegWrite,
    output logic MemWrite,
    output logic [1:0] ImmSrc
);

typedef enum logic [3:0] {
    S0_FETCH     = 4'd0,
    S1_DECODE    = 4'd1,
    S2_MEMADR    = 4'd2,
    S3_MEMREAD   = 4'd3,
    S4_MEMWB     = 4'd4,
    S5_MEMWRITE  = 4'd5,
    S6_EXECUTER  = 4'd6,
    S7_ALUWB     = 4'd7,
    S8_EXECUTEI  = 4'd8,
    S9_JAL       = 4'd9,
    S10_BRANCH   = 4'd10,
	 S11_JALWB   = 4'd11 
} state_t;

state_t state, nextstate;

always_ff @(posedge clk or posedge reset)
begin
    if (reset)
        state <= S0_FETCH;
    else
        state <= nextstate;
end

always_comb
begin
    nextstate = state;

    ALUSrcA = 2'b00;
    ALUSrcB = 2'b00;
    ResultSrc = 2'b00;
    AdrSrc = 1'b0;
    ALUOp = 2'b00;
    IRWrite = 1'b0;
    PCWrite = 1'b0;
    RegWrite = 1'b0;
    MemWrite = 1'b0;
    ImmSrc = 2'b00;

    case(state)

        S0_FETCH:
        begin
            ALUSrcA = 2'b00;
            ALUSrcB = 2'b10;
            ResultSrc = 2'b10;
            IRWrite = 1'b1;
            PCWrite = 1'b1;
            nextstate = S1_DECODE;
        end

        S1_DECODE:
        begin
            ALUSrcA = 2'b01;
            ALUSrcB = 2'b01;
            ALUOp = 2'b00;

            case(op)
                7'b0000011:
                begin
                    ImmSrc = 2'b00;
                    nextstate = S2_MEMADR;
                end

                7'b0100011:
                begin
                    ImmSrc = 2'b01;
                    nextstate = S2_MEMADR;
                end

                7'b0110011:
                begin
                    ImmSrc = 2'b00;
                    nextstate = S6_EXECUTER;
                end

                7'b0010011:
                begin
                    ImmSrc = 2'b00;
                    nextstate = S8_EXECUTEI;
                end

                7'b1101111:
                begin
                    ImmSrc = 2'b11;
                    nextstate = S9_JAL;
                end

                7'b1100011:
                begin
                    ImmSrc = 2'b10;
                    nextstate = S10_BRANCH;
                end

                default:
                begin
                    ImmSrc = 2'b00;
                    nextstate = S0_FETCH;
                end
            endcase
        end

        S2_MEMADR:
        begin
            ALUSrcA = 2'b10;
            ALUSrcB = 2'b01;
            ALUOp = 2'b00;

            if (op == 7'b0000011)
            begin
                ImmSrc = 2'b00;
                nextstate = S3_MEMREAD;
            end
            else
            begin
                ImmSrc = 2'b01;
                nextstate = S5_MEMWRITE;
            end
        end

        S3_MEMREAD:
        begin
            AdrSrc = 1'b1;
            ResultSrc = 2'b00;
            nextstate = S4_MEMWB;
        end

        S4_MEMWB:
        begin
            ResultSrc = 2'b01;
            RegWrite = 1'b1;
            nextstate = S0_FETCH;
        end

        S5_MEMWRITE:
        begin
            AdrSrc = 1'b1;
            ResultSrc = 2'b00;
            MemWrite = 1'b1;
            nextstate = S0_FETCH;
        end

        S6_EXECUTER:
        begin
            ALUSrcA = 2'b10;
            ALUSrcB = 2'b00;
            ALUOp = 2'b10;
            nextstate = S7_ALUWB;
        end

        S7_ALUWB:
        begin
            ResultSrc = 2'b00;
            RegWrite = 1'b1;
            nextstate = S0_FETCH;
        end

        S8_EXECUTEI:
        begin
            ALUSrcA = 2'b10;
            ALUSrcB = 2'b01;
            ALUOp = 2'b10;
            ImmSrc = 2'b00;
            nextstate = S7_ALUWB;
        end

//        S9_JAL:
//        begin
//            ALUSrcA = 2'b01;
//				ALUSrcB = 2'b10;
//				ResultSrc = 2'b10;
//            PCWrite = 1'b1;
//            RegWrite = 1'b1;
//            ImmSrc = 2'b11;
//            nextstate = S0_FETCH;
//        end

			S9_JAL: begin
				 ALUSrcA   = 2'b01;    // OldPC
				 ALUSrcB   = 2'b01;    // ImmExt (J-type)
				 ResultSrc = 2'b10;    // ALUResult → PC
				 PCWrite   = 1'b1;
				 ImmSrc    = 2'b11;
				 nextstate = S11_JALWB;
			end

			// S11_JALWB: rd ← OldPC + 4
			S11_JALWB: begin
				 ALUSrcA   = 2'b01;    // OldPC
				 ALUSrcB   = 2'b10;    // 4
				 ResultSrc = 2'b10;    // ALUResult = OldPC+4 → rd
				 RegWrite  = 1'b1;
				 nextstate = S0_FETCH;
			end
        S10_BRANCH:
        begin
            ALUSrcA = 2'b10;
            ALUSrcB = 2'b00;
            ALUOp = 2'b01;
            ResultSrc = 2'b00;
            ImmSrc = 2'b10;

            if (Zero)
                PCWrite = 1'b1;

            nextstate = S0_FETCH;
        end

        default:
        begin
            nextstate = S0_FETCH;
        end

    endcase
end

endmodule