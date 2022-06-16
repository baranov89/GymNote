//
//  TabBarItem.swift
//  Gnote
//
//  Created by alex on 25.04.2022.
//

import Foundation
import SwiftUI

enum TabBarItem: Hashable {

    case categoty, training, history
    
    var iconName: String {
        switch self {
        case .categoty: return "square.stack.3d.up"
        case .training: return "chart.bar"
        case .history: return "clock"
        }
    }
        
        var title: String {
            switch self {
            case .categoty: return "Categoty"
            case .training: return "Training"
            case .history: return "History"
            }
        }
    
    var colore: Color {
        switch self {
        case .categoty: return Color.red
        case .training: return Color.blue
        case .history: return Color.green
        }
    }
        
}
