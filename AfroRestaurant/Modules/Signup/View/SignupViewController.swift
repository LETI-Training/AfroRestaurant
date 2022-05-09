import UIKit
import SnapKit

extension SignupViewController {
    struct Appearance {
        let leadingTrailingInset: CGFloat = 26.0
    }
}

final class SignupViewController: BaseViewController {
    
    private let appearance = Appearance()
    var presenter: SignupPresenterProtocol?
    
    private lazy var contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "We’re delighted to have you join us"
        label.textColor = .textPrimary
        label.font = .font(.extraBold, size: 32.0)
        label.textAlignment = .center
        label.sizeToFit()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var welcomeSubLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Fill the form below to gain access to an amazing world"
        label.textColor = .textSecondary
        label.font = .font(.regular, size: 12.0)
        label.sizeToFit()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Display Name:"
        label.textColor = .textPrimary
        label.font = .font(.regular, size: 12.0)
        label.sizeToFit()
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.layer.cornerRadius = 12.0
        textField.textColor = .textPrimary
        textField.autocapitalizationType = .none
        textField.backgroundColor = .textField
        return textField
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "E-mail:"
        label.textColor = .textPrimary
        label.font = .font(.regular, size: 12.0)
        label.sizeToFit()
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.layer.cornerRadius = 12.0
        textField.textColor = .textPrimary
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        textField.backgroundColor = .textField
        return textField
    }()
    
    private lazy var passwordLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Password:"
        label.textColor = .textPrimary
        label.font = .font(.regular, size: 12.0)
        label.sizeToFit()
        return label
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.layer.cornerRadius = 12.0
        textField.textColor = .textPrimary
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.backgroundColor = .textField
        return textField
    }()
    
    private lazy var veryifyPasswordLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Verify Password:"
        label.textColor = .textPrimary
        label.font = .font(.regular, size: 12.0)
        label.sizeToFit()
        return label
    }()
    
    private lazy var veryifyPasswordTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.layer.cornerRadius = 12.0
        textField.textColor = .textPrimary
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.backgroundColor = .textField
        return textField
    }()
    
    private lazy var phoneNumberLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Phone Number:"
        label.textColor = .textPrimary
        label.font = .font(.regular, size: 12.0)
        label.sizeToFit()
        return label
    }()
    
    private lazy var phoneNumberTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.layer.cornerRadius = 12.0
        textField.textColor = .textPrimary
        textField.autocapitalizationType = .none
        textField.backgroundColor = .textField
        textField.keyboardType = .phonePad
        return textField
    }()
    
    private lazy var signupButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("CREATE ACCOUNT", for: .normal)
        button.setTitleColor(.background, for: .normal)
        button.titleLabel?.font = .font(.regular, size: 12.0)
        button.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
        button.clipsToBounds = true
        button.backgroundColor = .brandGreen
        button.layer.cornerRadius = 25.0
        button.sizeToFit()
        return button
    }()
    
    private lazy var loginLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .textPrimary
        label.font = .font(.regular, size: 12.0)
        label.sizeToFit()
        label.textAlignment = .center
        let attributedText = NSMutableAttributedString(string: "Do you already have an account? Log In here")
        attributedText.linkAction(
            color: .brandOrange,
            text: "here",
            font: .font(.regular, size: 12.0)
        ) { [weak self] in
            self?.loginButtonTapped()
        }
        label.addLinkActionsObserving()
        label.attributedText = attributedText
        return label
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
        navigationItem.titleView = UIImageView(image: .logoSmall)
    }
    
    private func addSubviews() {
        view.addSubview(contentScrollView)
        [nameLabel,
         nameTextField,
         welcomeLabel,
         welcomeSubLabel,
         emailLabel,
         emailTextField,
         passwordLabel,
         passwordTextField,
         veryifyPasswordLabel,
         veryifyPasswordTextField,
         phoneNumberLabel,
         phoneNumberTextField,
         signupButton,
         loginLabel].forEach { contentScrollView.addSubview($0) }
    }
    
    private func makeConstraints() {
        contentScrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(27.0)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(30.0)
        }
        
        welcomeSubLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(11.0)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(30.0)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomeSubLabel.snp.bottom).offset(38.0)
            make.leading.equalToSuperview().inset(appearance.leadingTrailingInset)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5.0)
            make.leading.equalTo(view.snp.leading).inset(appearance.leadingTrailingInset)
            make.trailing.equalTo(view.snp.trailing).inset(appearance.leadingTrailingInset)
            make.height.equalTo(50.0)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(20.0)
            make.leading.equalToSuperview().inset(appearance.leadingTrailingInset)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(5.0)
            make.leading.equalTo(view.snp.leading).inset(appearance.leadingTrailingInset)
            make.trailing.equalTo(view.snp.trailing).inset(appearance.leadingTrailingInset)
            make.height.equalTo(50.0)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20.0)
            make.leading.equalToSuperview().inset(appearance.leadingTrailingInset)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(5.0)
            make.leading.equalTo(view.snp.leading).inset(appearance.leadingTrailingInset)
            make.trailing.equalTo(view.snp.trailing).inset(appearance.leadingTrailingInset)
            make.height.equalTo(50.0)
        }
        
        veryifyPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20.0)
            make.leading.equalToSuperview().inset(appearance.leadingTrailingInset)
        }
        
        veryifyPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(veryifyPasswordLabel.snp.bottom).offset(5.0)
            make.leading.equalTo(view.snp.leading).inset(appearance.leadingTrailingInset)
            make.trailing.equalTo(view.snp.trailing).inset(appearance.leadingTrailingInset)
            make.height.equalTo(50.0)
        }
        
        phoneNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(veryifyPasswordTextField.snp.bottom).offset(20.0)
            make.leading.equalToSuperview().inset(appearance.leadingTrailingInset)
        }
        
        phoneNumberTextField.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberLabel.snp.bottom).offset(5.0)
            make.leading.equalTo(view.snp.leading).inset(appearance.leadingTrailingInset)
            make.trailing.equalTo(view.snp.trailing).inset(appearance.leadingTrailingInset)
            make.height.equalTo(50.0)
        }
        
        signupButton.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberTextField.snp.bottom).offset(33.0)
            make.width.equalTo(192.0)
            make.centerX.equalToSuperview()
            make.height.equalTo(50.0)
        }
        
        loginLabel.snp.makeConstraints { make in
            make.top.equalTo(signupButton.snp.bottom).offset(27.0)
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
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

private extension SignupViewController {
    @objc private func signupButtonTapped() {
        presenter?.didTapCreateAccountButton(
            name: nameTextField.text,
            email: emailTextField.text,
            password: passwordTextField.text,
            passwordVerify: veryifyPasswordTextField.text,
            phoneNumber: phoneNumberTextField.text
        )
    }
    
    private func loginButtonTapped() {
        presenter?.didTapLogInLabel()
    }
}

extension SignupViewController: SignupViewInput {}
