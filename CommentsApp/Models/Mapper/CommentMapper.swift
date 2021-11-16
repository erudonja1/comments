//
//  CommentMapper.swift
//  CommentsApp
//
//  Created by Elvis on 11/16/21.
//

import Foundation
import RealmSwift

struct CommentMapper {
    private func fromDb(_ comment: CommentDb) -> Comment {
        Comment(id: Int(comment.id) ?? 0, pageId: comment.pageId, title: comment.title, description: comment.commentDescription, author: comment.author)
    }
    
    private func toDb(_ comment: Comment) -> CommentDb {
        CommentDb(id: comment.id, pageId: comment.pageId, title: comment.title, commentDescription: comment.description, author: comment.author)
    }
    
    func toDb(_ comments: [Comment], page: Int) -> CommentsPageDb {
        let list: List<CommentDb> = List<CommentDb>()
            list.append(objectsIn: comments.map({self.toDb($0)}))
 
        return CommentsPageDb(page: page, comments: list)
    }
    
    
    func fromDb(_ commentsPage: CommentsPageDb) -> [Comment] {
        let array: [Comment] = Array(commentsPage.comments)
            .map({ commentDb in
                return fromDb(commentDb)
            })
        return array
    }
}
