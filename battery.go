package main

import (
	"github.com/aler9/goroslib"
	"github.com/aler9/goroslib/pkg/msg"
)

// BatteryStatus represents the battery status message from the robot
type BatteryStatus struct {
	msg.Package `ros:"roller_eye"`
	Level       float32 `ros:"level float32"`
	Charging    bool    `ros:"charging bool"`
}

// Global variables to store battery status
var (
	batteryLevel float32 = 0.0
	isCharging   bool    = false
)

// onBatteryStatus is called when a message is received from the CoreNode/battery_status topic
func onBatteryStatus(msg *BatteryStatus) {
	// Update the global variables with the latest battery status
	batteryLevel = msg.Level
	isCharging = msg.Charging
}

// subscribeToBatteryStatus sets up the subscription to the battery status topic
func subscribeToBatteryStatus(n *goroslib.Node) (*goroslib.Subscriber, error) {
	// Create a subscriber configuration
	batteryStatusConf := goroslib.SubscriberConf{
		Node:      n,
		Topic:     "/CoreNode/battery_status",
		Callback:  onBatteryStatus,
		QueueSize: 0,
	}

	// Create the subscriber
	sub, err := goroslib.NewSubscriber(batteryStatusConf)
	if err != nil {
		return nil, err
	}

	return sub, nil
}