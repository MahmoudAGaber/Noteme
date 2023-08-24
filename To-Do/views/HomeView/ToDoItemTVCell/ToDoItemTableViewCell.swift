//
//  ToDoItemTableViewCell.swift
//  ToDo
//
//  Created by MAG on 07/08/2023.
//

import UIKit

class ToDoItemTableViewCell: UITableViewCell {

    static var identifier = String(describing: ToDoItemTableViewCell.self)

    @IBOutlet var color: UIView!
    @IBOutlet var desc: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var date: UILabel!

    func setup(_ toDoModel: ToDoModel){
        self.color?.backgroundColor = toDoModel.toDoColor
        self.desc?.text = toDoModel.toDoDescription
        self.date?.text = toDoModel.toDodate
        self.time?.text = toDoModel.toDoTime
    }
}
