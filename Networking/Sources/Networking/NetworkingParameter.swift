//
//  NetworkingParameter.swift
//
//
//  Created by lee sangho on 1/13/24.
//

import Foundation

public protocol NetworkingParameter: Encodable {
    func toDictionary() -> [String: Any]
    func toData() -> Data?
}

public extension NetworkingParameter {
    func toDictionary() -> [String: Any] {
        let data = try? JSONEncoder().encode(self)
        guard let data = data,
              let dictionary = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any] else {
            return [:]
        }
        
        return dictionary
    }
    
    func toData() -> Data? {
        try? JSONEncoder().encode(self)
    }
}
