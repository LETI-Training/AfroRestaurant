import UIKit
import SnapKit

extension SignupViewController {
    struct Appearance {
    }
}

final class SignupViewController: BaseViewController {

    private let appearance = Appearance()
    var presenter: SignupPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }

    private func setupUI() {
        addSubviews()
        makeConstraints()
    }

    private func addSubviews() {
    }

    private func makeConstraints() {
    }
}

extension SignupViewController: SignupViewInput {
}
