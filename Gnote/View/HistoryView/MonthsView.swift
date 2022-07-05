//
//  MonthsView.swift
//  Gnote
//
//  Created by Алексей Баранов on 02.07.2022.
//

import SwiftUI

struct MonthsView: View {
    @Binding var monthArray: [String]
    @Binding var selectedMonth: String
    @Binding var toggleMonth: Bool
    @Binding var chsngeMonth: Bool
    
    var body: some View {
        Toggle(isOn: $toggleMonth) {
            HStack{
                Menu {
                    ForEach(monthArray, id: \.self) { month in
                        Button {
                            selectedMonth = month
                            chsngeMonth.toggle()
                        } label: {
                            Text("\(month)")
                        }
                    }
                } label: {
                    Text("Month:")
                        .foregroundColor(toggleMonth ? .blue : .gray)
                }
                .padding(.leading, 20)
                .disabled(!toggleMonth)
                Text("\(toggleMonth ? selectedMonth : "all months")")
                    .foregroundColor(toggleMonth ? .black : .gray)
            }
        }
        .tint(.red.opacity(0.3))
        .padding(.trailing , 20)
        .onChange(of: toggleMonth) { newValue in
            if !toggleMonth {
                selectedMonth = ""
            }
        }
    }
}
