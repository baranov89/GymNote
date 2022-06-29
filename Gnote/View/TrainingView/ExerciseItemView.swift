//
//  ExerciseItemView.swift
//  Gnote
//
//  Created by alex on 05.05.2022.
//

import SwiftUI

struct ExerciseItemView: View {
    @State var exercise: Exercise
    @ObservedObject var vm: CoreDataRelationShipViewModel
    
    @Binding var showSetView: Bool
    @Binding var musculGroupArray: [MuscleGroup]
    @Binding var selectedGroup: MuscleGroup?
    @Binding var updateMuscleGroupView: Bool
    @Binding var changeData: Bool
    
    var body: some View {
        Button {
            vm.exerciseACurrent = exercise
            vm.musclGroupCurrent = exercise.muscleGroupRS
            withAnimation(.easeIn) {
                showSetView.toggle()
            }
        } label: {
            VStack {
                HStack{
                    Text("\(exercise.number)")
                        .padding(.leading, 20)
                        .foregroundColor(.black)
                    Text(exercise.name ?? "empty")
                        .padding(.horizontal,20)
                        .font(.system(size: 20, weight: .light, design: .rounded))
                        .foregroundColor(.black)
                    Spacer()
                    Button {
                            deletexercise(exercise: exercise)
                            
                    } label: {
                        Image(systemName: "trash")
                            .padding(.trailing, 10)
                    }
                }
                .frame(width: UIScreen.main.bounds.width - 50, alignment: .leading)
                HStack{
                    
                    Text(exercise.muscleGroupRS?.name ?? "empty")
                        .padding(.horizontal,20)
                        .font(.system(size: 15, weight: .light, design: .rounded))
                        .foregroundColor(.gray)
                }
                .frame(width: UIScreen.main.bounds.width - 50, alignment: .leading)
                
                HStack{
                    Text("set | \(ecserciseCount(exercise: exercise))")
                        .font(.system(size: 15, weight: .light, design: .rounded))
                        .frame(alignment: .trailing)
                        .foregroundColor(.black)
                }
                .frame(width: UIScreen.main.bounds.width - 60, alignment: .trailing)
                
            }
            .frame(width: UIScreen.main.bounds.width - 40, height: 80, alignment: .leading)
            .background(Color.white)
            .cornerRadius(20)
        }
    }
    
    func ecserciseCount (exercise: Exercise) -> Int {
        if (exercise.powerSetRS?.allObjects as? [PowerSet]) != nil {
            return (exercise.powerSetRS?.allObjects as? [PowerSet])?.count ?? 0
        }
        return 0
    }
    
    func deletexercise(exercise: Exercise) {
        let exercisenuslGroup = exercise.muscleGroupRS
        vm.getAllExercise(idMusclGroup: (exercisenuslGroup?.id)!)
        if vm.exerciseArray.count == 1 {
            var count = 0
            for i in musculGroupArray {
                if i == exercisenuslGroup {
                    musculGroupArray.remove(at: count)
                    selectedGroup = musculGroupArray.last
                }
                count += 1
            }
            returnExercise(exercise: exercise, musclGroup: exercisenuslGroup!)
            vm.delete(deleteObject: exercisenuslGroup)
            vm.getAllMusclGroup(idWorkOut: (vm.workOutCurrent?.id)!)
            vm.musclGroupCurrent = musculGroupArray.last
            
        } else {
            returnExercise(exercise: exercise, musclGroup: exercisenuslGroup!)
            vm.delete(deleteObject: exercise)
            getNewNumberForExercise(musclegroup: exercisenuslGroup!)
        }
    }
    
    func getNewNumberForExercise(musclegroup: MuscleGroup) {
        vm.getAllExercise(idMusclGroup: musclegroup.id!)
        let sortedArray = vm.exerciseArray.sorted(by: { one, two in
            one.number > two.number
        })
        var finishArray: [Exercise] = []
        var count = 1
        for i in sortedArray {
            i.number = Int64(count)
            vm.save()
            finishArray.append(i)
            count += 1
        }
        vm.exerciseArray.removeAll()
        vm.exerciseArray = finishArray
    }
    
    func returnExercise(exercise: Exercise, musclGroup: MuscleGroup) {
        var muscleGroupList: MuscleGroupList?
        vm.getMuscleGroupList(idWorkOut: (vm.workOutCurrent?.id)!)
        for i in vm.allMuscleGroupArray {
            if i.name == musclGroup.name {
                muscleGroupList = i
            }
        }
        vm.saveExerciseList(name: exercise.name!, muscleGroup: muscleGroupList!)
    }
}

//struct ExerciseItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExerciseItemView()
//    }
//}
