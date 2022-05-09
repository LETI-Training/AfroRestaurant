import UIKit
import SnapKit

extension ConsumerProfileViewController {
    struct Appearance {
    }
}

final class ConsumerProfileViewController: BaseViewController {

    private let appearance = Appearance()
    var presenter: ConsumerProfilePresenterProtocol?

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

extension ConsumerProfileViewController: ConsumerProfileViewInput {
}
