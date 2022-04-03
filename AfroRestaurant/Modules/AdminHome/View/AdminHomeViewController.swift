import UIKit
import SnapKit

extension AdminHomeViewController {
    struct Appearance {
    }
}

final class AdminHomeViewController: BaseViewController {

    private let appearance = Appearance()
    var presenter: AdminHomePresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }

    private func setupUI() {
        addSubviews()
        makeConstraints()
        
        if #available(iOS 14.0, *) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", image: nil, primaryAction: UIAction.init(handler: { _ in
                
                // remove later
                AuthorizationService().signOut()
            }), menu: nil)
        } else {
            // Fallback on earlier versions
        }
    }

    private func addSubviews() {
    }

    private func makeConstraints() {
    }
}

extension AdminHomeViewController: AdminHomeViewInput {
}
