//===--- ToastView.swift ------------------------------------------===//

import SwiftUI

struct ToastView: View {
    let toast: Toast
    let configuration: ToastConfiguration
    let onDismiss: () -> Void
    
    @State private var dragOffset: CGSize = .zero
    @GestureState private var isDragging: Bool = false
    
    var theme: ToastTheme {
        configuration.theme
    }
    
    var body: some View {
        Group {
            if let customContent = toast.customContent {
                customContent
            } else {
                standardToastContent
            }
        }
        .offset(dragOffset)
        .gesture(dismissGestures)
        .onTapGesture {
            if configuration.tapToDismiss && toast.dismissible {
                onDismiss()
            }
        }
    }
}

// MARK: - standardToastContent
private extension ToastView {
    var standardToastContent: some View {
        HStack(spacing: 12) {
            // Icon
            if let icon = toast.icon {
                iconView(icon)
                    .foregroundStyle(theme.colorStyle(for: toast.type).foregroundColor)
                    .font(.system(size: theme.iconSize))
            }
            
            // Text Content
            Text(toast.message)
                .font(theme.messageFont)
                .foregroundStyle(theme.colorStyle(for: toast.type).foregroundColor)
            
            Spacer()
            
            // Buttons
            if !toast.buttons.isEmpty {
                HStack(spacing: 8) {
                    ForEach(toast.buttons, id: \.self) { button in
                        Button(action: button.action) {
                            Text(button.title)
                                .font(theme.buttonFont)
                        }
                        .buttonStyle(.plain)
                        .foregroundStyle(theme.colorStyle(for: toast.type).foregroundColor)
                    }
                }
            }
        }
        .padding(theme.padding)
        .frame(maxWidth: configuration.maxWidth)
        .background(
            theme.colorStyle(for: toast.type).background()
                .cornerRadius(theme.cornerRadius)
        )
        .shadow(
            color: .black.opacity(0.1),
            radius: theme.shadowRadius,
            x: 0,
            y: 2
        )
    }
}

// MARK: - iconView
private extension ToastView {
    @ViewBuilder
    func iconView(_ icon: ToastIcon) -> some View {
        switch icon {
        case .systemImage(let name):
            Image(systemName: name)
        case .image(let name):
            Image(name)
        case .view(let view):
            view
        }
    }
}

// MARK: - dismissGestures
private extension ToastView {
    var dismissGestures: some Gesture {
        DragGesture()
            .updating($isDragging) { _, state, _ in
                state = true
            }
            .onChanged { value in
                if configuration.swipeToDismiss && toast.dismissible {
                    dragOffset = value.translation
                }
            }
            .onEnded { value in
                let threshold: CGFloat = 100
                if abs(value.translation.width) > threshold || abs(value.translation.height) > threshold {
                    onDismiss()
                } else {
                    withAnimation(.spring()) {
                        dragOffset = .zero
                    }
                }
            }
    }
}
