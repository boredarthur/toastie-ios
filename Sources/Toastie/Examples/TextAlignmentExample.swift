//===--- TextAlignmentExample.swift -----------------------------------------===//

import SwiftUI

struct TextAlignmentExample: View {
    @State private var toastStatus = ToastStatus.dismissed
    @State private var selectedAlignmentIndex = 0
    
    private let alignmentOptions: [(name: String, alignment: HorizontalAlignment)] = [
        ("Leading", .leading),
        ("Center", .center),
        ("Trailing", .trailing)
    ]
    
    private var selectedAlignment: HorizontalAlignment {
        alignmentOptions[selectedAlignmentIndex].alignment
    }
    
    private var selectedAlignmentName: String {
        alignmentOptions[selectedAlignmentIndex].name.lowercased()
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Text Alignment Examples")
                .font(.title2)
                .fontWeight(.bold)
            
            // Alignment Picker
            Picker("Text Alignment", selection: $selectedAlignmentIndex) {
                ForEach(0..<alignmentOptions.count, id: \.self) { index in
                    Text(alignmentOptions[index].name).tag(index)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            Text("Current alignment: \(selectedAlignmentName)")
                .font(.caption)
                .foregroundColor(.secondary)
            
            VStack(spacing: 16) {
                Button("Success Toast") {
                    toastStatus = .init(success: "This is a success message with \(selectedAlignmentName) alignment!")
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
                
                Button("Error Toast") {
                    toastStatus = .init(error: "This is an error message with \(selectedAlignmentName) alignment!")
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                
                Button("Warning with Action") {
                    toastStatus = .init(
                        toast: .warning(
                            "This is a warning message with \(selectedAlignmentName) alignment and action buttons!",
                            duration: 5.0,
                            buttons: [
                                ToastButton("Cancel") {
                                    toastStatus = .dismissed
                                },
                                ToastButton("Retry") {
                                    toastStatus = .init(success: "Retried successfully!")
                                }
                            ]
                        )
                    )
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
                
                Button("Warning without Action") {
                    toastStatus = .init(
                        toast: .warning(
                            "This is a warning message with \(selectedAlignmentName) alignment and no action buttons!",
                            duration: 5.0
                        )
                    )
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
                
                Button("Long Message") {
                    toastStatus = .init(info: "This is a very long informational message that spans multiple lines to demonstrate how text alignment works with longer content. The alignment should be clearly visible with this amount of text.")
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                
                Button("Info without Icon") {
                    toastStatus = .init(
                        toast: .info(
                            "This message has no icon to show pure text alignment",
                            icon: ToastIcon.none
                        )
                    )
                }
                .buttonStyle(.borderedProminent)
                .tint(.purple)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding(.vertical)
        .toast(
            status: $toastStatus,
            configuration: ToastConfiguration(textAlignment: selectedAlignment)
        )
    }
}

#Preview {
    TextAlignmentExample()
}
