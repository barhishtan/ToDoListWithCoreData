//
//  VIew Controller + Table View Cell.swift
//  ToDoListWithCoreData
//
//  Created by Artur Sokolov on 03/09/2019.
//  Copyright © 2019 Artur Sokolov. All rights reserved.
//

import UIKit

// MARK: -  UITableViewCell
extension UITableViewCell {
    func customize() {
        self.textLabel?.font = UIFont(name: "HoeflerText-Regular", size: 21)
        self.textLabel?.textColor = .white
        self.backgroundColor = .clear
        self.selectionStyle = .none
    }
}
