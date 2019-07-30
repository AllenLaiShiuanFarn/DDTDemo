//
//  Plant.swift
//  DDTDemo
//
//  Created by Allen Lai on 2019/7/29.
//  Copyright © 2019 Allen Lai. All rights reserved.
//

import Foundation

struct PlantData: Decodable {
    var limit: Int
    var offset: Int
    var count: Int
    var sort: String
    var plants: [Plant]
    
    enum CodingKeys: String, CodingKey {
        case result
        case limit
        case offset
        case count
        case sort
        case plants = "results"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let result = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .result)
        limit = try result.decode(Int.self, forKey: .limit)
        offset = try result.decode(Int.self, forKey: .offset)
        count = try result.decode(Int.self, forKey: .count)
        sort = try result.decode(String.self, forKey: .sort)
        
        var results = try result.nestedUnkeyedContainer(forKey: .plants)
        var plantArray = [Plant]()
        while !results.isAtEnd {
            plantArray.append(try results.decode(Plant.self))
        }
        plants = plantArray
    }
}

struct Plant: Decodable {
    var chineseName: String
    var location: String?
    var feature: String?
    var pictureURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case chinesName = "F_Name_Ch"
        case location = "F_Location"
        case feature = "F_Feature"
        case pictureURL = "F_Pic01_URL"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        chineseName = try container.decode(String.self, forKey: .chinesName)
        location = try container.decodeIfPresent(String.self, forKey: .location)
        feature = try container.decodeIfPresent(String.self, forKey: .feature)
        let urlString = try container.decodeIfPresent(String.self, forKey: .pictureURL)
        if let urlString = urlString,
            let url = URL(string: urlString) {
            pictureURL = url
        }
    }
}
