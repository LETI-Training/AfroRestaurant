import UIKit
import SnapKit

extension LoginViewController {
    struct Appearance {
    }
}

final class LoginViewController: BaseViewController {
    
    private let appearance = Appearance()
    private let disposeBag = DisposeBag()
    var presenter: LoginPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateTexts()
        presenter.viewDidLoad()
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
    func updateTexts() {
    }
}
