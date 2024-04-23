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
        VStack {
            Text(message)
                .font(.headline)
            Button(action: onRetry) {
                Text("Retry")
                    .padding()
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

#Preview {
    FailureView(message: "Error message here", onRetry: {})
}
