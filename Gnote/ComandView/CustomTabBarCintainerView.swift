//
//  CustomTabBarCintainerView.swift
//  Gnote
//
//  Created by alex on 24.04.2022.
//

import SwiftUI

struct CustomTabBarCintainerView<Content: View> : View {
    @ObservedObject var vm: CoreDataRelationShipViewModel
    
    @Binding var selection: TabBarItem
    @Binding var selectedMusleGroup: MuscleGroup?
    
    @Binding var showView: Bool
    @Binding var showSetView: Bool
    @Binding var showSetHistoryView: Bool
    
    @State var tabs: [TabBarItem] = [.categoty,.training,.history]
    
    let content: Content
    
    init(selection: Binding<TabBarItem>, showView: Binding<Bool>, showSetView: Binding<Bool>, vm: CoreDataRelationShipViewModel, showSetHistoryView: Binding<Bool>, selectedMusleGroup: Binding<MuscleGroup?>, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self._showView = showView
        self._showSetHistoryView = showSetHistoryView
        self._selectedMusleGroup = selectedMusleGroup
        self.content = content()
        self._showSetView = showSetView
        self.vm = vm
    }
    
    var body: some View {
        ZStack{
            VStack(spacing: 0) {
                UpperView(selection: $selection)
                    .padding(.top, 30)
                ZStack{
                    content
                }
                Divider()
                CustomTabBarView(tabs: tabs, localSelection: selection, selection: $selection, showView: $showView)
            }
            .edgesIgnoringSafeArea(.bottom)
            .onPreferenceChange(TapBarItemsPreferenceKey.self) { value in
                self.tabs = value
            }
            HStack{
                if showSetView {
                    SetView(vm: vm, showSetView: $showSetView)
                        .transition(.move(edge: .trailing))
                }
                if showSetHistoryView {
                    SetHistoryView(showSetHistoryView: $showSetHistoryView, selectedMusleGroup: $selectedMusleGroup)
                        .transition(.move(edge: .trailing))
                }
            }
            .edgesIgnoringSafeArea(.all)
            .zIndex(2.0)
        }
        .frame(height: UIScreen.main.bounds.height)
    }
}
