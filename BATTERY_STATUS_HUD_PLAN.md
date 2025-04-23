# Plan: Add Battery Status to HUD

This plan outlines the steps to integrate the robot's battery status into the go-scout application's Head-Up Display (HUD).

**1. Define the Battery Status Message Type**
- Create a new Go struct that matches the ROS message type for battery status. According to `API_DOCUMENTATION.md`, the topic is likely `/CoreNode/battery_status` and a suggested message type is `BatteryStatus` with `Level` (float32) and `Charging` (bool) fields. This struct should be defined in a relevant file, likely `main.go` or a new file if battery-related logic grows.

**2. Subscribe to the Battery Status ROS Topic**
- In the `main()` function (or an appropriate initialization function), create a new ROS subscriber using `goroslib`.
- Configure the subscriber to listen to the `/CoreNode/battery_status` topic.
- Specify a callback function that will be executed when a new battery status message is received.

**3. Implement the Battery Status Callback Function**
- Create a Go function that matches the signature required by the `goroslib` subscriber callback. This function will receive the `BatteryStatus` message as an argument.
- Inside this function, update global or shared variables (e.g., `batteryLevel float32`, `isCharging bool`) with the data from the received message. These variables will hold the latest battery status. Consider using mutexes or channels if concurrent access to these variables becomes a concern, although for a simple HUD display, direct assignment might suffice initially.

**4. Update the HUD Display in the `Draw()` Function**
- Modify the `Draw()` function in `main.go`, which is responsible for rendering the GUI and HUD.
- Access the global/shared variables holding the battery status (`batteryLevel`, `isCharging`).
- Use Ebiten's text drawing capabilities (e.g., `ebitenutil.DebugPrintAt` or more advanced text rendering if needed) to display the battery level and charging status on the screen. Format the output clearly, for example, "Battery: XX.X% (Charging)".

**Data Flow Diagram:**

```mermaid
graph TD
    A[Robot] --> B(ROS Master);
    B --> C[/CoreNode/battery_status Topic];
    C --> D[go-scout Application];
    D --> E[goroslib Subscriber];
    E --> F[onBatteryStatus Callback Function];
    F --> G[Global Battery Status Variables];
    G --> H[Draw Function (Ebiten)];
    H --> I[HUD Display];
```

**Explanation of Flow:**
- The Robot publishes battery status information to the ROS Master.
- The ROS Master makes this information available on the `/CoreNode/battery_status` topic.
- The go-scout application, through its `goroslib` subscriber, listens to this topic.
- When a message is published to the topic, the `onBatteryStatus` callback function in go-scout is triggered.
- The callback function updates global variables with the latest battery level and charging status.
- The `Draw` function, which runs continuously as part of the Ebiten game loop, reads these global variables.
- The `Draw` function renders the battery status information onto the HUD displayed in the application window.