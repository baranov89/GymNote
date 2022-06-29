//
//  WorkoutSelectionView.swift
//  Gnote
//
//  Created by alex on 14.04.2022.
//

import SwiftUI

struct WorkoutSelectionView: View {
    @ObservedObject var vm: CoreDataRelationShipViewModel
    @State var moveToMainView: Bool = false
    var array2 = ["Breast", "Back", "Legs", "Shoulders", "Biceps", "Triceps", "Abs"]
    var array = ["bench press", "incline bench press", "push-ups", "dumbbells", "dips"]
    @Binding var showView: Bool
    var body: some View {
        VStack{
            Spacer()
            Text("Select workout")
                .font(.headline)
                .foregroundColor(Color.black)
                .padding(.vertical)
            Divider()
            ScrollView {
                ForEach(vm.workOutArray, id: \.self) { workOut in
                    Button {
                        vm.workOutCurrent = workOut
                        vm.getMuscleGroupList(idWorkOut: (vm.workOutCurrent?.id)!)
                        vm.getAllMusclGroup(idWorkOut: (vm.workOutCurrent?.id)!)
//                        createMuscleGroup()
                        moveToMainView.toggle()
                    } label: {
                        Text(workOut.date ?? Date(), style: .date)
                            .padding(5)
                            .foregroundColor(Color.black)
                    }
                }
                .frame(width: UIScreen.main.bounds.width)
            }
            
            Divider()
            Button {
                showView.toggle()
            } label: {
                Text("Concel")
                    .font(.headline)
            }
            .foregroundColor(.blue)
            .padding(.vertical)
            Spacer()
        }
        .fullScreenCover(isPresented: $moveToMainView) {
            MainView(vm: vm)
        }
    }
    func createMuscleGroup() {
        for i in 0 ... array2.count - 1 {
            let musclgrouplist = vm.saveMuscleGroupList(name: array2[i], workOut: vm.workOutCurrent!)
            for j in 0 ... array.count - 1 {
                vm.saveExerciseList(name: array[j], muscleGroup: musclgrouplist)
            }
       }
    }
}

//struct WorkoutSelectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        WorkoutSelectionView()
//    }
//}
