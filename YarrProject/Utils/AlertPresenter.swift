//
//  AlertPresenter.swift
//  YarrProject
//
//  Created by Никита Швец on 06.04.2023.
//

import UIKit

final class AlertPresenter {
    
    func presentAlert(title: String?, message: String?, viewController: UIViewController, handler: ((UIAlertAction, String?) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addTextField { alertTextField in
                alertTextField.placeholder = Strings.alertTextFieldPlaceholder
            }
        let action = UIAlertAction(title: Strings.alertActionTitle, style: .default) { action in
            let textField = alert.textFields?.first
            handler?(action, textField?.text)
        }
        let cancelAction = UIAlertAction(title: Strings.alertCancelActionTitle, style: .destructive)
        alert.addAction(action)
        alert.addAction(cancelAction)
        viewController.present(alert, animated: true, completion: nil)
    }
}

