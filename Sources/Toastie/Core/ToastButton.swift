//===--- ToastButton.swift ----------------------------------------===//

import SwiftUI

/// Button configuration for  toast actions
public struct ToastButton: Identifiable, Hashable, Equatable {
    public let id: UUID = UUID()
    public let title: String
    public let role: ButtonRole?
    public let action: () -> Void
    
    public init(
        _ title: String,
        role: ButtonRole? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.role = role
        self.action = action
    }
    
    public static func == (lhs: ToastButton, rhs: ToastButton) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
