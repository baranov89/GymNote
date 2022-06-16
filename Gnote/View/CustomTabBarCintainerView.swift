//
//  CustomTabBarCintainerView.swift
//  Gnote
//
//  Created by alex on 24.04.2022.
//

import SwiftUI

struct CustomTabBarCintainerView<Content: View> : View {
    
    let content: Content
    @ObservedObject var vm: CoreDataRelationShipViewModel
   
    @State var tabs: [TabBarItem] = [.categoty,.training,.history]
    
    @Binding var selection: TabBarItem
    @Binding var showView: Bool
    @Binding var showSetView: Bool
    
    
    init(selection: Binding<TabBarItem>, showView: Binding<Bool>, showSetView: Binding<Bool>, vm: CoreDataRelationShipViewModel, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self._showView = showView
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
            }
            .edgesIgnoringSafeArea(.all)
            .zIndex(2.0)
        }
        .frame(height: UIScreen.main.bounds.height)
        
    }
}

//struct CustomTabBarCintainerView_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomTabBarCintainerView()
//    }
//}
