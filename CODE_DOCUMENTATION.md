# go-scout Code Documentation

This document provides detailed information about the go-scout codebase for developers who want to contribute to the project.

## Project Overview

go-scout is a tool that allows controlling a Moorebot Scout robot from a computer without using the mobile app. The application uses an Xbox controller or keyboard for input, displays the robot's video feed in a window, and communicates with the robot using the Robot Operating System (ROS) protocol.

## Codebase Structure

The project consists of several Go files, each with specific responsibilities:

### main.go

This is the application's entry point and contains most of the core functionality:

- **Initialization and Setup**: Parses command-line flags, sets up the ROS node, and initializes the GUI.
- **Video Display**: Receives video frames from the robot and displays them using Ebiten.
- **Input Handling**: Processes input from either an Xbox controller or keyboard.
- **Robot Control**: Translates input commands into ROS messages to control the robot's movement.

### lights.go

This file handles the functionality for controlling the robot's lights:

- **Light Control Service**: Defines the ROS service structures for adjusting the robot's lights.
- **turnOnLight Function**: Calls the `/CoreNode/adjust_light` ROS service to control the robot's lights.

### gohome.go

This file contains the functionality for sending the robot back to its charging station:

- **Go Home Service**: Defines the ROS service structures for the "return to home" command.
- **scoutGoHome Function**: Calls the `/nav_low_bat` ROS service to make the robot return to its charging station.

## Key Components

### 1. Command-Line Interface

The application accepts several command-line flags:

```
-h string    ROS endpoint such as IP_ADDRESS:PORT (default "192.168.1.224:11311")
-v           Verbose mode
-windowX int Window width (default 1920)
-windowY int Window height (default 1080)
-l string    Localhost address (default "127.0.0.1")
-c string    Control scheme, keyboard or joystick (default "keyboard")
```

### 2. ROS Communication

The application uses the `goroslib` library to communicate with the robot:

- **Node Creation**: Creates a ROS node named "scout-access" to communicate with the robot.
- **Video Subscription**: Subscribes to the `/CoreNode/jpg` topic to receive video frames.
- **Movement Control**: Publishes to the `/cmd_vel` topic to control the robot's movement.
- **Service Clients**: Uses ROS services for specific functions like light control and returning home.

### 3. GUI and Video Display

The application uses the Ebiten game engine to display the robot's video feed:

- **Game Structure**: Implements the Ebiten Game interface with Draw, Update, and Layout methods.
- **Video Processing**: Receives video frames from the ROS topic and displays them in the window.
- **HUD Display**: Shows control information and status in the window.

### 4. Input Handling

The application supports two input methods:

#### Xbox Controller (robotControl function)

- **Left Stick**: Controls forward/backward movement and turning left/right.
- **Right Stick**: Controls strafing left/right.
- **Bumpers**: Adjusts the maximum speed (left decreases, right increases).
- **Both Bumpers**: Stops the robot.
- **Start Button**: Exits the application.

#### Keyboard (robotControlKeyboard function)

- **W/S**: Forward/backward movement.
- **A/D**: Turn left/right.
- **Q/E**: Strafe left/right.
- **P/O**: Increase/decrease speed.
- **H**: Return to charging station.
- **9/0**: Adjust night vision brightness.
- **Space**: Save screenshot.
- **Escape**: Exit application.

### 5. Robot Control Logic

The application translates input commands into ROS messages:

- **Movement Control**: Creates `geometry_msgs.Twist` messages with linear and angular vectors.
- **Speed Adjustment**: Modifies the speed multiplier based on user input.
- **Special Commands**: Handles special commands like returning home and controlling lights.

## Key Functions

### main.go

- **main()**: Entry point that initializes the application, sets up ROS communication, and starts the GUI.
- **Draw()**: Renders the video feed and HUD information.
- **onMessageFrame()**: Callback function for receiving video frames from the robot.
- **robotControl()**: Handles Xbox controller input and sends movement commands.
- **robotControlKeyboard()**: Handles keyboard input and sends movement commands.
- **squashToFloat()**: Utility function to convert joystick input values to a normalized float.
- **saveScreenshot()**: Saves the current video frame as a JPEG file.

### lights.go

- **turnOnLight()**: Calls the ROS service to adjust the robot's lights.

### gohome.go

- **scoutGoHome()**: Calls the ROS service to make the robot return to its charging station.

## Data Structures

### Frame (main.go)

Represents a video frame received from the robot:

```go
type Frame struct {
    msg.Package     `ros:"roller_eye"`
    msg.Definitions `ros:"int8 VIDEO_STREAM_H264=0,int8 VIDEO_STREAM_JPG=1,int8 AUDIO_STREAM_AAC=2"`
    Seq             uint32
    Stamp           uint64
    Session         uint32
    Type            int8
    Oseq            uint32
    Par1            int32
    Par2            int32
    Par3            int32
    Par4            int32
    Data            []uint8
}
```

### adjustLightService (lights.go)

Represents the ROS service for controlling the robot's lights:

```go
type adjustLightService struct {
    msg.Package `ros:"/CoreNode/adjust_light"`
    Request     adjustLightRequest
    Response    adjustLightResponse
}
```

### goHomeService (gohome.go)

Represents the ROS service for sending the robot back to its charging station:

```go
type goHomeService struct {
    msg.Package `ros:"/nav_low_bat"`
    Request     goHomeRequest
    Response    goHomeResponse
}
```

## Dependencies

The project relies on several external libraries:

- **goroslib** (v0.0.0-20220831065204-cd7cf8973f37): ROS client library for Go.
- **ebiten/v2** (v2.4.0): 2D game library for handling graphics and input.
- **joystick** (v1.0.1): Library for reading input from joysticks/controllers.

## Control Flow

1. The application starts by parsing command-line flags and initializing the ROS node.
2. It subscribes to the video feed topic and starts a goroutine for handling input (either joystick or keyboard).
3. The Ebiten game loop begins, continuously:
   - Receiving video frames from the robot
   - Displaying them in the window
   - Processing user input
   - Sending movement commands to the robot
4. Special commands (screenshots, light control, return home) are handled as they are triggered.
5. The application exits when the user presses the Start button (joystick) or Escape key (keyboard).

## Adding New Features

When adding new features to the project, consider the following:

### 1. Adding Support for Other Controllers

To add support for other controllers, you would need to:

- Create a new input handling function similar to `robotControl()`.
- Map the controller's inputs to the appropriate robot commands.
- Update the command-line flags to include the new controller type.

### 2. Creating a Proper HUD

To create a more comprehensive HUD:

- Modify the `Draw()` function to include additional information.
- Consider creating dedicated functions for rendering different HUD elements.
- Look into using Ebiten's text and image drawing capabilities for more advanced displays.

### 3. Adding More Robot Features

To add support for more robot features:

- Identify the corresponding ROS topics or services for the features.
- Create appropriate service client structures and functions.
- Add user interface elements to trigger these features.

For example, to add battery status to the HUD (which has been implemented):

1. Find the ROS topic that provides battery information (`/CoreNode/battery_status`).
2. Define a message type for battery status in `battery.go`:
   ```go
   type BatteryStatus struct {
       msg.Package `ros:"roller_eye"`
       Level       float32 `ros:"level float32"`
       Charging    bool    `ros:"charging bool"`
   }
   ```
3. Subscribe to this topic in the main function using the `subscribeToBatteryStatus` function.
4. Create a callback function (`onBatteryStatus`) to process battery status messages and update global variables.
5. Update the HUD display in the `Draw()` function to show the battery status.

## Debugging Tips

- Use the `-v` flag to enable verbose logging.
- Check the ROS endpoint configuration if you're having connection issues.
- Ensure the controller is properly connected before starting the application.
- Use the screenshot functionality to capture issues with the video feed.
