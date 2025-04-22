# go-scout

A tool for controlling the Moorebot Scout robot from your computer using an Xbox controller or keyboard.

## Intro

go-scout is a tool that allows you to control a Moorebot Scout robot from your computer (without using the mobile app). The robot is controlled using an Xbox controller or keyboard, and video is displayed in a new window.

## Demo

![go-scout demo](demo.gif)

## Installation

To install go-scout, simply download the latest release from the releases page and run the installer, or compile using the steps below.

```
go install github.com/shell-company/go-scout

OR

git clone https://github.com/shell-company/go-scout && cd go-scout && go build
```

## Usage

### Command-Line Options

```
Usage of ./scout:
  -h string
    	ROS endpoint such as IP_ADDRESS:PORT (default "192.168.1.224:11311")
  -v	verbose
  -windowX int
        Window width (default 1920)
  -windowY int
        Window height (default 1080)
  -l string
        Localhost address (default "127.0.0.1")
  -c string
        Control scheme, keyboard or joystick (default "keyboard")
```

Example:

```
./scout -h "192.168.1.225:11311"
```

### Xbox Controller Controls

To use go-scout with an Xbox controller, connect the controller to your computer and launch the application with the `-c joystick` flag. The controls are as follows:

| Button       | Action                        |
| ------------ | ----------------------------- |
| Left Stick   | Forward, Reverse, Left, Right |
| Right Stick  | Strafe                        |
| Left Bumper  | Lower Max Speed               |
| Right Bumper | Raise Max Speed               |
| Both Bumpers | Stop                          |
| Start        | Exit                          |

### Keyboard Controls

To use go-scout with the keyboard, launch the application with the `-c keyboard` flag (this is the default). The controls are as follows:

| Key    | Action                           |
| ------ | -------------------------------- |
| W      | Forward                          |
| S      | Reverse                          |
| A      | Turn Left                        |
| D      | Turn Right                       |
| Q      | Strafe Left                      |
| E      | Strafe Right                     |
| P      | Increase Speed                   |
| O      | Decrease Speed                   |
| 0      | Decrease Night Vision Brightness |
| 9      | Increase Night Vision Brightness |
| Space  | Save Screenshot                  |
| H      | Return to Charging Station       |
| Escape | Exit                             |

## Architecture

go-scout uses the Robot Operating System (ROS) to communicate with the Moorebot Scout robot. The application creates a ROS node that subscribes to the robot's video feed and publishes movement commands.

The main components of the application are:

1. **ROS Communication**: Uses the `goroslib` library to communicate with the robot.
2. **GUI**: Uses the Ebiten game engine to display the robot's video feed and handle input.
3. **Input Handling**: Processes input from either an Xbox controller or keyboard.
4. **Robot Control**: Translates input commands into ROS messages to control the robot's movement.

## Considerations

Moorebot added a fair amount of bloatware to an otherwise great hardware platform. I took the following steps to increase privacy and reduce resource usage on the robot.

**Follow the steps below at your own risk** as they may void warranties and potentially violate Moorebot terms of service.

- [ ] SSH Access via `root:plt` to bot IP

```
ssh root@<SCOUT IP ADDRESS>
```

- [ ] Remove /opt/sockproxy/proxy_list.json

```
rm /opt/sockproxy/proxy_list.json
```

- [ ] Disable sockproxy service

```
systemctl disable sockproxy.service
```

- [ ] Null route what appear to be backdoors in the CloudNode

```
route add 62.210.208.47 gw 127.0.0.1 lo
route add 45.35.33.24 gw 127.0.0.1 lo
route add 118.107.244.35 gw 127.0.0.1 lo
```

## Development

For developers interested in contributing to the project, please refer to the following documentation:

- [Development Plan](DEVELOPMENT_PLAN.md): Outlines the plan for documenting and extending the project.
- [Code Documentation](CODE_DOCUMENTATION.md): Provides detailed information about the codebase structure and functionality.

## To-Do

- Add support for other controllers
- Create a proper Heads-Up-Display
- Add support for more features of the robot
  - Add battery status to HUD
  - Add compass to HUD
  - Add sensor data to HUD
