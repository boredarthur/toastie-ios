//===--- ColorStyle.swift -----------------------------------------===//

import SwiftUI

/// Color style options
public enum ColorStyle: Hashable {
    case solid(Color)
    case gradient([Color])
    
    @ViewBuilder
    func background() -> some View {
        switch self {
        case .solid(let color):
            color
        case .gradient(let colors):
            LinearGradient(
                colors: colors,
                startPoint: .leading,
                endPoint: .trailing
            )
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .solid(let color):
            return color.opacity(1) == Color.clear ? .primary : .white
        case .gradient:
            return .white
        }
    }
}
