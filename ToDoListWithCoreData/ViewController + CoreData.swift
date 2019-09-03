//
//  ViewController + CoreData.swift
//  ToDoListWithCoreData
//
//  Created by Artur Sokolov on 03/09/2019.
//  Copyright © 2019 Artur Sokolov. All rights reserved.
//

import UIKit
import CoreData

extension ViewController {
    
    // MARK: - Work with Core Data
    func save(_ taskName: String) {
        
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

    func fetchData() {
        
        // Запрос выборки из базы по ключу Task
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        // Присваем результат выборки переменой Tasks
        do {
            tasks = try managedContext.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func delete(at index: Int) {
        // Запрос выборки из базы по ключу Task
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            // Присваеваем результат выборки константе
            let tasks = try managedContext.fetch(fetchRequest)
            // Выбираем элемент по указанному индексу для удаления
            let taskToDelete = tasks[index] as NSManagedObject
            // Удаляем элемент из базы
            managedContext.delete(taskToDelete)
            // Удаляем элемент из массива
            self.tasks.remove(at: index)
            // Удаляем элемент из таблицы
            tableView.deleteRows(at: [IndexPath(row: index, section: 0)],
                                 with: .automatic)
            
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
    
    func update(at index: Int, newTaskName: String) {
        
        // Запрос выборки из базы по ключу Task
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            // Присваеваем результат выборки константе
            let tasks = try managedContext.fetch(fetchRequest)
            // Выбираем элемент по указанному индексу для обновления
            let taskToUpdate = tasks[index] as NSManagedObject
            // Обновляем
            taskToUpdate.setValue(newTaskName, forKey: "name")
            
            self.tasks[index].name = newTaskName
            self.tableView.reloadRows(
                at: [IndexPath(row: index, section: 0)],
                with: .automatic)
            
            // Сохраняем
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
