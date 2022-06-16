//
//  ExerciseItemView.swift
//  Gnote
//
//  Created by alex on 05.05.2022.
//

import SwiftUI

struct ExerciseItemView: View {
    var exercise: Exercise
    @ObservedObject var vm: CoreDataRelationShipViewModel
    
    @Binding var showSetView: Bool
    
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
                    Text(exercise.name ?? "empty")
                        .padding(.horizontal,20)
                        .font(.system(size: 20, weight: .light, design: .rounded))
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
                    Text("set | \(f(exercise: exercise))")
                        .font(.system(size: 15, weight: .light, design: .rounded))
                        .frame(alignment: .trailing)
                }
                .frame(width: UIScreen.main.bounds.width - 60, alignment: .trailing)
                
            }
            .frame(width: UIScreen.main.bounds.width - 40, height: 80, alignment: .leading)
            .background(Color.white)
            .cornerRadius(20)
        }
    }
    func f (exercise: Exercise) -> Int {
        if (exercise.powerSetRS?.allObjects as? [PowerSet]) != nil {
            return (exercise.powerSetRS?.allObjects as? [PowerSet])?.count ?? 0
        }
        return 0
    }
}

//struct ExerciseItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExerciseItemView()
//    }
//}
