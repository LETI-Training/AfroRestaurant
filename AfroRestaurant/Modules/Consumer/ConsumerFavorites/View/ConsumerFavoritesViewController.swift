import UIKit
import SnapKit

extension ConsumerFavoritesViewController {
    struct Appearance {
    }
}

final class ConsumerFavoritesViewController: BaseViewController {

    private let appearance = Appearance()
    var presenter: ConsumerFavoritesPresenterProtocol?

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

extension ConsumerFavoritesViewController: ConsumerFavoritesViewInput {
}
