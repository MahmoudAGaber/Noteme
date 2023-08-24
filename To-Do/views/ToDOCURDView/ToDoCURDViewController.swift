//
//  ToDoCURDViewController.swift
//  ToDo
//
//  Created by MAG on 08/08/2023.
//

import UIKit
import Combine

class ToDoCURDViewController: UIViewController {

    var curdViewModel = CurdViewModel()
    static var identifier = String(describing: ToDoCURDViewController.self)
    private var cancellables = Set<AnyCancellable>()

    @IBOutlet var curdLabel: UILabel!
    @IBOutlet var colorsCollection: UICollectionView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var descTextField: UITextField!
    @IBOutlet var date: UIDatePicker!
    @IBOutlet var time: UIDatePicker!

    @IBOutlet var addBtn: UIButton!
    @IBOutlet var stackUpdateTask: UIStackView!

    var colorindex: Bool = false
    var colorSelected: UIColor?
    var toDoModel: ToDoModel?
    var isAdded: Bool = false
    var id: String?

    var colors: [UIColor]?
    var dateSelected: String?
    var timeSelected: String?
    var nameSelected: String?
    var descSelected: String?
    var fullDate: Date?

    var colorSelectedS: IndexPath?

    var onItemAdded: (() -> Void)?


    override func viewDidLoad() {
        super.viewDidLoad()


        isTaskAdded()

        colorSelectedS? = IndexPath(item: 1, section: 1)
        colorSelected = self.toDoModel?.toDoColor
        colorsCollection.delegate = self
        colorsCollection.dataSource = self
        nameTextField.delegate = self
        descTextField.delegate = self

        colors = [.blue, .orange, .yellow, .purple, .red, .green]
        colorSelectedS?.row = (colors?.firstIndex(of: (toDoModel?.toDoColor)!))!


        date.addTarget(self, action: #selector(datePicked), for: .valueChanged)
        time.addTarget(self, action: #selector(timePicked), for: .valueChanged)

        register()


    }

    func notification (){
        let timeFormater = DateFormatter()
        timeFormater.dateFormat = "HH:mm"
        let time = timeFormater.date(from: (toDoModel?.toDoTime)!)

        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy/MM/dd"
        let date = dateFormater.date(from: (toDoModel?.toDodate)!)

        let calendar = Calendar.current
        let combined = calendar.date(bySettingHour: calendar.component(.hour, from: time!),
                                     minute: calendar.component(.minute, from: time!),
                                     second: 0,
                                     of: date!)!

        print(combined)

        let notificationtest = LocalNotificationCenter().scheduleLocalNotification(title: "NotificationTest", body: "Hellllo how are ", date: combined )
    }
   

    func index(for color: UIColor) -> Int? {
        return colors?.firstIndex(of: color)
    }


    func isTaskAdded () {
        if isAdded {

            addBtn.isHidden = true
            stackUpdateTask.isHidden = false
            curdLabel.text = "Update Task"
            colorSelected = toDoModel?.toDoColor
            nameTextField.text = toDoModel?.toDoTitle
            descTextField.text = toDoModel?.toDoDescription

            time.date =  DateAndString().convertStringToDate((toDoModel?.toDoTime)!) ?? Date.now
            date.date =  DateAndString().convertDateStringToDate((toDoModel?.toDodate)!) ?? Date.now

            notification()

            index(for: toDoModel?.toDoColor ?? .gray)

            if let color = toDoModel?.toDoColor {
                if let selectedIndex = index(for: color) {
                    colorSelectedS = IndexPath(item: selectedIndex, section: 0)
                } else {
                    colorSelectedS = nil
                }
            } else {
                colorSelectedS = nil
            }

            colorsCollection.reloadData()

        }
        else {
            curdLabel.text = "Add Task"
        }
    }


    @objc func datePicked (_ datePicker: UIDatePicker) {
        let selectedDate = datePicker.date
        datePicker.date = Date.now
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd" // Customize the date format as needed
        dateSelected = dateFormatter.string(from: selectedDate)
    }

    @objc func timePicked (_ datePicker: UIDatePicker) {
        fullDate = datePicker.date
        datePicker.date = Date.now
        datePicker.preferredDatePickerStyle = .compact
        let selectedDate = datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm" // Customize the date format as needed
        timeSelected = dateFormatter.string(from: selectedDate)
    }



    @IBAction func addBtn(_ sender: Any) {
        let stringId = DateFormatter().string(from: Date.now)
        if let nameText = nameTextField.text, !nameText.isEmpty,
              let descText = descTextField.text, !descText.isEmpty,
              let date = dateSelected, !date.isEmpty,
              let time = timeSelected, !time.isEmpty,
           let color = colorSelected {

            curdViewModel.addToDoItem(toDoItem: ToDoModel(toDoColor: color, id: String(describing: Date.now), toDoTitle: nameText, toDoDescription: descText, toDodate:date, toDoTime: time))

            LocalNotificationCenter().scheduleLocalNotification(title: nameText, body: descText, date: fullDate!)

            onItemAdded?()

            dismiss(animated: true){
                self.navigationController?.popViewController(animated: true)
            }

           } else {
               print("Validation error")
           }
       }

    @IBAction func deleteBtn(_ sender: Any) {

        let alert = UIAlertController(title: "Are you sure you 6?", message: "", preferredStyle: .alert)
        let CancleAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.curdViewModel.deleteToDoItem(id: self.id ?? "")
            self.dismiss(animated: true){
                       self.navigationController?.popViewController(animated: true)
                  }
        })
        alert.addAction(CancleAction)
        alert.addAction(okAction)
        present(alert, animated: true)


    }


    @IBAction func updateBtn(_ sender: Any) {
        if let nameText = nameTextField.text, !nameText.isEmpty,
              let descText = descTextField.text, !descText.isEmpty,
              let date = dateSelected, !date.isEmpty,
              let time = timeSelected, !time.isEmpty,
           let color = colorSelected {

            curdViewModel.updateToDoItem(toDoItem: ToDoModel(toDoColor: color,toDoTitle: nameText, toDoDescription: descText, toDodate:date, toDoTime: time), id: self.id ?? "")

            dismiss(animated: true){
                self.navigationController?.popViewController(animated: true)
            }
            
           } else {
               print("Validation error")
           }
    }


    private func register(){
        colorsCollection.register(ToDoCURDCollectionViewCell.self,
                                  forCellWithReuseIdentifier: ToDoCURDCollectionViewCell.identifier)
    }
}



extension ToDoCURDViewController: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var color = false
        let cell = colorsCollection.dequeueReusableCell(withReuseIdentifier: ToDoCURDCollectionViewCell.identifier, for: indexPath) as! ToDoCURDCollectionViewCell

        let isSelected = colorSelectedS == indexPath

        cell.setupUI(colors![indexPath.row],isSelected: isSelected)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            // Customize the size of your circular cell
            let cellSize = CGSize(width: 50, height: 50)
            return cellSize
        }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        self.colorSelected = colors![indexPath.row]

        if colorSelectedS == indexPath {
            colorSelectedS = nil
        }else {
            colorSelectedS = indexPath
        }



        collectionView.reloadData()
        
    }

}

extension ToDoCURDViewController: UITextFieldDelegate{

    func textFieldDidChangeSelection(_ textField: UITextField) {
        if  textField == nameTextField || textField == descTextField {
        }
    }

}


