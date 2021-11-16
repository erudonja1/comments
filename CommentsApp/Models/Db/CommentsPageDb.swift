//
//  CommentDb.swift
//  CommentsApp
//
//  Created by Elvis on 11/16/21.
//

//import Foundation
import RealmSwift

class CommentsPageDb: Object {

    override class func primaryKey() -> String? {
        "page"
    }
    
    @Persisted
    var page: String
    
    @Persisted
    var comments: List<CommentDb>
    
    override convenience init() {
        self.init(page:0, comments:List<CommentDb>())
    }
    
    init(page: Int, comments: List<CommentDb>) {
        super.init()
        self.page = String(page)
        self.comments = comments
    }
    
}

class CommentDb: Object {
    
    override class func primaryKey() -> String? {
        "id"
    }
    
    @Persisted
    var id: String
    
    @Persisted
    var pageId: Int
    
    @Persisted
    var title: String
    
    @Persisted
    var commentDescription: String
    
    @Persisted
    var author: String
    
    override convenience init() {
        self.init(id: 0, pageId: 0, title: "", commentDescription: "", author: "")
    }
    
    init(id: Int, pageId: Int, title: String, commentDescription: String, author: String) {
        super.init()
        self.id = String(id)
        self.pageId = pageId
        self.title = title
        self.commentDescription = commentDescription
        self.author = author
    }
}
