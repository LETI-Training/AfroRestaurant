import UIKit
import SnapKit

extension AdminNewCategoryViewController {
    struct Appearance {
        let leadingTrailingInset: CGFloat = 26.0
    }
}

final class AdminNewCategoryViewController: BaseViewController {
    
    private let appearance = Appearance()
    var presenter: AdminNewCategoryPresenterProtocol?
    
    private lazy var contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var categoryNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Category Name:"
        label.textColor = .textPrimary
        label.font = .font(.extraBold, size: 20.0)
        label.textAlignment = .left
        label.sizeToFit()
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.layer.cornerRadius = 12.0
        textField.textColor = .textSecondary
        textField.autocapitalizationType = .none
        textField.backgroundColor = .none
        textField.font = .font(.regular, size: 16.0)
        return textField
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Description:"
        label.textColor = .textPrimary
        label.font = .font(.extraBold, size: 20.0)
        label.textAlignment = .left
        label.sizeToFit()
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var descriptionTextField: UITextView = {
        let textField = UITextView(frame: .zero)
        textField.isScrollEnabled = false
        textField.layer.cornerRadius = 12.0
        textField.textColor = .textSecondary
        textField.font = .font(.regular, size: 16.0)
        textField.autocapitalizationType = .none
        textField.backgroundColor = .none
        return textField
    }()
    
    private lazy var createCategoryButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Create Category", for: .normal)
        button.setTitleColor(.background, for: .normal)
        button.titleLabel?.font = .font(.bold, size: 17.0)
        button.addTarget(self, action: #selector(createCategoryButtonTapped), for: .touchUpInside)
        button.clipsToBounds = true
        button.backgroundColor = .brandGreen
        button.layer.cornerRadius = 12.0
        button.sizeToFit()
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(UIColor(red: 0.467, green: 0.467, blue: 0.467, alpha: 1), for: .normal)
        button.titleLabel?.font = .font(.bold, size: 17.0)
        button.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        button.clipsToBounds = true
        button.backgroundColor = .divider
        button.layer.cornerRadius = 12.0
        button.sizeToFit()
        return button
    }()
    
    private lazy var nameDividerView: UIView = {
        let divider = BaseViewController.dividerView
        divider.backgroundColor = .textSecondary.withAlphaComponent(0.4)
        return divider
    }()
    
    private lazy var descriptionDividerView: UIView = {
        let divider = BaseViewController.dividerView
        divider.backgroundColor = .textSecondary.withAlphaComponent(0.4)
        return divider
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setupUI() {
        addSubviews()
        makeConstraints()
        addKeyBoardObserver()
        navigationController?.navigationBar.backgroundColor = .divider
    }
    
    private func addSubviews() {
        view.addSubview(contentScrollView)
        view.addSubview(nameDividerView)
        view.addSubview(descriptionDividerView)
        [categoryNameLabel,
         nameTextField,
         descriptionLabel,
         descriptionTextField,
         createCategoryButton,
         cancelButton].forEach { contentScrollView.addSubview($0) }
    }
    
    private func makeConstraints() {
        contentScrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        categoryNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(25.0)
            make.leading.trailing.equalToSuperview().inset(appearance.leadingTrailingInset)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(categoryNameLabel.snp.bottom).offset(5.0)
            make.leading.equalTo(view.snp.leading).inset(appearance.leadingTrailingInset)
            make.trailing.equalTo(view.snp.trailing).inset(appearance.leadingTrailingInset)
            make.height.equalTo(33.0)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(31.0)
            make.leading.equalToSuperview().inset(appearance.leadingTrailingInset)
        }
        
        descriptionTextField.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(5.0)
            make.leading.equalTo(view.snp.leading).inset(appearance.leadingTrailingInset)
            make.trailing.equalTo(view.snp.trailing).inset(appearance.leadingTrailingInset)
            make.height.equalTo(67.0)
        }
        
        createCategoryButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextField.snp.bottom).offset(300)
            make.leading.equalTo(view.snp.leading).inset(appearance.leadingTrailingInset)
            make.trailing.equalTo(view.snp.trailing).inset(appearance.leadingTrailingInset)
            make.height.equalTo(56.0)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(createCategoryButton.snp.bottom).offset(16)
            make.leading.equalTo(view.snp.leading).inset(appearance.leadingTrailingInset)
            make.trailing.equalTo(view.snp.trailing).inset(appearance.leadingTrailingInset)
            make.height.equalTo(56.0)
            make.bottom.lessThanOrEqualToSuperview()
        }
        
        nameDividerView.snp.makeConstraints { make in
            make.bottom.equalTo(nameTextField)
            make.leading.trailing.equalTo(nameTextField)
        }
        
        descriptionDividerView.snp.makeConstraints { make in
            make.bottom.equalTo(descriptionTextField)
            make.leading.trailing.equalTo(descriptionTextField)
        }
    }
    
    override func handleKeyboardHeight(rect: CGRect) {
        super.handleKeyboardHeight(rect: rect)
        contentScrollView.contentInset = UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: rect.height,
            right: 0.0
        )
        view.layoutIfNeeded()
    }
}

private extension AdminNewCategoryViewController {
    @objc private func createCategoryButtonTapped() {
        presenter?.createCategoryButtonTapped()
    }
    
    @objc private func cancelTapped() {
        presenter?.cancelTapped()
    }
}

extension AdminNewCategoryViewController: AdminNewCategoryViewInput {
}
