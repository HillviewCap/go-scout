# go-scout API Documentation

This document describes the Robot Operating System (ROS) topics and services used by go-scout to communicate with the Moorebot Scout robot. This information is useful for developers who want to extend go-scout or create their own applications that interact with the robot.

## ROS Overview

The Robot Operating System (ROS) is a flexible framework for writing robot software. It provides a collection of tools, libraries, and conventions that aim to simplify the task of creating complex and robust robot behavior across a wide variety of robotic platforms.

go-scout uses the `goroslib` library to communicate with the Moorebot Scout robot via ROS.

## ROS Node

go-scout creates a ROS node named `scout-access` to communicate with the robot. The node connects to the ROS master running on the robot at the specified IP address and port (default: `192.168.1.224:11311`).

## ROS Topics

### Subscribed Topics

#### `/CoreNode/jpg`

- **Description**: Provides the video feed from the robot's camera.
- **Message Type**: Custom `Frame` type defined in `main.go`.
- **Callback Function**: `onMessageFrame` in `main.go`.
- **Usage**: The application subscribes to this topic to receive video frames from the robot's camera, which are then displayed in the application window.

### Published Topics

#### `/cmd_vel`

- **Description**: Controls the robot's movement.
- **Message Type**: `geometry_msgs.Twist`
- **Publisher**: Created in the `robotControl` and `robotControlKeyboard` functions.
- **Usage**: The application publishes to this topic to send movement commands to the robot.

The message structure is as follows:

```go
msg := &geometry_msgs.Twist{
    Linear: geometry_msgs.Vector3{
        X: joystickRightX * .2,          // strafe left/right
        Y: joystickLeftY * forwardSpeed, // move forward/backward
    },
    Angular: geometry_msgs.Vector3{
        Z: joystickLeftX * -2.9, // rotate left/right
    },
}
```

Where:

- `Linear.X`: Controls strafing (left/right movement without rotation).
- `Linear.Y`: Controls forward/backward movement.
- `Angular.Z`: Controls rotation (turning left/right).

## ROS Services

### `/CoreNode/adjust_light`

- **Description**: Controls the robot's lights.
- **Service Type**: Custom `adjustLightService` type defined in `lights.go`.
- **Client Function**: `turnOnLight` in `lights.go`.
- **Usage**: The application calls this service to adjust the robot's night vision lights.

The service request structure is as follows:

```go
type adjustLightRequest struct {
    Cmd int32 `ros:"cmd int32"`
}
```

Where:

- `Cmd`: The light command value (0 or 1).

### `/nav_low_bat`

- **Description**: Sends the robot back to its charging station.
- **Service Type**: Custom `goHomeService` type defined in `gohome.go`.
- **Client Function**: `scoutGoHome` in `gohome.go`.
- **Usage**: The application calls this service to make the robot return to its charging station.

The service request structure is as follows:

```go
type goHomeRequest struct {
}
```

This service doesn't require any parameters in the request.

## Custom Message Types

### Frame

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

This type is used to receive video frames from the robot. The actual image data is contained in the `Data` field as a byte array.

## Extending the API

To add support for additional robot features, you'll need to:

1. **Identify the ROS topics or services** used by the feature you want to add.
2. **Create appropriate message or service types** in Go.
3. **Subscribe to topics or create service clients** to interact with the robot.

### Example: Adding Battery Status (Implemented)

Battery status monitoring has been implemented in the project. Here's how it was done:

1. Identified the ROS topic that provides battery information (`/CoreNode/battery_status`).
2. Created a message type for battery status in `battery.go`:

```go
type BatteryStatus struct {
    msg.Package `ros:"roller_eye"`
    Level       float32 `ros:"level float32"`
    Charging    bool    `ros:"charging bool"`
}
```

3. Created global variables to store the battery status:

```go
var (
    batteryLevel float32 = 0.0
    isCharging   bool    = false
)
```

4. Implemented a function to subscribe to the battery status topic:

```go
func subscribeToBatteryStatus(n *goroslib.Node) (*goroslib.Subscriber, error) {
    batteryStatusConf := goroslib.SubscriberConf{
        Node:      n,
        Topic:     "/CoreNode/battery_status",
        Callback:  onBatteryStatus,
        QueueSize: 0,
    }

    sub, err := goroslib.NewSubscriber(batteryStatusConf)
    if err != nil {
        return nil, err
    }

    return sub, nil
}
```

5. Created a callback function to process battery status messages:

```go
func onBatteryStatus(msg *BatteryStatus) {
    batteryLevel = msg.Level
    isCharging = msg.Charging
}
```

6. Updated the HUD in the `Draw()` function to display the battery information:

```go
func (g *Game) Draw(screen *ebiten.Image) {
    // ... existing code ...

    // Display battery status
    batteryText := fmt.Sprintf("Battery: %.1f%% %s", batteryLevel * 100, isCharging ? "(Charging)" : "")
    ebitenutil.DebugPrintAt(screen, batteryText, 10, WindowY-40)
}
```

This implementation allows the application to display the robot's current battery level and charging status in the HUD.

## Debugging ROS Communication

To debug ROS communication issues:

1. **Enable verbose logging** with the `-v` flag.
2. **Use ROS command-line tools** on the robot to monitor topics and services.
3. **Check network connectivity** between your computer and the robot.

## References

- [ROS Documentation](http://wiki.ros.org/)
- [goroslib Documentation](https://github.com/aler9/goroslib)
