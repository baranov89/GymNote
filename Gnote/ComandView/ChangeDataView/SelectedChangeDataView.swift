//
//  SelectedChangeDataView.swift
//  Gnote
//
//  Created by Алексей Баранов on 07.07.2022.
//

import SwiftUI

struct SelectedChangeDataView: View {
    @Binding var muscleListArray: [MuscleGroupList]
    @Binding var selectedData : SelectedDataEnum
    @Binding var selectedMuscle: String
    @Binding var exerciseArray: [ExerciseList]
    var body: some View {
        HStack{
            HStack{
                if selectedData == .exercise {
                    Text("Exercises")
                } else {
                    Text("Muscle groups")
                }
                
            }
            Spacer()
            HStack{
                Spacer()
                Text("count:")
                if selectedData == .muscle {
                    Text("\(muscleListArray.count)")
                        .padding(.trailing, 20)
                } else {
                    Text("\(exerciseArray.count)")
                        .padding(.trailing, 20)
                }
            }
        }
        .font(.system(size: 20, weight: .light, design: .rounded))
        .padding(.top , 5)
        .padding(.leading, 20)
    }
    
    
}

