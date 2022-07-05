//
//  MusclesView.swift
//  Gnote
//
//  Created by Алексей Баранов on 02.07.2022.
//

import SwiftUI

struct MusclesView: View {
    @Binding var musclesArray: [String]
    @Binding var selectedMuscle: String
    @Binding var toggleMuscle: Bool
    @Binding var toggleExercise: Bool
    @Binding var changeMuscle: Bool
    
    var body: some View {
        Toggle(isOn: $toggleMuscle) {
            HStack{
                Menu {
                    ForEach(musclesArray, id: \.self) { muscle in
                        Button {
                            selectedMuscle = muscle
                            changeMuscle.toggle()
                        } label: {
                            Text("\(muscle)")
                        }
                    }
                } label: {
                    Text("Muscle:")
                        .foregroundColor(toggleMuscle ? .blue : .gray)
                }
                .padding(.leading, 20)
                .disabled(!toggleMuscle)
                Text("\(toggleMuscle ? selectedMuscle : "all muscles")")
                    .foregroundColor(toggleMuscle ? .black : .gray)
            }
        }
        .tint(.red.opacity(0.3))
        .padding(.trailing , 20)
        .onChange(of: toggleMuscle) { newValue in
            if !toggleMuscle {
                selectedMuscle = ""
                toggleExercise = false
            }
        }
    }
}
