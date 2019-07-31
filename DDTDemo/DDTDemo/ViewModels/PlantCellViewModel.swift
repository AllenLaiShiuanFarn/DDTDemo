//
//  PlantCellViewModel.swift
//  DDTDemo
//
//  Created by Allen Lai on 2019/7/30.
//  Copyright © 2019 Allen Lai. All rights reserved.
//

import UIKit

class PlantCellViewModel {
    let name: String
    let location: String?
    let feature: String?
    let pictureURL: URL?
    
    init(name: String, location: String?, feature: String?, pictureURL: URL?) {
        self.name = name
        self.location = location
        self.feature = feature
        self.pictureURL = pictureURL
    }
}
