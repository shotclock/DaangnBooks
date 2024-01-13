//
//  NetworkingBuilder.swift
//
//
//  Created by lee sangho on 1/13/24.
//

import Foundation

public struct NetworkingBuilder {
    private init() { }
    
    public static func build(urlSession: URLSession = .shared) -> Networking {
        NetworkingImplement(urlSession: urlSession)
    }
}
