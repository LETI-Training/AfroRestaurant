import UIKit
import SnapKit

extension ConsumerProfileViewController {
    struct Appearance {
        let leadingTrailingInset: CGFloat = 26.0
    }
}

final class ConsumerProfileViewController: BaseViewController {

    private let appearance = Appearance()
    var presenter: ConsumerProfilePresenterProtocol?
    
    var isLoaded = false
    
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(red: 0.451, green: 0.451, blue: 0.451, alpha: 1).cgColor,
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
        label.text = "Profile"
        label.textColor = .textPrimary
        label.font = .font(.extraBold, size: 32.0)
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    private lazy var contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Name:"
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
    
    private lazy var numberLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Phone Number:"
        label.textColor = .textPrimary
        label.font = .font(.extraBold, size: 20.0)
        label.textAlignment = .left
        label.sizeToFit()
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var numberTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.layer.cornerRadius = 12.0
        textField.textColor = .textSecondary
        textField.autocapitalizationType = .none
        textField.backgroundColor = .none
        textField.font = .font(.regular, size: 16.0)
        textField.keyboardType = .phonePad
        return textField
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Email:"
        label.textColor = .textPrimary
        label.font = .font(.extraBold, size: 20.0)
        label.textAlignment = .left
        label.sizeToFit()
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.layer.cornerRadius = 12.0
        textField.textColor = .textSecondary
        textField.autocapitalizationType = .none
        textField.backgroundColor = .none
        textField.font = .font(.regular, size: 16.0)
        textField.keyboardType = .emailAddress
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Address:"
        label.textColor = .textPrimary
        label.font = .font(.extraBold, size: 20.0)
        label.textAlignment = .left
        label.sizeToFit()
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var addressTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.layer.cornerRadius = 12.0
        textField.textColor = .textSecondary
        textField.autocapitalizationType = .none
        textField.backgroundColor = .none
        textField.font = .font(.regular, size: 16.0)
        textField.keyboardType = .default
        return textField
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Save Changes", for: .normal)
        button.setTitleColor(.background, for: .normal)
        button.titleLabel?.font = .font(.bold, size: 17.0)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.clipsToBounds = true
        button.backgroundColor = .brandGreen
        button.layer.cornerRadius = 25.0
        button.sizeToFit()
        return button
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Log Out", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = .font(.bold, size: 17.0)
        button.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        button.clipsToBounds = true
        button.backgroundColor = .clear
        button.layer.cornerRadius = 12.0
        button.sizeToFit()
        return button
    }()
    
    private lazy var nameDividerView: UIView = {
        let divider = BaseViewController.dividerView
        divider.backgroundColor = .textSecondary.withAlphaComponent(0.4)
        return divider
    }()
    
    private lazy var phoneNumberDividerView: UIView = {
        let divider = BaseViewController.dividerView
        divider.backgroundColor = .textSecondary.withAlphaComponent(0.4)
        return divider
    }()
    
    private lazy var emailDividerView: UIView = {
        let divider = BaseViewController.dividerView
        divider.backgroundColor = .textSecondary.withAlphaComponent(0.4)
        return divider
    }()
    
    private lazy var addressDividerView: UIView = {
        let divider = BaseViewController.dividerView
        divider.backgroundColor = .textSecondary.withAlphaComponent(0.4)
        return divider
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
        addKeyBoardObserver()
    }

    private func setupUI() {
        addSubviews()
        makeConstraints()
        navigationController?.navigationBar.barStyle = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navLargeLabel)
    }

    private func addSubviews() {
        view.addSubview(gradientView)
        view.addSubview(contentScrollView)
        view.addSubview(nameDividerView)
        view.addSubview(phoneNumberDividerView)
        view.addSubview(emailDividerView)
        view.addSubview(addressDividerView)
        [nameLabel,
         nameTextField,
         numberLabel,
         numberTextField,
         emailLabel,
         emailTextField,
         addressLabel,
         addressTextField,
         saveButton,
         logoutButton].forEach { contentScrollView.addSubview($0) }
    }
    
    private func makeConstraints() {
        
        gradientView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(10)
        }
        
        contentScrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24.0)
            make.leading.trailing.equalToSuperview().inset(appearance.leadingTrailingInset)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5.0)
            make.leading.equalTo(view.snp.leading).inset(appearance.leadingTrailingInset)
            make.trailing.equalTo(view.snp.trailing).inset(appearance.leadingTrailingInset)
            make.height.equalTo(33.0)
        }
        
        numberLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(31.0)
            make.leading.equalToSuperview().inset(appearance.leadingTrailingInset)
        }
        
        numberTextField.snp.makeConstraints { make in
            make.top.equalTo(numberLabel.snp.bottom).offset(5.0)
            make.leading.equalTo(view.snp.leading).inset(appearance.leadingTrailingInset)
            make.trailing.equalTo(view.snp.trailing).inset(appearance.leadingTrailingInset)
            make.height.equalTo(33.0)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(numberTextField.snp.bottom).offset(24.0)
            make.leading.trailing.equalToSuperview().inset(appearance.leadingTrailingInset)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(5.0)
            make.leading.equalTo(view.snp.leading).inset(appearance.leadingTrailingInset)
            make.trailing.equalTo(view.snp.trailing).inset(appearance.leadingTrailingInset)
            make.height.equalTo(33.0)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(24.0)
            make.leading.trailing.equalToSuperview().inset(appearance.leadingTrailingInset)
        }
        
        addressTextField.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(5.0)
            make.leading.equalTo(view.snp.leading).inset(appearance.leadingTrailingInset)
            make.trailing.equalTo(view.snp.trailing).inset(appearance.leadingTrailingInset)
            make.height.equalTo(33.0)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(addressTextField.snp.bottom).offset(57)
            make.centerX.equalToSuperview()
            make.width.equalTo(192)
            make.height.equalTo(50.0)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(saveButton.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(192)
            make.height.equalTo(50.0)
            make.bottom.lessThanOrEqualToSuperview()
        }
        
        nameDividerView.snp.makeConstraints { make in
            make.bottom.equalTo(nameTextField)
            make.leading.trailing.equalTo(nameTextField)
        }
        
        phoneNumberDividerView.snp.makeConstraints { make in
            make.bottom.equalTo(numberTextField)
            make.leading.trailing.equalTo(numberTextField)
        }
        
        emailDividerView.snp.makeConstraints { make in
            make.bottom.equalTo(emailTextField)
            make.leading.trailing.equalTo(emailTextField)
        }
        
        addressDividerView.snp.makeConstraints { make in
            make.bottom.equalTo(addressTextField)
            make.leading.trailing.equalTo(addressTextField)
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

private extension ConsumerProfileViewController {
    @objc private func saveButtonTapped() {
        presenter?.saveButtonPressed(
            name: nameTextField.text ?? "",
            phoneNumber: numberTextField.text ?? "",
            address: addressTextField.text ?? ""
        )
        view.endEditing(true)
    }
    
    @objc private func logoutTapped() {
        presenter?.logoutTapped()
    }
}

extension ConsumerProfileViewController: ConsumerProfileViewInput {
    func updateView(model: ConsumerDataBaseService.UserDetails) {
        nameTextField.text = model.userName
        numberTextField.text = model.phoneNumber
        addressTextField.text = model.address
        emailTextField.text = model.email
    }
}
