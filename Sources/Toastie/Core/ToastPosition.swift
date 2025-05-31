//===--- ToastPosition.swift --------------------------------------===//

import SwiftUI

/// Toast display position
public enum ToastPosition: Equatable {
    case top
    case bottom
    case center
    
    /// Custom position with alignment and offset
    case custom(alignment: Alignment, offset: CGPoint = .zero)
    
    var alignment: Alignment {
        switch self {
        case .top: .top
        case .bottom: .bottom
        case .center: .center
        case .custom(let alignment, _): alignment
        }
    }
    
    var offset: CGPoint {
        switch self {
        case .custom(_, let offset): offset
        default: .zero
        }
    }
}
