//===--- ToastTheme.swift -----------------------------------------===//

import SwiftUI

/// Theme configuration for toast styles
public struct ToastTheme: Hashable {
    // MARK: - Colors
    public var errorColors: ColorStyle
    public var successColors: ColorStyle
    public var warningColors: ColorStyle
    public var infoColors: ColorStyle
    
    // MARK: - Typography
    public var messageFont: Font
    public var buttonFont: Font
    
    // MARK: - Layout
    public var padding: EdgeInsets
    public var cornerRadius: CGFloat
    public var shadow: ShadowStyle
    public var iconSize: CGFloat
    
    public init(
        errorColors: ColorStyle = .solid(.red),
        successColors: ColorStyle = .solid(.green),
        warningColors: ColorStyle = .solid(.orange),
        infoColors: ColorStyle = .solid(.blue),
        messageFont: Font = .headline,
        buttonFont: Font = .callout.weight(.medium),
        padding: EdgeInsets = .init(top: 12, leading: 16, bottom: 12, trailing: 16),
        cornerRadius: CGFloat = 12,
        shadow: ShadowStyle = .default,
        iconSize: CGFloat = 20
    ) {
        self.errorColors = errorColors
        self.successColors = successColors
        self.warningColors = warningColors
        self.infoColors = infoColors
        self.messageFont = messageFont
        self.buttonFont = buttonFont
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.shadow = shadow
        self.iconSize = iconSize
    }
    
    // MARK: - Hashable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(errorColors)
        hasher.combine(successColors)
        hasher.combine(warningColors)
        hasher.combine(infoColors)
        hasher.combine(messageFont)
        hasher.combine(buttonFont)
        hasher.combine(cornerRadius)
        hasher.combine(shadow)
        hasher.combine(iconSize)
    }
    
    // MARK: - Preset Themes
    
    /// Default theme with solid colors
    public static let `default` = ToastTheme()
    
    /// Vibrant theme with gradients
    public static let vibrant = ToastTheme(
        errorColors: .gradient([.red, .pink]),
        successColors: .gradient([.green, .mint]),
        warningColors: .gradient([.orange, .yellow]),
        infoColors: .gradient([.blue, .cyan])
    )
    
    /// Subtle theme with translucent colors
    public static let subtle = ToastTheme(
        errorColors: .solid(.red.opacity(0.1)),
        successColors: .solid(.green.opacity(0.1)),
        warningColors: .solid(.orange.opacity(0.1)),
        infoColors: .solid(.blue.opacity(0.1))
    )
    
    /// Get color style for toast type
    func colorStyle(for type: ToastType) -> ColorStyle {
        switch type {
        case .error:
            return errorColors
        case .success:
            return successColors
        case .warning:
            return warningColors
        case .info:
            return infoColors
        case .custom:
            return .solid(.gray) // Default for custom
        }
    }
}
