🚦 1. Introduction
Traffic control systems are essential for maintaining safe and efficient vehicle movement at road intersections.
This project implements a 4-Way Traffic Light Controller using Finite State Machine (FSM) architecture in Verilog HDL.

The system controls four directions:
North | West | South | East
Only one direction is allowed to move at a time while others remain RED, ensuring safe traffic management.

The design is verified using a testbench and waveform analysis in Xilinx ISE.

🎯 2. Problem Statement
Design a synchronous digital controller that:
Manages traffic signals for four directions.
Uses FSM-based sequential control logic.
Allows only one direction to be GREEN/YELLOW at a time.
Automatically cycles through directions in fixed order:
North → West → South → East → Repeat

Timing Requirements
GREEN duration = 16 clock cycles
YELLOW duration = 4 clock cycles
RESET must return system to NorthGreen state.

3.Timing Requirements
GREEN duration = 16 clock cycles
YELLOW duration = 4 clock cycles
RESET must return system to NorthGreen state.
| State | Description |
| ----- | ----------- |
| S0    | NorthGreen  |
| S1    | NorthYellow |
| S2    | WestGreen   |
| S3    | WestYellow  |
| S4    | SouthGreen  |
| S5    | SouthYellow |
| S6    | EastGreen   |
| S7    | EastYellow  |

State Transition Flow
S0 → S1 → S2 → S3 → S4 → S5 → S6 → S7 → S0

4. State Diagram
       START
        ↓
      (S0)
        ↓ count==15
      (S1)
        ↓ count==3
      (S2)
        ↓ count==15
      (S3)
        ↓ count==3
      (S4)
        ↓ count==15
      (S5)
        ↓ count==3
      (S6)
        ↓ count==15
      (S7)
        ↓ count==3
        └───────────────→ back to S0
   
5. Verilog Implementation
The design consists of three major RTL blocks:
1️⃣ State Register
Stores current FSM state and updates on clock edge.
2️⃣ Counter Logic
Controls timing delays between GREEN and YELLOW states.

6.Test Cases Performed
✔ Initial reset VERIFIED
✔ Sequential FSM transitions
✔ Timing  for GREEN/YELLOW states
✔ Emergency reset during operation

7. Simulation Output (Waveform Analysis)
   <img width="1919" height="961" alt="TIMING_WAVEFORM" src="https://github.com/user-attachments/assets/dc086b00-f0a3-49ed-8511-17268486f895" />
   <img width="1497" height="314" alt="TIMING DIAGRAM" src="https://github.com/user-attachments/assets/7403ce75-e5ba-4320-859f-aaa6c11d35c8" />
   
8.🎓 Skills Demonstrated
RTL Design using Verilog HDL
Moore FSM Modelling
Counter-based Timing Control
Sequential Logic Design
Functional Verification
Waveform Debugging

9.Conclusion
The project successfully demonstrates the design  of a synchronous FSM-based traffic light controller.
Simulation results confirm correct state transitions, timing behaviour, and safe traffic sequencing.
This implementation strengthens understanding of FSM design, RTL coding practices, and hardware verification workflows.



   
