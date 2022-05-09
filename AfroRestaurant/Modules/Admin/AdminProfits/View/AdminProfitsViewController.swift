import UIKit
import SnapKit

import UIKit
import SnapKit

extension AdminProfitsViewController {
    struct Appearance {
        let leadingTrailingInset: CGFloat = 26.0
    }
}

final class AdminProfitsViewController: BaseViewController {
    
    private let appearance = Appearance()
    var presenter: AdminProfitsPresenterProtocol?
    var viewModels: [AdminProfitsTableViewCell.ViewModel] = []
    
    private lazy var headerView: AdminProfitsHeaderView = {
        AdminProfitsHeaderView()
    }()
    
    private lazy var navLargeLabel: UILabel = {
        let label = UILabel()
        label.text = "Profits"
        label.textColor = .textPrimary
        label.font = .font(.extraBold, size: 32.0)
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .none
        tableView.keyboardDismissMode = .interactive
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AdminProfitsTableViewCell.self, forCellReuseIdentifier: AdminProfitsTableViewCell.identifier)
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
        navigationController?.navigationBar.barStyle = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navLargeLabel)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    private func setupUI() {
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func makeConstraints() {
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
}

extension AdminProfitsViewController: AdminProfitsViewInput {
    
    func updateUI(totalProfits: String) {
        headerView.profitsLabel.text = totalProfits
    }
    
    func updateItems(viewModels: [AdminProfitsTableViewCell.ViewModel]) {
        self.viewModels = viewModels
        tableView.reloadData()
    }
}

extension AdminProfitsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: AdminProfitsTableViewCell.identifier,
            for: indexPath
        ) as? AdminProfitsTableViewCell else {
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

extension AdminProfitsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 42.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

