//
//  SelectedChangeDataView.swift
//  Gnote
//
//  Created by Алексей Баранов on 07.07.2022.
//

import SwiftUI

struct SelectedChangeDataView: View {
    @Binding var muscleListArray: [MuscleGroupList]
    @Binding var selectedData : String
    @Binding var selectedMuscle: String
    @Binding var exerciseArray: [ExerciseList]
    var body: some View {
        HStack{
            Menu {
                HStack{
                    Button {
                        selectedData = "Exercise"
                    } label: {
                        Text("Exercise")
                    }
                    Button {
                        selectedData = "Muscle group"
                    } label: {
                        Text("Muscle Group")
                    }
                }
            } label: {
                Text("Data:")
            }
            Text("\(selectedData)")
            Spacer()
            HStack{
                Spacer()
                Text("count:")
                if selectedData == "Muscle group" {
                    Text("\(muscleListArray.count)")
                        .padding(.trailing, 20)
                } else {
                    Text("\(exerciseArray.count)")
                        .padding(.trailing, 20)
                }
            }
        }
        .font(.system(size: 20, weight: .light, design: .rounded))
        .padding([.leading, .top] , 20)
        HStack{
                Menu {
                    ForEach(muscleListArray, id: \.self) { muscle in
                        Button {
                            selectedMuscle = muscle.name!
                        } label: {
                            Text("\(muscle.name!)")
                        }
                    }
                } label: {
                    Text("in muscle group:")
                }
                .padding(.leading, 20)
                Text("\(selectedMuscle)")
                Spacer()
        }
        .opacity(selectedData == "Exercise" ? 1 : 0)
    }
}

