//
//  PrintLog.swift
//  DDTDemo
//
//  Created by Allen Lai on 2019/7/29.
//  Copyright © 2019 Allen Lai. All rights reserved.
//

import UIKit

func printLog(_ items: Any,
              level: LogLevel = .verbose,
              file: String = #file,
              function: String = #function,
              line: Int = #line) {
    #if DEBUG
    if LogLevelConfigurator.shared.logLevels.contains(level) {
        let currentDateString = Date.currentDateString()
        let fileName = file.components(separatedBy: "/").last?.components(separatedBy: ".").first ?? ""
        let logString = "[\(currentDateString)][\(level.rawValue)] \(fileName).\(function):\(line) ~ \(items)"
        
        print(logString)
        
        if LogLevelConfigurator.shared.shouldShow {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let logTextView = appDelegate.logTextView
            
            if logTextView.contentSize.height < logTextView.frame.size.height {
                logTextView.text += "\n\(logString)"
            } else {
                logTextView.text = logString
            }
        }
        
        if LogLevelConfigurator.shared.shouldCache {
            do {
                try logString.saveLog()
            } catch {
                printLog(error.localizedDescription, level: .error)
            }
        }
    }
    #endif
}
