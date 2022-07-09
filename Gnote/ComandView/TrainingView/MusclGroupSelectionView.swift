//
//  MusclGroupSelectionView.swift
//  Gnote
//
//  Created by alex on 04.05.2022.
//

import SwiftUI

struct MusclGroupSelectionView: View {
    @ObservedObject var vm: CoreDataRelationShipViewModel
    
    @State var moveToMainView: Bool = false
    @State var arrayExercise: [Exercise] = []
    @State var showMuscleViewBool = false
    @State var musculGroupName: String = ""
    @State var pushMusclGroup: MuscleGroupList?
    @State var chooseExercise: ExerciseList?
    
    @Binding var showView: Bool
    @Binding var selectedGroup: MuscleGroup?
    @Binding var updateMuscleGroupView: Bool
    @Binding var changeData: Bool
    @Binding var chooseMusclegroup: MuscleGroupList?
    
    func getMuscleGroupFoName (name: String) -> MuscleGroup {
        let muscleGroupArray = vm.getCurrentMusclGroup(MuscleGroup: musculGroupName)
        let y = muscleGroupArray.filter { muscle in
            muscle.workOutRS?.id == vm.workOutCurrent?.id
        }
        let u = y.first
        return u!
    }
    
    var body: some View {
        VStack{
            Spacer()
            Text(showMuscleViewBool ? "Select exercise" : "Select muscle group")
                .font(.headline)
                .foregroundColor(Color.black)
                .padding(.vertical)
                .animation(.none, value: UUID())
            ScrollView {
                if showMuscleViewBool {
                    ForEach((chooseMusclegroup!.exerciseListRS?.allObjects as? [ExerciseList])!.sorted(by: { one, two in
                        one.name! < two.name!
                    }), id: \.self) { exercise in
                        HStack{
                            Button {
                                chooseExercise = exercise
                                pushMusclGroup = nil
                                if vm.findMuscleGroup(name: musculGroupName, idWorkOut: (vm.workOutCurrent?.id)!) {
                                    vm.musclGroupCurrent = getMuscleGroupFoName(name: musculGroupName)
                                } else {
                                    vm.musclGroupCurrent = vm.saveMusclGroup(id: UUID(), name: musculGroupName, workOut: vm.workOutCurrent!)
                                }
                                vm.getAllMusclGroup(idWorkOut: (vm.workOutCurrent?.id)!)
                                let countMusclgroup = (vm.musclGroupCurrent!.exerciseRS?.allObjects as? [Exercise])!.count + 1
                                vm.saveExercise(id: UUID(), name: exercise.name!, number: Int64(countMusclgroup), musclGroup: vm.musclGroupCurrent!)
                                vm.getAllMusclGroup(idWorkOut: (vm.workOutCurrent?.id)!)
                                vm.getAllExercise(idMusclGroup: (vm.musclGroupCurrent?.id)!)
                                changeData.toggle()
                                updateMuscleGroupView.toggle()
                                vm.deleteExerciseList(exerciseList: exercise)
                                withAnimation(.easeIn) {
                                    showView = false
                                }
                            } label: {
                                HStack(alignment: .center){
                                    Text(exercise.name ?? "empty")
                                        .padding( .vertical, 7)
                                        .foregroundColor(chooseExercise == exercise ? .white : .black)
                                }
                            }
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width)
                } else {
                    ForEach(vm.allMuscleGroupArray, id: \.self) { muscleGroup in
                        Button {
                            chooseExercise = nil
                            chooseMusclegroup = muscleGroup
                            pushMusclGroup = muscleGroup
                            vm.getExerciseList(muscleGroup: muscleGroup.name!)
                            musculGroupName = muscleGroup.name ?? ""
                            showMuscleViewBool.toggle()
                        } label: {
                            HStack(alignment: .center){
                                Text(muscleGroup.name ?? "empty")
                                    .padding( .vertical, 7)
                            }
                            .foregroundColor(pushMusclGroup == muscleGroup ? Color.gray : Color.black)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width)
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 0)
                    .stroke(.gray.opacity(0.2), lineWidth: 1)
            )
            Button {
                pushMusclGroup = nil
                if showMuscleViewBool {
                    showMuscleViewBool.toggle()
                } else {
                    withAnimation(.easeIn) {
                        showView.toggle()
                    }
                }
            } label: {
                Text(showMuscleViewBool ? "Back" : "Concel")
                    .font(.headline)
            }
            .animation(.none, value: UUID())
            .foregroundColor(.blue)
            .padding(.vertical, 10)
            .padding(.bottom, 10)
            Spacer()
        }
        .onAppear(perform: {
            vm.getMuscleGroupList(idWorkOut: (vm.workOutCurrent?.id)!)
        })
    }
}
