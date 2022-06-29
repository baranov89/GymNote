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
    @State var deleteButtonPressed = true
    @State var historyButtonPressed = true
    @State var setNew: PowerSet?
    @State var setOld: PowerSet?
    
    @State var arrayHistory: [PowerSet] = []
    @State var dateHistory: Date = Date()
    @State var historyIs: Bool = true
    
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
                                        .foregroundColor(.gray)
                                    Text("\(Int(setOne.weight))")
                                        .padding(.vertical, 7)
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
                                .onChange(of: deleteButtonPressed, perform: { value in
                                    withAnimation {
                                        proxy.scrollTo(setOld, anchor: .trailing)
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
            HStack{
                Spacer()
                Button {
                    if vm.powerSetArray.count == 1 {
                        deleteSet()
                    } else {
                        withAnimation(.linear) {
                            deleteSet()
                        }
                    }
                    vm.getAllPowerSet(idExercise: (vm.exerciseACurrent?.id)!)
                    setOld = vm.powerSetArray.last
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(5)) {
                        withAnimation {
                            deleteButtonPressed.toggle()
                        }
                    }
                } label: {
                    Image(systemName: "delete.left")
                        .font(.system(size: 24, weight: .light, design: .rounded))
                        .frame(width: 110, height: 50)
                        .background(Color.white)
                        .foregroundColor(disabledDeleteButton() ? .gray.opacity(0.3) : .red)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(disabledDeleteButton() ? .gray.opacity(0.3) : .red, lineWidth: 1)
                        )
                }
                .disabled(disabledDeleteButton())
                .padding(.vertical, 20)
                
            Spacer()
                Button {
                    setNew = vm.savePowerSet(id: UUID(), name: "", repeads: Int64(repeats)!, set: Int64((vm.exerciseACurrent?.powerSetRS!.count)! + 1), weight: Double(weight)!, exercise: vm.exerciseACurrent!)
                    vm.getAllPowerSet(idExercise: (vm.exerciseACurrent?.id)!)
                    weight = ""
                    repeats = ""
                    focusFeild = .weight
                    withAnimation {
                        addButtonPressed.toggle()
                    }
                    
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
            Spacer()
            }
            HStack{
                Button {
                    if historyButtonPressed {
                        getHistory()
                    }
                    withAnimation {
                        historyButtonPressed.toggle()
                    }
                    
                } label: {
                    Image(systemName: historyButtonPressed ? "chevron.down" : "chevron.up")
                }
            }
            ZStack{
                VStack{
                    Text("History")
                    HStack{
                        Text(historyIs ? "Last exercise - none" : "Last exercise - \(dateHistory, format: Date.FormatStyle().day().month().year())")
                    }
                HStack{
                    HStack{
                        VStack(alignment: .trailing) {
                            Text("set")
                            Text("weight")
                                .padding(.vertical, 5)
                            Text("repeat")
                        }
                        .font(.system(size: 17, weight: .medium, design: .rounded))
                        .foregroundColor(.black)
                        .frame(height: 100)
                        ScrollView(.horizontal, showsIndicators: false, content: {
                            ScrollViewReader(content: { proxy in
                                HStack{
                                    ForEach(arrayHistory, id: \.self) { setOne in
                                        VStack{
                                            Text("\(setOne.set)")
                                                .foregroundColor(.gray)
                                            Text("\(Int(setOne.weight))")
                                                .padding(.vertical, 5)
                                            Text("\(setOne.repeats)")
                                        }
                                        .id(setOne)
                                        .font(.system(size: 17, weight: .medium, design: .rounded))
                                        .foregroundColor(.black)
                                        .padding(.horizontal, 12)
                                        .onChange(of: historyButtonPressed, perform: { value in
                                            withAnimation {
                                                proxy.scrollTo(arrayHistory.last, anchor: .trailing)
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
                    .padding(.bottom, 60)
                }
            }
                HStack{
                    KeyboardView(weight: $weight, repeats: $repeats, focusFeild: $focusFeild)
                        .padding(.bottom,50)
                        .background(.white)
                }
                .offset(y: historyButtonPressed ? 0 : 300)
            }
            
            
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
        .onAppear{
            historyIs = true
            vm.getAllPowerSet(idExercise: (vm.exerciseACurrent?.id)!)
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(5)) {
                setNew = g()
                addButtonPressed.toggle()
                    }
        }
    }
    
    func getHistory() {
        vm.getEveryExercise()
        var exer: [Exercise] = []
        for i in vm.exerciseArrayEvery {
            if i.id != vm.exerciseACurrent?.id && i.muscleGroupRS?.name == vm.exerciseACurrent?.muscleGroupRS!.name && i.name == vm.exerciseACurrent?.name {
                exer.append(i)
            }
        }
        
        var findExercise: Exercise?
        var sortedExeciseArray: [Exercise] = []
        
        switch exer.count {
        case 0:
            break
        case 1:
            findExercise = exer[0]
        default:
            sortedExeciseArray = exer.sorted { one, two in
                (one.muscleGroupRS?.workOutRS?.date)! < (two.muscleGroupRS?.workOutRS?.date)!
            }
                findExercise = sortedExeciseArray.last
        }
        
        if findExercise != nil {
            dateHistory = (findExercise?.muscleGroupRS?.workOutRS?.date)!
            historyIs = false
            arrayHistory = vm.getHistoryPowerSet(idExercise: (findExercise?.id)!)
        }
        
    }
    
    func disabledAddButton() -> Bool {
        if weight.count != 0 && repeats.count != 0 {
            return false
        }
        return true
    }
    
    func disabledDeleteButton() -> Bool {
        if vm.powerSetArray.count != 0 {
            return false
        }
        return true
    }
    
    func deleteSet() {
        vm.delete(deleteObject: vm.powerSetArray.last)
        vm.getAllPowerSet(idExercise: (vm.exerciseACurrent?.id)!)
    }
    
    func g() -> PowerSet? {
        vm.getAllPowerSet(idExercise: (vm.exerciseACurrent?.id)!)
            let x: [PowerSet] = vm.powerSetArray
            for i in x {
                if i.set == (vm.powerSetArray).count {
                    return i
                }
            }
        
        return nil
    }
}


enum FocusFeild {
    case weight
    case repeats
}

//struct SetView_Previews: PreviewProvider {
//    static var previews: some View {
//        SetView()
//    }
//}
