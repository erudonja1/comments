//
//  CommentsDbDataSource.swift
//  CommentsApp
//
//  Created by Elvis on 11/16/21.
//

import Foundation
import Combine

protocol CommentsDbSource {
    func get(page: Int) -> AnyPublisher<[Comment], AppError>
    func save(page: Int, comments: [Comment])
}

class CommentsDbDataSource: CommentsDbSource {
    private let baseDb: BaseDbSource
    private let mapper: CommentMapper
    
    init(baseDb: BaseDbSource = BaseDbDataSource(), mapper: CommentMapper = CommentMapper()) {
        self.baseDb = baseDb
        self.mapper = mapper
    }
    
    func save(page: Int, comments: [Comment]) {
        let db = baseDb.createInstance()
        let data: CommentsPageDb = mapper.toDb(comments, page: page)
        
        if let db = db {
            try! db.write {
                db.add(data, update: .all)
            }
        }
    }
    
    func get(page: Int) -> AnyPublisher<[Comment], AppError> {
        let db = baseDb.createInstance()
        var results: [Comment] = []
        
        if let db = db, let dbResults = db.objects(CommentsPageDb.self).first(where: { $0.page == String(page) }) {
            results = mapper.fromDb(dbResults)
        }
        
        return Just(results).setFailureType(to: AppError.self).eraseToAnyPublisher()
    }
}

