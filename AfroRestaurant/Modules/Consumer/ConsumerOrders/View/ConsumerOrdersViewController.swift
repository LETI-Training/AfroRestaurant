import UIKit
import SnapKit

extension ConsumerOrdersViewController {
    struct Appearance {
    }
}

final class ConsumerOrdersViewController: BaseViewController {

    private let appearance = Appearance()
    var presenter: ConsumerOrdersPresenterProtocol?

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

extension ConsumerOrdersViewController: ConsumerOrdersViewInput {
}
