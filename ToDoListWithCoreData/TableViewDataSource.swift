//
//  TableViewDataSource.swift
//  ToDoListWithCoreData
//
//  Created by Artur Sokolov on 03/09/2019.
//  Copyright © 2019 Artur Sokolov. All rights reserved.
//

import UIKit

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
            delete(at: indexPath.row)
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        showEditAlert(at: indexPath.row)
    }
    
}
