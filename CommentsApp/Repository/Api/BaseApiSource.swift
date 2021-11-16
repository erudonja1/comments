//
//  BaseApi.swift
//  CommentsApp
//
//  Created by Elvis on 11/15/21.
//

import Foundation

protocol BaseApiSource {
    func getUrl(route: String) -> URL?
    
    func getHeaders()
    func getAuthenticatedHeaders()
    func getSession()
}

class BaseApiDataSource: NSObject, BaseApiSource {
    
    static let sharedInstance: BaseApiDataSource = BaseApiDataSource()
    private let environment: Environment
    
    init(environment: Environment = .development) {
        self.environment = environment
    }

    func getUrl(route service: String) -> URL? {
        let baseUrl = environment.getBaseUrl()
        guard let url = URL(string: "\(baseUrl)/\(service)") else {
          return nil
        }
        
        return url
    }
    
    func getHeaders() {
        //
    }
    
    func getAuthenticatedHeaders() {
        //
    }
    
    func getSession() {
        //
    }

}


extension URL {

    func appendQuery(_ queryItem: String, value: String?) -> URL {

        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }

        // Create array of existing query items
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []

        // Create query item
        let queryItem = URLQueryItem(name: queryItem, value: value)

        // Append the new query item in the existing query items array
        queryItems.append(queryItem)

        // Append updated query items array in the url component object
        urlComponents.queryItems = queryItems

        // Returns the url from new url components
        return urlComponents.url!
    }
}
