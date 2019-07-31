//
//  PlantListViewModel.swift
//  DDTDemo
//
//  Created by Allen Lai on 2019/7/31.
//  Copyright © 2019 Allen Lai. All rights reserved.
//

import UIKit

class PlantListViewModel {
    let isLoading = Observable<Bool>(value: false)
    let plantCellViewModels = Observable<[PlantCellViewModel]>(value: [])
    
    func createPlantCellViewModels(plants: [Plant]) {
        var viewModels = [PlantCellViewModel]()
        for plant in plants {
            let plantCellViewModel = PlantCellViewModel(name: plant.chineseName, location: plant.location, feature: plant.feature, pictureURL: plant.pictureURL)
            viewModels.append(plantCellViewModel)
        }
        
        self.plantCellViewModels.value.append(contentsOf: viewModels)
    }
    
    func start() {
        isLoading.value = true
        
        APIClient.shared.requstPlantData(withLimit: 20, offset: 0) { [weak self] (result) in
            self?.isLoading.value = false
            
            switch result {
            case .success(let response):
                if let response = try? response.decode(to: PlantData.self) {
                    self?.createPlantCellViewModels(plants: response.body.plants)
                } else {
                    printLog("Failed to decode response")
                }
            case .failure:
                printLog("Error perform network request")
            }
        }
    }
    
    func loadMorePlants() {
        isLoading.value = true
        
        APIClient.shared.requstPlantData(withLimit: 20, offset: plantCellViewModels.value.count) { [weak self] (result) in

            self?.isLoading.value = false
            
            switch result {
            case .success(let response):
                if let response = try? response.decode(to: PlantData.self) {
                    self?.createPlantCellViewModels(plants: response.body.plants)
                } else {
                    printLog("Failed to decode response")
                }
            case .failure:
                printLog("Error perform network request")
            }
        }
    }
}
