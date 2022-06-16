//
//  UpperView.swift
//  Gnote
//
//  Created by alex on 26.04.2022.
//

import SwiftUI

struct UpperView: View {
    
    @State var toppic: [String] = ["Category", "Training", "History"]
    
    @Binding var selection: TabBarItem
    
    var body: some View {
        HStack{
            Image(systemName: "slider.horizontal.3")
                .padding(.leading, 15)
                .font(.system(size: 20, weight: .light, design: .rounded))
            Spacer()
            Text(e(selection: selection, toppic: toppic))
                .font(.system(size: 25, weight: .light, design: .rounded))
            Spacer()
            Image(systemName: "stop.circle")
                .padding(.trailing, 15)
                .font(.system(size: 20, weight: .light, design: .rounded))
            
        }
        .frame(width: UIScreen.main.bounds.width, height: 50)
        .background(Color.white)
    }
    
    func e(selection: TabBarItem, toppic: [String]) -> String {
        switch selection {
        case TabBarItem.categoty: return toppic[0]
        case TabBarItem.training: return toppic[1]
        case TabBarItem.history: return toppic[2]
    }
}
}
//struct UpperView_Previews: PreviewProvider {
//    static var previews: some View {
//        UpperView()
//    }
//}
