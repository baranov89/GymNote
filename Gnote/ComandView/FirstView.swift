//
//  FirstView.swift
//  Gnote
//
//  Created by alex on 11.04.2022.
//

import SwiftUI

struct FirstView: View {
    @StateObject var vm = CoreDataRelationShipViewModel()
    
    @State var idWorkOut: UUID? = nil
    @State var showView: Bool = false
    @State var moveToMainView: Bool = false
    
    var date = Date()
    var arrayExercise: [[String]] = [["bench press", "incline bench press", "push-ups", "dumbbells", "dips", "dips", "dips", "dips", "dips"],
                                     ["bench press", "incline bench press", "push-ups", "dumbbells", "dips"],
                                     ["bench press", "incline bench press", "push-ups", "dumbbells", "dips"],
                                     ["bench press", "incline bench press", "push-ups", "dumbbells", "dips"],
                                     ["bench press", "incline bench press", "push-ups", "dumbbells", "dips"],
                                     ["bench press", "incline bench press", "push-ups", "dumbbells", "dips"],
                                     ["bench press", "incline bench press", "push-ups", "dumbbells", "dips"]]
    var arrayMuscle = ["Breast", "Back", "Legs", "Shoulders", "Biceps", "Triceps", "Abs"]
    
    var body: some View {
        ZStack(alignment: .bottom){
            VStack {
                Spacer()
                    .frame(width: 40, height: 520, alignment: .center)
                Button {
                    idWorkOut = UUID()
                    vm.workOutCurrent = vm.saveWorkout(id: idWorkOut!, year: getYear(), month: getMonth(), date: Date())
                    vm.getAllMusclGroup(idWorkOut: (vm.workOutCurrent?.id)!)
                    createMuscleGroupList()
                    moveToMainView.toggle()
                } label: {
                    Text("new")
                        .frame(width: 200, height: 40, alignment: .center)
                        .foregroundColor(.black)
                        .background(Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)))
                        .cornerRadius(15)
                }
                Button {
                    vm.getAllWorkOut()
                    vm.workOutCurrent = vm.workOutArray.last
                    vm.getMuscleGroupList(idWorkOut: (vm.workOutCurrent?.id)!)
                    vm.getAllMusclGroup(idWorkOut: (vm.workOutCurrent?.id)!)
                    moveToMainView.toggle()
                } label: {
                    Text("continue")
                        .frame(width: 200, height: 40, alignment: .center)
                        .foregroundColor(.black)
                        .background(Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)))
                        .cornerRadius(15)
                }
                .padding(.vertical)
                Button {
                    vm.getAllWorkOut()
                    showView.toggle()
//                    vm.deleteAllData()
                } label: {
                    Text("open")
                        .frame(width: 200, height: 40, alignment: .center)
                        .foregroundColor(.black)
                        .background(Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)))
                        .cornerRadius(15)
                }
                Spacer()
            }
            ZStack{
                if showView {
                    WorkoutSelectionView(vm: vm, showView: $showView)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.4)
                        .background(Color(#colorLiteral(red: 0.9905317155, green: 0.9905317155, blue: 0.9905317155, alpha: 1)))
                        .cornerRadius(30)
                        .transition(.move(edge: .bottom))
                        .animation(.easeIn, value: showView)
                }
            }
            .zIndex(2.0)
        }
        .fullScreenCover(isPresented: $moveToMainView) {
            MainView(vm: vm)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    func createMuscleGroupList() {
        for j in 0 ... arrayMuscle.count - 1 {
            let musclgrouplist = vm.saveMuscleGroupList(name: arrayMuscle[j], workOut: vm.workOutCurrent!)
            for k in 0 ... arrayExercise[j].count  - 1 {
                vm.saveExerciseList(name: arrayExercise[j][k], muscleGroup: musclgrouplist)
            }
        }
    }
    
    func getYear() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        let yearString = dateFormatter.string(from: date)
        return yearString
    }
    
    func getMonth() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let monthString = dateFormatter.string(from: date)
        return monthString
    }
}

struct FirstView_Previews: PreviewProvider {
    static var previews: some View {
        FirstView()
    }
}
