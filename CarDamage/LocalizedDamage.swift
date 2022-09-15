//
//  LocalizedDamage.swift
//  CarDamage
//
//  Created by Darren Asamov on 31/01/2022.
//

import UIKit

class LocalizedDamage: Codable {
    let imageColor: String, CoordinatePointX: CGFloat, CoordinatePointY: CGFloat
    
    init(imageColor: String, CoordinatePointX: CGFloat, CoordinatePointY: CGFloat)
    {
        self.imageColor = imageColor
        self.CoordinatePointX = CoordinatePointX
        self.CoordinatePointY = CoordinatePointY
    }
    
    static func toString(record: [LocalizedDamage]) -> String  {
        do {
          let encoder = JSONEncoder()
          let response = try encoder.encode(record)
            if let jsonString = String(data: response, encoding: .utf8) {
                return jsonString
            }
    
        } catch {
            print(error.localizedDescription)
        }
        return ""
    }
    
    static func fromString(json: String) -> [LocalizedDamage] {
        do {
          let jsonDecoder = JSONDecoder()
          let decodedResponse = try jsonDecoder.decode([LocalizedDamage].self,
                                                       from: json.data(using: .utf8)!)
           return decodedResponse
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
}
