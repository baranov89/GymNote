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
    @Binding var showSetHistoryView: Bool
    @Binding var selectedMusleGroup: MuscleGroup?
    
    @State var selectedIndex: [Int] = []
    @State var workOutPush: [Int] = []
    
    @State var triger: Bool = false
    
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
                                Text(getDate(date: (workOutFiltered[indexWorkOut].date!), object: "dayOfWeek") + ",")
                                Text(getDate(date: (workOutFiltered[indexWorkOut].date!), object: "dayNumber"))
                                Text(getDate(date: (workOutFiltered[indexWorkOut].date!), object: "month"))
                                Spacer()
                                HStack{
                                    Text("musle groups:")
                                        
                                    Text("\((workOutFiltered[indexWorkOut].muscleGroupRS?.allObjects as? [MuscleGroup])!.count)")
                                        .frame(width: 20)
                                        .padding(.trailing, 10)
                                }
                                .foregroundColor(.gray)
                                .font(.system(size: 15, weight: .light, design: .rounded))
                            }
                            .font(.system(size: 18, weight: .light, design: .rounded))
                            .padding(.vertical, 5)
                            if toggleShowMuscleGroup || (selectedIndex.contains(indexWorkOut)){
                                VStack{
                                    ForEach((workOutFiltered[indexWorkOut].muscleGroupRS?.allObjects as? [MuscleGroup])!) { muscle in
                                        HStack{
                                            Button {
                                                selectedMusleGroup = muscle
                                                withAnimation(.easeIn) {
                                                    showSetHistoryView.toggle()
                                                }
                                            } label: {
                                                Text("\(muscle.name!)")
                                                    .padding(.bottom, 1)
                                                    .padding(.leading, 40)
                                            }
                                            .font(.system(size: 18, weight: .light, design: .rounded))
                                            Spacer()
                                            HStack{
                                            Text("ex.:")
                                            Text("\((muscle.exerciseRS?.allObjects as? [Exercise])!.count)")
                                                .frame(width: 20)
                                                .padding(.trailing, 10)
                                            }
                                            .foregroundColor(.gray)
                                            .font(.system(size: 15, weight: .light, design: .rounded))
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
    
    func getDate(date: Date, object: String) -> String {
        let dateFormatter = DateFormatter()
        var objectDate = ""
        switch object {
        case "dayNumber":
            objectDate = "d"
        case "month":
            objectDate = "LLLL"
        case "dayOfWeek":
            objectDate = "EEEE"
        default:
            break
        }
        dateFormatter.dateFormat = objectDate
        return dateFormatter.string(from: date).capitalized
    }
}


