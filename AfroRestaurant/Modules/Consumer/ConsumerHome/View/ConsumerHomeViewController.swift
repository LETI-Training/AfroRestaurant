import UIKit
import SnapKit

extension ConsumerHomeViewController {
    struct Appearance {
    }
}

final class ConsumerHomeViewController: BaseViewController {

    private let appearance = Appearance()
    var presenter: ConsumerHomePresenterProtocol?

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

extension ConsumerHomeViewController: ConsumerHomeViewInput {
}
