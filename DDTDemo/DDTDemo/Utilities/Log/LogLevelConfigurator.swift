//
//  LogLevelConfigurator.swift
//  DDTDemo
//
//  Created by Allen Lai on 2019/7/29.
//  Copyright © 2019 Allen Lai. All rights reserved.
//

import Foundation

enum LogLevel: String {
    case log, error, warn, debug, info, verbose
}

class LogLevelConfigurator {
    // MARK: - Properties
    static let shared = LogLevelConfigurator()
    private(set) var logLevels = [LogLevel]()
    private(set) var shouldShow = false
    private(set) var shouldCache = false
    
    // MARK: - Initializer
    private init() {  }
    
    // MARK: - Public method
    func configure(_ logLevels: [LogLevel], shouldShow: Bool = false, shouldCache: Bool = false) {
        self.logLevels = logLevels
        self.shouldShow = shouldShow
        self.shouldCache = shouldCache
    }
}
