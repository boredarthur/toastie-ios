//===--- ToastContainer.swift -------------------------------------===//

import SwiftUI

/// Container for displaying toasts
struct ToastContainer: View {
    let toasts: [Toast]
    let configuration: ToastConfiguration
    let onDismiss: (Toast) -> Void
    
    var body: some View {
        GeometryReader { geometry in 
            ZStack {
                ForEach(toasts) { toast in
                    ToastView(
                        toast: toast,
                        configuration: configuration,
                        onDismiss: { onDismiss(toast) }
                    )
                    .position(for: toast.position, in: geometry)
                }
            }
        }
        .allowsHitTesting(false)
    }
}

private extension View {
    func position(for position: ToastPosition, in geometry: GeometryProxy) -> some View {
        self.position(
            x: geometry.size.width / 2 + position.offset.x,
            y: {
                switch position {
                case .top:
                    return geometry.safeAreaInsets.top + 50
                case .bottom:
                    return geometry.size.height - geometry.safeAreaInsets.bottom - 50
                case .center:
                    return geometry.size.height / 2
                case .custom:
                    return geometry.size.height / 2 + position.offset.y
                }
            }()
        )
    }
}
