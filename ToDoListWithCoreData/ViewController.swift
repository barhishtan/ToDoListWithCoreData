//
//  ViewController.swift
//  ToDoListWithCoreData
//
//  Created by Artur Sokolov on 03/09/2019.
//  Copyright © 2019 Artur Sokolov. All rights reserved.
//


import UIKit
import CoreData

class ViewController: UITableViewController {
    
    // MARK: - Private Properties
    private let tableColor = #colorLiteral(red: 0.09376922995, green: 0.1349649727, blue: 0.1769709289, alpha: 1)
    private let navigationBarColor = #colorLiteral(red: 0.1299668252, green: 0.1871848702, blue: 0.2499502599, alpha: 1)
    
    private var tasks: [Task] = []
    private let cellID = "cell"
    
    // Managed Object Context
    private let managedContext = (UIApplication.shared.delegate as!
        AppDelegate).persistentContainer.viewContext

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: cellID)
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
    }

    // MARK: - Private Methods
    private func setupView() {
        setupNavigationBar()
        tableView.backgroundColor = tableColor
    }
    
    private func setupNavigationBar() {
        title = "To Do List"
        navigationController?.navigationBar.barTintColor = navigationBarColor
        
        navigationController?.navigationBar.titleTextAttributes =
            [.foregroundColor : UIColor.white,
             .font : UIFont(name: "HoeflerText-Italic", size: 28)!]
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes =
        navigationController?.navigationBar.titleTextAttributes
        navigationController?.navigationBar.barStyle = .black
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    @objc private func addNewTask() {
        showAlert()
    }
    
    private func showAlert() {
        let alert = UIAlertController(
            title: "New Task",
            message: "What do you want do do?",
            preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let task = alert.textFields?.first?.text,
                 !task.isEmpty else { return }
            
            self.save(task)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addTextField()
        alert.textFields?.first?.keyboardAppearance = .dark
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    // MARK: - Work with Core Data
    private func save(_ taskName: String) {
      
        // Entity Description
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: managedContext) else { return }
        
        // Entity (Task model instance from Core Data)
        let task = NSManagedObject(entity: entityDescription, insertInto: managedContext) as! Task
        
        task.name = taskName
        
        // Saving
        do {
            try managedContext.save()
            tasks.append(task)
            self.tableView.insertRows(
                at: [IndexPath(row: self.tasks.count - 1, section: 0)],
                with: .automatic)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func fetchData() {
        
        // Запрос выборки из базы по ключу Task
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        // Присваем результат выборки переменой Tasks
        do {
            tasks = try managedContext.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func deleteTask(at index: Int) {
        // Запрос выборки из базы по ключу Task
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            // Присваеваем результат выборки константе
            let tasks = try managedContext.fetch(fetchRequest)
            // Выбираем элемент по указанному индексу для удаления
            let taskToDelete = tasks[index] as NSManagedObject
            // Удаляем элемент из базы
            managedContext.delete(taskToDelete)
            
            // Пытаемся сохранить изменения
            do {
                try managedContext.save()
            } catch let error {
                print(error.localizedDescription)
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
}


// MARK: -  UITableViewDataSource
extension ViewController {
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        cell.textLabel?.text = tasks[indexPath.row].name
        cell.customize()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            deleteTask(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            moveRowAt fromIndexPath: IndexPath,
                            to: IndexPath) {
        let task = tasks.remove(at: fromIndexPath.row)
        tasks.insert(task, at: to.row)
        tableView.reloadData()
    }
    
}

// MARK: -  UITableViewCell
extension UITableViewCell {
    func customize() {
        self.textLabel?.font = UIFont(name: "HoeflerText-Regular", size: 21)
        self.textLabel?.textColor = .white
        self.backgroundColor = .clear
        self.selectionStyle = .none
    }
}

