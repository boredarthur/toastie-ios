//===--- ToastModifier.swift --------------------------------------===//

import SwiftUI
import Combine

/// Modifier for displaying toast using ToastStatus
struct ToastStatusModifier: ViewModifier {
    @Binding var status: ToastStatus
    let configuration: ToastConfiguration
    
    @State private var localToast: Toast?
    @State private var dismissTask: Task<Void, Never>?
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if case .presented(let toast) = status.status {
                    localToast = toast
                }
            }
            .onChange(of: status) { _, newStatus in
                updateToastPresentation(newStatus)
            }
            .overlay(alignment: positionAlignment) {
                if let toast = localToast {
                    ToastView(
                        toast: toast,
                        configuration: configuration,
                        onDismiss: {
                            dismissToast()
                        }
                    )
                    .padding(.horizontal, configuration.horizontalPadding)
                    .padding(edgePadding)
                    .transition(transition)
                    .zIndex(999)
                    .id(toast.id)
                    .onAppear {
                        scheduleAutoDismiss(for: toast)
                        performHaptic(toast.haptic)
                    }
                    .onDisappear {
                        dismissTask?.cancel()
                    }
                }
            }
            .animation(configuration.animation, value: localToast)
    }
}

// MARK: - updateToastPresentation
private extension ToastStatusModifier {
    func updateToastPresentation(_ newStatus: ToastStatus) {
        switch newStatus.status {
        case .presented(let toast):
            if localToast?.id != toast.id {
                localToast = toast
            }
            
        case .dismissed:
            if localToast != nil {
                localToast = nil
            }
        }
    }
}

// MARK: - positionAlignment
private extension ToastStatusModifier {
    var positionAlignment: Alignment {
        guard let toast = localToast else { return .top }
        return toast.position.alignment
    }
}

// MARK: - dismissToast
private extension ToastStatusModifier {
    func dismissToast() {
        dismissTask?.cancel()
        localToast = nil
        status = .dismissed
    }
}

// MARK: - edgePadding
private extension ToastStatusModifier {
    var edgePadding: EdgeInsets {
        guard let toast = localToast else { return EdgeInsets() }
        
        switch toast.position {
        case .top:
            return EdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 0)
        case .bottom:
            return EdgeInsets(top: 0, leading: 0, bottom: 50, trailing: 0)
        case .center:
            return EdgeInsets()
        case .custom(_, let offset):
            return EdgeInsets(top: offset.y, leading: offset.x, bottom: 0, trailing: 0)
        }
    }
}

// MARK: - scheduleAutoDismiss
private extension ToastStatusModifier {
    func scheduleAutoDismiss(for toast: Toast) {
        dismissTask?.cancel()
        
        if toast.duration > 0 {
            dismissTask = Task {
                try? await Task.sleep(nanoseconds: UInt64(toast.duration * 1_000_000_000))
                await MainActor.run {
                    dismissToast()
                }
            }
        }
    }
}

// MARK: - transition
private extension ToastStatusModifier {
    var transition: AnyTransition {
        guard let toast = localToast else { return .opacity }
        
        switch toast.position {
        case .top:
            return .asymmetric(
                insertion: .move(edge: .top).combined(with: .opacity),
                removal: .move(edge: .top).combined(with: .opacity)
            )
        case .bottom:
            return .asymmetric(
                insertion: .move(edge: .bottom).combined(with: .opacity),
                removal: .move(edge: .bottom).combined(with: .opacity)
            )
        case .center, .custom:
            return .opacity.combined(with: .scale(scale: 0.9))
        }
    }
}

// MARK: - performHaptic
private extension ToastStatusModifier {
    func performHaptic(_ feedback: HapticFeedback?) {
        #if os(iOS)
        guard let feedback else { return }
        
        switch feedback {
        case .success:
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .warning:
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
        case .error:
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        case .light:
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        case .medium:
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        case .heavy:
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        }
        #endif
    }
}

/// Modifier for displaying single toast
struct ToastModifier: ViewModifier {
    @Binding var toast: Toast?
    let configuration: ToastConfiguration
    
    @State private var dismissTask: Task<Void, Never>?
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: positionAlignment) {
                if let toast {
                    ToastView(
                        toast: toast,
                        configuration: configuration,
                        onDismiss: {
                            self.toast = nil
                        }
                    )
                    .padding(.horizontal, configuration.horizontalPadding)
                    .padding(edgePadding)
                    .transition(transition)
                    .zIndex(999)
                    .id(toast.id)
                    .onAppear {
                        scheduleAutoDismiss(for: toast)
                        performHaptic(toast.haptic)
                    }
                    .onDisappear {
                        dismissTask?.cancel()
                    }
                }
            }
            .animation(configuration.animation, value: toast)
    }
}

// MARK: - positionAlignment
private extension ToastModifier {
    var positionAlignment: Alignment {
        toast?.position.alignment ?? .top
    }
}

// MARK: - edgePadding
private extension ToastModifier {
    var edgePadding: EdgeInsets {
        guard let toast else { return EdgeInsets() }
        
        switch toast.position {
        case .top:
            return EdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 0)
        case .bottom:
            return EdgeInsets(top: 0, leading: 0, bottom: 50, trailing: 0)
        case .center:
            return EdgeInsets()
        case .custom(_, let offset):
            return EdgeInsets(top: offset.y, leading: offset.x, bottom: 0, trailing: 0)
        }
    }
}

// MARK: - transition
private extension ToastModifier {
    var transition: AnyTransition {
        guard let toast  else { return .opacity }
        
        switch toast.position {
        case .top:
            return .asymmetric(
                insertion: .move(edge: .top).combined(with: .opacity),
                removal: .move(edge: .top).combined(with: .opacity)
            )
        case .bottom:
            return .asymmetric(
                insertion: .move(edge: .bottom).combined(with: .opacity),
                removal: .move(edge: .bottom).combined(with: .opacity)
            )
        case .center, .custom:
            return .opacity.combined(with: .scale(scale: 0.9))
        }
    }
}

// MARK: - scheduleAutoDismiss
private extension ToastModifier {
    func scheduleAutoDismiss(for toast: Toast) {
        dismissTask?.cancel()
        
        if toast.duration > 0 {
            dismissTask = Task {
                try? await Task.sleep(nanoseconds: UInt64(toast.duration * 1_000_000_000))
                if !Task.isCancelled {
                    await MainActor.run {
                        self.toast = nil
                    }
                }
            }
        }
    }
}

// MARK: - performHaptic
private extension ToastModifier {
    func performHaptic(_ feedback: HapticFeedback?) {
        #if os(iOS)
        guard let feedback = feedback else { return }
        
        switch feedback {
        case .success:
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .warning:
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
        case .error:
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        case .light:
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        case .medium:
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        case .heavy:
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        }
        #endif
    }
}

/// Modifier for displaying multiple toasts
struct ToastQueueModifier: ViewModifier {
    @Binding var toasts: [Toast]
    let configuration: ToastConfiguration
    
    func body(content: Content) -> some View {
        content
            .overlay {
                ToastContainer(
                    toasts: toasts,
                    configuration: configuration,
                    onDismiss: { toast in
                        withAnimation(configuration.animation) {
                            toasts.removeAll { $0.id == toast.id }
                        }
                    }
                )
            }
    }
}
