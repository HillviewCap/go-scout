#!/bin/bash
# This script demonstrates how to use go-scout with different configurations

# Check if go-scout is built
if [ ! -f "../scout" ]; then
    echo "Building go-scout..."
    cd ..
    go build
    cd examples
fi

# Function to display usage information
show_usage() {
    echo "Quick Start Script for go-scout"
    echo ""
    echo "Usage: ./quick_start.sh [option]"
    echo ""
    echo "Options:"
    echo "  keyboard    Start go-scout with keyboard controls (default)"
    echo "  joystick    Start go-scout with Xbox controller"
    echo "  custom      Start go-scout with custom IP and window size"
    echo "  help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  ./quick_start.sh keyboard"
    echo "  ./quick_start.sh joystick"
    echo "  ./quick_start.sh custom"
}

# Parse command-line arguments
if [ $# -eq 0 ]; then
    OPTION="keyboard"
else
    OPTION=$1
fi

# Set the path to the go-scout executable
SCOUT="../scout"

# Handle different options
case $OPTION in
keyboard)
    echo "Starting go-scout with keyboard controls..."
    $SCOUT -c keyboard
    ;;
joystick)
    echo "Starting go-scout with Xbox controller..."
    $SCOUT -c joystick
    ;;
custom)
    # Prompt for custom settings
    echo "Enter the robot's IP address (default: 192.168.1.224):"
    read IP
    IP=${IP:-192.168.1.224}

    echo "Enter the robot's port (default: 11311):"
    read PORT
    PORT=${PORT:-11311}

    echo "Enter window width (default: 1280):"
    read WIDTH
    WIDTH=${WIDTH:-1280}

    echo "Enter window height (default: 720):"
    read HEIGHT
    HEIGHT=${HEIGHT:-720}

    echo "Choose control scheme (keyboard/joystick, default: keyboard):"
    read CONTROL
    CONTROL=${CONTROL:-keyboard}

    echo "Starting go-scout with custom settings..."
    $SCOUT -h "$IP:$PORT" -windowX $WIDTH -windowY $HEIGHT -c $CONTROL
    ;;
help)
    show_usage
    ;;
*)
    echo "Unknown option: $OPTION"
    show_usage
    exit 1
    ;;
esac
