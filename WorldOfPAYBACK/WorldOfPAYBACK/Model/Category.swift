//
//  Category.swift
//  WorldOfPAYBACK
//
//  Created by Mohamed Fawzy on 23/04/2024.
//

import Foundation

struct Category: Equatable {
    let id: Int
    var name: String {
        String(id)
    }
}
