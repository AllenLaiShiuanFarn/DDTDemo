//
//  UITableViewExtension.swift
//  DDTDemo
//
//  Created by Allen Lai on 2019/7/29.
//  Copyright © 2019 Allen Lai. All rights reserved.
//

import UIKit

extension UITableView {
    func register(cellClasses: UITableViewCell.Type...) {
        cellClasses.forEach { self.register($0, forCellReuseIdentifier: $0.className) }
    }
}
