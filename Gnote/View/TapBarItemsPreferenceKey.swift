//
//  TapBarItemsPreferenceKey.swift
//  Gnote
//
//  Created by alex on 25.04.2022.
//

import Foundation
import SwiftUI

struct TapBarItemsPreferenceKey: PreferenceKey {
    static var defaultValue: [TabBarItem] = []
    static func reduce(value: inout [TabBarItem], nextValue: () -> [TabBarItem]) {
        value += nextValue()
    }
}

struct  TabBarViewModifer: ViewModifier {
    @Binding var selection: TabBarItem
    let tab: TabBarItem
    func body(content: Content) -> some View {
        content
            .opacity(selection == tab ? 1.0 : 0.0)
            .preference(key: TapBarItemsPreferenceKey.self, value: [tab])
    }
}

extension View {
    func tabBarItem(tab: TabBarItem, selection: Binding<TabBarItem>) -> some View {
        modifier(TabBarViewModifer(tab: tab, selection: selection))
    }
}

