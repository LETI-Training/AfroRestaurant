import UIKit
import SnapKit

extension ConsumerMapViewController {
    struct Appearance {
    }
}

final class ConsumerMapViewController: BaseViewController {

    private let appearance = Appearance()
    var presenter: ConsumerMapPresenterProtocol?

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

extension ConsumerMapViewController: ConsumerMapViewInput {
}
