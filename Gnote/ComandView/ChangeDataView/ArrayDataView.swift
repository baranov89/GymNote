//
//  ArrayDataView.swift
//  Gnote
//
//  Created by Алексей Баранов on 08.07.2022.
//

import SwiftUI

struct ArrayDataView: View {
    @ObservedObject var vm: CoreDataRelationShipViewModel
    @Binding var selectedMuscle: String
    @Binding var selectedData: SelectedDataEnum
    @Binding var selectedIcon: String
    @State var triger = false
    
    var body: some View {
        
        ZStack{
            HStack{
                if !triger {
                    ScrollViewReader(content: { proxy in
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack{
                                ForEach(vm.allMuscleGroupArray, id: \.self) { muscle in
                                    HStack{
                                        Text("\(muscle.name!)")
                                            .padding(.leading, 40)
                                            .padding(.vertical, 10)
                                        Spacer()
                                        Button {
                                            
                                        } label: {
                                            Image(systemName: getIcon(selectedIcon: selectedIcon))
                                                .font(.system(size: 20, weight: .thin, design: .rounded))
                                                .opacity(selectedIcon == "plus.circle" ? 0 : 1)
                                                .foregroundColor(selectedIcon == "trash.circle" ? .red : .blue)
                                                .padding(.trailing, 20)
                                        }
                                        .disabled(selectedIcon == "plus.circle")
                                    }
                                    .id(muscle)
                                    .frame(width: UIScreen.main.bounds.width - 20, height: 50)
                                    .background(.white)
                                    .cornerRadius(20)
                                    .padding(.bottom, 10)
                                    .onTapGesture {
                                        selectedMuscle = muscle.name!
                                        triger = true
                                    }
                                }
                                Button {
                                    
                                } label: {
                                    Text("add new muscle group")
                                        .foregroundColor(.black)
                                        .frame(width: UIScreen.main.bounds.width - 20, height: 50)
                                        .background(.green.opacity(0.2))
                                        .cornerRadius(20)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(.green, lineWidth: 3)
                                        )
                                }
                                .opacity(selectedIcon == "plus.circle" ? 1 : 0)
                                .disabled(selectedIcon != "plus.circle")
                                .padding(.bottom, 10)
                            }
                            .frame(width: UIScreen.main.bounds.width)
                        }
                        .background(.gray.opacity(0.2))
                        .onChange(of: selectedIcon, perform: { value in
                            if value == "plus.circle" {
                                withAnimation {
                                    proxy.scrollTo(selectedData == .muscle ? vm.allMuscleGroupArray.last : getExerciseListTwo(muscleGroup: selectedMuscle).last, anchor: .trailing)
                                }
                            }
                        })
                        .onChange(of: selectedIcon, perform: { value in
                            if value == "trash.circle" || value == "pencil.circle" {
                                withAnimation(.spring()) {
                                    proxy.scrollTo(selectedData == .muscle ? vm.allMuscleGroupArray.first : getExerciseListTwo(muscleGroup: selectedMuscle).first, anchor: .leading)
                                }
                            }
                        })
                    })
                }
            }
            
            HStack{
                if triger  {
                    ExerciseListView(vm: vm, selectedMuscle: $selectedMuscle, selectedIcon: $selectedIcon, selectedData: $selectedData)
                        .transition(.move(edge: .trailing))
                        .animation(.easeIn, value: triger)
                }
            }
        }
        
    }
    
    func getIcon(selectedIcon: String) -> String {
        var icon = ""
        switch selectedIcon {
        case "plus.circle":
            icon = "plus.circle"
        case "pencil.circle":
            icon = "pencil.and.outline"
        case "trash.circle":
            icon = "trash"
        default:
            break
        }
        return icon
    }
    
    func getExerciseListTwo(muscleGroup: String) -> [ExerciseList] {
        var array: [ExerciseList] = []
        let mascleGrouplist = (vm.workOutCurrent?.muscleGroupListRS?.allObjects as? [MuscleGroupList])!
        for muscle in mascleGrouplist {
            if muscle.name == muscleGroup {
                array = (muscle.exerciseListRS?.allObjects as? [ExerciseList])!
            }
        }
        return array
    }
    
}
