//
//  BaseDb.swift
//  CommentsApp
//
//  Created by Elvis on 11/16/21.
//

import Foundation
import RealmSwift

protocol BaseDbSource {
    init(configuration: Realm.Configuration, fileUrl: URL)
    func createInstance() -> Realm?
}


class BaseDbDataSource: NSObject, BaseDbSource {
    var configuration: Realm.Configuration

    required init(configuration: Realm.Configuration = .defaultConfiguration, fileUrl: URL = URL(fileURLWithPath: "")) {
        self.configuration = configuration
//        if !fileUrl.absoluteString.isEmpty {
//            self.configuration.fileURL = fileUrl
//        }
    }
    
    func createInstance() -> Realm? {
        do {
            let realm = try Realm(configuration: configuration)
            // Use realm
            return realm
        } catch let error as NSError {
            // Handle error
            print(error)
            return nil
        }
    }
}
