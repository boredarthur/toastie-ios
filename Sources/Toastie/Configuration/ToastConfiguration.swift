//===--- ToastConfiguration.swift ---------------------------------===//

import SwiftUI

/// Configuration for toast behavior and appearance
public struct ToastConfiguration {
    // MARK: - Theme
    public var theme: ToastTheme
    
    // MARK: - Behaviour
    public var defaultDuration: TimeInterval
    public var tapToDismiss: Bool = true
    public var swipeToDismiss: Bool = true
    
    // MARK: - Animation
    public var animation: Animation
    public var transaition: AnyTransition = .asymmetric(
        insertion: .move(edge: .top).combined(with: .opacity),
        removal: .move(edge: .top).combined(with: .opacity)
    )
    
    // MARK: - Layout
    public var maxWidth: CGFloat
    public var horizontalPadding: CGFloat
    
    public init(
        theme: ToastTheme = .default,
        defaultDuration: TimeInterval = 2.0,
        tapToDismiss: Bool = true,
        swipeToDismiss: Bool = true,
        animation: Animation = .spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0),
        maxWidth: CGFloat = 600,
        horizontalPadding: CGFloat = 16
    ) {
        self.theme = theme
        self.defaultDuration = defaultDuration
        self.tapToDismiss = tapToDismiss
        self.swipeToDismiss = swipeToDismiss
        self.animation = animation
        self.maxWidth = maxWidth
        self.horizontalPadding = horizontalPadding
    }
}
