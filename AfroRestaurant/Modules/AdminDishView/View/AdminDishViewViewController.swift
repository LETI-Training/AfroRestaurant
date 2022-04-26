import UIKit
import SnapKit

extension AdminDishViewViewController {
    struct Appearance {
    }
}

final class AdminDishViewViewController: BaseViewController {

    private let appearance = Appearance()
    var presenter: AdminDishViewPresenterProtocol?

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

extension AdminDishViewViewController: AdminDishViewViewInput {
}
