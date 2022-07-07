//
//  SetHistoryView.swift
//  Gnote
//
//  Created by Алексей Баранов on 06.07.2022.
//

import SwiftUI

struct SetHistoryView: View {
    @Binding var showSetHistoryView: Bool
    @Binding var selectedMusleGroup: MuscleGroup?
    
    var body: some View {
        VStack{
            VStack{
                
                HStack{
                    Button {
                        withAnimation(.easeOut) {
                            showSetHistoryView.toggle()
                        }
                    } label: {
                        Text("History")
                            .font(.system(size: 20, weight: .light, design: .rounded))
                    }
                    .padding(.leading, 20)
                    Spacer()
                }
                VStack{
                    HStack{
                        Text(getDate(date: (selectedMusleGroup?.workOutRS!.date)!, object: "dayOfWeek") + ",")
                        Text(getDate(date: (selectedMusleGroup?.workOutRS!.date)!, object: "dayNumber"))
                        Text(getDate(date: (selectedMusleGroup?.workOutRS!.date)!, object: "month"))
                        Text(getDate(date: (selectedMusleGroup?.workOutRS!.date)!, object: "year"))
                    }
                        .font(.system(size: 15, weight: .light, design: .rounded))
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                    Text((selectedMusleGroup?.name)!)
                        .font(.system(size: 30, weight: .light, design: .rounded))
                }
            }
            .padding(.top, 55)
            Divider()
            VStack{
                ScrollView(.vertical, showsIndicators: false){
                    ForEach(((selectedMusleGroup?.exerciseRS?.allObjects as? [Exercise])!).sorted(by: { $0.number < $1.number })) {exercise in
                        VStack{
                            HStack{
                                Spacer()
                                HStack{
                                    Spacer()
                                    Text(exercise.name!)
                                        .font(.system(size: 25, weight: .regular , design: .rounded))
                                        .padding(.trailing, 30)
                                }
                            }
                            HStack{
                                Text("\(exercise.number)")
                                    .padding(.leading, 20)
                                    .font(.system(size: 20, weight: .regular , design: .rounded))
                                Spacer()
                                Text("max weight, kg:")
                                Text("\(maxWiegth(exercise: exercise), specifier: "%.1f")")
                                    .padding(.trailing, 30)
                            }
                            .font(.system(size: 17, weight: .thin, design: .rounded))
                            HStack{
                                
                                Spacer()
                                Text("sets:")
                                Text("\((exercise.powerSetRS?.allObjects as? [PowerSet])!.count)")
                                    .padding(.trailing, 30)
                            }
                            .font(.system(size: 17, weight: .thin, design: .rounded))
                            HStack{
                                Spacer()
                                HStack{
                                    VStack(alignment: .trailing) {
                                        Text("set")
                                        Text("weight")
                                            .padding(.vertical, 5)
                                        Text("repeat")
                                    }
                                    .padding(.leading, 20)
                                    .font(.system(size: 17, weight: .thin, design: .rounded))
                                    .foregroundColor(.black)
                                    .frame(height: 100)
                                    ScrollView(.horizontal, showsIndicators: false, content: {
                                        ScrollViewReader(content: { proxy in
                                            HStack{
                                                ForEach(((exercise.powerSetRS?.allObjects as? [PowerSet])!).sorted(by: {
                                                    $0.set < $1.set
                                                })) { setOne in
                                                    VStack{
                                                        Text("\(setOne.set)")
                                                            .font(.system(size: 17, weight: .thin, design: .rounded))
                                                        Text("\(Int(setOne.weight))")
                                                            .font(.system(size: 17, weight: .regular, design: .rounded))
                                                            .padding(.vertical, 5)
                                                        Text("\(setOne.repeats)")
                                                            .font(.system(size: 17, weight: .regular, design: .rounded))
                                                    }
                                                    .id(setOne)
                                                    .foregroundColor(.black)
//                                                    .padding(.vertical, 12)
                                                    .padding(.horizontal, 12)
//                                                    .padding(.bottom, setOne == ((exercise.powerSetRS?.allObjects as? [PowerSet])!).sorted(by: {$0.set < $1.set}).last() ? 40 : 12)
                                                }
                                            }
                                        })
                                    })
                                    .frame(width: 250, height: 100)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)), lineWidth: 0.5)
                                    )
                                }
                                .padding(.trailing, 20)
                                Spacer()
                            }
                        }
                        .padding(.vertical, 20)
                    }
                }
            }
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(.white)
    }
    
    func getDate(date: Date, object: String) -> String {
        let dateFormatter = DateFormatter()
        var objectDate = ""
        switch object {
        case "dayNumber":
            objectDate = "d"
        case "month":
            objectDate = "LLLL"
        case "year":
            objectDate = "yyyy"
        case "dayOfWeek":
            objectDate = "EEEE"
        default:
            break
        }
        dateFormatter.dateFormat = objectDate
        return dateFormatter.string(from: date).capitalized
    }
    
    func maxWiegth(exercise: Exercise) -> Double {
        var maxWiegth = 0.0
        if (exercise.powerSetRS?.allObjects as? [PowerSet])?.count != 0 {
            for powerSet in (exercise.powerSetRS?.allObjects as? [PowerSet])! {
                if powerSet.weight > maxWiegth {
                    maxWiegth = powerSet.weight
                }
            }
        } else {
            return 0.0
        }
        return maxWiegth
    }
}
