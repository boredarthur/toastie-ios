//===--- Toast.swift ----------------------------------------------===//

import Foundation
import SwiftUI

/// Toast status management
public struct ToastStatus: Equatable, Identifiable {
    public static var dismissed: Self { .init() }
    
    public var id: UUID
    public var status: Status
    
    public enum Status: Equatable {
        case presented(Toast)
        case dismissed
    }
    
    // MARK: - Convenience Initializers
    
    /// Initialize with a registered toast identified by a unique ID.
    public init(id: some Hashable) {
        if let toast = Toast.from(id: id) {
            self = .init(toast: toast)
        } else {
            self = .dismissed
        }
    }
    
    /// Initialize with error message
    public init(error: String?) {
        if let error, !error.isEmpty {
            self = .init(toast: .error(error))
        } else {
            self = .init()
        }
    }
    
    /// Initialize with success message
    public init(success: String?) {
        if let success, !success.isEmpty {
            self = .init(toast: .success(success))
        } else {
            self = .init()
        }
    }
    
    /// Initialize with warning message
    public init(warning: String?) {
        if let warning, !warning.isEmpty {
            self = .init(toast: .warning(warning))
        } else {
            self = .init()
        }
    }
    
    /// Initialize with info message
    public init(info: String?) {
        if let info, !info.isEmpty {
            self = .init(toast: .info(info))
        } else {
            self = .init()
        }
    }
    
    /// Initialize with toast
    public init(toast: Toast) {
        id = toast.id
        status = .presented(toast)
    }
     
    /// Initialize dismissed status
    public init() {
        id = UUID()
        status = .dismissed
    }
}

/// Core toast model
public struct Toast: Equatable, Identifiable {
    public let id: UUID = UUID()
    public var type: ToastType
    public var message: String
    public var icon: ToastIcon?
    public var position: ToastPosition
    public var duration: TimeInterval
    public var haptic: HapticFeedback?
    public var dismissible: Bool
    public var buttons: [ToastButton]
    
    /// For custom content
    internal var customContent: AnyView?
    
    public init(
        type: ToastType,
        message: String,
        icon: ToastIcon? = nil,
        position: ToastPosition = .top,
        duration: TimeInterval = 2.0,
        haptic: HapticFeedback? = nil,
        dismissible: Bool = true,
        buttons: [ToastButton] = []
    ) {
        self.type = type
        self.message = message
        self.icon = icon ?? type.defaultIcon
        self.position = position
        self.duration = duration
        self.haptic = haptic ?? type.defaultHaptic
        self.dismissible = dismissible
        self.buttons = buttons
    }
    
    // MARK: - Equatable
    
    public static func == (lhs: Toast, rhs: Toast) -> Bool {
        lhs.id == rhs.id &&
        lhs.type == rhs.type &&
        lhs.message == rhs.message &&
        lhs.icon == rhs.icon &&
        lhs.position == rhs.position &&
        lhs.duration == rhs.duration &&
        lhs.haptic == rhs.haptic &&
        lhs.dismissible == rhs.dismissible &&
        lhs.buttons == rhs.buttons
    }
}

// MARK: - Convenience Factory Methods
public extension Toast {
    /// Creates an error toast
    static func error(
        _ message: String,
        icon: ToastIcon? = nil,
        position: ToastPosition = .top,
        duration: TimeInterval = 2.0,
        buttons: [ToastButton] = []
    ) -> Toast {
        Toast(
            type: .error,
            message: message,
            icon: icon,
            position: position,
            duration: duration,
            buttons: buttons
        )
    }
    
    /// Creates a success toast
    static func success(
        _ message: String,
        icon: ToastIcon? = nil,
        position: ToastPosition = .top,
        duration: TimeInterval = 2.0,
        buttons: [ToastButton] = []
    ) -> Toast {
        Toast(
            type: .success,
            message: message,
            icon: icon,
            position: position,
            duration: duration,
            buttons: buttons
        )
    }
    
    /// Creates a warning toast
    static func warning(
        _ message: String,
        icon: ToastIcon? = nil,
        position: ToastPosition = .top,
        duration: TimeInterval = 2.0,
        dismissible: Bool = true,
        buttons: [ToastButton] = []
    ) -> Toast {
        Toast(
            type: .warning,
            message: message,
            icon: icon,
            position: position,
            duration: duration,
            dismissible: dismissible,
            buttons: buttons
        )
    }
    
    /// Creates an info toast
    static func info(
        _ message: String,
        icon: ToastIcon? = nil,
        position: ToastPosition = .top,
        duration: TimeInterval = 2.0,
        dismissible: Bool = true,
        buttons: [ToastButton] = []
    ) -> Toast {
        Toast(
            type: .info,
            message: message,
            icon: icon,
            position: position,
            duration: duration,
            dismissible: dismissible,
            buttons: buttons
        )
    }
    
    /// Creates a custom toast with SwiftUI content
    static func custom<Content: View>(
        position: ToastPosition = .top,
        duration: TimeInterval = 2.0,
        haptic: HapticFeedback? = nil,
        dismissible: Bool = true,
        @ViewBuilder content: () -> Content
    ) -> Toast {
        var toast = Toast(
            type: .custom,
            message: "",
            position: position,
            duration: duration,
            haptic: haptic,
            dismissible: dismissible
        )
        
        toast.customContent = AnyView(content())
        return toast
    }
}

// MARK: - Supporting Types

/// Icon representation for toasts
public enum ToastIcon: Equatable {
    case systemImage(String)
    case image(String)
    case view(AnyView)
    
    public static func == (lhs: ToastIcon, rhs: ToastIcon) -> Bool {
        switch (lhs, rhs) {
        case (.systemImage(let lhsName), .systemImage(let rhsName)):
            return lhsName == rhsName
        case (.image(let lhsName), .image(let rhsName)):
            return lhsName == rhsName
        case (.view, .view):
            return true
        default:
            return false
        }
    }
}

/// Haptic feedback types
public enum HapticFeedback: Equatable {
    case success
    case warning
    case error
    case light
    case medium
    case heavy
}
