# Contributing to go-scout

Thank you for your interest in contributing to go-scout! This document provides guidelines and instructions for contributing to the project.

## Getting Started

1. **Fork the repository**: Start by forking the repository to your GitHub account.

2. **Clone the repository**: Clone your fork to your local machine.

   ```
   git clone https://github.com/YOUR-USERNAME/go-scout.git
   cd go-scout
   ```

3. **Install dependencies**: Make sure you have Go installed (version 1.19 or later). Use `uv` to manage dependencies.

   ```
   uv sync
   ```

4. **Build the project**: Build the project to make sure everything is working.
   ```
   go build
   ```

## Development Workflow

1. **Create a branch**: Create a new branch for your feature or bug fix.

   ```
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**: Implement your feature or bug fix.

3. **Test your changes**: Make sure your changes work as expected.

   ```
   go test ./...
   ```

4. **Commit your changes**: Commit your changes with a descriptive commit message.

   ```
   git commit -m "Add feature: your feature description"
   ```

5. **Push your changes**: Push your changes to your fork.

   ```
   git push origin feature/your-feature-name
   ```

6. **Create a pull request**: Create a pull request from your fork to the main repository.

## Code Style

- Follow the [Go Code Review Comments](https://github.com/golang/go/wiki/CodeReviewComments) for style guidance.
- Use `gofmt` to format your code before committing.
- Write clear, concise comments for functions and complex code sections.

## Project Structure

The project is organized as follows:

- `main.go`: Entry point and main application logic.
- `lights.go`: Light control functionality.
- `gohome.go`: Return-to-home functionality.
- `go.mod` and `go.sum`: Dependency management.

## Adding New Features

When adding new features, consider the following:

### 1. Adding Support for Other Controllers

To add support for other controllers:

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

## Testing

- Write tests for new functionality.
- Make sure existing tests pass before submitting a pull request.
- Test your changes with both keyboard and controller input if applicable.

## Documentation

- Update the README.md file with any new features or changes to existing functionality.
- Update the CODE_DOCUMENTATION.md file with details about new code.
- Add comments to your code to explain complex logic.

## Submitting a Pull Request

When submitting a pull request:

1. Provide a clear, descriptive title.
2. Describe the changes you've made and why they're needed.
3. Mention any related issues (e.g., "Fixes #123").
4. Make sure all tests pass.
5. Update documentation as needed.

## Getting Help

If you have questions or need help, you can:

- Open an issue on GitHub.
- Reach out to the project maintainers.

Thank you for contributing to go-scout!
