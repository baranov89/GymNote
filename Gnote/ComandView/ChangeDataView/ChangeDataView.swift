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
    @State var selectedData: SelectedDataEnum = .muscle
    @State var muscleListArray: [MuscleGroupList] = []
    @State var exerciseArray: [ExerciseList] = []
    @State var selectedIcon = "plus.circle"
    @State var triger: Bool = false
    
    var body: some View {
        VStack{
            TopTitleView(selectedIcon: $selectedIcon)
            Divider()
            VStack{
                SelectedChangeDataView(muscleListArray: $muscleListArray, selectedData: $selectedData, selectedMuscle: $selectedMuscle, exerciseArray: $exerciseArray)
            }
            HStack {
                IconView(selectedIcon: $selectedIcon, selectedMuscle: $selectedMuscle, selectedData: $selectedData, triger: $triger)
            }
            .padding(.vertical, 5)
            ArrayData(vm: vm, selectedMuscle: $selectedMuscle, selectedData: $selectedData, selectedIcon: $selectedIcon, triger: $triger)
                .padding(.top, 10)
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
    
    func getTitle() -> String {
        var title = ""
        switch selectedIcon {
        case "plus.circle":
            title = "Add data"
        case "pencil.circle":
            title = "Change data"
        case "trash.circle":
            title = "Delete data"
        default:
            break
        }
        return title
    }
}

enum SelectedDataEnum {
    case muscle, exercise
    var category: String {
        switch self {
        case .muscle: return "Muscle group"
        case .exercise: return "Exercise"
        }
    }
}
