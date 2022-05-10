import UIKit
import SnapKit

extension AdminOrdersViewController {
    struct Appearance {
    }
}

final class AdminOrdersViewController: BaseViewController {

    private let appearance = Appearance()
    var presenter: AdminOrdersPresenterProtocol?

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

extension AdminOrdersViewController: AdminOrdersViewInput {
}
