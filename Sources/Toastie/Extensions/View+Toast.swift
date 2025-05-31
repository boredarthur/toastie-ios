//===--- View+Toast.swift -----------------------------------------===//

import SwiftUI

public extension View {
    /// Display toast using ToastStatus binding
    func toast(status: Binding<ToastStatus>) -> some View {
        self.modifier(
            ToastStatusModifier(
                status: status,
                configuration: ToastConfiguration()
            )
        )
    }
    
    /// Display toast using ToastStatus binding with custom configuration
    func toast(
        status: Binding<ToastStatus>,
        configuration: ToastConfiguration
    ) -> some View {
        self.modifier(
            ToastStatusModifier(
                status: status,
                configuration: configuration
            )
        )
    }
    
    /// Display a single toast (legacy API)
    func toast(
        item: Binding<Toast?>,
        configuration: ToastConfiguration = ToastConfiguration()
    ) -> some View {
        self.modifier(
            ToastModifier(
                toast: item,
                configuration: configuration
            )
        )
    }
    
    /// Display multiple toasts
    func toast(
        items: Binding<[Toast]>,
        configuration: ToastConfiguration = ToastConfiguration()
    ) -> some View {
        self.modifier(
            ToastQueueModifier(
                toasts: items,
                configuration: configuration
            )
        )
    }
}
