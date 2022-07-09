//
//  IconView.swift
//  Gnote
//
//  Created by Алексей Баранов on 07.07.2022.
//

import SwiftUI

struct IconView: View {
    @Binding var selectedIcon: String
    @Binding var selectedMuscle: String
    @Binding var selectedData: SelectedDataEnum
    @Binding var triger: Bool
    
    var body: some View {
        Button {
            selectedData = .muscle
            withAnimation(.easeInOut) {
                triger = false
            }
//            selectedMuscle = ""
            
        } label: {
            Image(systemName: "arrow.backward.square")
                .font(.system(size: 40, weight: .thin, design: .rounded))
//                .resizable()
//                .frame(width: 40, height: 40)
                .padding(.leading, 20)
                .foregroundColor( triger  ? .blue : .gray.opacity(0.3))
                
        }
        
        Spacer()
        Image(systemName: "pencil.circle")
            .resizable()
            .frame(width: 40, height: 40)
            .foregroundColor(selectedIcon == "pencil.circle" ? .blue : .gray.opacity(0.3))
            .onTapGesture {
                selectedIcon = "pencil.circle"
            }
        Image(systemName: "plus.circle")
            .resizable()
            .frame(width: 40, height: 40)
            .foregroundColor(selectedIcon == "plus.circle" ? .green : .gray.opacity(0.3))
            .padding(.horizontal, 30)
            .onTapGesture {
                selectedIcon = "plus.circle"
            }
        
        Image(systemName: "trash.circle")
            .resizable()
            .frame(width: 40, height: 40)
            .foregroundColor(selectedIcon == "trash.circle" ? .red : .gray.opacity(0.3))
            .padding(.trailing, 20)
            .onTapGesture {
                selectedIcon = "trash.circle"
            }
    }
}

