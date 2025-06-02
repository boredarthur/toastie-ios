//===--- CustomThemeExample.swift -----------------------------------------===//

import SwiftUI

struct CustomThemeExample: View {
    @State private var toastStatus = ToastStatus.dismissed
    @State private var selectedTheme: ThemeOption = .default
    
    enum ThemeOption: String, CaseIterable {
        case `default` = "Default"
        case vibrant = "Vibrant"
        case subtle = "Subtle"
        case custom = "Custom"
        
        var configuration: ToastConfiguration {
            switch self {
            case .default:
                return ToastConfiguration()
            case .vibrant:
                return ToastConfiguration(theme: .vibrant)
            case .subtle:
                return ToastConfiguration(theme: .subtle)
            case .custom:
                return ToastConfiguration(
                    theme: ToastTheme(
                        errorColors: .gradient([.red, .pink]),
                        successColors: .gradient([.green, .mint]),
                        warningColors: .gradient([.orange, .yellow]),
                        infoColors: .gradient([.blue, .purple]),
                        messageFont: .callout,
                        cornerRadius: 20,
                        shadow: .disabled,
                        iconSize: 24
                    )
                )
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Custom Theme Examples")
                .font(.title2)
                .fontWeight(.bold)
            
            // Theme Picker
            Picker("Theme", selection: $selectedTheme) {
                ForEach(ThemeOption.allCases, id: \.self) { theme in
                    Text(theme.rawValue).tag(theme)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            // Toast Buttons
            VStack(spacing: 12) {
                Button("Success Toast") {
                    toastStatus = .init(success: "Looking good! \(selectedTheme.rawValue)")
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
                
                Button("Error Toast") {
                    toastStatus = .init(error: "Something went wrong \(selectedTheme.rawValue)")
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                
                Button("Warning Toast") {
                    toastStatus = .init(warning: "Be careful! \(selectedTheme.rawValue)")
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
                
                Button("Info Toast") {
                    toastStatus = .init(info: "Did you know? \(selectedTheme.rawValue)")
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding(.vertical)
        .toast(status: $toastStatus, configuration: selectedTheme.configuration)
    }
}

#Preview {
    CustomThemeExample()
}
