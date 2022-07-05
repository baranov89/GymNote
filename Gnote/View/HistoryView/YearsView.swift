//
//  YearsView.swift
//  Gnote
//
//  Created by Алексей Баранов on 02.07.2022.
//

import SwiftUI

struct YearsView: View {
    @Binding var yearSArray: [String]
    @Binding var selectedYear: String
    
    var body: some View {
        
        HStack(alignment: .center){
            Menu {
                ForEach(yearSArray, id: \.self) { year in
                    Button {
                        selectedYear = year
                    } label: {
                        Text("\(year)")
                    }
                }
            } label: {
                Text("Year:")
                    .foregroundColor(.blue)
            }
            .padding(.leading, 20)
            Text("\(selectedYear)")
            Spacer()
        }
    }
}

