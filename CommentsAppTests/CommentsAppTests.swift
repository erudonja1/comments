//
//  CommentsAppTests.swift
//  CommentsAppTests
//
//  Created by Elvis on 11/11/21.
//

import XCTest
import Combine

@testable import CommentsApp

class CommentsAppTests: XCTestCase {

    override func setUpWithError() throws {}
    override func tearDownWithError() throws {}

    func testGettingThreeCommentsInViewModel() throws {
        let viewModel = HomeViewModel(repository: MockedCommentsRepository1(), commentItems: [], render: {})
        viewModel.fetchInitialPage()
        
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for 3 seconds")], timeout: 3.0)
        
       // XCTAssertEqual(viewModel.state, .loaded)
        XCTAssertEqual(viewModel.data, MockData.getThreeMocks())
    }
    
    func testGettingThreeCommentsInRepository() throws {
        var results: [Comment] = []
        
        let mockedApiSuccessSource = CommentsMockedSuccessApiDataSource()
        let mockedApiFailureSource = CommentsMockedFailureApiDataSource()
        let mockedDbDataSource = CommentsMockedDbDataSource()
        
        var repository: CommentsRepository = CommentsRepositoryService(apiDataSource: mockedApiSuccessSource, dbDataSource: mockedDbDataSource)
        repository.get(page: 1).sink { errors in } receiveValue: { comments in }

        _ = XCTWaiter.wait(for: [expectation(description: "Wait for 3 seconds")], timeout: 3.0)
        
        repository = CommentsRepositoryService(apiDataSource: mockedApiFailureSource, dbDataSource: mockedDbDataSource)
        repository.get(page: 1).sink { errors in
            
        } receiveValue: { comments in
            results = comments
        }

        
        XCTAssertEqual(results, MockData.getTwoMocks())
    }
    
    class MockedCommentsRepository1: CommentsRepository {
        func get(page: Int) -> AnyPublisher<[Comment], AppError> {
            let comments = MockData.getThreeMocks()
            let resultToBeReturned: Result<[Comment], AppError> = .success(comments)
            return resultToBeReturned.publisher.eraseToAnyPublisher()
        }
    }
    
    class CommentsMockedSuccessApiDataSource: CommentsApiSource {
        func get(page: Int) -> AnyPublisher<[Comment], AppError> {
            let comments = MockData.getTwoMocks()
            let resultToBeReturned: Result<[Comment], AppError> = .success(comments)
            return resultToBeReturned.publisher.eraseToAnyPublisher()
        }
    }
    
    class CommentsMockedFailureApiDataSource: CommentsApiSource {
        func get(page: Int) -> AnyPublisher<[Comment], AppError> {
            let resultToBeReturned: Result<[Comment], AppError> = .failure(.invalidData)
            return resultToBeReturned.publisher.eraseToAnyPublisher()
        }
    }
    
    class CommentsMockedDbDataSource: CommentsDbSource {
        var comments: [Comment] = []
        
        func get(page: Int) -> AnyPublisher<[Comment], AppError> {
            let resultToBeReturned: Result<[Comment], AppError> = .success(comments)
            return resultToBeReturned.publisher.eraseToAnyPublisher()
        }
        
        func save(page: Int, comments: [Comment]) {
            self.comments = comments
        }
    }
    
    struct MockData {
        static func getThreeMocks() -> [Comment] {
            let comment1 = Comment(id: 1, pageId: 1, title: "Title", description: "Description", author: "Author")
            let comment2 = Comment(id: 2, pageId: 1, title: "Title1", description: "Description", author: "Author1")
            let comment3 = Comment(id: 3, pageId: 1, title: "Title2", description: "Description", author: "Author2")
            return [comment1, comment2, comment3]
        }
        
        static func getTwoMocks() -> [Comment] {
            let comment1 = Comment(id: 1, pageId: 1, title: "Title", description: "Description", author: "Author")
            let comment2 = Comment(id: 2, pageId: 1, title: "Title1", description: "Description", author: "Author1")
            return [comment1, comment2]
        }
        
        static func getFiveMocks() -> [Comment] {
            let comment1 = Comment(id: 1, pageId: 1, title: "Title", description: "Description", author: "Author")
            let comment2 = Comment(id: 2, pageId: 1, title: "Title1", description: "Description", author: "Author1")
            let comment3 = Comment(id: 3, pageId: 1, title: "Title2", description: "Description", author: "Author2")
            let comment4 = Comment(id: 4, pageId: 1, title: "Title3", description: "Description", author: "Author3")
            let comment5 = Comment(id: 5, pageId: 1, title: "Title4", description: "Description", author: "Author4")
            return [comment1, comment2, comment3, comment4, comment5]
        }
    }
}
