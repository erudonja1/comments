//
//  CommentTableViewCell.swift
//  CommentsApp
//
//  Created by Elvis on 11/11/21.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    var comment: Comment?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        self.titleLabel.text = ""
        self.descriptionLabel.text = ""
        self.authorLabel.text = ""
    }

    func setup(comment: Comment) {
        self.removeLoading()
        self.comment = comment
        
        self.titleLabel.text = comment.title
        self.descriptionLabel.text = comment.description
        self.authorLabel.text = comment.author
    }
    
    func setupLoading() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn) {  [weak self] in
            self?.loadingView.alpha = 1
        } completion: { [weak self] finished in
            self?.loadingActivityIndicator.startAnimating()
        }
    }
    
    func removeLoading() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {  [weak self] in
            self?.loadingView.alpha = 0
        } completion: { [weak self] finished in
            self?.loadingActivityIndicator.stopAnimating()
        }
    }
}
