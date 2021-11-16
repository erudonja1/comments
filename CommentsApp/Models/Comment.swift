//
//  Comment.swift
//  CommentsApp
//
//  Created by Elvis on 11/11/21.
//

import Foundation
import Realm

struct Comment: Decodable, Equatable {
    var id: Int
    var pageId: Int
    var title: String
    var description: String
    var author: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title = "name"
        case pageId = "postId"
        case author = "email"
        case description = "body"
    }
}
