//
//  FailureView.swift
//  WorldOfPAYBACK
//
//  Created by Mohamed Fawzy on 23/04/2024.
//

import SwiftUI

struct FailureView: View {
    var message: String
    var onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Text(message)
                .font(.headline)
            Button("Retry", action: onRetry)
                .buttonStyle(RoundedButtonStyle())
        }
        .padding()
    }
}

#Preview {
    FailureView(message: "Error message here", onRetry: {})
}
