//
//  ViewController.swift
//  worksample
//
//  Created by Григорий Мартюшин on 26.03.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    public var tasksList: [CompositeTask] = [CompositeTask(name: "Task 1", tasks: [ConcreteTask(name: "Task 1.1")]),
                                             CompositeTask(name: "Task 2", tasks: [ConcreteTask(name: "Task 2.1")])]
    
    @IBOutlet weak var tableView: UITableView!
    
    // Номер текущей задачи (заполняется при клике на ячейку)
    public var currentTaskNumber: Int? {
        didSet {
            if let currentTaskNumber = self.currentTaskNumber {
                if let currentTaskGroup = self.currentTaskGroup {
                    self.currentTaskGroup = currentTaskGroup.subTask[currentTaskNumber]
                } else {
                    self.currentTaskGroup = tasksList[currentTaskNumber]
                }
            } else {
                self.currentTaskGroup = nil
            }
            
            self.tableView.reloadData()
        }
    }
    
    // Выбранная композитная задача
    public var currentTaskGroup: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        let alert = UIAlertController(title: "Название задачи", message: "Напишите название задачи", preferredStyle: .alert)
        
        // Добавим поле для ввода
        alert.addTextField(configurationHandler: nil)
        
        // Добавим кнопки
        let ok = UIAlertAction(title: "Ok", style: .default) { (_) in
            if let textField = alert.textFields,
                textField.count > 0,
                let taskTitle = textField[0].text,
                taskTitle.isEmpty == false
            {
                self.addTask(title: taskTitle)
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func addTask (title: String) {
        // Если текущая задача существует - значит
        if let currentTaskGroup = currentTaskGroup {
            // Если выбранная группа не группа вовсе, а просто задача
            // то её надо трансформировать в групп
            if let currentTask = currentTaskGroup as? ConcreteTask {
                self.currentTaskGroup = CompositeTask(name: currentTask.name, tasks: [])
            }
                
            // Добавялем задачу в выбранную группу
            self.currentTaskGroup?.add(task: ConcreteTask(name: title))
            
        } else {
            tasksList.append(CompositeTask(name: title, tasks: []))
        }
        
        self.tableView.reloadData()
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let currentTask = currentTaskGroup {
            return currentTask.count
        } else {
            return tasksList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkListCell", for: indexPath)
        let task: Task
        
        if let currentTask = currentTaskGroup {
            task = currentTask.subTask[indexPath.row]
        } else {
            task = tasksList[indexPath.row]
        }
        
        cell.textLabel?.text = task.name
        cell.detailTextLabel?.text = String(task.count)
    
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentTaskNumber = indexPath.row
    }
}
