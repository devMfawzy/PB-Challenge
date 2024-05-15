//
//  RoundedButtonStyle.swift
//  WorldOfPAYBACK
//
//  Created by Mohamed Fawzy on 01/05/2024.
//

import SwiftUI

struct RoundedButtonStyle: ButtonStyle {
    var cornerRadius: CGFloat = 10
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(10)
            .background(configuration.isPressed ? .secondary : Color.secondary.opacity(0.7) )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}
