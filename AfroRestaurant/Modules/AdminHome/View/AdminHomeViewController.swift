import UIKit
import SnapKit

extension AdminHomeViewController {
    struct Appearance {
    }
}

final class AdminHomeViewController: BaseViewController {

    private let appearance = Appearance()
    private let disposeBag = DisposeBag()
    var presenter: AdminHomePresenterProtocol?

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

extension AdminHomeViewController: AdminHomeViewInput {
}
