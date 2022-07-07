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
    @Binding var selectedData: String
    @Binding var selectedIcon: String
    
    var body: some View {
        ScrollView{
            if selectedData == "Muscle group" {
                ForEach(vm.allMuscleGroupArray, id: \.self) { changeData in
                    HStack{
                        Text("\(changeData.name!)")
                            .padding(.leading, 40)
                            .padding(.vertical, 10)
                        Spacer()
                    }
                }
            } else {
                ForEach(getExerciseListTwo(muscleGroup: selectedMuscle), id: \.self) { exercise in
                    HStack{
                        Text("\(exercise.name!)")
                            .padding(.leading, 40)
                            .padding(.vertical, 10)
                        Spacer()
                    }
                }
            }
        }
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
