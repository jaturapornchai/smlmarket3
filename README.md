# SML Market

A Flutter application that supports both Windows and Web platforms, featuring a modern market/e-commerce interface.

## Features

- **Multi-platform support**: Runs on Windows desktop and Web browsers
- **Modern UI**: Clean and responsive Material Design 3 interface
- **Product showcase**: Grid layout displaying products with icons and pricing
- **Navigation**: Bottom navigation bar with Home and Profile sections
- **Search functionality**: App bar with search and shopping cart icons

## Getting Started

### Prerequisites

- Flutter SDK (3.32.4 or later)
- Dart (3.8.1 or later)
- For Windows: Visual Studio with C++ tools
- For Web: Any modern web browser

### Installation

1. Clone this repository or download the source code
2. Navigate to the project directory:
   ```bash
   cd smlmarket3
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```

### Running the Application

#### Web Platform
To run on web:
```bash
flutter run -d web-server --web-port 8080
```
Then open your browser to `http://localhost:8080`

#### Windows Platform
To run on Windows:
```bash
flutter run -d windows
```

### Building for Production

#### Web Build
```bash
flutter build web
```
The output will be in `build/web/` directory.

#### Windows Build
```bash
flutter build windows
```
The executable will be in `build/windows/x64/runner/Release/smlmarket3.exe`

### VS Code Integration

This project includes VS Code tasks and launch configurations:

- **Tasks**: Use Ctrl+Shift+P → "Tasks: Run Task" to access:
  - Flutter: Run on Web
  - Flutter: Run on Windows  
  - Flutter: Build Web
  - Flutter: Build Windows

- **Debug**: Use F5 or the Debug panel to run:
  - Flutter (Web)
  - Flutter (Windows)

## Project Structure

```
smlmarket3/
├── lib/
│   └── main.dart          # Main application code
├── web/                   # Web platform files
├── windows/               # Windows platform files
├── .vscode/               # VS Code configuration
│   ├── tasks.json         # Build and run tasks
│   └── launch.json        # Debug configurations
└── pubspec.yaml           # Project dependencies
```

## Sample Products

The app currently displays sample products including:
- Electronics (Laptop, Smartphone, Tablet)
- Audio devices (Headphones)
- Wearables (Smart Watch)
- Photography (Camera)

## Contributing

Feel free to submit issues and enhancement requests!

## License

This project is open source and available under the [MIT License](LICENSE).
