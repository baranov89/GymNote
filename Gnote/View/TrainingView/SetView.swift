//
//  SetView.swift
//  Gnote
//
//  Created by alex on 10.05.2022.
//

import SwiftUI

struct SetView: View {
    
    @State var focusFeild: FocusFeild? = .weight
    @ObservedObject var vm: CoreDataRelationShipViewModel
    
    @Binding var showSetView: Bool
    @State var weight: String = ""
    @State var repeats: String = ""
    @State var addButtonPressed = true
    @State var setNew: PowerSet?
    
    var body: some View {
        VStack{
            VStack{
                HStack {
                    Button {
                        withAnimation(.easeOut) {
                            showSetView.toggle()
                        }
                    } label: {
                        Text("\(vm.musclGroupCurrent?.name ?? "empty")")
                            .font(.system(size: 20, weight: .light, design: .rounded))
                            .padding(.leading, 20)
                    }
                    Spacer()
                }
                Text("\(vm.exerciseACurrent?.name ?? "empty")")
                    .font(.system(size: 28, weight: .light, design: .rounded))
                    .padding(.vertical, 10)
            }
            .padding(.top, 70)
            HStack{
                VStack(alignment: .trailing) {
                    Text("set")
                    Text("weight")
                        .padding(.vertical, 5)
                    Text("repeat")
                }
                .font(.system(size: 17, weight: .medium, design: .rounded))
                .frame(height: 100)
                ScrollView(.horizontal, showsIndicators: false, content: {
                    ScrollViewReader(content: { proxy in
                        HStack{
                            ForEach(vm.powerSetArray, id: \.self) { setOne in
                                VStack{
                                    Text("\(setOne.set)")
                                    Text("\(Int(setOne.weight))")
                                        .padding(.vertical, 5)
                                    Text("\(setOne.repeats)")
                                }
                                .id(setOne)
                                .font(.system(size: 17, weight: .medium, design: .rounded))
                                .padding(.horizontal, 12)
                                .onChange(of: addButtonPressed, perform: { value in
                                    withAnimation {
                                        proxy.scrollTo(setNew, anchor: .trailing)
                                    }
                                })
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
            .padding(.top, 20)
            HStack{
                Spacer()
                VStack{
                    Text("weight")
                        .font(.system(size: 24, weight: .light, design: .rounded))
                    Text("\(weight)")
                        .multilineTextAlignment(.center)
                        .frame(width: 60, height: 60, alignment: .center)
                        .background(.white)
                        .onTapGesture {
                            focusFeild = .weight
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(focusFeild == .weight ? Color.blue : Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)), lineWidth: focusFeild == .weight ? 2 : 0.5)
                        )
                }
                Text("set \((vm.exerciseACurrent?.powerSetRS?.count ?? 0) + 1)")
                    .frame(width: 100, height: 40)
                    .font(.system(size: 24, weight: .light, design: .rounded))
                    .padding(.horizontal, 30)
                
                VStack{
                    Text("repeat")
                        .font(.system(size: 24, weight: .light, design: .rounded))
                    Text("\(repeats)")
                        .multilineTextAlignment(.center)
                        .frame(width: 60, height: 60, alignment: .center)
                        .background(.white)
                        .onTapGesture {
                            focusFeild = .repeats
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(focusFeild == .repeats ? Color.blue : Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)), lineWidth: focusFeild == .repeats ? 2 : 0.5)
                        )
                }
                Spacer()
            }
            .padding(.top, 30)
            Button {
//                vm.getAllPowerSet(idExercise: (vm.exerciseACurrent?.id)!)
                setNew = vm.savePowerSet(id: UUID(), name: "", repeads: Int64(repeats)!, set: Int64((vm.exerciseACurrent?.powerSetRS!.count)! + 1), weight: Double(weight)!, exercise: vm.exerciseACurrent!)
                vm.getAllPowerSet(idExercise: (vm.exerciseACurrent?.id)!)
                weight = ""
                repeats = ""
                focusFeild = .weight
                addButtonPressed.toggle()
            } label: {
                Text("add")
                    .font(.system(size: 24, weight: .light, design: .rounded))
                    .frame(width: 110, height: 50)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(disabledAddButton() ? .gray.opacity(0.3) : .blue, lineWidth: 1)
                    )
            }
            .disabled(disabledAddButton())
            .padding(.vertical, 20)
            KeyboardView(weight: $weight, repeats: $repeats, focusFeild: $focusFeild)
                .padding(.bottom,50)
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
        .onAppear{
            vm.getAllPowerSet(idExercise: (vm.exerciseACurrent?.id)!)
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(5)) {
                setNew = g()
                addButtonPressed.toggle()
                    }
        }
        
    }
    func disabledAddButton() -> Bool {
        if weight.count != 0 && repeats.count != 0 {
            return false
        }
        return true
    }
    func g() -> PowerSet? {
        vm.getAllPowerSet(idExercise: (vm.exerciseACurrent?.id)!)
            let x: [PowerSet] = (vm.powerSetArray)
            for i in x {
                if i.set == (vm.powerSetArray).count {
                    return i
                }
            }
        
        return nil
    }
}
//    func g() -> PowerSet? {
//        if (vm.exerciseACurrent?.powerSetRS?.allObjects as? [PowerSet]) != nil {
//            let x: [PowerSet] = (vm.exerciseACurrent?.powerSetRS?.allObjects as? [PowerSet])!
//            for i in x {
//                if i.set == (vm.exerciseACurrent?.powerSetRS?.allObjects as? [PowerSet])!.count {
//                    return i
//                }
//            }
//        }
//        return nil
//    }


enum FocusFeild {
    case weight
    case repeats
}

//struct SetView_Previews: PreviewProvider {
//    static var previews: some View {
//        SetView()
//    }
//}
