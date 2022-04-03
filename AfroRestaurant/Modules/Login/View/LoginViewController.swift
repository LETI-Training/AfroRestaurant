import UIKit
import SnapKit

extension LoginViewController {
    struct Appearance {
    }
}

final class LoginViewController: BaseViewController {
    
    private let appearance = Appearance()
    var presenter: LoginPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }
    
    func setupUI() {
        addSubviews()
        makeConstraints()
    }
    
    func addSubviews() {
    }
    
    func makeConstraints() {
    }
}

extension LoginViewController: LoginViewInput {
}
