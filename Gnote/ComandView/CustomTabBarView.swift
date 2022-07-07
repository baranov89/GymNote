//
//  CustomTabView.swift
//  Gnote
//
//  Created by alex on 19.04.2022.
//

import SwiftUI

struct CustomTabBarView: View {
    
    let tabs: [TabBarItem]
    @State var localSelection: TabBarItem
    @State var f = false
    
    @Binding var selection: TabBarItem
    @Binding var showView: Bool
    
    @Namespace private var namespace
    
    var body: some View {
        Spacer()
        HStack{
            ForEach(tabs, id: \.self) { tabOne in
                Spacer()
                tabView(tab: tabOne)
                    .onTapGesture{
                        switchToTab(tab: tabOne)
                    }
                Spacer()
            }
        }
        .onChange(of: selection, perform: { value in
            withAnimation(.easeIn) {
                localSelection = value
            }
        })
        .padding(.bottom, 30)
    }
}


extension CustomTabBarView {
    
    private func tabView(tab: TabBarItem) -> some View {
        VStack{
            Image(systemName: tab.iconName == selection.iconName && tab.iconName == TabBarItem.training.iconName ? "plus" : tab.iconName)
                .font(.system(size: tab.iconName == selection.iconName && tab.iconName == TabBarItem.training.iconName ? 40 : 20, weight: .light, design: .rounded))
            if tab.iconName != selection.iconName || tab.iconName != TabBarItem.training.iconName {
                Text(tab.title)
                    .font(.system(size: 10, weight: .medium, design: .rounded))
            }
        }
        .foregroundColor(localSelection == tab ? tab.iconName == selection.iconName && tab.iconName == TabBarItem.training.iconName ? Color.red : Color.black : Color.gray)
        .padding(.vertical, 2)
        .frame(width: 60, height: 60)
        .background(
            ZStack{
                if localSelection == tab {
                    RoundedRectangle(cornerRadius: localSelection.iconName == TabBarItem.training.iconName ? 35 : 15 )
                        .stroke(tab.iconName == selection.iconName && tab.iconName == TabBarItem.training.iconName ? Color.red : Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)), lineWidth: 1)
                        .matchedGeometryEffect(id: "background_rectangle", in: namespace)
                }
            }
        )
    }
    
    private func switchToTab(tab: TabBarItem) {
        selection = tab
        if selection == .training && f == true {
            withAnimation(.easeIn) {
                showView = true
            }
        }
        if selection == .training {
            self.f = true
        } else {
            self.f = false
        }
    }
}


//struct CustomTabView_Previews: PreviewProvider {
//    static let tabs: [TabBarItem] = [
//        TabBarItem(iconName: "house", title: "Home", color: Color.red),
//        TabBarItem(iconName: "heart", title: "favorins", color: Color.blue),
//        TabBarItem(iconName: "person", title: "Profile", color: Color.green)
//    ]
//    static var previews: some View {
//        CustomTabView(tabs: tabs)
//    }
//}


