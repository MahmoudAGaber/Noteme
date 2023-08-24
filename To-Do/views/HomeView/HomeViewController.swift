//
//  HomeViewController.swift
//  ToDo
//
//  Created by MAG on 07/08/2023.
//

import UIKit
import Combine

class HomeViewController: UIViewController {

    static let Identifier = String(describing: HomeViewController.self)
    var curdViewModel = CurdViewModel()
    private var cancellables = Set<AnyCancellable>()

    @IBOutlet var addBtn: UIButton!
    @IBOutlet var tableView: UITableView!

    var items: [ToDoModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = true

        itemRegister()

    }

    override func viewWillAppear(_ animated: Bool) {
        updateTableView()
        setupBinds()
        self.title = "TODO"
        navigationItem.title = "TODO"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if let addViewController = segue.destination as? ToDoCURDViewController {
               addViewController.onItemAdded = { [weak self] in
                   self?.tableView.reloadData()
               }
           }
       }
    
    func updateTableView() {
        DispatchQueue.main.async {
            self.curdViewModel.getToDoList()
            self.tableView.reloadData()
        }

    }

    private func itemRegister(){
        tableView.register(UINib(nibName: ToDoItemTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ToDoItemTableViewCell.identifier)
    }
    

    @IBAction func addBtnClicked(_ sender: Any) {

        let vc = storyboard?.instantiateViewController(withIdentifier: ToDoCURDViewController.identifier) as! ToDoCURDViewController

        vc.modalPresentationStyle = .fullScreen
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        title = ""
        navigationController?.pushViewController(vc, animated: true)
        //present(vc, animated: true)
    }

    func setupBinds() {
        curdViewModel.$toToList.sink { [weak self] list in
                self?.items = list
        }.store(in: &cancellables)
    }


}

extension HomeViewController: UITableViewDelegate,UITableViewDataSource {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let vc = storyboard?.instantiateViewController(withIdentifier: ToDoCURDViewController.identifier) as! ToDoCURDViewController

        vc.toDoModel = items[indexPath.row]
        vc.isAdded = true
        vc.id = items[indexPath.row].id
        vc.modalPresentationStyle = .fullScreen
        title = ""
        navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return items.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ToDoItemTableViewCell.identifier, for: indexPath) as! ToDoItemTableViewCell

        cell.setup(items[indexPath.row])
        cell.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        cell.selectionStyle = .none
        return cell

    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }








}


