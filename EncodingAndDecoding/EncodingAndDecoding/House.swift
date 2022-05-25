//
//  House.swift
//  EncodingAndDecoding
//
//  Created by Hut on 2022/5/25.
//

import Foundation

/*
 For more information
 
 https://developer.apple.com/documentation/foundation/archives_and_serialization/encoding_and_decoding_custom_types
 
 */

struct House {
    var name: String
    var location: Coordinate
    var buidDate: Date?
    var stories: Int
    var area: Double
}

struct Coordinate: Codable {
    var latitude: Double
    var longitude: Double
}

extension House: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case location
        case buidDate
        case stories
        case area
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(location, forKey: .location)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var dateString = ""
        if let sTime = buidDate {
            let dateStr = dateFormatter.string(from: sTime)
            dateString = dateStr
        }
        try container.encode(dateString, forKey: .buidDate)
        try container.encode(stories, forKey: .stories)
        try container.encode(area, forKey: .area)
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        location = try values.decode(Coordinate.self, forKey: .location)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var sDate: Date? = nil
        if let dateString = try? values.decode(String.self, forKey: .buidDate),
           let saveDate = dateFormatter.date(from: dateString) {
            sDate = saveDate
        }
        buidDate = sDate
        stories = try values.decode(Int.self, forKey: .stories)
        area = try values.decode(Double.self, forKey: .area)
    }
}
