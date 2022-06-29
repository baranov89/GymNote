//
//  TrainingViewMusclGroup.swift
//  Gnote
//
//  Created by alex on 29.04.2022.
//

import SwiftUI

struct TrainingViewMusclGroup: View {
    
    @ObservedObject var vm: CoreDataRelationShipViewModel
    
    @Binding var muscleArray: [MuscleGroup]
    @Binding var selectedGroup: MuscleGroup?
    @Binding var updateMuscleGroupView: Bool
    
    var body: some View {
        ZStack(alignment: .trailing) {
            ScrollView(.horizontal, showsIndicators: false, content: {
                ScrollViewReader { value in
                    HStack{
                        ForEach(muscleArray, id: \.self) { muscleGroup in
                            Text(muscleGroup.name ?? "empty")
                                .id(muscleGroup)
                                .onChange(of: updateMuscleGroupView, perform: { newValue in
                                    withAnimation(.easeIn) {
                                        value.scrollTo(selectedGroup, anchor: .center)
                                    }
                                })
                                .padding(.horizontal, 2)
                                .onTapGesture(perform: {
                                    vm.getAllExercise(idMusclGroup: muscleGroup.id!)
                                    selectedGroup = muscleGroup
                                    withAnimation(.easeIn) {
                                        value.scrollTo(muscleGroup, anchor: .center)
                                    }
                                })
                                .font(.system(size: 27, weight: .light, design: .rounded))
                                .foregroundColor(selectedGroup == muscleGroup ? Color.black : Color.gray)
                                .overlay(
                                    RoundedRectangle(cornerRadius: selectedGroup == muscleGroup ? 10 : 0)
                                        .stroke(selectedGroup == muscleGroup ? .gray : .white, lineWidth: 1)
                                    )
                        }
                    }
                    .padding(.horizontal,20)
                }
            })
            .frame(width: UIScreen.main.bounds.width)
        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

//struct TrainingViewMusclGroup_Previews: PreviewProvider {
//    static var previews: some View {
//        TrainingViewMusclGroup()
//    }
//}
