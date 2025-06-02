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
            if let icon = toast.icon,
               icon != ToastIcon.none,
               configuration.textAlignment == .leading {
                iconView(icon)
                    .foregroundStyle(theme.colorStyle(for: toast.type).foregroundColor)
                    .font(.system(size: theme.iconSize))
            }
            
            if configuration.textAlignment == .center || configuration.textAlignment == .trailing {
                if toast.icon != ToastIcon.none && configuration.textAlignment == .center {
                    Spacer()
                } else if configuration.textAlignment == .trailing {
                    Spacer()
                }
            }
            
            VStack(alignment: configuration.textAlignment == .leading ? .leading : 
                    configuration.textAlignment == .trailing ? .trailing : .center) {
                HStack {
                    if let icon = toast.icon, configuration.textAlignment == .center {
                        iconView(icon)
                            .foregroundStyle(theme.colorStyle(for: toast.type).foregroundColor)
                            .font(.system(size: theme.iconSize))
                    }
                    
                    Text(toast.message)
                        .font(theme.messageFont)
                        .foregroundStyle(theme.colorStyle(for: toast.type).foregroundColor)
                        .multilineTextAlignment(configuration.textAlignment == .leading ? .leading :
                                                    configuration.textAlignment == .trailing ? .trailing : .center)
                    
                    if let icon = toast.icon, configuration.textAlignment == .trailing {
                        iconView(icon)
                            .foregroundStyle(theme.colorStyle(for: toast.type).foregroundColor)
                            .font(.system(size: theme.iconSize))
                    }
                }
                
                if !toast.buttons.isEmpty {
                    HStack(spacing: 8) {
                        if configuration.textAlignment == .trailing || configuration.textAlignment == .center {
                            Spacer()
                        }
                        
                        ForEach(toast.buttons, id: \.self) { button in
                            Button(action: button.action) {
                                Text(button.title)
                                    .font(theme.buttonFont)
                            }
                            .buttonStyle(.plain)
                            .foregroundStyle(theme.colorStyle(for: toast.type).foregroundColor)
                        }
                        
                        if configuration.textAlignment == .leading {
                            Spacer()
                        }
                    }
                    .padding(.top, 4)
                }
            }
            
            if configuration.textAlignment == .leading || configuration.textAlignment == .center {
                if toast.buttons.isEmpty {
                    Spacer()
                }
            }
        }
        .padding(theme.padding)
        .frame(maxWidth: configuration.maxWidth)
        .background(
            theme.colorStyle(for: toast.type).background()
                .cornerRadius(theme.cornerRadius)
        )
        .applyShadow(theme.shadow)
    }
}

// MARK: - iconView
private extension ToastView {
    @ViewBuilder
    func iconView(_ icon: ToastIcon) -> some View {
        switch icon {
        case .none:
            EmptyView()
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

// MARK: - Handle Shadows
private extension View {
    @ViewBuilder
    func applyShadow(_ shadowStyle: ShadowStyle) -> some View {
        switch shadowStyle {
        case .disabled:
            self
        case .enabled(let radius, let opacity, let offset):
            self.shadow(
                color: .black.opacity(opacity),
                radius: radius,
                x: offset.x,
                y: offset.y
            )
        }
    }
}
