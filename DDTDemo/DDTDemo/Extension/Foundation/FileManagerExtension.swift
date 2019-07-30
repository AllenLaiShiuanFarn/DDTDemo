//
//  FileManagerExtension.swift
//  DDTDemo
//
//  Created by Allen Lai on 2019/7/29.
//  Copyright © 2019 Allen Lai. All rights reserved.
//

import Foundation

extension FileManager {
    static var documentDirectory: URL? {
        return self.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    static var cachesDirectory: URL? {
        return self.default.urls(for: .cachesDirectory, in: .userDomainMask).first
    }
    
    static func fileDirectory(with pathComponent: String) throws -> URL? {
        guard let cachesDirectory = FileManager.cachesDirectory else { return nil }
        let fileDirectoryPath = cachesDirectory.appendingPathComponent(pathComponent)
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: fileDirectoryPath.path) == false {
            do {
                try fileManager.createDirectory(at: fileDirectoryPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                throw error
            }
        }
        return fileDirectoryPath
    }
}
