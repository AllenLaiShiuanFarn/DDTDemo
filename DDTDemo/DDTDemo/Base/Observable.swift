//
//  Observable.swift
//  DDTDemo
//
//  Created by Allen Lai on 2019/7/31.
//  Copyright © 2019 Allen Lai. All rights reserved.
//

import Foundation

class Observable<T> {
    var value: T {
        didSet {
            DispatchQueue.main.async {
                self.valueChanged?(self.value)
            }
        }
    }
    private var valueChanged: ((T) -> Void)?
    
    init(value: T) {
        self.value = value
    }
    
    func addObserver(willPerfromImmediately: Bool = true, _ onChange: ((T) -> Void)?) {
        valueChanged = onChange
        if willPerfromImmediately {
            onChange?(value)
        }
    }
    
    func removeObserver() {
        valueChanged = nil
    }
}
