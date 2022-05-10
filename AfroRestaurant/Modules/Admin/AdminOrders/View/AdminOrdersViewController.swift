import UIKit
import SnapKit

extension AdminOrdersViewController {
    struct Appearance {
        
    }
    
    struct ViewModel {
        let sectionModel: AdminOrdersHeaderView.ViewModel
        let cellModels: [AdminOrdersTableViewCell.ViewModel]
    }
}

final class AdminOrdersViewController: BaseViewController {

    private let appearance = Appearance()
    var presenter: AdminOrdersPresenterProtocol?
    var viewModels: [AdminOrdersViewController.ViewModel] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .none
        tableView.keyboardDismissMode = .interactive
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AdminOrdersTableViewCell.self, forCellReuseIdentifier: AdminOrdersTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        presenter?.viewWillAppear()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
        navigationController?.navigationBar.barStyle = .black
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

extension AdminOrdersViewController: AdminOrdersViewInput {
    func updateItems(viewModels: [AdminOrdersViewController.ViewModel]) {
        self.viewModels = viewModels
        tableView.reloadData()
    }
}


extension AdminOrdersViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModels.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels[section].cellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: AdminOrdersTableViewCell.identifier,
            for: indexPath
        ) as? AdminOrdersTableViewCell else {
            return UITableViewCell()
        }
        let cellViewModel = viewModels[indexPath.section].cellModels[indexPath.row]
        cell.accessoryType = .none
        cell.selectionStyle = .none
        cell.viewModel = cellViewModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        AdminOrdersHeaderView(viewModel: viewModels[section].sectionModel)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }
}

extension AdminOrdersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 42.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}


