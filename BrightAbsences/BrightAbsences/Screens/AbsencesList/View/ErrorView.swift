//
//  ErrorView.swift
//  BrightAbsences
//
//  Created by Umair on 07/08/2026.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
            Text("Something went wrong")
                .font(.headline)
            Text(message)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button {
                retryAction()
            } label: {
                Text("Try Again")
                        .padding(.horizontal, 30)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    ErrorView(message: "Something went wrong", retryAction: {
        print("Retry Tapped")
    })
}
