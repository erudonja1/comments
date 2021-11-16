//
//  AppError.swift
//  CommentsApp
//
//  Created by Elvis on 11/12/21.
//

import Foundation

enum AppError: Error {
    case statusCode
    case decoding
    case invalidData
    case invalidURL
    case other(Error)
    
    static func map(_ error: Error) -> AppError {
      return (error as? AppError) ?? .other(error)
    }
}

extension AppError: Equatable {
    static func == (lhs: AppError, rhs: AppError) -> Bool {
        lhs.localizedDescription == rhs.localizedDescription
    }
}
