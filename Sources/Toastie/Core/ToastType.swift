//===--- ToastType.swift ------------------------------------------===//

import SwiftUI

/// Predefined toast style types
public enum ToastType: String, CaseIterable {
    case error
    case success
    case warning
    case info
    case custom
    
    /// Default icon for each type
    var defaultIcon: ToastIcon? {
        switch self {
        case .error:
            return .systemImage("xmark.circle.fill")
        case .success:
            return .systemImage("checkmark.circle.fill")
        case .warning:
            return .systemImage("exclamationmark.triangle.fill")
        case .info:
            return .systemImage("info.circle.fill")
        case .custom:
            return nil
        }
    }
    
    /// Default haptic for each type
    var defaultHaptic: HapticFeedback? {
        switch self {
        case .error: .error
        case .success: .success
        case .warning: .warning
        case .info, .custom: nil
        }
    }
}
