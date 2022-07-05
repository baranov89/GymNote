//
//  CoreDataRaelationShipViewModel.swift
//  Gnote
//
//  Created by alex on 07.04.2022.
//

import Foundation
import CoreData

class CoreDataRelationShipViewModel: ObservableObject {
    
    let manager = CoreDataManager.instance
    
    @Published var workOutCurrent: WorkOut?
    @Published var musclGroupCurrent: MuscleGroup?
    @Published var exerciseACurrent: Exercise?
    @Published var powerSetCurrent: PowerSet?
    @Published var cardioSetCurrent: CardioSet?
    
    @Published var workOutArray: [WorkOut] = []
    @Published var musclGroupArray: [MuscleGroup] = []
    @Published var exerciseArray: [Exercise] = []
    @Published var exerciseArrayEvery: [Exercise] = []
    @Published var powerSetArray: [PowerSet] = []
    @Published var cardioSetArray: [CardioSet] = []
    @Published var allMuscleGroupArray: [MuscleGroupList] = []
    @Published var allExerciseArray: [ExerciseList] = []
    @Published var count = 0
    func save() {
        manager.save()
    }
    
    func deleteAllData() {
        manager.clearDatabase()
    }
    
    func saveMuscleGroupList(name: String, workOut: WorkOut) -> MuscleGroupList {
        let muscleGroupList = MuscleGroupList(context: manager.context)
        muscleGroupList.name = name
        muscleGroupList.workOutRS = workOut
        save()
        return muscleGroupList
    }
    
    func saveWorkout(id: UUID, year: String, month: String, date: Date) -> WorkOut {
        let workOut = WorkOut(context: manager.context)
        workOut.year = year
        workOut.month = month
        workOut.date = date
        workOut.id = id
        
        save()
        return workOut
    }
    
    func saveMusclGroup(id: UUID, name: String, workOut: WorkOut) -> MuscleGroup {
        let musclGroup = MuscleGroup(context: manager.context)
        musclGroup.id = id
        musclGroup.name = name
        
        musclGroup.workOutRS = workOut
        save()
        return musclGroup
    }
    
    func saveExercise(id: UUID, name: String, number: Int64, comment: String = "Нет комментаря", musclGroup: MuscleGroup) {
        let exercise = Exercise(context: manager.context)
        exercise.id = id
        exercise.name = name
        exercise.number = number
        exercise.comment = comment
        
        exercise.muscleGroupRS = musclGroup
        save()
    }
    
    func saveExerciseList(name: String, muscleGroup: MuscleGroupList) {
        let exercise = ExerciseList(context: manager.context)
        
        exercise.name = name
        exercise.muscleGroupListRS = muscleGroup
        save()
    }
    
    func savePowerSet(id: UUID, name: String, repeads: Int64, set: Int64, weight: Double, exercise: Exercise) -> PowerSet {
        let powerSet = PowerSet(context: manager.context)
        powerSet.id = id
        powerSet.name = name
        powerSet.set = set
        powerSet.repeats = repeads
        powerSet.weight = weight
        
        powerSetCurrent = powerSet
        
        powerSet.exerciseRS = exercise
        save()
        return powerSet
    }
    
    func saveCardioSet(id: UUID, name: String, speed: Double = 0.0, slope: Double = 0.0, time: Date, distance: Double = 0.0, comment: String = "Нет комментария", sitting: Int64 = 0, exercise: Exercise) -> CardioSet {
        let cardioSet = CardioSet(context: manager.context)
        cardioSet.id = id
        cardioSet.name = name
        cardioSet.speed = speed
        cardioSet.slope = slope
        cardioSet.distance = distance
        cardioSet.comment = comment
        cardioSet.time = time
        
        cardioSet.exerciseRS = exercise
        save()
        return cardioSet
    }
    
    func getAllWorkOut() {
        let request = NSFetchRequest<WorkOut>(entityName: "WorkOut")
        workOutArray.removeAll()
        do {
            try workOutArray = manager.context.fetch(request)
        } catch let error {
            print("Error fetchig worckout \(error.localizedDescription)")
        }
    }
    
    func getMuscleGroupList(idWorkOut: UUID) {
        let request = NSFetchRequest<MuscleGroupList>(entityName: "MuscleGroupList")
        let filter = NSPredicate(format: "workOutRS.id == %@", "\(idWorkOut)")
        request.predicate = filter
        allMuscleGroupArray.removeAll()
        do {
            try allMuscleGroupArray = manager.context.fetch(request).sorted(by: { one, two in
                one.name! < two.name!
            })
        } catch let error {
            print("Error fetchig worckout \(error.localizedDescription)")
        }
    }
    
    func getExerciseList(muscleGroup: String) {
        let request = NSFetchRequest<ExerciseList>(entityName: "ExerciseList")
        
        let filter = NSPredicate(format: "muscleGroupListRS.name == %@", "\(muscleGroup)")
        request.predicate = filter
        allExerciseArray.removeAll()
        do {
            try allExerciseArray = manager.context.fetch(request)
        } catch let error {
            print("Error fetchig worckout \(error.localizedDescription)")
        }
    }
    
    func getCurrentWorkOut(idWorkOut: UUID) {
        let request = NSFetchRequest<WorkOut>(entityName: "WorkOut")
        
        let filter = NSPredicate(format: "id == %@", "\(idWorkOut)")
        request.predicate = filter
        workOutArray.removeAll()
        do {
            try workOutArray = manager.context.fetch(request)
        } catch let error {
            print("Error fetchig worckout \(error.localizedDescription)")
        }
    }
    
    func getAllMusclGroup(idWorkOut: UUID) {
        let request = NSFetchRequest<MuscleGroup>(entityName: "MuscleGroup")
        
        let filter = NSPredicate(format: "workOutRS.id == %@", "\(idWorkOut)")
        request.predicate = filter
        
        musclGroupArray.removeAll()
        
        do {
            try musclGroupArray = manager.context.fetch(request)
        } catch let error {
            print("Error fetchig musclegroup \(error.localizedDescription)")
        }
    }
    
    func findMuscleGroup(name: String, idWorkOut: UUID) -> Bool {
        let request = NSFetchRequest<MuscleGroup>(entityName: "MuscleGroup")
        let filterOne = NSPredicate(format: "name == %@", "\(name)")
        request.predicate = filterOne
        var muscleGroup: [MuscleGroup] = []
        do {
            try muscleGroup = manager.context.fetch(request)
        } catch let error {
            print("Error fetchig vusclgroup \(error.localizedDescription)")
        }
        if muscleGroup.isEmpty {
            return false
        } else {
            let f = muscleGroup.filter { i in
                i.workOutRS?.id == idWorkOut
            }
            if f.isEmpty {
                return false
            } else {
                return true
            }
        }
    }
    
    func getCurrentMusclGroup(MuscleGroup: String) -> [MuscleGroup] {
        let request = NSFetchRequest<MuscleGroup>(entityName: "MuscleGroup")
        let filter = NSPredicate(format: "name == %@", "\(MuscleGroup)")
        request.predicate = filter
        var muscleGroup: [MuscleGroup] = []
        do {
            try muscleGroup = manager.context.fetch(request)
        } catch let error {
            print("Error fetchig vusclgroup \(error.localizedDescription)")
        }
        return muscleGroup
    }
    
    func getAllExercise(idMusclGroup: UUID) -> [Exercise] {
        let request = NSFetchRequest<Exercise>(entityName: "Exercise")
        let filter = NSPredicate(format: "muscleGroupRS.id == %@", "\(idMusclGroup)")
        request.predicate = filter
        exerciseArray.removeAll()
        var exerciseArrayTwo: [Exercise] = []
        do {
            try exerciseArray = manager.context.fetch(request)
        } catch let error {
            print("Error fetchig vusclgroup \(error.localizedDescription)")
        }
        exerciseArrayTwo = exerciseArray
        return exerciseArrayTwo
    }
    
    func getEveryExercise() {
        let request = NSFetchRequest<Exercise>(entityName: "Exercise")
        exerciseArrayEvery.removeAll()
        do {
            try exerciseArrayEvery = manager.context.fetch(request)
        } catch let error {
            print("Error fetchig vusclgroup \(error.localizedDescription)")
        }
    }
    
    func getHistoryPowerSet(idExercise: UUID) -> [PowerSet] {
        let request = NSFetchRequest<PowerSet>(entityName: "PowerSet")
        let filter = NSPredicate(format: "exerciseRS.id == %@", "\(idExercise)")
        request.predicate = filter
        var powerSetHistoryArray: [PowerSet] = []
        do {
            try powerSetHistoryArray = manager.context.fetch(request)
        } catch let error {
            print("Error fetchig musclgroup \(error.localizedDescription)")
        }
        return powerSetHistoryArray
    }
    
    func getAllPowerSet(idExercise: UUID) {
        let request = NSFetchRequest<PowerSet>(entityName: "PowerSet")
        let filter = NSPredicate(format: "exerciseRS.id == %@", "\(idExercise)")
        request.predicate = filter
        powerSetArray.removeAll()
        do {
            try powerSetArray = manager.context.fetch(request)
        } catch let error {
            print("Error fetchig musclgroup \(error.localizedDescription)")
        }
    }
    
    func getAllCardioSet(idExercise: UUID) {
        let request = NSFetchRequest<CardioSet>(entityName: "CardioSet")
        let filter = NSPredicate(format: "exerciseRS.id == %@", "\(idExercise)")
        request.predicate = filter
        cardioSetArray.removeAll()
        do {
            try cardioSetArray = manager.context.fetch(request)
        } catch let error {
            print("Error fetchig musclgroup \(error.localizedDescription)")
        }
    }
    
    func delete<T>(deleteObject: T) {
        let deleteObject = deleteObject
        manager.context.delete(deleteObject as! NSManagedObject)
        save()
    }
    
    func deleteExerciseList(exerciseList: ExerciseList) {
        manager.context.delete(exerciseList)
        save()
    }
}

