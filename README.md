
# APB-Based SPI Master IP Design

## Project Overview

The **APB-Based SPI Master IP Design** is a Serial Peripheral Interface (SPI) master implemented using Verilog HDL and interfaced with the Advanced Peripheral Bus (APB) protocol. The design enables communication between a processor-based system and SPI-compatible slave devices.

The project is divided into multiple RTL modules to provide a modular and reusable design. Each block performs a specific function, including APB communication, baud rate generation, slave selection, and serial data transmission and reception.

## SPI CORE BLOCK DIAGRAM

![SPI_Core_Block diagram](images/SPI_Core_Blockdiagram.png)

## Project Objectives

- Design an SPI Master IP using Verilog HDL.
- Implement APB interface functionality.
- Generate the SPI serial clock using a programmable baud rate generator.
- Select the SPI slave device using slave-select logic.
- Implement serial data transmission and reception using a shift register.
- Verify RTL functionality using simulation and testbenches.

## Block Descriptions

### 1. APB Slave Interface

The APB Slave block provides communication between the APB bus and the SPI Master IP. It handles APB read and write transactions, register access, and control and status information.

![APB Slave Block Diagram](images/APB_Slave.png)

### 2. Baud Rate Generator

The Baud Rate Generator generates the SPI serial clock (SCLK) based on the programmed baud rate divisor and SPI configuration settings.

![BaudRate Generator Block Diagram](images/Baudrate_Generator.png)

### 3. Slave Select

The Slave Select block manages SPI slave selection and transfer control. It generates the slave-select signal and tracks the progress of data transfers.

![SPI_Slave_Control_Select Block Diagram](images/SPI_Slave_Control_Select.png)

### 4. Shift Register

The Shift Register handles serial data transmission through MOSI and serial data reception through MISO. It supports SPI clock polarity, clock phase, and data bit-order configuration.

![Shift_Register Block Diagram](images/Shift_Register.png)

### 5. Top Module

The Top Module integrates the APB Slave, Baud Rate Generator, Slave Select, and Shift Register blocks to form the complete SPI Master IP.



## Design Architecture

The design consists of the following major components:

- **APB Slave:** Handles bus transactions and register access.
- **Baud Rate Generator:** Generates the SPI clock.
- **Slave Select:** Controls slave selection and transfer status.
- **Shift Register:** Performs serial data transmission and reception.
- **Top Module:** Connects all submodules.

## SPI Signals

| Signal | Description |
|---|---|
| PCLK | APB system clock |
| PRESET_n | Active-low reset |
| SCLK | SPI serial clock |
| MOSI | Master Out Slave In |
| MISO | Master In Slave Out |
| SS | Slave Select |
| CPOL | Clock Polarity |
| CPHA | Clock Phase |

## Technologies Used

- Verilog HDL
- APB Protocol
- SPI Protocol
- RTL Design
- ModelSim
- Testbench Development
- Waveform Analysis

## Simulation and Verification

The RTL modules were verified through Verilog testbenches and simulation. Waveforms were analyzed to check clock generation, slave selection, APB transactions, and serial data transmission and reception.

## Repository Structure

```text
APB-Based-SPI-Master-IP-Design/
│
├── APB_Slave/
│   ├── Apbslave.v
│   └── Apbslave_tb.v
│
├── Baudrate_generator/
│   ├── Baud_generator.v
│   └── Baud_generator_tb.v
│
├── Slave_Select/
│   ├── Slaveselect.v
│   └── Slaveselect_tb.v
│
├── Shift_Register/
│   ├── Shift_register.v
│   └── Shift_register_tb.v
│
├── Top_Module/
│   ├── Topmodule.v
│   └── Topmodule_tb.v
│
├── images/
│   ├── top_module.png
│   ├── apb_slave.png
│   ├── baud_rate_generator.png
│   ├── slave_select.png
│   ├── shift_register.png
│   └── 
│
└── README.md
```

*Note: Update the filenames in this structure to match the actual files in your repository.*

## Learning Outcomes

- Understanding APB and SPI protocol fundamentals.
- Developing modular RTL designs using Verilog HDL.
- Integrating multiple RTL modules into a top-level design.
- Writing testbenches and debugging simulation waveforms.
- Understanding serial communication and hardware IP integration.

## Author

**VINUKONDA PRAMEELA**

B.Tech – Electronics and Communication Engineering

GitHub: [Prameela18](https://github.com/Prameela18)
