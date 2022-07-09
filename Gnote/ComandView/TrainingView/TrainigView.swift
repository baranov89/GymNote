//
//  TrainigView.swift
//  Gnote
//
//  Created by alex on 29.04.2022.
//

import SwiftUI

struct TrainigView: View {
    
    @ObservedObject var vm: CoreDataRelationShipViewModel
    
    @State var musculGroupArray: [MuscleGroup] = []
    @State var musculGroupArrayString: [String] = [""]
    
    @Binding var showSetView: Bool
    @Binding var selectedGroup: MuscleGroup?
    @Binding var updateMuscleGroupView: Bool
    @Binding var chooseMusclegroup: MuscleGroupList?
    @Binding var changeData: Bool
    
    var d: [String] = ["qwe"]
    
    var body: some View {
        VStack(spacing: 0){
            HStack{
                Text("Wednesday, ")
                    .font(.system(size: 22, weight: .light, design: .rounded))
                    .padding(.leading , 20)
                Text("24 July 2022")
                    .font(.system(size: 20, weight: .light, design: .rounded))
                Spacer()
            }
            .padding(.top, 20)
            Divider()
                .padding(.top, 15)
                .padding(.bottom, 20)
            TrainingViewMusclGroup(vm: vm, muscleArray: $musculGroupArray, selectedGroup: $selectedGroup, updateMuscleGroupView: $updateMuscleGroupView)
            Divider()
                .padding(.top, 20)
            ScrollView(.horizontal, showsIndicators: false)
            {
                ScrollViewReader(content: { proxy in
                HStack{
                    ForEach(musculGroupArray, id: \.self) { muscleGroup in
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack{
                                ForEach((muscleGroup.exerciseRS?.allObjects as? [Exercise])!.sorted(by: {one, two in
                                    one.number > two.number}) , id: \.self) { exercise in
                                    ExerciseItemView(exercise: exercise, vm: vm, showSetView: $showSetView, musculGroupArray: $musculGroupArray, selectedGroup: $selectedGroup, updateMuscleGroupView: $updateMuscleGroupView, changeData: $changeData)
                                        .padding(.vertical, 7)
                                }
                            }
                            .frame(width: UIScreen.main.bounds.width)
                        }
                        .id(muscleGroup)
                        .frame(width: UIScreen.main.bounds.width)
                    }
                }
//                .background(Color.gray.opacity(0.2))
                .onChange(of: selectedGroup, perform: { value in
                    withAnimation {
                        proxy.scrollTo(value, anchor: .trailing)
                    }
                })
            }) 
            }
//            }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.7)
        }
        .frame(width: UIScreen.main.bounds.width)
        .onChange(of: changeData, perform: { newValue in
            musculGroupArray.removeAll()
            musculGroupArrayString.removeAll()
            for i in vm.musclGroupArray {
                musculGroupArray.append(i)
                musculGroupArrayString.append(i.name!)
            }
            for i in vm.musclGroupArray {
                if i.name == chooseMusclegroup?.name {
                    selectedGroup = i
                }
            }
            updateMuscleGroupView.toggle()
        })
        .onAppear {
            musculGroupArray.removeAll()
            musculGroupArrayString.removeAll()
            for i in vm.musclGroupArray {
                musculGroupArray.append(i)
                musculGroupArrayString.append(i.name!)
            }
            selectedGroup = musculGroupArray.first
        }
    }
}
