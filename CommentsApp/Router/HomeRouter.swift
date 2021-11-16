//
//  HomeRouter.swift
//  CommentsApp
//
//  Created by Elvis on 11/16/21.
//

import Foundation
import UIKit

protocol HomeRouterProtocol {
    func presentAlert(for comment: Comment, with viewController: UIViewController)
}

class HomeRouter: HomeRouterProtocol {

    func presentAlert(for comment: Comment, with viewController: UIViewController) {
        let alert = UIAlertController(title: comment.title, message: comment.description, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}
