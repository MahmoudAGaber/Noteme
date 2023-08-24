//
//  CurdViewModel.swift
//  To-Do
//
//  Created by MAG on 16/08/2023.
//

import Foundation

final class CurdViewModel {

    @Published var toToList: [ToDoModel] = []
    @Published var isAdded: Bool = false

    func getToDoList() -> [ToDoModel] {
        toToList = DataManager.shared.fetchTasks()
        return toToList
    }

     func addToDoItem (toDoItem: ToDoModel) {
         DataManager.shared.insertTask(toDoModel: toDoItem)
         self.toToList.append(toDoItem)
    }

    func updateToDoItem (toDoItem: ToDoModel, id:String) {
        DataManager.shared.updateTask(toDoModel: toDoItem, id: id)
   }

    func deleteToDoItem (id: String) {
        DataManager.shared.deleteTask(id: id)
   }
}
