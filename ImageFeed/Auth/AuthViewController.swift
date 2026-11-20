import UIKit

import ProgressHUD

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}
class AuthViewController: UIViewController {
    weak var delegate: AuthViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = ""
        configureBackButton()
    }
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "ypBlack")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowWebView" {
            guard let webViewViewController = segue.destination as? WebViewViewController else { return }
            webViewViewController.delegate = self
        }
    }
}
//MARK: - WebViewViewControllerDelegate
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_vc: WebViewViewController, didAuthenticateWithCode code: String) {
        navigationController?.popViewController(animated: true)
        UIBlockingProgressHUD.show()
        OAuth2Service.shared.fetchOAuthToken(code) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success:
                print("Успех! Токен сохранен.")
                self.delegate?.didAuthenticate(self)
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                print("[AuthViewController] Ошибка авторизации: \(error)")
                let alert = UIAlertController(title: "Что то пошло не так", message: "Не удалось войти в систему", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ок", style: .default)
                alert.addAction(action)
                self.present(alert, animated: true)
                
            }
        }
    }
    func webViewViewControllerDidCancel(_vc: WebViewViewController) {
        
    }
}
