//
//  HomeViewModel.swift
//  CommentsApp
//
//  Created by Elvis on 11/11/21.
//

import Foundation
import Combine

private enum Constants {
    static let title: String = "Comments"
    //static let pageSize: Int = 5
}

protocol HomeViewModelProtocol {
    var data: [Comment] { get }
    var state: HomeViewModel.State { get }
    var title: String { get }
    var lastSelected: Comment? { get set }
    
    func fetchInitialPage()
    func fetchNextPage()
    
    func startFetching(for page: Int)
    func stopFetching()
}

class HomeViewModel: HomeViewModelProtocol {
    enum State: Equatable {
        case isLoading
        case loaded
        case failed(error: AppError)
    }
    
    var state: State = .loaded
    var data: [Comment] = []
    var title: String = Constants.title
    var renderOutput: (() -> Void) = {}
    var lastSelected: Comment?
    
    private var currentPage: Int = 1
    private var repository: CommentsRepository
    private var subscriptions: Set<AnyCancellable>
    
    init(repository: CommentsRepository = CommentsRepositoryService(), commentItems: [Comment] = [], render: @escaping (() -> Void)) {
        self.repository = repository
        self.data = commentItems
        self.subscriptions = []
        self.renderOutput = render
    }
    
    func fetchInitialPage() {
        currentPage = 1
        data.removeAll()
        stopFetching()
    
        startFetching(for: currentPage)
    }
    
    func fetchNextPage() {
        switch state {
            case .isLoading:
                break
            default:
                currentPage = currentPage + 1
                startFetching(for: currentPage)
        }
    }
    
    func startFetching(for page: Int) {
        state = .isLoading
        renderOutput()
        
        repository.get(page: page)
            .receive(on: DispatchQueue.main)
            .sink {[weak self] status in
                switch status {
                    case .failure(let error):
                        self?.state = .failed(error: error)
                        self?.renderOutput()
                        
                    case .finished:
                        break
                }
        } receiveValue: { [weak self] items in
            
            // FOR TESTING PURPOSES, forced latency
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self?.data.append(contentsOf: items)
                self?.state = .loaded
                self?.renderOutput()
            })
            
        }.store(in: &subscriptions)
    }
    
    func stopFetching() {
        subscriptions.forEach { $0.cancel() }
        state = .loaded
        renderOutput()
    }
}
