#!/bin/bash
# system_check.sh - Verify system configuration for go-scout
#
# This script checks if the system is properly configured to run go-scout by:
# 1. Verifying Go installation
# 2. Checking for required dependencies
# 3. Testing controller connectivity
# 4. Verifying network connectivity to the robot

# Text formatting
BOLD="\033[1m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
RESET="\033[0m"

# Print header
echo -e "${BOLD}go-scout System Check${RESET}"
echo "This script will verify your system configuration for running go-scout."
echo

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to print status
print_status() {
    if [ $1 -eq 0 ]; then
        echo -e "[ ${GREEN}OK${RESET} ] $2"
    else
        echo -e "[${RED}FAIL${RESET}] $2"
    fi
}

# Function to print warning
print_warning() {
    echo -e "[${YELLOW}WARN${RESET}] $1"
}

# Function to print info
print_info() {
    echo -e "[ ${BOLD}..${RESET} ] $1"
}

# Check Go installation
echo -e "${BOLD}Checking Go installation:${RESET}"
if command_exists go; then
    GO_VERSION=$(go version | awk '{print $3}')
    print_status 0 "Go is installed: $GO_VERSION"

    # Check Go version (need 1.19 or later)
    GO_VERSION_NUM=$(echo $GO_VERSION | sed 's/go//' | cut -d. -f1-2)
    if (($(echo "$GO_VERSION_NUM < 1.19" | bc -l))); then
        print_warning "Go version is older than 1.19. You may need to upgrade."
    fi
else
    print_status 1 "Go is not installed. Please install Go 1.19 or later."
fi
echo

# Check for required dependencies
echo -e "${BOLD}Checking required dependencies:${RESET}"

# Check for uv
if command_exists uv; then
    print_status 0 "uv is installed"
else
    print_status 1 "uv is not installed. Please install uv for package management."
fi

# Check for required Go packages
echo
echo -e "${BOLD}Checking Go packages:${RESET}"
print_info "This will check if the required Go packages can be found."

# Create a temporary Go file to check imports
TMP_FILE=$(mktemp)
cat >$TMP_FILE <<'EOF'
package main

import (
	"fmt"
	
	// Required packages for go-scout
	_ "github.com/aler9/goroslib"
	_ "github.com/hajimehoshi/ebiten/v2"
	_ "github.com/simulatedsimian/joystick"
)

func main() {
	fmt.Println("All packages found!")
}
EOF

# Try to build the temporary file
if go build -o /dev/null $TMP_FILE >/dev/null 2>&1; then
    print_status 0 "All required Go packages are available"
else
    print_status 1 "Some required Go packages are missing. Run 'uv sync' in the project directory."
fi

# Clean up
rm $TMP_FILE

# Check for joystick/controller
echo
echo -e "${BOLD}Checking for joystick/controller:${RESET}"

if [ -d "/dev/input" ]; then
    # Linux
    JS_DEVICES=$(find /dev/input -name "js*" 2>/dev/null)
    if [ -n "$JS_DEVICES" ]; then
        print_status 0 "Joystick device(s) found: $JS_DEVICES"
    else
        print_warning "No joystick devices found. You can still use keyboard controls."
    fi
elif [ -d "/dev/hidraw" ]; then
    # Some Linux systems
    print_info "Checking alternative joystick interfaces..."
    if ls /dev/hidraw* >/dev/null 2>&1; then
        print_status 0 "HID devices found, joystick may be available"
    else
        print_warning "No HID devices found. You can still use keyboard controls."
    fi
elif [ "$(uname)" == "Darwin" ]; then
    # macOS
    print_info "On macOS, joystick detection requires additional permissions."
    print_info "You may need to grant permission to access input devices."
    print_warning "Please connect an Xbox controller and test with the application."
elif [ "$(uname -s | cut -c 1-5)" == "MINGW" ] || [ "$(uname -s | cut -c 1-5)" == "MSYS_" ]; then
    # Windows
    print_info "On Windows, joystick detection is handled by the DirectInput API."
    print_info "Please connect an Xbox controller and test with the application."
else
    print_warning "Unknown system, cannot check for joystick devices."
    print_info "You can still use keyboard controls."
fi

# Check network connectivity to robot
echo
echo -e "${BOLD}Checking network connectivity:${RESET}"
print_info "Enter the IP address of your Moorebot Scout robot (default: 192.168.1.224):"
read ROBOT_IP
ROBOT_IP=${ROBOT_IP:-192.168.1.224}

print_info "Checking connectivity to $ROBOT_IP..."
if ping -c 1 -W 2 $ROBOT_IP >/dev/null 2>&1; then
    print_status 0 "Robot is reachable at $ROBOT_IP"

    # Try to check if ROS port is open
    if command_exists nc; then
        if nc -z -w 2 $ROBOT_IP 11311 >/dev/null 2>&1; then
            print_status 0 "ROS port (11311) is open on the robot"
        else
            print_warning "ROS port (11311) does not appear to be open on the robot."
            print_info "Make sure the robot is fully booted and ROS is running."
        fi
    else
        print_info "Cannot check ROS port (nc command not available)."
        print_info "Use './scout -h \"$ROBOT_IP:11311\"' to connect to the robot."
    fi
else
    print_status 1 "Cannot reach the robot at $ROBOT_IP"
    print_info "Make sure the robot is powered on and connected to the same network."
    print_info "Check your network configuration and firewall settings."
fi

# Summary
echo
echo -e "${BOLD}Summary:${RESET}"
echo "This system check provides basic verification of your setup for go-scout."
echo "If any issues were found, please refer to the TROUBLESHOOTING.md file for solutions."
echo
echo "To run go-scout, use: ./scout -h \"$ROBOT_IP:11311\""
echo
