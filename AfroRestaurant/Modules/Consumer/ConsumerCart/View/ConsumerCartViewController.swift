import UIKit
import SnapKit

extension ConsumerCartViewController {
    struct Appearance {
    }
}

final class ConsumerCartViewController: BaseViewController {

    private let appearance = Appearance()
    var presenter: ConsumerCartPresenterProtocol?

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

extension ConsumerCartViewController: ConsumerCartViewInput {
}
