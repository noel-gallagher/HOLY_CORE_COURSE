`timescale 1ns/1ps

module control (
    // IN
    input logic [6:0] op,
    input logic [2:0] func3,
    input logic [6:0] func7,
    input logic alu_zero,

    // OUT
    output logic [2:0] alu_control,
    output logic [1:0] imm_source,
    output logic mem_write,
    output logic reg_write,
    output logic alu_source,
    output logic write_back_source
);

/**
* MAIN DECODER
*/

logic [1:0] alu_op;
always_comb begin
    case (op)
        // I-type
        7'b0000011 : begin
            reg_write = 1'b1;
            imm_source = 2'b00;
            mem_write = 1'b0;
            alu_op = 2'b00;
            alu_source = 1'b1; //imm
            write_back_source = 1'b1; //memory_read
        end
        // S-Type
        7'b0100011 : begin
            reg_write = 1'b0;
            imm_source = 2'b01;
            mem_write = 1'b1;
            alu_op = 2'b00;
            alu_source = 1'b1; //imm
        end
        // R-Type
        7'b0110011 : begin
            reg_write = 1'b1;
            mem_write = 1'b0;
            alu_op = 2'b10;
            alu_source = 1'b0; //reg2
            write_back_source = 1'b0; //alu_result
        end
        // EVERYTHING ELSE
        default: begin
            reg_write = 1'b0;
            imm_source = 2'b00;
            mem_write = 1'b0;
            alu_op = 2'b00;
        end
    endcase
end

/**
* ALU DECODER
*/

always_comb begin
    case (alu_op)
        // LW, SW
        2'b00 : alu_control = 3'b000;
        // R-Types
        2'b10 : begin
            case (func3)
                // ADD (and later SUB with a different F7)
                3'b000 : alu_control = 3'b000;
                // AND
                3'b111 : alu_control = 3'b010;
                // OR
                3'b110 : alu_control = 3'b011;
                // ALL THE OTHERS
                default: alu_control = 3'b111;
            endcase
        end
        // EVERYTHING ELSE
        default: alu_control = 3'b111;
    endcase
end
    
endmodule