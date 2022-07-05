//
//  HistoryView.swift
//  Gnote
//
//  Created by Алексей Баранов on 01.07.2022.
//


import SwiftUI

struct HistoryViwe: View {
    @ObservedObject var vm: CoreDataRelationShipViewModel
    
    @State var workOutFiltered: [WorkOut] = []
    @State var changeMonth: Bool = false
    @State var changeMuscle: Bool = false
    @State var changeExercise: Bool = false
    
    @State var yearsArray: [String] = []
    @State var selectedYear: String = ""
    
    @State var monthArray: [String] = []
    @State var selectedMonth: String = ""
    @State var toggleMonth: Bool = false
    
    @State var musclesArray: [String] = []
    @State var selectedMuscle: String = ""
    @State var toggleMuscle: Bool = false
    
    @State var exercisesArray: [String] = []
    @State var selectedExercise: String = ""
    @State var toggleExercise: Bool = false
    @State var toggleShowMuscleGroup: Bool = false
    @State var countX = 0
    
    var body: some View {
        VStack{
            HStack{
                Text("Add Filter")
                    .padding(.leading , 20)
                Spacer()
            }
            .padding(.top, 20)
            Divider()
            VStack{
                YearsView(yearSArray: $yearsArray, selectedYear: $selectedYear)
                MonthsView(monthArray: $monthArray, selectedMonth: $selectedMonth, toggleMonth: $toggleMonth, chsngeMonth: $changeMonth)
                    .padding(.vertical, 5)
                MusclesView(musclesArray: $musclesArray, selectedMuscle: $selectedMuscle, toggleMuscle: $toggleMuscle, toggleExercise: $toggleExercise, changeMuscle: $changeMuscle)
                HStack{
                    Toggle(isOn: $toggleShowMuscleGroup) {
                        Text("Show muscle group")
                            .padding(.leading, 20)
                    }
                    .padding(.trailing, 20)
                    .tint(.red.opacity(0.3))
                }
                .padding(.top, 20)
                Divider()
            }
            ExerciseScrollView(workOutFiltered: $workOutFiltered, toggleMuscle: $toggleMuscle, toggleMonth: $toggleMonth, toggleShowMuscleGroup: $toggleShowMuscleGroup)
            .onAppear{
                getYears()
                selectedYear = yearsArray.first!
                toggleMonth = false
                toggleMuscle = false
                toggleExercise = false
                filterForWorkOut()
            }
            .onChange(of: changeMonth, perform: { newValue in
                if toggleMuscle {
                    getMuscle()
                    selectedMuscle = musclesArray.first!
                }
                if toggleExercise {
                    getExercise()
                    selectedExercise = exercisesArray.first!
                }
                filterForWorkOut()
            })
            .onChange(of: changeMuscle, perform: { newValue in
                if toggleExercise {
                    getExercise()
                    if exercisesArray.isEmpty {
                        toggleExercise = false
                    } else {
                        selectedExercise = exercisesArray.first!
                    }
                    
                }
                filterForWorkOut()
            })
            .onChange(of: changeExercise, perform: { newValue in
                filterForWorkOut()
            })
            .onChange(of: toggleMonth) { newValue in
                getMonth()
                if toggleMonth {
                    selectedMonth = monthArray.first!
                } else {
                    selectedMonth = ""
                }
                getMuscle()
                if toggleMuscle {
                    selectedMuscle = musclesArray.first!
                } else {
                    selectedMuscle = ""
                }
                filterForWorkOut()
            }
            .onChange(of: toggleMuscle) { newValue in
                getMuscle()
                if toggleMuscle {
                    selectedMuscle = musclesArray.first!
                } else {
                    selectedMuscle = ""
                }
                getExercise()
                if toggleExercise {
                    selectedExercise = exercisesArray.first!
                } else {
                    selectedExercise = ""
                }
                filterForWorkOut()
            }
        }
    }
    
    func filterForWorkOut() {
        workOutFiltered.removeAll()
        var workOutArrayYear: [WorkOut] = []
        var workOutArrayMonth: [WorkOut] = []
        var workOutArrayMuscle: [WorkOut] = []
        for workOut in vm.workOutArray {
            if workOut.year == selectedYear {
                workOutArrayYear.append(workOut)
            }
        }
        if selectedMonth != "" {
            for workOut in workOutArrayYear {
                if workOut.month == selectedMonth {
                    workOutArrayMonth.append(workOut)
                }
            }
        } else {
            for workOut in workOutArrayYear {
                workOutArrayMonth.append(workOut)
            }
            
        }
        if selectedMuscle != "" {
            for workOut in workOutArrayMonth {
                for muscleGroup in (workOut.muscleGroupRS?.allObjects as? [MuscleGroup])! {
                    if muscleGroup.name == selectedMuscle {
                        workOutArrayMuscle.append(workOut)
                    }
                }
            }
        } else {
            for workOut in workOutArrayMonth {
                workOutArrayMuscle.append(workOut)
            }
        }
        workOutFiltered = workOutArrayMuscle.sorted(by: { one, two in
            one.date! < two.date!
        })
    }
    
    func getYears() {
        yearsArray.removeAll()
        vm.getAllWorkOut()
        var array: [String] = []
        for i in vm.workOutArray {
            array.append(i.year!)
        }
        yearsArray = Array(Set(array))
    }
    
    func getMonth() {
        monthArray.removeAll()
        var arrayWorkOut: [WorkOut] = []
        var monthArrayAll: [String] = []
        for i in vm.workOutArray {
            if i.year! == selectedYear {
                arrayWorkOut.append(i)
            }
        }
        for i in arrayWorkOut {
            monthArrayAll.append(i.month!)
        }
        monthArray = Array(Set(monthArrayAll))
        monthArray = monthArray.sorted()
    }
    
    func getMuscle() {
        musclesArray.removeAll()
        //        var arrayWorkOut: [WorkOut] = []
        //        var muscleArrayAll: [MuscleGroup] = []
        var arrayWorkOutInYear: [WorkOut] = []
        var arrayWorkOutInMonth: [WorkOut] = []
        var muscleArrayString: [String] = []
        for i in vm.workOutArray {
            if i.year! == selectedYear  {
                arrayWorkOutInYear.append(i)
            }
        }
        for i in arrayWorkOutInYear {
            if selectedMonth != "" {
                if selectedMonth == i.month {
                    arrayWorkOutInMonth.append(i)
                }
            } else {
                arrayWorkOutInMonth.append(i)
            }
            
            for workOut in arrayWorkOutInMonth {
                for muscleGroup in (workOut.muscleGroupRS?.allObjects as? [MuscleGroup])! {
                    muscleArrayString.append(muscleGroup.name!)
                }
            }
        }
        muscleArrayString = Array(Set(muscleArrayString))
        musclesArray = muscleArrayString
        musclesArray = musclesArray.sorted()
    }
    
    func getExercise() {
        exercisesArray.removeAll()
        var arrayWorkOutInYear: [WorkOut] = []
        var arrayWorkOutInMonth: [WorkOut] = []
        var exersiseArrayString: [String] = []
        for i in vm.workOutArray {
            if i.year! == selectedYear  {
                arrayWorkOutInYear.append(i)
            }
        }
        for i in arrayWorkOutInYear {
            if selectedMonth != "" {
                if selectedMonth == i.month {
                    arrayWorkOutInMonth.append(i)
                }
            } else {
                arrayWorkOutInMonth.append(i)
            }
        }
        for workOut in arrayWorkOutInMonth {
            for muscleGroup in (workOut.muscleGroupRS?.allObjects as? [MuscleGroup])! {
                if muscleGroup.name == selectedMuscle {
                    for exercise in (muscleGroup.exerciseRS!.allObjects as? [Exercise])! {
                        if exercise.name == selectedExercise {
                            exersiseArrayString.append(exercise.name!)
                        }
                    }
                }
                
            }
        }
        exersiseArrayString = Array(Set(exersiseArrayString))
        exersiseArrayString = exersiseArrayString.sorted()
        exercisesArray = exersiseArrayString
    }
}


