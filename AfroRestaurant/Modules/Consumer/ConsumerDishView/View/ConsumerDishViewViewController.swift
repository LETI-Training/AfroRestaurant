import UIKit
import SnapKit

extension ConsumerDishViewViewController {
    struct Appearance {
    }
}

final class ConsumerDishViewViewController: BaseViewController {

    private let appearance = Appearance()
    var presenter: ConsumerDishViewPresenterProtocol?

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

extension ConsumerDishViewViewController: ConsumerDishViewViewInput {
}
