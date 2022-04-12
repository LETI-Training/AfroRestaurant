import UIKit
import SnapKit

extension AdminDishesViewController {
    struct Appearance {
    }
}

final class AdminDishesViewController: BaseViewController {

    private let appearance = Appearance()
    var presenter: AdminDishesPresenterProtocol?

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

extension AdminDishesViewController: AdminDishesViewInput {
}
