# AES Decryption Hardware Implementation

This project implements a hardware-based AES (Advanced Encryption Standard) decryption system using VHDL for FPGA implementation. The design targets the Basys3 FPGA board and provides a complete implementation of the AES decryption algorithm.

## Project Overview

This implementation focuses on AES-128 decryption, which involves reversing the encryption process by applying the following operations in reverse order:
- AddRoundKey (XOR operation with round keys)
- InvMixColumns (matrix multiplication in Galois Field)
- InvShiftRows (cyclic shifts of rows in the state matrix)
- InvSubBytes (inverse S-box substitution)

The project is structured as a Finite State Machine (FSM) that controls the flow of data through these decryption operations across multiple rounds.

## Directory Structure

- `FInal_files/`: Contains the main implementation files
  - `fsm_controller.vhd`: Main FSM controlling the decryption process
  - `four_mult.vhd`: Implementation of MixColumns inverse operation
  - `four_row.vhd`: Implementation of ShiftRows inverse operation
  - `four_subbytes.vhd`: Implementation of SubBytes inverse operation
  - `four_xor.vhd`: Implementation of AddRoundKey operation
  - `bram_controller.vhd`: Controller for Block RAM operations
  - `rom_controller.vhd`: Controller for ROM operations
  - `basys3.xdc`: Constraint file for the Basys3 FPGA board
  
- `Part_a/`: Contains helper modules and components
  - Basic logic gates (AND, OR, NOT)
  - Multiplexers and combinational logic
  - Specialized components for AES operations

- `Simulations/`: Contains testbench files for verification
  - Testbenches for individual modules and the complete design

- `plain_text/`: Additional display and interface modules
  - Seven-segment display control
  - ASCII decoder for displaying results

## Data Structures

The primary data structures used in this implementation include:

1. **State Matrix**: 4x4 matrix of bytes (128 bits total) that holds the intermediate data during decryption
2. **Round Keys**: Pre-computed and stored in ROM, used in each decryption round
3. **S-Box**: Inverse substitution table stored in ROM for the InvSubBytes operation
4. **FSM States**: State machine with various states to control the decryption process flow

## Hardware Components

- **BRAM (Block RAM)**: Stores the encrypted text and will hold the decrypted output
- **ROM**: Stores the round keys and inverse S-box for lookup operations
- **FSM Controller**: Orchestrates the overall decryption process
- **Processing Units**:
  - XOR units for AddRoundKey
  - Multiplication units for InvMixColumns
  - Shift register networks for InvShiftRows
  - Lookup-based substitution for InvSubBytes

## Implementation Flow

### FSM-Controlled Decryption Process

The AES decryption is implemented as a Finite State Machine (FSM) with multiple states controlling the precise sequence of operations. The main flow consists of:

1. **Initialization (INIT state)**:
   - Reset all registers and counters
   - Initialize control signals to default values
   - Prepare the FSM for decryption operations
   - Set the BRAM and ROM addresses to their starting positions

2. **Data Loading (READ states)**:
   - Fetch encrypted data blocks from Block RAM (BRAM)
   - Each block is 32 bits (1 word), and four blocks make a complete 128-bit state
   - The FSM controls address generation and data flow timing
   - Wait states ensure proper data synchronization between memory and processing units

3. **Initial AddRoundKey (XOR1 state)**:
   - XOR the encrypted data with the final round key (round key 10 for AES-128)
   - This operation is performed using dedicated XOR units implemented in `four_xor.vhd`
   - Data is processed in 32-bit chunks (one word at a time)
   - Results are stored in intermediate registers for the next stage

4. **Decryption Rounds (10 rounds for AES-128)**:
   - **InvShiftRows (ROW states)**: 
     - Performs cyclic right shifts on rows of the state matrix
     - Row 0: No shift, Row 1: Right shift by 1, Row 2: Right shift by 2, Row 3: Right shift by 3
     - Implemented in `four_row.vhd` using shift registers and multiplexers
     - This operation undoes the ShiftRows operation of encryption
   
   - **InvSubBytes (SUBBOX states)**:
     - Substitutes each byte with its corresponding value from the inverse S-box
     - The inverse S-box is pre-computed and stored in ROM
     - Implemented in `four_subbytes.vhd` using lookup operations
     - This is a non-linear transformation that adds security to the algorithm
   
   - **AddRoundKey (XOR2 states)**:
     - XOR with the appropriate round key (counting down from round 9 to round 0)
     - Round keys are pre-computed and stored in ROM
     - Each round key is fetched from memory and XORed with the current state
   
   - **InvMixColumns (MULT states)**:
     - Matrix multiplication in Galois Field GF(2^8)
     - Multiplies each column with a fixed polynomial matrix
     - Implemented in `four_mult.vhd` using Galois field arithmetic
     - This operation is skipped in the final round (round 0)
     - The most computationally intensive operation in the decryption process

5. **Round Transition (NEXT_ROUND state)**:
   - Updates round counters and addresses
   - Checks if all rounds are complete
   - Prepares for the next round or transitions to final output stage

6. **Output (WRITE, DONE1 states)**:
   - Store the fully decrypted data back to BRAM
   - Generate done signal to indicate completion
   - Optional display of results on seven-segment display

### Hardware Data Flow

The FSM orchestrates data movement through the following path:
1. BRAM → Processing Units → Intermediate Registers → BRAM
2. ROM provides round keys and S-box values as needed during processing
3. Control signals manage the flow, ensuring correct sequencing and timing

### Clock Cycle Breakdown

- Each state typically takes 1-4 clock cycles
- Data loading/storing: 1-2 cycles per 32-bit word
- Processing operations: 1-4 cycles depending on the operation
- Complete 128-bit block decryption: Approximately 140-180 clock cycles
- Full decryption process timing is optimized by the FSM to minimize waiting states

## How to Run

### Prerequisites
- Xilinx Vivado Design Suite (2018.2 or later recommended)
- Basys3 FPGA board or compatible hardware

### Synthesizing the Design
1. Open Vivado and create a new project
2. Add all VHDL files from the `FInal_files`, `Part_a`, and relevant interface files
3. Add the constraints file (`basys3.xdc`)
4. Run synthesis and implementation
5. Generate bitstream

### Programming the FPGA
1. Connect the Basys3 board to your computer
2. Open Hardware Manager in Vivado
3. Program the FPGA with the generated bitstream (`fsm_controller.bit`)
4. Use the onboard buttons and switches as specified in the constraints file to:
   - Start the decryption process
   - View the results on the seven-segment display

## Testing

The design can be verified using the provided testbench files in the `Simulations` directory:
1. `tb_fsm_controller.vhd`: Tests the complete decryption process
2. Individual module tests for each component (XOR, SubBytes, etc.)

To run a simulation:
1. Open the project in Vivado
2. Add the desired testbench file to the project
3. Set it as the top-level simulation file
4. Run the simulation and observe the waveforms

## Performance

The AES decryption implementation is designed for efficient hardware execution, with each round of decryption requiring multiple clock cycles. The total decryption time depends on the clock frequency, but the FSM design ensures proper sequencing of operations for correct results.

## Acknowledgments

This project was developed as part of the COL215 (Digital Logic and System Design) course at IIT Delhi.

## References

1. FIPS PUB 197, "Advanced Encryption Standard (AES)"
2. Xilinx FPGA Documentation
3. Basys3 Reference Manual