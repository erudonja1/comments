//
//  Environment.swift
//  CommentsApp
//
//  Created by Elvis on 11/16/21.
//

import Foundation

enum Environment {
    case development
    case staging
    case production
    
    
    func getBaseUrl() -> String {
        switch self {
        case .development:
            return "https://jsonplaceholder.typicode.com"
        case .staging:
            return "https://jsonplaceholder.typicode.com"
        case .production:
            return "https://jsonplaceholder.typicode.com"
        }
    }
}
