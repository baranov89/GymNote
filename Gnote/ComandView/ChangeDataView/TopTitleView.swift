//
//  TopTitleView.swift
//  Gnote
//
//  Created by Алексей Баранов on 09.07.2022.
//

import SwiftUI

struct TopTitleView: View {
    @Binding var selectedIcon: String
    var body: some View {
        HStack{
            Text(getTitle())
            Spacer()
        }
        .font(.system(size: 22, weight: .light, design: .rounded))
        .padding(.leading , 20)
        .padding(.top, 20)
    }
    
    func getTitle() -> String {
        var title = ""
        switch selectedIcon {
        case "plus.circle":
            title = "Add data"
        case "pencil.circle":
            title = "Change data"
        case "trash.circle":
            title = "Delete data"
        default:
            break
        }
        return title
    }

}
