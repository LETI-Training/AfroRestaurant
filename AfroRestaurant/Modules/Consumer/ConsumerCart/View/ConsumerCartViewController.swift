import UIKit
import SnapKit

extension ConsumerCartViewController {
    struct Appearance {
    }
    
    struct ViewModel {
        let type: CellType
    }
    
    enum CellType {
        case cart(CartTableViewCell.ViewModel)
        case amount(CartPriceLabelCell.ViewModel)
    }
}

final class ConsumerCartViewController: BaseViewController {

    private let appearance = Appearance()
    var presenter: ConsumerCartPresenterProtocol?
    
    var viewModels = [ViewModel]()
    
    var isLoaded = false
    
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(red: 0.031, green: 0.624, blue: 0.404, alpha: 1).cgColor,
            UIColor(red: 1, green: 1, blue: 1, alpha: 0).cgColor
        ]
        layer.locations = [0, 1]
        layer.startPoint = CGPoint(x: 0.50, y: 0.5)
        layer.endPoint = CGPoint(x: 0.75, y: 0.5)
        layer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0, b: 1, c: -1, d: 0, tx: 1, ty: 0))
        return layer
    }()
    
    lazy var gradientView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.addSublayer(gradientLayer)
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var navLargeLabel: UILabel = {
        let label = UILabel()
        label.text = "Cart"
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
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: CartTableViewCell.identifier)
        tableView.register(CartPriceLabelCell.self, forCellReuseIdentifier: CartPriceLabelCell.identifier)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        return tableView
    }()
    
    private lazy var checkoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Checkout", for: .normal)
        button.setTitleColor(.background, for: .normal)
        button.titleLabel?.font = .font(.regular, size: 14.0)
        button.addTarget(self, action: #selector(checkoutTapped), for: .touchUpInside)
        button.clipsToBounds = true
        button.backgroundColor = .brandGreen
        button.layer.cornerRadius = 25.0
        button.sizeToFit()
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        presenter?.viewWillAppear()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard !isLoaded else { return }
        isLoaded = true
        gradientView.layoutIfNeeded()
        gradientLayer.bounds = gradientView.bounds
            .insetBy(dx: -0.5 * gradientView.bounds.size.width, dy: -0.5 * gradientView.bounds.size.height)
        gradientLayer.position = gradientView.center
    }

    private func setupUI() {
        addSubviews()
        makeConstraints()
        navigationController?.navigationBar.barStyle = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navLargeLabel)
    }

    private func addSubviews() {
        view.addSubview(gradientView)
        view.addSubview(tableView)
        view.addSubview(checkoutButton)
    }

    private func makeConstraints() {
        gradientView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(10)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(17.0)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(-10.0)
        }
        
        checkoutButton.snp.makeConstraints { make in
            make.width.equalTo(192.0)
            make.height.equalTo(50.0)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(67.0)
        }
    }
    
    @objc private func checkoutTapped() {
        presenter?.checkoutButtonTapped()
    }
}

extension ConsumerCartViewController: ConsumerCartViewInput {
    func updateItems(viewModels: [ConsumerCartViewController.ViewModel], cartCount: Int) {
        self.viewModels = viewModels
        if cartCount <= 0 {
            navLargeLabel.text = "Cart"
        } else {
            navLargeLabel.text = "Cart (\(cartCount))"
        }
        tableView.reloadData()
    }
}

extension ConsumerCartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch viewModels[indexPath.row].type {
        case .cart(let viewModel):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CartTableViewCell.identifier,
                for: indexPath
            ) as? CartTableViewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .default
            cell.viewModel = viewModel
            cell.selectionStyle = .none
            return cell
        case .amount(let viewModel):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CartPriceLabelCell.identifier,
                for: indexPath
            ) as? CartPriceLabelCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .default
            cell.viewModel = viewModel
            cell.selectionStyle = .none
            return cell
        }
        
    }
}

extension ConsumerCartViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch viewModels[indexPath.row].type {
        case .cart:
            return 139
        case .amount:
            return 90
        }
    }
}

