//
//  ArrayData.swift
//  Gnote
//
//  Created by Алексей Баранов on 09.07.2022.
//

import SwiftUI

struct ArrayData: View {
    @ObservedObject var vm: CoreDataRelationShipViewModel
    @Binding var selectedMuscle: String
    @Binding var selectedData: SelectedDataEnum
    @Binding var selectedIcon: String
    @Binding var triger: Bool
    
    var body: some View {
        VStack{
            ZStack{
                HStack{
                    if !triger {
                        HStack{
                            ScrollViewReader(content: { proxy in
                            ScrollView(.vertical, showsIndicators: false) {
                                VStack( spacing: 5) {
                                    ForEach(vm.allMuscleGroupArray, id: \.self) { muscle in
                                        HStack{
                                            Button {
                                                selectedData = .exercise
                                                selectedMuscle = muscle.name!
                                                withAnimation(.easeIn) {
                                                    triger = true
                                                }
                                            } label: {
                                                Text("\(muscle.name!)")
                                                    .padding(.leading, 40)
                                            }
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
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)), lineWidth: 0.5)
                                        )
                                        .onTapGesture {
                                            
                                            
                                        }
                                    }
                                    .frame(width: UIScreen.main.bounds.width)
                                    Button {
                                        
                                    } label: {
                                        Text("add new muscle group")
                                            .foregroundColor(.black)
                                            .frame(width: UIScreen.main.bounds.width - 20, height: 50)
                                            .background(.green.opacity(0.2))
                                            .cornerRadius(20)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(.green, lineWidth: 1)
                                            )
                                    }
                                    .opacity(selectedIcon == "plus.circle" ? 1 : 0)
                                    .disabled(selectedIcon != "plus.circle")
                                    .padding(.bottom, 10)
                                }
                            }
                            .onChange(of: selectedIcon, perform: { value in
                                if value == "plus.circle" {
                                    withAnimation {
                                        proxy.scrollTo(vm.allMuscleGroupArray.last, anchor: .trailing)
                                    }
                                }
                            })
                            .onChange(of: selectedIcon, perform: { value in
                                if value == "trash.circle" || value == "pencil.circle" {
                                    withAnimation(.spring()) {
                                        proxy.scrollTo(vm.allMuscleGroupArray.first, anchor: .leading)
                                    }
                                }
                            })
                            })
                        }
                        .transition(.move(edge: .leading))
                    }
                }
                HStack{
                    if triger  {
                        ExerciseListView(vm: vm, selectedMuscle: $selectedMuscle, selectedIcon: $selectedIcon, selectedData: $selectedData)
                            .transition(.move(edge: .trailing))
                    }
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
