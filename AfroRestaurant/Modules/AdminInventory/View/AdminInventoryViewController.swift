import UIKit
import SnapKit

extension AdminInventoryViewController {
    struct Appearance {
        let leadingTrailingInset: CGFloat = 26.0
    }
}

final class AdminInventoryViewController: BaseViewController {

    private let appearance = Appearance()
    var presenter: AdminInventoryPresenterProtocol?

    var viewModels: [AdminInventoryTableViewCell.ViewModel] = []
    
    private lazy var headerView: UIView = {
        
        let view = UIView()
        let label = UILabel()
        label.textColor = .textSecondary
        label.font = .font(.regular, size: 14.0)
        label.textAlignment = .left
        label.text = "Here, you can see all categories of dishes you added"
        label.sizeToFit()
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(appearance.leadingTrailingInset)
            make.centerY.equalToSuperview()
        }
        return view
    }()
    
    private lazy var navLargeLabel: UILabel = {
        let label = UILabel()
        label.text = "Inventory"
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
        tableView.register(AdminInventoryTableViewCell.self, forCellReuseIdentifier: AdminInventoryTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        return tableView
    }()
    
    private lazy var newCategoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("ADD CATEGORY", for: .normal)
        button.setTitleColor(.background, for: .normal)
        button.titleLabel?.font = .font(.regular, size: 14.0)
        button.addTarget(self, action: #selector(newCategoryButtonTapped), for: .touchUpInside)
        button.clipsToBounds = true
        button.backgroundColor = .brandGreen
        button.layer.cornerRadius = 25.0
        button.sizeToFit()
        return button
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
        view.addSubview(newCategoryButton)
    }
    
    private func makeConstraints() {
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        newCategoryButton.snp.makeConstraints { make in
            make.width.equalTo(192.0)
            make.height.equalTo(50.0)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(57.0)
        }
    }
    
    @objc private func newCategoryButtonTapped() {
        presenter?.didTapAddNewCategory()
    }
}

extension AdminInventoryViewController: AdminInventoryViewInput {
    func updateItems(viewModels: [AdminInventoryTableViewCell.ViewModel]) {
        self.viewModels = viewModels
        tableView.reloadData()
    }
}

extension AdminInventoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: AdminInventoryTableViewCell.identifier,
            for: indexPath
        ) as? AdminInventoryTableViewCell else {
            return UITableViewCell()
        }
        let cellViewModel = viewModels[indexPath.row]
        cell.selectionStyle = .default
        cell.viewModel = cellViewModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        16.0
    }
}

extension AdminInventoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectItem(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            viewModels.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            presenter?.didDeleteItem(at: indexPath.row)
        }
    }
}

