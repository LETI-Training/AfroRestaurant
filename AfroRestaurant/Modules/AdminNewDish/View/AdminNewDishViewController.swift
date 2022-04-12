import UIKit
import SnapKit

extension AdminNewDishViewController {
    struct Appearance {
    }
}

final class AdminNewDishViewController: BaseViewController {

    private let appearance = Appearance()
    var presenter: AdminNewDishPresenterProtocol?

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

extension AdminNewDishViewController: AdminNewDishViewInput {
}
