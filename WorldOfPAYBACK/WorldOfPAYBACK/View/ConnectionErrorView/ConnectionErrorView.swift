//
//  ConnectionErrorView.swift
//  WorldOfPAYBACK
//
//  Created by Mohamed Fawzy on 25/04/2024.
//

import SwiftUI

struct ConnectionErrorView: View {
    var title: LocalizedStringKey
    
    var body: some View {
        HStack {
            Image(systemName: "wifi.slash")
                .font(.largeTitle)
            Spacer()
            Text(title)
        }
        .padding(.horizontal)
        .padding(.vertical, 6)
        .background(.pink)
        .foregroundStyle(.background)
    }
}
