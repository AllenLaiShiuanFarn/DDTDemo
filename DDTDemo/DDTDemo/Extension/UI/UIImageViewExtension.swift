//
//  UIImageViewExtension.swift
//  DDTDemo
//
//  Created by Allen Lai on 2019/7/30.
//  Copyright © 2019 Allen Lai. All rights reserved.
//

import UIKit

extension UIImageView {
    func loadImage(from url: URL?) {
        image = nil
        APIClient.shared.requestPlantImage(with: url) { [weak self] (result) in
            switch result {
            case .success(let response):
                if let imageData = response.body {
                    DispatchQueue.main.async {
                        self?.image = UIImage(data: imageData)
                    }
                }
            case .failure:
                printLog("Error perform network request")
            }
        }
    }
}
