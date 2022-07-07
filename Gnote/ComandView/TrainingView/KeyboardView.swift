//
//  KeyboardView.swift
//  Gnote
//
//  Created by Алексей Баранов on 29.05.2022.
//

import SwiftUI

struct KeyboardView: View {
    
    @State var backgroundTriger = false
    @State var disabledButton: Bool = true
    @State var colorButton: Color = .black
    
    @Binding var weight: String
    @Binding var repeats: String
    @Binding var focusFeild: FocusFeild?
    
    var arrays: [[String]] = [["1","2","3"],["4","5","6"],["7","8","9"],[".","0","<"]]
    
    var body: some View {
        VStack{
            ForEach(arrays, id: \.self) { array in
                HStack{
                    ForEach(array, id: \.self) { number in
                        Spacer()
                        HStack{
                            Button {
                                if number == "<" {
                                    removeNumber(number: number)
                                } else {
                                    wrightNumber(number: number)
                                }
                            } label: {
                                Text("\(number)")
                                .font(.system(size: 25, weight: .light, design: .rounded))
                                .foregroundColor(colorButton(number: number))
                                .frame(width: 110, height: 50)
                                .background(Color.white)
                                .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(colorButton(number: number), lineWidth: 1)
                                    )
                            }
                            .disabled(colorButton(number: number) == Color.gray.opacity(0.3))
                        }
                        Spacer()
                    }
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/3,alignment: .center)
    }
    
    func wrightNumber(number: String) {
        switch focusFeild {
        case .weight:
            weight += number
        case .repeats:
            repeats += number
        case .none:
            return
        }
    }
    
    func colorButton(number: String) -> Color  {
        if weight.first == "0" && weight.count == 1 && focusFeild == .weight && (number == "1" || number == "2" || number == "3" || number == "4" || number == "5" || number == "6" || number == "7" || number == "8" || number == "9" || number == "0")  {
            return Color.gray.opacity(0.3)
        }
        if weight.contains(".") && focusFeild == .weight && number == "." {
            return Color.gray.opacity(0.3)
        }
        if repeats.count == 0 && focusFeild == .repeats && (number == "0" || number == "."){
            return Color.gray.opacity(0.3)
        }
        if (focusFeild == .repeats || focusFeild == .weight) && number == "." && weight.count == 0 {
            return Color.gray.opacity(0.3)
        }
        return Color.black
    }
    
    func disabledButton(boolTriger: Bool) -> Bool{
        return boolTriger
    }
    
    func removeNumber(number: String) {
        switch focusFeild {
        case .weight:
            if !weight.isEmpty {
                weight.removeLast()
            } else {
                return
            }
        case .repeats:
            if !repeats.isEmpty {
                repeats.removeLast()
            } else {
                return
            }
        case .none:
            return
        }
    }
}
