`timescale 1ns/1ps
// ============================================================================
// Project : 4-Way Traffic Light Controller Testbench
// Author  : Yuvesh R Menghare
//
// Description:
// This testbench verifies the functional behaviour of the
// traffic_light_controller module.
//
// Verification Goals:
// 1) Check reset behaviour (FSM must start at NorthGreen)
// 2) Verify sequential state transitions
// 3) Observe Green and Yellow timing using waveform analysis
// 4) Validate emergency reset during operation
//
// Tool Compatibility : Xilinx ISE ISim
// ============================================================================

module traffic_light_tb;

    // ------------------------------------------------------------------------
    // Testbench Signals
    // ------------------------------------------------------------------------
    // Clock and reset are driven from testbench
    reg clk;
    reg rst;

    // DUT outputs observed using wires
    wire [2:0] north_light;
    wire [2:0] west_light;
    wire [2:0] south_light;
    wire [2:0] east_light;

    // ------------------------------------------------------------------------
    // DUT (Device Under Test) Instantiation
    // Connects testbench signals to traffic_light_controller ports
    // ------------------------------------------------------------------------
    traffic_light_controller uut (
        .clk(clk),
        .rst(rst),
        .north_light(north_light),
        .west_light(west_light),
        .south_light(south_light),
        .east_light(east_light)
    );

    // ========================================================================
    // CLOCK GENERATION BLOCK
    // Generates a continuous clock with 10ns period
    // Used to drive synchronous FSM transitions
    // ========================================================================
    initial begin
        clk = 0;
        forever #5 clk = ~clk;   // Toggle every 5ns → 10ns clock period
    end

    // ========================================================================
    // STIMULUS BLOCK (TEST SCENARIOS)
    //
    // Test Case 1 : Initial Reset
    // Test Case 2 : Normal FSM Operation
    // Test Case 3 : Emergency Reset during operation
    // ========================================================================
    initial begin

        // ---------------- INITIAL RESET ----------------
        // Forces FSM into NorthGreen state
        rst = 1;
        #20;
        rst = 0;

        // ---------------- NORMAL OPERATION -------------
        // Allow FSM to cycle through all 8 states
        #2000;

        // ---------------- EMERGENCY RESET --------------
        // Apply reset while FSM is running
        rst = 1;
        #20;
        rst = 0;

        // Continue simulation to verify recovery
        #1500;

        // Stop simulation (ISE waveform viewer remains open)
        $stop;
    end

endmodule
