//
//  CommentsRepository.swift
//  CommentsApp
//
//  Created by Elvis on 11/16/21.
//

import Foundation
import Combine

protocol CommentsRepository {
    func get(page: Int) -> AnyPublisher<[Comment], AppError>
}

class CommentsRepositoryService: CommentsRepository {
    private let apiDataSource: CommentsApiSource
    private let dbDataSource: CommentsDbSource
    
    init(apiDataSource: CommentsApiSource = CommentsApiDataSource(), dbDataSource: CommentsDbSource = CommentsDbDataSource()) {
        self.apiDataSource = apiDataSource
        self.dbDataSource = dbDataSource
    }
    
    func get(page: Int) -> AnyPublisher<[Comment], AppError> {
        
        return apiDataSource.get(page: page).map({ result in
            self.dbDataSource.save(page: page, comments: result)
            return result
        }).catch { _ in
            self.dbDataSource.get(page: page)
        }.eraseToAnyPublisher()
    }
}
