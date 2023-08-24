//
//  DataManager.swift
//  To-Do
//
//  Created by MAG on 09/08/2023.
//

import Foundation
import CoreData
import UIKit

class DataManager {

    static let shared = DataManager()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }


    func  saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }


    func fetchTasks() -> [ToDoModel] {
        let fetchRequest: NSFetchRequest<ToDoDC> = ToDoDC.fetchRequest()

        do{
            let models = try context.fetch(fetchRequest)

            let toDoList = models.map { item in
                let colorString = item.color
                let color = UIColor(hexString: colorString!)
                return ToDoModel(toDoColor: color, id: item.id, toDoTitle: item.name, toDoDescription: item.desc, toDodate: item.date, toDoTime: item.time)
            }

            return toDoList
        } catch {
            print("Error Fetching")
            return []
        }
    }

    func insertTask(toDoModel: ToDoModel) {

        let toDo = ToDoDC(context: context)

        if let color = toDoModel.toDoColor {
        let colorHex = color.toHexString()
                toDo.color = colorHex
            } else {
                toDo.color = "No color"
            }

        toDo.id = toDoModel.id
        toDo.name = toDoModel.toDoTitle
        toDo.desc = toDoModel.toDoDescription
        toDo.date = toDoModel.toDodate
        toDo.time = toDoModel.toDoTime
        DataManager.shared.saveContext()

        print("Task Inserted")

    }

    func updateTask(toDoModel: ToDoModel, id: String) {

        let fetchRequest: NSFetchRequest<ToDoDC> = ToDoDC.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        

        do {
            let model = try context.fetch(fetchRequest)
            if let modelToUpdate = model.first {
                modelToUpdate.name = toDoModel.toDoTitle
                modelToUpdate.desc = toDoModel.toDoDescription
                modelToUpdate.date = toDoModel.toDodate
                modelToUpdate.time = toDoModel.toDoTime
                modelToUpdate.color = (toDoModel.toDoColor)?.toHexString()
                try context.save()
            }
        } catch {
            print("Error fetching tasks: \(error)")
        }

    }

    func deleteTask(id: String) {

        let fetchRequest: NSFetchRequest<ToDoDC> = ToDoDC.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)

        do {
            let model = try context.fetch(fetchRequest)
            if let itemDeleted = model.first {
                context.delete(itemDeleted)
                try context.save()
            }

        } catch {
            print("Error fetching tasks: \(error)")
        }

    }

    }

extension UIColor {
    func toHexString() -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let redInt = Int(red * 255)
        let greenInt = Int(green * 255)
        let blueInt = Int(blue * 255)

        return String(format: "#%02X%02X%02X", redInt, greenInt, blueInt)
    }
}

extension UIColor {
    convenience init?(hexString: String) {
        var sanitizedHex = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        sanitizedHex = sanitizedHex.replacingOccurrences(of: "#", with: "")

        var rgbValue: UInt64 = 0
        Scanner(string: sanitizedHex).scanHexInt64(&rgbValue)

        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}


