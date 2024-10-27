//
//  Item.swift
//  ا
//
//  Created by Sumayah Alshehri on 24/04/1446 AH.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
