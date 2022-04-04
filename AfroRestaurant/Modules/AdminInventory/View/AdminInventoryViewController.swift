import UIKit
import SnapKit

extension AdminInventoryViewController {
    struct Appearance {
    }
}

final class AdminInventoryViewController: BaseViewController {

    private let appearance = Appearance()
    var presenter: AdminInventoryPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
        title = "Coming Soon"
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

extension AdminInventoryViewController: AdminInventoryViewInput {
}
