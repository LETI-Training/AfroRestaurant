import UIKit
import SnapKit

extension AdminOrdersViewController {
    struct Appearance {
        let leadingTrailingInset: CGFloat = 26.0
    }
    
    struct ViewModel {
        let type: CellType
    }
    
    enum CellType {
        case header(AdminOrdersHeaderView.ViewModel)
        case dishes(AdminOrdersTableViewCell.ViewModel)
    }
}

final class AdminOrdersViewController: BaseViewController {

    private let appearance = Appearance()
    var presenter: AdminOrdersPresenterProtocol?
    var viewModels: [AdminOrdersViewController.ViewModel] = []
    
    private lazy var navLargeLabel: UILabel = {
        let label = UILabel()
        label.text = "Orders"
        label.textColor = .textPrimary
        label.font = .font(.extraBold, size: 32.0)
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    let segmentedController: UISegmentedControl = {
        let items: [String] = AdminOrdersPresenter.OrderFilterType.allCases.compactMap({ $0.name })
        let segmentedController = UISegmentedControl(items: items)
        segmentedController.addTarget(self, action: #selector(segmentedValueChanged), for: .valueChanged)
        return segmentedController
    }()
    
    @objc private func segmentedValueChanged() {
        presenter?.segmentedControllerTapped(newIndex: segmentedController.selectedSegmentIndex)
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .none
        tableView.keyboardDismissMode = .interactive
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AdminOrdersTableViewCell.self, forCellReuseIdentifier: AdminOrdersTableViewCell.identifier)
        tableView.register(AdminOrdersHeaderView.self, forCellReuseIdentifier: AdminOrdersHeaderView.identifier)
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
        navigationController?.navigationBar.barStyle = .black
        self.title = "Orders"
    }

    private func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(segmentedController)
    }

    private func makeConstraints() {
        segmentedController.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(appearance.leadingTrailingInset)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.top.equalTo(segmentedController.snp.bottom).offset(3.0)
        }
    }
}

extension AdminOrdersViewController: AdminOrdersViewInput {
    func changeSelectedIndex(index: Int) {
        segmentedController.selectedSegmentIndex = index
    }
    
    func updateItems(viewModels: [AdminOrdersViewController.ViewModel]) {
        self.viewModels = viewModels
        tableView.reloadData()
    }
}


extension AdminOrdersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch viewModels[indexPath.row].type {
            
        case .header(let viewModel):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: AdminOrdersHeaderView.identifier,
                for: indexPath
            ) as? AdminOrdersHeaderView else {
                return UITableViewCell()
            }
            cell.accessoryType = .none
            cell.selectionStyle = .none
            cell.viewModel = viewModel
            return cell
        case .dishes(let viewModel):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: AdminOrdersTableViewCell.identifier,
                for: indexPath
            ) as? AdminOrdersTableViewCell else {
                return UITableViewCell()
            }
            cell.accessoryType = .none
            cell.selectionStyle = .none
            cell.viewModel = viewModel
            return cell
        }
    }
}

extension AdminOrdersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch viewModels[indexPath.row].type {
        case .header:
           return UITableView.automaticDimension
        case .dishes:
            return 42.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}


