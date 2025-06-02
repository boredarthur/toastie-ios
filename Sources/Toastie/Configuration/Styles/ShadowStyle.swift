//===--- ShadowStyle.swift -----------------------------------------===//

import SwiftUI

/// Shadow configuration for toasts
public enum ShadowStyle: Hashable {
    case disabled
    case enabled(radius: CGFloat = 4, opacity: Double = 0.1, offset: CGPoint = CGPoint(x: 0, y: 2))
    
    /// Default shadow style
    public static let `default`: ShadowStyle = .enabled()
    
    /// Subtle shadow
    public static let subtle: ShadowStyle = .enabled(radius: 2, opacity: 0.05, offset: CGPoint(x: 0, y: 1))
    
    /// Strong shadow
    public static let strong: ShadowStyle = .enabled(radius: 8, opacity: 0.2, offset: CGPoint(x: 0, y: 4))
}
