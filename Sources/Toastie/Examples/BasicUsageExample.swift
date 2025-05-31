//===--- BasicUsageEaxmple.swift -----------------------------------------===//

import SwiftUI

struct BasicUsageExample: View {
    @State private var toastStatus = ToastStatus.dismissed
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Basic Toast Examples")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(spacing: 16) {
                Button {
                    toastStatus = .init(success: "File saved successfully!")
                } label: {
                    Label("Show Success", systemImage: "checkmark.circle.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
                
                Button {
                    toastStatus = .init(error: "Upload failed")
                } label: {
                    Label("Show Error", systemImage: "xmark.circle.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                
                Button {
                    toastStatus = .init(warning: "Storage almost full")
                } label: {
                    Label("Show Warning", systemImage: "exclamationmark.triangle.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
                
                Button {
                    toastStatus = .init(info: "3 new messages")
                } label: {
                    Label("Show Info", systemImage: "info.circle.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
            }
            
            Spacer()
        }
        .padding()
        .toast(status: $toastStatus)
    }
}

#Preview {
    BasicUsageExample()
}
