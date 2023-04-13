import UIKit

final class AlertPresenter {
    
    struct Action {
        let title: String
        let style: UIAlertAction.Style
        let handler: ((_ text: String?) -> Void)?
    }
    
    func presentAlert(
        over viewController: UIViewController,
        title: String?,
        message: String?,
        actions: [Action]
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = Strings.Alerts.alertTextFieldPlaceholder
        }
        
        actions.forEach { action in
            let alertAction = UIAlertAction(
                title: action.title,
                style: action.style,
                handler: { _ in
                    let text = alert.textFields?.first?.text
                    action.handler?(text)
                })
            alert.addAction(alertAction)
        }
        viewController.present(alert, animated: true, completion: nil)
    }
}
