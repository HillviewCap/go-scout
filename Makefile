# Makefile for go-scout

# Variables
BINARY_NAME=scout
GO=go
UV=uv
GOFLAGS=-v
BUILD_DIR=./build
MAIN_FILE=main.go

# Default robot IP and port
ROBOT_IP=192.168.1.224
ROBOT_PORT=11311

# Default window size
WINDOW_X=1280
WINDOW_Y=720

# Default control scheme
CONTROL=keyboard

# Colors
CYAN=\033[36m
RESET=\033[0m

.PHONY: all build clean run test deps help check

# Default target
all: build

# Build the application
build:
	@echo "$(CYAN)Building $(BINARY_NAME)...$(RESET)"
	@$(GO) build $(GOFLAGS) -o $(BINARY_NAME) $(MAIN_FILE)

# Clean build artifacts
clean:
	@echo "$(CYAN)Cleaning...$(RESET)"
	@rm -f $(BINARY_NAME)
	@rm -rf $(BUILD_DIR)

# Run the application
run: build
	@echo "$(CYAN)Running $(BINARY_NAME)...$(RESET)"
	@./$(BINARY_NAME) -h "$(ROBOT_IP):$(ROBOT_PORT)" -windowX $(WINDOW_X) -windowY $(WINDOW_Y) -c $(CONTROL)

# Run with keyboard controls
keyboard: build
	@echo "$(CYAN)Running $(BINARY_NAME) with keyboard controls...$(RESET)"
	@./$(BINARY_NAME) -h "$(ROBOT_IP):$(ROBOT_PORT)" -c keyboard

# Run with joystick controls
joystick: build
	@echo "$(CYAN)Running $(BINARY_NAME) with joystick controls...$(RESET)"
	@./$(BINARY_NAME) -h "$(ROBOT_IP):$(ROBOT_PORT)" -c joystick

# Run tests
test:
	@echo "$(CYAN)Running tests...$(RESET)"
	@$(GO) test ./...

# Install dependencies
deps:
	@echo "$(CYAN)Installing dependencies...$(RESET)"
	@$(UV) sync

# Run system check
check:
	@echo "$(CYAN)Running system check...$(RESET)"
	@bash tools/system_check.sh

# Build for multiple platforms
build-all: clean
	@echo "$(CYAN)Building for multiple platforms...$(RESET)"
	@mkdir -p $(BUILD_DIR)
	
	@echo "$(CYAN)Building for Linux (amd64)...$(RESET)"
	@GOOS=linux GOARCH=amd64 $(GO) build $(GOFLAGS) -o $(BUILD_DIR)/$(BINARY_NAME)-linux-amd64 $(MAIN_FILE)
	
	@echo "$(CYAN)Building for Windows (amd64)...$(RESET)"
	@GOOS=windows GOARCH=amd64 $(GO) build $(GOFLAGS) -o $(BUILD_DIR)/$(BINARY_NAME)-windows-amd64.exe $(MAIN_FILE)
	
	@echo "$(CYAN)Building for macOS (amd64)...$(RESET)"
	@GOOS=darwin GOARCH=amd64 $(GO) build $(GOFLAGS) -o $(BUILD_DIR)/$(BINARY_NAME)-darwin-amd64 $(MAIN_FILE)
	
	@echo "$(CYAN)Building for macOS (arm64)...$(RESET)"
	@GOOS=darwin GOARCH=arm64 $(GO) build $(GOFLAGS) -o $(BUILD_DIR)/$(BINARY_NAME)-darwin-arm64 $(MAIN_FILE)

# Show help
help:
	@echo "$(CYAN)go-scout Makefile Help$(RESET)"
	@echo "Available targets:"
	@echo "  all        : Build the application (default)"
	@echo "  build      : Build the application"
	@echo "  clean      : Remove build artifacts"
	@echo "  run        : Build and run the application"
	@echo "  keyboard   : Run with keyboard controls"
	@echo "  joystick   : Run with joystick controls"
	@echo "  test       : Run tests"
	@echo "  deps       : Install dependencies using uv"
	@echo "  check      : Run system check"
	@echo "  build-all  : Build for multiple platforms"
	@echo "  help       : Show this help message"
	@echo ""
	@echo "Environment variables:"
	@echo "  ROBOT_IP   : Robot IP address (default: $(ROBOT_IP))"
	@echo "  ROBOT_PORT : Robot port (default: $(ROBOT_PORT))"
	@echo "  WINDOW_X   : Window width (default: $(WINDOW_X))"
	@echo "  WINDOW_Y   : Window height (default: $(WINDOW_Y))"
	@echo "  CONTROL    : Control scheme (default: $(CONTROL))"
	@echo ""
	@echo "Example usage:"
	@echo "  make run ROBOT_IP=192.168.1.100 WINDOW_X=1920 WINDOW_Y=1080 CONTROL=joystick"