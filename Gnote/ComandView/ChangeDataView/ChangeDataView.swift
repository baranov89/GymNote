//
//  ChangeDataView.swift
//  Gnote
//
//  Created by Алексей Баранов on 07.07.2022.
//

import SwiftUI

struct ChangeDataView: View {
    @ObservedObject var vm: CoreDataRelationShipViewModel
    @State var togglyExercise: Bool = false
    @State var togglyMuscleGroup: Bool = false
    @State var selectedMuscle: String = ""
    @State var selectedData: String = "Muscle group"
    @State var muscleListArray: [MuscleGroupList] = []
    @State var exerciseArray: [ExerciseList] = []
    @State var selectedIcon = "plus.circle"
    
    var body: some View {
        VStack{
            HStack{
                Text("Change data")
                Spacer()
            }
            .font(.system(size: 22, weight: .light, design: .rounded))
            .padding(.leading , 20)
            .padding(.top, 20)
            Divider()
            VStack{
                SelectedChangeDataView(muscleListArray: $muscleListArray, selectedData: $selectedData, selectedMuscle: $selectedMuscle, exerciseArray: $exerciseArray)
            }
            Divider()
            HStack {
                IconView(selectedIcon: $selectedIcon)
            }
            .padding(.vertical, 20)
            Divider()
            ArrayDataView(vm: vm, selectedMuscle: $selectedMuscle, selectedData: $selectedData, selectedIcon: $selectedIcon)
            Spacer()
        }
        .onAppear{
            vm.getMuscleGroupList(idWorkOut: (vm.workOutCurrent?.id)!)
            let muscleList = vm.allMuscleGroupArray
            selectedMuscle = (muscleList.first?.name)!
            getMuscleGroupList()
        }
        .onChange(of: selectedData) { newValue in
            getExerciseList(muscleGroup: selectedMuscle)
        }
        .onChange(of: selectedMuscle) { newValue in
            getExerciseList(muscleGroup: selectedMuscle)
        }
    }
    
    func getMuscleGroupList() {
        vm.getMuscleGroupList(idWorkOut: (vm.workOutCurrent?.id)!)
        muscleListArray = vm.allMuscleGroupArray.sorted(by: { $0.name! < $1.name! })
    }
    
    func getExerciseList(muscleGroup: String) {
        exerciseArray.removeAll()
        let mascleGrouplist = (vm.workOutCurrent?.muscleGroupListRS?.allObjects as? [MuscleGroupList])!
        for muscle in mascleGrouplist {
            if muscle.name == muscleGroup {
                for j in (muscle.exerciseListRS?.allObjects as? [ExerciseList])! {
                    exerciseArray.append(j)
                }
            }
        }
    }
    
    
}
