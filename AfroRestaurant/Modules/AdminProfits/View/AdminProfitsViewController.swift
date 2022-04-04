import UIKit
import SnapKit

extension AdminProfitsViewController {
    struct Appearance {
    }
}

final class AdminProfitsViewController: BaseViewController {

    private let appearance = Appearance()
    private let disposeBag = DisposeBag()
    var presenter: AdminProfitsPresenterProtocol?

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

extension AdminProfitsViewController: AdminProfitsViewInput {
}
