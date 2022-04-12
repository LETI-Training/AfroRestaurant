import UIKit
import SnapKit

extension AdminNewCategoryViewController {
    struct Appearance {
    }
}

final class AdminNewCategoryViewController: BaseViewController {

    private let appearance = Appearance()
    var presenter: AdminNewCategoryPresenterProtocol?

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

extension AdminNewCategoryViewController: AdminNewCategoryViewInput {
}
