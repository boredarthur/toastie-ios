//
//  SwiftUIView.swift
//  Toastie
//
//  Created by Arthur Zavolovych on 31.05.2025.
//

//===--- CustomContentExample.swift -----------------------------------------===//

import SwiftUI

struct CustomContentExample: View {
    @State private var toastStatus = ToastStatus.dismissed
    @State private var downloadProgress: Double = 0
    @State private var isDownloading = false
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Custom Toast Content")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(spacing: 16) {
                // Loading Toast
                Button("Show Loading") {
                    toastStatus = .init(
                        toast: .custom(position: .center, duration: 3.0) {
                            HStack(spacing: 16) {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(1.2)
                                Text("Processing...")
                                    .foregroundColor(.white)
                                    .font(.headline)
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 16)
                            .background(
                                Capsule()
                                    .fill(Color.black.opacity(0.8))
                            )
                        }
                    )
                }
                .buttonStyle(.borderedProminent)
                
                // Download Progress Toast
                Button("Start Download") {
                    startDownload()
                }
                .buttonStyle(.borderedProminent)
                .disabled(isDownloading)
                
                // Custom Styled Toast
                Button("Show Achievement") {
                    toastStatus = .init(
                        toast: .custom(position: .top, duration: 4.0) {
                            HStack(spacing: 12) {
                                Image(systemName: "trophy.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.yellow)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Achievement Unlocked!")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Text("You've completed 10 tasks")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                
                                Spacer()
                            }
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [.purple, .pink],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                            .shadow(color: .purple.opacity(0.3), radius: 10, y: 5)
                        }
                    )
                }
                .buttonStyle(.borderedProminent)
                .tint(.purple)
                
                // Notification Style Toast
                Button("Show Notification") {
                    toastStatus = .init(
                        toast: .custom(position: .top, duration: 5.0, dismissible: true) {
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: "person.crop.circle.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.blue)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("John Doe")
                                        .font(.headline)
                                    Text("Hey! How are you doing today? Let's catch up soon!")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .lineLimit(2)
                                    Text("2 min ago")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.ultraThinMaterial)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                        }
                    )
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
        .toast(status: $toastStatus)
    }
    
    private func startDownload() {
        isDownloading = true
        downloadProgress = 0
        
        toastStatus = .init(
            toast: .custom(position: .bottom, duration: 0) { // Duration 0 = manual dismiss
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "arrow.down.circle.fill")
                            .foregroundColor(.blue)
                        Text("Downloading...")
                            .font(.headline)
                        Spacer()
                        Text("\(Int(downloadProgress * 100))%")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    ProgressView(value: downloadProgress)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
                )
            }
        )
        
        // Simulate download
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            downloadProgress += 0.05
            
            if downloadProgress >= 1.0 {
                timer.invalidate()
                isDownloading = false
                toastStatus = .init(success: "Download completed!")
            }
        }
    }
}

#Preview {
    CustomContentExample()
}
