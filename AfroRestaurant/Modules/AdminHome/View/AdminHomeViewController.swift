import UIKit
import SnapKit

extension AdminHomeViewController {
    struct Appearance {
    }
}

final class AdminHomeViewController: BaseViewController {

    private let appearance = Appearance()
    var presenter: AdminHomePresenterProtocol?
    
    var navLargeLabel: UILabel {
        let label = UILabel()
        label.text = "Welcome,"
        label.textColor = .textPrimary
        label.font = .font(.extraBold, size: 32.0)
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
        setupNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    private func setupUI() {
        addSubviews()
        makeConstraints()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navLargeLabel)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: makeRightBar(text: "4.5"))
    }

    private func addSubviews() {
    }

    private func makeConstraints() {
    }
    
    @objc func profileImageTapped() {
        presenter?.didTapProfileImage()
    }
}

extension AdminHomeViewController: AdminHomeViewInput {
}
