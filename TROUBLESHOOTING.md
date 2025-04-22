# Troubleshooting go-scout

This guide provides solutions for common issues you might encounter when using go-scout.

## Connection Issues

### Cannot connect to the robot

**Symptoms:**

- Error message: "Failed to connect to master"
- No video feed appears
- Robot does not respond to commands

**Possible solutions:**

1. **Check the robot's IP address:**

   - Make sure the robot is powered on and connected to the same network as your computer.
   - Verify the IP address using your router's admin panel or a network scanner.
   - Use the correct IP address with the `-h` flag: `./scout -h "192.168.1.XXX:11311"`

2. **Check network connectivity:**

   - Ping the robot to verify basic connectivity: `ping 192.168.1.XXX`
   - Make sure no firewall is blocking the connection.
   - Try connecting to the robot via SSH to verify it's responsive: `ssh root@192.168.1.XXX`

3. **Restart the robot:**
   - Power cycle the robot and wait for it to fully boot up before trying to connect again.

## Controller Issues

### Xbox controller not detected

**Symptoms:**

- Error message: "Please connect a joystick"
- Cannot control the robot with the controller

**Possible solutions:**

1. **Check controller connection:**

   - Make sure the controller is properly connected to your computer.
   - For wireless controllers, ensure the battery is charged.
   - Try reconnecting the controller or using a different USB port.

2. **Test the controller:**

   - Use a controller testing tool to verify the controller is working properly.
   - On Windows, you can use the "Game Controllers" settings in Control Panel.
   - On Linux, you can use `jstest /dev/input/js0`.

3. **Use keyboard controls instead:**
   - Launch go-scout with the keyboard control option: `./scout -c keyboard`

### Controller inputs not responding correctly

**Symptoms:**

- Robot moves in unexpected ways
- Some buttons don't work as expected

**Possible solutions:**

1. **Check controller mapping:**

   - Different controller models might have different button mappings.
   - Check the `robotControl()` function in `main.go` to see the expected mapping.

2. **Calibrate the controller:**
   - Use your operating system's controller calibration tools.
   - Ensure joystick dead zones are properly set.

## Video Issues

### No video feed

**Symptoms:**

- Window appears but no video is displayed
- Error messages related to image processing

**Possible solutions:**

1. **Check ROS topic subscription:**

   - Make sure the robot is publishing video to the `/CoreNode/jpg` topic.
   - Use a ROS topic monitoring tool to verify the topic is active.

2. **Check network bandwidth:**

   - Video streaming requires significant bandwidth.
   - Try reducing the window size with the `-windowX` and `-windowY` flags.

3. **Restart the application:**
   - Close and reopen go-scout.
   - If the issue persists, restart the robot as well.

### Poor video quality

**Symptoms:**

- Video is pixelated or laggy
- Frame rate is low

**Possible solutions:**

1. **Check network connection:**

   - Ensure you have a strong Wi-Fi signal or use a wired connection if possible.
   - Reduce other network traffic during operation.

2. **Adjust window size:**
   - Try using a smaller window size with the `-windowX` and `-windowY` flags.

## Robot Control Issues

### Robot moves too fast or too slow

**Symptoms:**

- Difficult to control the robot precisely
- Robot moves unexpectedly

**Possible solutions:**

1. **Adjust speed settings:**

   - Use the left and right bumpers (controller) or O/P keys (keyboard) to adjust the speed.
   - The default speed can be modified in the `forwardSpeed` variable in `main.go`.

2. **Check surface conditions:**
   - The robot may behave differently on different surfaces.
   - Smooth, flat surfaces provide the best control experience.

### Robot doesn't return to charging station

**Symptoms:**

- Robot doesn't respond to the "return home" command (H key)
- Error messages when trying to use the `scoutGoHome()` function

**Possible solutions:**

1. **Check charging station setup:**

   - Ensure the charging station is properly set up and powered on.
   - The robot needs to know the location of the charging station.

2. **Check ROS service availability:**
   - The `/nav_low_bat` service must be available on the robot.
   - Use a ROS service list tool to verify the service exists.

## Application Issues

### Application crashes

**Symptoms:**

- Application suddenly closes
- Error messages in the terminal

**Possible solutions:**

1. **Check error messages:**

   - Run the application with the `-v` flag to enable verbose logging.
   - Look for specific error messages that might indicate the cause.

2. **Check system resources:**

   - Ensure your computer has sufficient memory and CPU resources.
   - Close other resource-intensive applications.

3. **Update dependencies:**
   - Make sure you're using the correct versions of all dependencies.
   - Rebuild the application with the latest dependencies.

## Getting Additional Help

If you continue to experience issues not covered in this guide:

1. **Check the GitHub repository:**

   - Look for open issues that might describe your problem.
   - Check for recent updates or patches.

2. **Create a new issue:**

   - Provide detailed information about your problem.
   - Include error messages, system information, and steps to reproduce the issue.

3. **Contact the developers:**
   - Reach out to the project maintainers for assistance.
