// ============================================================================
// Project : 4-Way Traffic Light Controller using FSM (Verilog HDL)
// Author  : Yuvesh R Menghare
//
// Description:
// This design implements a synchronous Moore Finite State Machine (FSM)
// for a 4-direction traffic junction (North, West, South, East).
//
// Key Features:
// - Only one direction can be GREEN/YELLOW at a time.
// - Remaining directions remain RED for safety.
// - State transitions are controlled using a counter-based timing mechanism.
// - GREEN duration  = 16 clock cycles
// - YELLOW duration = 4 clock cycles
// - Asynchronous RESET forces system back to NorthGreen state.
// ============================================================================


// ---------------------------------------------------------------------------
// Module Declaration
// Inputs  : clk  -> System clock
//           rst  -> Asynchronous reset
// Outputs : Encoded 3-bit traffic light signals for each direction
// ---------------------------------------------------------------------------
module traffic_light_controller(
    input clk,          // Clock signal driving FSM transitions
    input rst,          // Reset signal (active high)
    output reg [2:0] north_light, west_light, south_light, east_light
);


// ---------------------------------------------------------------------------
// STATE ENCODING (Moore FSM)
// Each direction has GREEN and YELLOW state.
// Total states = 8
// ---------------------------------------------------------------------------
parameter NorthGreen  = 3'b000, NorthYellow = 3'b001,
          WestGreen   = 3'b010, WestYellow  = 3'b011,
          SouthGreen  = 3'b100, SouthYellow = 3'b101,
          EastGreen   = 3'b110, EastYellow  = 3'b111;


// FSM state register (implemented using flip-flops after synthesis)
reg [2:0] state;

// Counter register used to generate timing delays between state transitions
// 4-bit width allows counting up to 16 cycles (0 to 15)
reg [3:0] count;


// ---------------------------------------------------------------------------
// LIGHT ENCODING
// Using 3-bit encoding for readability and waveform clarity
// GREEN  = 001
// YELLOW = 010
// RED    = 100
// ---------------------------------------------------------------------------
localparam GREEN = 3'b001,
           YELLOW = 3'b010,
           RED = 3'b100;


// ---------------------------------------------------------------------------
// SEQUENTIAL LOGIC BLOCK
// Triggered on:
//  - Positive edge of clock
//  - Positive edge of reset
//
// Responsibilities:
// 1) Update FSM state
// 2) Control counter timing
// ---------------------------------------------------------------------------
always @(posedge clk or posedge rst) begin

    // Reset condition
    // System always starts from NorthGreen state
    if (rst) begin
        state = NorthGreen; // Initial FSM state after reset
        count = 0;          // Clear timing counter
    end 
    
    else begin

        // FSM State Transition Logic
        // Counter determines when state changes occur
        case (state)

            // ---------------- NORTH GREEN ----------------
            // North direction GREEN for 16 cycles
            NorthGreen: begin
                if (count == 15) begin
                    state = NorthYellow; // Move to Yellow phase
                    count = 0;
                end 
                else count = count + 1;
            end

            // ---------------- NORTH YELLOW ----------------
            // Yellow warning phase for 4 cycles
            NorthYellow: begin
                if (count == 3) begin
                    state = WestGreen; // Switch to West direction
                    count = 0;
                end 
                else count <= count + 1;
            end

            // ---------------- WEST GREEN ----------------
            WestGreen: begin
                if (count == 15) begin
                    state = WestYellow;
                    count = 0;
                end 
                else count = count + 1;
            end

            // ---------------- WEST YELLOW ----------------
            WestYellow: begin
                if (count == 3) begin
                    state = SouthGreen;
                    count = 0;
                end 
                else count = count + 1;
            end

            // ---------------- SOUTH GREEN ----------------
            SouthGreen: begin
                if (count == 15) begin
                    state = SouthYellow;
                    count = 0;
                end 
                else count = count + 1;
            end

            // ---------------- SOUTH YELLOW ----------------
            SouthYellow: begin
                if (count == 3) begin
                    state = EastGreen;
                    count = 0;
                end 
                else count = count + 1;
            end

            // ---------------- EAST GREEN ----------------
            EastGreen: begin
                if (count == 15) begin
                    state = EastYellow;
                    count = 0;
                end 
                else count = count + 1;
            end

            // ---------------- EAST YELLOW ----------------
            // Last state in sequence; returns to NorthGreen
            EastYellow: begin
                if (count == 3) begin
                    state = NorthGreen; // Restart full traffic cycle
                    count = 0;
                end 
                else count = count + 1;
            end
        endcase
    end
end


// ---------------------------------------------------------------------------
// OUTPUT DECODER (COMBINATIONAL LOGIC)
// Moore FSM: Outputs depend ONLY on current state.
//
// Design Rule:
// Whenever one direction is GREEN/YELLOW,
// all other directions remain RED.
// ---------------------------------------------------------------------------
always @(state)
begin
    case (state)

        // NORTH ACTIVE STATES
        NorthGreen: begin
            north_light = GREEN;
            south_light = RED;
            east_light  = RED;
            west_light  = RED;
        end

        NorthYellow: begin
            north_light = YELLOW;
            south_light = RED;
            east_light  = RED;
            west_light  = RED;
        end

        // WEST ACTIVE STATES
        WestGreen: begin
            north_light = RED;
            south_light = RED;
            east_light  = RED;
            west_light  = GREEN;
        end

        WestYellow: begin
            north_light = RED;
            south_light = RED;
            east_light  = RED;
            west_light  = YELLOW;
        end

        // SOUTH ACTIVE STATES
        SouthGreen: begin
            north_light = RED;
            south_light = GREEN;
            east_light  = RED;
            west_light  = RED;
        end

        SouthYellow: begin
            north_light = RED;
            south_light = YELLOW;
            east_light  = RED;
            west_light  = RED;
        end

        // EAST ACTIVE STATES
        EastGreen: begin
            north_light = RED;
            south_light = RED;
            east_light  = GREEN;
            west_light  = RED;
        end

        EastYellow: begin
            north_light = RED;
            south_light = RED;
            east_light  = YELLOW;
            west_light  = RED;
        end

        // Default safety condition
        default: begin
            north_light = RED;
            south_light = RED;
            east_light  = RED;
            west_light  = RED;
        end
    endcase
end

endmodule
