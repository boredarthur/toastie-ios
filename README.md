# Toastie 🍞

A modern, flexible, and beautiful toast notification system for SwiftUI.

![Swift](https://img.shields.io/badge/Swift-5.10+-orange.svg)
![iOS](https://img.shields.io/badge/iOS-17.0+-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## Features

✨ **Modern API** - Clean and intuitive `ToastStatus` binding for state management  
🎨 **Customizable Themes** - Built-in themes (default, vibrant, subtle) or create your own  
🎯 **Multiple Toast Types** - Error, success, warning, info, and custom  
📐 **Text Alignment** - Configure text alignment (leading, center, trailing) for perfect layouts  
🎮 **Interactive** - Support for action buttons and gesture-based dismissal  
📍 **Flexible Positioning** - Top, bottom, center, or custom positions  
📱 **Haptic Feedback** - Native haptic feedback support  
🎭 **Custom Content** - Create completely custom toast views  
🚀 **Smooth Animations** - Beautiful spring animations with customizable transitions  
📦 **Queue Support** - Display multiple toasts in sequence  
🏗️ **Registration System** - Pre-register toasts for reuse across your app

## Installation

### Swift Package Manager

Add Toastie to your project via Swift Package Manager:

1. In Xcode, go to **File > Add Package Dependencies...**
2. Enter the repository URL: `https://github.com/boredarthur/toastie-ios.git`
3. Select version **1.0.1** or later
4. Click **Add Package**

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/boredarthur/toastie-ios.git", from: "1.0.1")
]
```

## Usage

### Basic Usage

The simplest way to use Toastie is with the `ToastStatus` binding:

```swift
import SwiftUI
import Toastie

struct ContentView: View {
    @State private var toastStatus = ToastStatus.dismissed
    
    var body: some View {
        VStack {
            Button("Show Success") {
                toastStatus = .init(success: "File saved successfully!")
            }
            
            Button("Show Error") {
                toastStatus = .init(error: "Upload failed")
            }
        }
        .toast(status: $toastStatus)
    }
}
```

### Toast Types

Toastie provides convenient initializers for common toast types:

```swift
// Success toast
toastStatus = .init(success: "Operation completed!")

// Error toast
toastStatus = .init(error: "Something went wrong")

// Warning toast
toastStatus = .init(warning: "Storage almost full")

// Info toast
toastStatus = .init(info: "3 new messages")
```

### Toast with Action Buttons

Add interactive buttons to your toasts for undo operations or quick actions:

```swift
toastStatus = .init(
    toast: .warning(
        "Item deleted",
        duration: 5.0,
        buttons: [
            ToastButton("Undo") {
                // Restore the item
                items.append(deletedItem)
                toastStatus = .dismissed
            }
        ]
    )
)
```

### Text Alignment

Configure how text is aligned within your toasts:

```swift
// Center-aligned toast
.toast(status: $toastStatus, configuration: ToastConfiguration(textAlignment: .center))
```

### Custom Toast Content

Create completely custom toast views for unique scenarios:

```swift
// Loading toast
toastStatus = .init(
    toast: .custom(position: .center, duration: 3.0) {
        HStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
            Text("Processing...")
                .foregroundColor(.white)
        }
        .padding()
        .background(Capsule().fill(Color.black.opacity(0.8)))
    }
)

// Achievement toast
toastStatus = .init(
    toast: .custom(position: .top, duration: 4.0) {
        HStack {
            Image(systemName: "trophy.fill")
                .font(.system(size: 30))
                .foregroundColor(.yellow)
            
            VStack(alignment: .leading) {
                Text("Achievement Unlocked!")
                    .font(.headline)
                    .foregroundColor(.white)
                Text("You've completed 10 tasks")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .padding()
        .background(
            LinearGradient(
                colors: [.purple, .pink],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(16)
    }
)
```

### Custom Themes

Customize the appearance of your toasts with themes:

```swift
// Use built-in themes
.toast(status: $toastStatus, configuration: ToastConfiguration(theme: .vibrant))

// Create a custom theme
let customTheme = ToastTheme(
    errorColors: .gradient([.red, .pink]),
    successColors: .gradient([.green, .mint]),
    messageFont: .headline,
    cornerRadius: 20,
    shadow: .strong,
    iconSize: 24
)

.toast(
    status: $toastStatus, 
    configuration: ToastConfiguration(theme: customTheme)
)

// Disable shadows completely
let minimalTheme = ToastTheme(
    errorColors: .solid(.red),
    successColors: .solid(.green),
    shadow: .disabled
)

// Toast without icon
toastStatus = .init(
    toast: .info("Clean message", icon: .none)
)
```

### Advanced Configuration

Fine-tune toast behavior with configuration options:

```swift
let config = ToastConfiguration(
    theme: .vibrant,
    defaultDuration: 3.0,
    tapToDismiss: true,
    swipeToDismiss: true,
    textAlignment: .center,
    animation: .spring(response: 0.3, dampingFraction: 0.6),
    maxWidth: 400,
    horizontalPadding: 20
)

.toast(status: $toastStatus, configuration: config)
```

### Toast Registration

Pre-register toasts for consistent use across your app:

```swift
// Register a toast
Toast.register(id: "networkError") {
    .error("No internet connection", icon: .systemImage("wifi.slash"))
}

// Use the registered toast
if let toast = Toast.from(id: "networkError") {
    toastStatus = .init(toast: toast)
}
```

### Legacy API Support

Toastie also supports the traditional single toast binding approach:

```swift
@State private var toast: Toast?

// Show toast
toast = .success("Saved!")

// In view
.toast(item: $toast)
```

## Video Examples

🎬 **Basic Toast Types**  
![Basic Toast Types](https://media3.giphy.com/media/v1.Y2lkPTc5MGI3NjExeTdyY3FscGIycW1pN2Q3ZXh0ajFqZXZsZXlsdnRjeDF1ZHF3Znh4dCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/FLZvS3PVfgSLeujJ5y/giphy.gif)

🎬 **Interactive Toasts**  
![Interactive Toasts](https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExZG84Mjg4bngybXhjNG1mMXp5eTRmMmdmdDVjMG53c3l4MjRyNXRnbyZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/ZA3Fl9xOEnddF5BOLT/giphy.gif)

🎬 **Custom Content**  
![Custom Content](https://media1.giphy.com/media/v1.Y2lkPTc5MGI3NjExcmZvY3YwZzRhdmh0ZG0xNHU0cGhybWRoMnI1ams0MmF6dGFlYmQzZCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/oySzjc4vn7dQpuh3hv/giphy.gif)

🎬 **Theme Variations**  
![Toast Themes](https://media1.giphy.com/media/v1.Y2lkPTc5MGI3NjExMWhka2duYnZuNWE0YW95MmdiMm1xMjBteGFsYjFpbDVienoyb3ppNiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/Zo1uWtMWaptCWl8vBQ/giphy.gif)

## Requirements

- iOS 17.0+
- Swift 5.10+
- Xcode 15.0+

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

Toastie is available under the MIT license. See the LICENSE file for more info.

---

Made with ❤️ by boredarthur
