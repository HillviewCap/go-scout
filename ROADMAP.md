# go-scout Project Roadmap

This document outlines the planned development roadmap for go-scout. It provides a high-level overview of the features and improvements we plan to implement in the future.

## Current Status

go-scout currently provides basic functionality for controlling a Moorebot Scout robot using an Xbox controller or keyboard. The application displays the robot's video feed in a window and allows for basic movement control and a few special commands (light control, return to charging station, screenshots).

## Short-term Goals (0-3 months)

### 1. Improved User Interface

- [ ] Create a proper Heads-Up Display (HUD) with:
  - [ ] Battery status indicator
  - [ ] Signal strength indicator
  - [ ] Speed indicator
  - [ ] Compass/orientation display
- [ ] Add on-screen controls for touch devices
- [ ] Implement a settings menu for adjusting parameters without command-line flags

### 2. Enhanced Robot Control

- [ ] Add support for additional controllers (PlayStation, generic gamepads)
- [ ] Implement customizable control mappings
- [ ] Add fine-grained speed control
- [ ] Implement "cruise control" mode for constant movement

### 3. Improved Video Handling

- [ ] Add support for video recording
- [ ] Implement video quality settings
- [ ] Add support for image filters and enhancements
- [ ] Implement picture-in-picture for sensor data

### 4. Documentation and Testing

- [ ] Add comprehensive unit tests
- [ ] Create end-to-end tests for robot communication
- [ ] Improve API documentation
- [ ] Create user guides with screenshots and videos

## Medium-term Goals (3-6 months)

### 1. Advanced Features

- [ ] Implement autonomous navigation capabilities
- [ ] Add support for mapping and environment scanning
- [ ] Create waypoint-based patrol routes
- [ ] Implement object detection and tracking

### 2. Multi-robot Support

- [ ] Add support for controlling multiple robots
- [ ] Implement robot switching interface
- [ ] Create multi-view display for monitoring multiple robots
- [ ] Add robot-to-robot communication capabilities

### 3. Remote Access

- [ ] Implement web-based control interface
- [ ] Add support for remote access over the internet
- [ ] Create mobile-friendly web interface
- [ ] Implement secure authentication and encryption

### 4. Performance Improvements

- [ ] Optimize video processing for lower latency
- [ ] Improve resource usage for better battery life
- [ ] Enhance error handling and recovery
- [ ] Implement adaptive quality based on network conditions

## Long-term Goals (6+ months)

### 1. Advanced Autonomy

- [ ] Implement SLAM (Simultaneous Localization and Mapping)
- [ ] Add support for autonomous exploration
- [ ] Create AI-based decision making for patrol and security
- [ ] Implement advanced path planning algorithms

### 2. Integration with Smart Home

- [ ] Add support for MQTT for smart home integration
- [ ] Implement integration with popular smart home platforms
- [ ] Create automation rules based on robot observations
- [ ] Add voice control through smart assistants

### 3. Extended Sensor Support

- [ ] Add support for additional sensors (temperature, humidity, air quality)
- [ ] Implement sensor data logging and analysis
- [ ] Create alerts based on sensor readings
- [ ] Add support for custom sensor modules

### 4. Community Features

- [ ] Create a plugin system for community extensions
- [ ] Implement a marketplace for sharing configurations and plugins
- [ ] Add support for custom robot behaviors
- [ ] Create a community forum for sharing ideas and solutions

## How to Contribute

We welcome contributions to help achieve these goals! If you're interested in working on any of these features, please:

1. Check the [CONTRIBUTING.md](CONTRIBUTING.md) file for guidelines on how to contribute.
2. Look for open issues related to the feature you want to work on.
3. If no issue exists, create a new one describing what you want to implement.
4. Fork the repository and submit a pull request with your implementation.

## Priority and Timeline

The items in this roadmap are prioritized based on user needs and technical dependencies. However, the actual implementation order may vary based on contributor interest and resource availability.

This roadmap is a living document and will be updated regularly to reflect the current state and future direction of the project.

## Feedback

If you have suggestions for additional features or different priorities, please open an issue on GitHub to discuss your ideas. Community feedback is essential for shaping the future of go-scout!
