import UIKit
import SnapKit

extension AdminHomeViewController {
    struct Appearance {
        let leadingTrailingInset: CGFloat = 26.0
    }
}

final class AdminHomeViewController: BaseViewController {
    
    private let appearance = Appearance()
    var presenter: AdminHomePresenterProtocol?
    var viewModels: [AdminUpdatesTableViewCell.ViewModel] = []
    
    private lazy var headerView: AdminTableHeaderView = {
        let view = AdminTableHeaderView()
        view.cancelledOrdersTapped = { [weak self] in
            self?.presenter?.didTapCancelledView()
        }
        view.newOrdersTapped = { [weak self] in
            self?.presenter?.didTapNewOrdersView()
        }
        return view
    }()
    
    private lazy var navLargeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome,"
        label.textColor = .background
        label.font = .font(.extraBold, size: 32.0)
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor,
            UIColor(red: 0.031, green: 0.624, blue: 0.404, alpha: 0).cgColor
        ]
        layer.locations = [0, 1]
        layer.startPoint = CGPoint(x: 0.20, y: 0.5)
        layer.endPoint = CGPoint(x: 0.75, y: 0.5)
        layer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0, b: 1, c: -1, d: 0, tx: 1, ty: 0))
        return layer
    }()
    
    lazy var gradientView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.addSublayer(gradientLayer)
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .none
        tableView.keyboardDismissMode = .interactive
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AdminUpdatesTableViewCell.self, forCellReuseIdentifier: AdminUpdatesTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
        setupNavigationBar(isDark: true)
        navigationController?.navigationBar.barStyle = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientView.layoutIfNeeded()
        gradientLayer.bounds = gradientView.bounds
            .insetBy(dx: -0.5 * gradientView.bounds.size.width, dy: -0.5 * gradientView.bounds.size.height)
        gradientLayer.position = gradientView.center
    }
    
    private func setupUI() {
        addSubviews()
        makeConstraints()
    }
    
    private func setupNavigationBar(isDark: Bool) {
        navLargeLabel.textColor = isDark ? .background : .textPrimary
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navLargeLabel)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: makeRightBar(text: "4.5", isDark: isDark))
    }
    
    private func addSubviews() {
        view.addSubview(gradientView)
        view.addSubview(tableView)
    }
    
    private func makeConstraints() {
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        gradientView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.snp.centerY)
        }
    }
    
    @objc func profileImageTapped() {
        presenter?.didTapProfileImage()
    }
}

extension AdminHomeViewController: AdminHomeViewInput {
    
    func updateUI(dailyProfits: String, newOrders: String, cancelledOrders: String) {
        headerView.profitsLabel.text = dailyProfits
        headerView.newOrdersCountLabel.text = newOrders
        headerView.cancelledOrdersCountLabel.text = cancelledOrders
    }
    
    func updateItems(viewModels: [AdminUpdatesTableViewCell.ViewModel]) {
        self.viewModels = viewModels
        tableView.reloadData()
    }
}

extension AdminHomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: AdminUpdatesTableViewCell.identifier,
            for: indexPath
        ) as? AdminUpdatesTableViewCell else {
            return UITableViewCell()
        }
        let cellViewModel = viewModels[indexPath.row]
        cell.accessoryType = .none
        cell.selectionStyle = .none
        cell.viewModel = cellViewModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }
}

extension AdminHomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 61.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateNavigationTitleWhileScrolling(scrollView: scrollView)
        updateGradientLayerWhileScrolling(scrollView: scrollView)
    }
    
    private func updateNavigationTitleWhileScrolling(scrollView: UIScrollView) {
        navLargeLabel.text = scrollView.contentOffset.y <= gradientView.frame.height - 75.0
        ? "Welcome,"
        : "Updates"
        setupNavigationBar(isDark: (gradientView.frame.origin.y + 40.0) >= 0)
    }
    
    private func updateGradientLayerWhileScrolling(scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            guard abs(scrollView.contentOffset.y) <= 50.0 else { return }
        } else {
            guard scrollView.contentOffset.y < gradientView.frame.height - 50.0 else { return }
        }
        gradientView.snp.updateConstraints { make in
            make.top.equalToSuperview().offset(-scrollView.contentOffset.y)
            make.bottom.equalTo(view.snp.centerY).offset(-scrollView.contentOffset.y)
        }
        view.layoutIfNeeded()
        gradientView.layoutIfNeeded()
    }
}
