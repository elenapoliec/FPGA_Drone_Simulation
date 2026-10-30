# FPGA-Based Drone Flight Simulation

## 1. Project Overview

This project implements a drone flight simulation system using VHDL and an FPGA development board, developed in AMD Vivado.

The main objective is to simulate the operation of an autonomous drone, including flight route generation, navigation, battery monitoring, obstacle detection, and emergency handling.

The user configures the initial and destination coordinates using physical switches on the FPGA development board. Based on these inputs, the system generates a flight route and simulates the drone's movement along the calculated trajectory.

The system also includes several control mechanisms that allow the user to interrupt the mission or trigger automatic safety procedures depending on simulated battery levels and external conditions.

## 2. Coordinate Input and Validation

The user enters the drone's starting and destination coordinates using the switches available on the FPGA development board.

Each coordinate is represented using minutes and seconds.

The system provides visual confirmation through LED indicators:
- One LED signals that the starting coordinates have been successfully read.
- Another LED confirms that the destination coordinates have been successfully read.

Once both coordinate sets have been entered, the system proceeds to generate the flight route.

## 3. Automatic Flight Route Generation

After receiving the initial and destination coordinates, the system automatically calculates the intermediate coordinates required for the drone to reach its destination.

The flight path is assumed to be a straight line. Therefore, the intermediate coordinates are calculated using a first-degree equation (linear equation), based on the initial and final positions.

The complete route is generated once, before the flight begins. The calculated coordinates are subsequently used throughout the mission, including during the return journey.

After successful route generation, LED indicators provide visual confirmation of:
- Route generation completion.
- Motor activation.
- Drone takeoff.

## 4. Navigation and Position Monitoring

During the simulated flight, the drone follows the previously generated sequence of coordinates.

Its current position is displayed on the FPGA board's seven-segment display, allowing the user to monitor its movement along the route.

A complete mission consists of the following stages:

1. Entering and validating the starting coordinates.
2. Entering and validating the destination coordinates.
3. Automatically generating the flight route.
4. Activating the motors and simulating takeoff.
5. Navigating towards the destination.
6. Reaching the destination and performing the landing procedure.
7. Returning to the initial position by following the previously generated coordinates in reverse order.
8. Completing the return journey and landing at the starting position.

## 5. Mission Control and Safety Mechanisms

The system includes physical buttons and switches that allow the user to interact with the simulated drone and trigger different operating conditions.

### 5.1. Manual Return-to-Base

A dedicated button allows the user to interrupt the current mission and initiate the return-to-base procedure.

When activated, the drone abandons its original flight plan and follows the previously generated route in reverse order, returning to its initial coordinates.

No new route is calculated during the return procedure.

### 5.2. Battery Level Monitoring

Two dedicated switches simulate different battery levels and trigger predefined safety responses.

**Battery level – 20%**

When the corresponding switch is activated, the battery level is set to 20%. The system automatically initiates the return-to-base procedure, directing the drone towards its initial position.

**Battery level – 5%**

When the corresponding switch is activated, the battery level is set to 5%. The system initiates an emergency landing procedure, causing the drone to land at its current position.

### 5.3. Obstacle Detection and Avoidance

The system includes a dedicated switch for simulating obstacle detection.

An LED indicator signals the obstacle detection event. The VHDL implementation also includes logic for simulating a rightward deviation from the original flight path to avoid the obstacle.

### 5.4. Reset Functionality

A dedicated reset button allows the system to be reset, preparing it for a new mission.

## 6. Operating Scenarios

The system is designed to simulate three main operating scenarios:

### 6.1. Mission Completed

The drone successfully reaches its destination, performs the landing procedure, returns to its initial position by following the generated route in reverse order, and lands again.

### 6.2. Mission Interrupted

The mission is interrupted either manually through the return button or automatically when the simulated battery level reaches 20%.

The drone abandons its original mission and returns to its starting position, where it performs the landing procedure.

### 6.3. Emergency Landing

When the simulated battery level reaches 5%, the system triggers an emergency landing procedure.

The drone immediately performs a landing at its current position rather than continuing towards its destination or returning to its starting point.

## 7. Hardware Interaction

The FPGA development board provides the physical interface for controlling and monitoring the simulation.

The hardware components are used as follows:

- **Switches:** Entering the initial and destination coordinates, simulating battery levels, and triggering obstacle detection.
- **Buttons:** Resetting the system and manually initiating the return-to-base procedure.
- **LED indicators:** Confirming coordinate input, route generation, motor activation, takeoff, and obstacle detection.
- **Seven-segment display:** Displaying the drone's current coordinates during navigation.

## 8. Technologies Used

- **VHDL** – Hardware Description Language used to implement the system logic.
- **AMD Vivado** – Development environment used for design, implementation, and FPGA programming.
- **FPGA Development Board** – Hardware platform used to run and test the project.

## 9. Implementation and Testing

The project was implemented using VHDL and tested directly on an FPGA development board.

Physical switches, buttons, LEDs, and the seven-segment display were used to interact with the system and observe its behavior.

Testing focused on:
- Coordinate input and validation.
- Automatic flight route generation.
- Simulated navigation and coordinate display.
- Mission completion and return-to-base procedures.
- Manual mission interruption.
- Battery-related safety responses.
- Emergency landing.
- Obstacle detection indication.

The battery levels were simulated manually using dedicated switches rather than through continuous automatic battery consumption.

## 10. Known Limitations and Future Improvements

Although the main flight simulation functionalities were implemented and tested on the FPGA development board, some aspects could be further improved.

### Known Limitations

- **Obstacle Avoidance:** The VHDL implementation includes logic for simulating a rightward deviation to avoid obstacles. However, during hardware testing, only the obstacle detection LED indicator was successfully verified. The complete avoidance behavior was not fully validated on the FPGA board.
- **Battery Monitoring:** Battery levels are simulated manually using dedicated switches. Automatic battery consumption was explored during development but was not included in the final implementation because the battery level decreased too quickly relative to the simulated flight duration.

### 10.Future Improvements

- Implement a more realistic battery consumption model based on flight duration and operating conditions.
- Fully validate and improve the obstacle avoidance mechanism.
- Extend the navigation system with more advanced trajectory generation methods.
- Improve the simulation by introducing additional flight conditions and safety mechanisms.

## 11. Project Objectives

This project demonstrates the design and implementation of an FPGA-based control system using VHDL, focusing on:

- Digital system design and hardware description.
- Coordinate processing and linear trajectory calculation.
- Sequential control of flight operations.
- Hardware input and output management.
- State-based control and decision-making.
- Simulated safety mechanisms and emergency procedures.
- Practical implementation and testing on an FPGA development board.

