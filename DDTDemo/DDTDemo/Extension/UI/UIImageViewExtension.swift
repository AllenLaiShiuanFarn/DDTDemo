//
//  UIImageViewExtension.swift
//  DDTDemo
//
//  Created by Allen Lai on 2019/7/30.
//  Copyright © 2019 Allen Lai. All rights reserved.
//

import UIKit

private let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func loadImage(from url: URL?) {
        image = nil
        
        // get image from cache
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            DispatchQueue.main.async {
                self.image = imageFromCache
                return
            }
        }
        
        APIClient.shared.requestPlantImage(with: url) { [weak self] (result) in
            switch result {
            case .success(let response):
                if let imageData = response.body {
                    DispatchQueue.main.async {
                        // set image to cache
                        guard let imageToCache = UIImage(data: imageData) else { return }
                        imageCache.setObject(imageToCache, forKey: url as AnyObject)
                        self?.image = imageToCache
                    }
                }
            case .failure:
                printLog("Error perform network request")
            }
        }
    }
}
