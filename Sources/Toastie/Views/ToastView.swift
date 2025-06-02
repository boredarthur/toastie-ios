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
            leadingContent
            mainContent
            trailingContent
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
        Group {
            switch icon {
            case .systemImage(let name):
                Image(systemName: name)
            case .image(let name):
                Image(name)
            case .view(let view):
                view
            case .none:
                EmptyView()
            }
        }
        .foregroundStyle(theme.colorStyle(for: toast.type).foregroundColor)
        .font(.system(size: theme.iconSize))
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

// MARK: - Content Helpers
private extension ToastView {
    @ViewBuilder
    var leadingContent: some View {
        if configuration.textAlignment == .leading, let icon = toast.icon {
            iconView(icon)
        } else if shouldAddLeadingSpacer {
            Spacer()
        }
    }
    
    var mainContent: some View {
        VStack(alignment: configuration.textAlignment) {
            HStack {
                if configuration.textAlignment == .center, let icon = toast.icon {
                    iconView(icon)
                }
                
                Text(toast.message)
                    .font(theme.messageFont)
                    .foregroundStyle(theme.colorStyle(for: toast.type).foregroundColor)
                    .multilineTextAlignment(textAlignmentFromHorizontal(configuration.textAlignment))
                
                if configuration.textAlignment == .trailing, let icon = toast.icon {
                    iconView(icon)
                }
            }
            
            if !toast.buttons.isEmpty {
                buttonRow
            }
        }
    }
    
    @ViewBuilder
    var trailingContent: some View {
        if shouldAddTrailingSpacer {
            Spacer()
        }
    }
    
    var buttonRow: some View {
        HStack(spacing: 8) {
            if configuration.textAlignment == .trailing {
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
    
    var shouldAddLeadingSpacer: Bool {
        let hasIcon = toast.icon != nil
        
        switch configuration.textAlignment {
        case .center:
            return hasIcon
        case .trailing:
            return true
        default:
            return false
        }
    }
    
    var shouldAddTrailingSpacer: Bool {
        let hasButtons = !toast.buttons.isEmpty
        
        switch configuration.textAlignment {
        case .leading, .center:
            return !hasButtons
        default:
            return false
        }
    }
}

// MARK: - textAlignmentFromHorizontal
private extension ToastView {
    func textAlignmentFromHorizontal(_ horizontal: HorizontalAlignment) -> TextAlignment {
        switch horizontal {
        case .leading: return .leading
        case .center: return .center
        case .trailing: return .trailing
        default: return .leading
        }
    }
}
