//
//  MainView.swift
//  Gnote
//
//  Created by alex on 13.04.2022.
//

import SwiftUI

struct MainView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm: CoreDataRelationShipViewModel
    @State var tabSelection : TabBarItem = .categoty
    
    @State var showView = false
    @State var selectedGroup: MuscleGroup? = nil
    @State var showSetView: Bool = false
    @State var updateMuscleGroupView = false
    @State var chooseMusclegroup: MuscleGroupList?
    @State var changeData = false
    
    var body: some View {
        ZStack(alignment: .bottom){
            VStack{
                CustomTabBarCintainerView(selection: $tabSelection, showView: $showView, showSetView: $showSetView, vm: vm) {
                    Color.black
                        .tabBarItem(tab: .categoty, selection: $tabSelection)
                        .opacity(0.1)
                    TrainigView(vm: vm, showSetView: $showSetView, selectedGroup: $selectedGroup, updateMuscleGroupView: $updateMuscleGroupView, chooseMusclegroup: $chooseMusclegroup, changeData: $changeData)
                        .tabBarItem(tab: .training, selection: $tabSelection)
                    Color.blue
                        .tabBarItem(tab: .history, selection: $tabSelection)
                        .opacity(0.1)
                }
            }
            ZStack{
                if showView {
                    MusclGroupSelectionView(vm: vm, showView: $showView, selectedGroup: $selectedGroup, updateMuscleGroupView: $updateMuscleGroupView, changeData: $changeData, chooseMusclegroup: $chooseMusclegroup)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.4)
                        .background(Color(#colorLiteral(red: 0.9905317155, green: 0.9905317155, blue: 0.9905317155, alpha: 1)))
                        .cornerRadius(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(.gray.opacity(0.2), lineWidth: 1)
                        )
                        .transition(.move(edge: .bottom))
                }
            }
            .zIndex(2.0)
        }
        .ignoresSafeArea(edges: .bottom)
    }   
}

//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        let vm = CoreDataRelationShipViewModel()
//        MainView(vm: vm)
//    }
//}
