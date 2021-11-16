//
//  CommentsApi.swift
//  CommentsApp
//
//  Created by Elvis on 11/15/21.
//

import Foundation
import Combine

protocol CommentsApiSource {
    func get(page: Int) -> AnyPublisher<[Comment], AppError>
}

class CommentsApiDataSource: CommentsApiSource {
    private let baseApiClient: BaseApiSource
    private let urlSession: URLSession
    
    init(baseApiClient: BaseApiSource = BaseApiDataSource.sharedInstance, urlSession: URLSession = URLSession.shared) {
        self.baseApiClient = baseApiClient
        self.urlSession = urlSession
    }
    
    func get(page: Int) -> AnyPublisher<[Comment], AppError> {
        guard let url = baseApiClient.getUrl(route: "posts/\(page)/comments") else {
            return Fail(error: AppError.invalidURL)
                .eraseToAnyPublisher()
        }

        return urlSession.dataTaskPublisher(for: url)
            .tryMap { response -> Data in
                guard let httpURLResponse = response.response as? HTTPURLResponse, httpURLResponse.statusCode == 200
                else {
                    throw AppError.statusCode
                }
                
                return response.data
            }
            .decode(type: [Comment].self, decoder: JSONDecoder())
            .mapError {AppError.map($0)}
            .eraseToAnyPublisher()
    }
}
