//
//  ExerciseScrollView.swift
//  Gnote
//
//  Created by Алексей Баранов on 05.07.2022.
//

import SwiftUI

struct ExerciseScrollView: View {
    @Binding var workOutFiltered: [WorkOut]
    @Binding var toggleMuscle: Bool
    @Binding var toggleMonth: Bool
    @Binding var toggleShowMuscleGroup: Bool
    
    @State var selectedIndex: [Int] = []
    @State var workOutPush: [Int] = []
    
    var body: some View {
        VStack{
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading){
                    ForEach(workOutFiltered.indices, id: \.self) { indexWorkOut in
                        VStack{
                            HStack{
                                Text("\(indexWorkOut + 1)")
                                    .frame(width: 20)
                                    .padding(.leading, 10)
                                    .padding(.trailing, 20)
                                Text("\(workOutFiltered[indexWorkOut].date!, format: Date.FormatStyle().weekday().day().month())")
                                Spacer()
                                Text("musle groups:")
                                    .foregroundColor(.gray)
                                Text("\((workOutFiltered[indexWorkOut].muscleGroupRS?.allObjects as? [MuscleGroup])!.count)")
                                    .frame(width: 20)
                                    .padding(.trailing, 10)
                            }
                            .padding(.vertical, 5)
                            if toggleShowMuscleGroup || (selectedIndex.contains(indexWorkOut)){
                                VStack{
                                    ForEach((workOutFiltered[indexWorkOut].muscleGroupRS?.allObjects as? [MuscleGroup])!) { muscle in
                                        HStack{
                                            Button {
                                                
                                            } label: {
                                                Text("\(muscle.name!)")
                                                    .padding(.bottom, 1)
                                                    .padding(.leading, 70)
                                                    .foregroundColor(.red.opacity(0.8))
                                            }
                                            Spacer()
                                            Text("ex.:")
                                                .foregroundColor(.gray)
                                            Text("\((muscle.exerciseRS?.allObjects as? [Exercise])!.count)")
                                                .frame(width: 20)
                                                .padding(.trailing, 10)
                                        }
                                    }
                                }
                            }
                        }
                        .background(.white)
                        .onTapGesture {
                            if !workOutPush.contains(indexWorkOut) {
                                selectedIndex.append(indexWorkOut)
                                workOutPush.append(indexWorkOut)
                            } else {
                                for i in workOutPush.indices {
                                    if workOutPush[i] == indexWorkOut {
                                        workOutPush.remove(at: i)
                                        break
                                    }
                                }
                                for i in selectedIndex.indices {
                                    if selectedIndex[i] == indexWorkOut {
                                        selectedIndex.remove(at: i)
                                        break
                                    }
                                }
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width - 20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.gray.opacity(0.5), lineWidth: 1)
                            )
                        .padding(.bottom, 5)
                    }
                }
                .frame(width: UIScreen.main.bounds.width)
                .padding(.top, 5)
            }
        }
        .onChange(of: toggleShowMuscleGroup, perform: { newValue in
            selectedIndex.removeAll()
            workOutPush.removeAll()
        })
        .onChange(of: toggleMuscle, perform: { newValue in
            selectedIndex.removeAll()
            workOutPush.removeAll()
        })
        .onChange(of: toggleMonth, perform: { newValue in
            selectedIndex.removeAll()
            workOutPush.removeAll()
        })
    }
}


