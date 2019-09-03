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
    
    // MARK: - Properties
    private let tableColor = #colorLiteral(red: 0.09376922995, green: 0.1349649727, blue: 0.1769709289, alpha: 1)
    private let navigationBarColor = #colorLiteral(red: 0.1299668252, green: 0.1871848702, blue: 0.2499502599, alpha: 1)
    
    var tasks: [Task] = []
    let cellID = "cell"
    
    // Managed Object Context
    let managedContext = (UIApplication.shared.delegate as!
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

    // MARK: - Methods
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
        
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.leftBarButtonItem?.title = "—"
        navigationItem.leftBarButtonItem?.tintColor = .red
    }
    
    @objc private func addNewTask() {
        showAddAlert()
    }
    
    private func showAddAlert() {
        let alert = UIAlertController(
            title: "New Task",
            message: "What do you want to do?",
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
    
    func showEditAlert(at row: Int) {
        let alert = UIAlertController(
            title: "Edit task",
            message: "Do you want to change this?",
            preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let task = alert.textFields?.first?.text,
                !task.isEmpty else { return }
            
            self.update(at: row, newTaskName: task)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addTextField()
        alert.textFields?.first?.keyboardAppearance = .dark
        alert.textFields?.first?.text = tasks[row].name
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
}





