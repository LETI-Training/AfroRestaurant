import UIKit
import SnapKit

extension LoginViewController {
    struct Appearance {
        let leadingTrailingInset: CGFloat = 26.0
    }
}

final class LoginViewController: BaseViewController {
    
    private let appearance = Appearance()
    var presenter: LoginPresenterProtocol?
    
    private lazy var contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var headerImageView: UIImageView = {
        let imageView = UIImageView(image: .afroHeader)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: .logo)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Добро пожаловать"
        label.textColor = .textPrimary
        label.font = .font(.extraBold, size: 32.0)
        label.textAlignment = .center
        label.sizeToFit()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var welcomeSubLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Enter a world of mouth-watering delicacies"
        label.textColor = .textSecondary
        label.font = .font(.regular, size: 12.0)
        label.sizeToFit()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "E-mail:"
        label.textColor = .textPrimary
        label.font = .font(.regular, size: 12.0)
        label.sizeToFit()
        label.numberOfLines = 0
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
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("SIGN IN", for: .normal)
        button.setTitleColor(.background, for: .normal)
        button.titleLabel?.font = .font(.regular, size: 12.0)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        button.clipsToBounds = true
        button.backgroundColor = .brandGreen
        button.layer.cornerRadius = 25.0
        button.sizeToFit()
        return button
    }()
    
    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Forgot Password?", for: .normal)
        button.setTitleColor(.textSecondary, for: .normal)
        button.titleLabel?.font = .font(.regular, size: 12.0)
        button.addTarget(self, action: #selector(forgotPasswordButtonWasClicked), for: .touchUpInside)
        button.clipsToBounds = true
        button.backgroundColor = .clear
        button.sizeToFit()
        return button
    }()
    
    private lazy var signupLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .textPrimary
        label.font = .font(.regular, size: 12.0)
        label.sizeToFit()
        label.textAlignment = .center
        let attributedText = NSMutableAttributedString(string: "Don’t have an account? Create one here")
        attributedText.linkAction(
            color: .brandOrange,
            text: "here",
            font: .font(.regular, size: 12.0)
        ) { [weak self] in
            self?.presenter?.didTapOnCreateNewAccount()
        }
        label.addLinkActionsObserving()
        label.attributedText = attributedText
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
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
    }
    
    private func addSubviews() {
        view.addSubview(headerImageView)
        view.addSubview(contentScrollView)
        [logoImageView,
         welcomeLabel,
         welcomeSubLabel,
         emailLabel,
         emailTextField,
         passwordLabel,
         passwordTextField,
         loginButton,
         forgotPasswordButton,
         signupLabel].forEach { contentScrollView.addSubview($0) }
    }
    
    private func makeConstraints() {
        headerImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(26.0)
        }
        
        contentScrollView.snp.makeConstraints { make in
            make.top.equalTo(headerImageView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(58.0)
            make.centerX.equalToSuperview()
            make.height.equalTo(81.3)
        }
        
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(59.0)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(30.0)
        }
        
        welcomeSubLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(11.0)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(30.0)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomeSubLabel.snp.bottom).offset(55.0)
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
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(97.0)
            make.width.equalTo(192.0)
            make.centerX.equalToSuperview()
            make.height.equalTo(50.0)
        }
        
        forgotPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(18.0)
            make.centerX.equalToSuperview()
            make.height.equalTo(16.0)
        }
        
        signupLabel.snp.makeConstraints { make in
            make.top.equalTo(forgotPasswordButton.snp.bottom).offset(65.0)
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

private extension LoginViewController {
    
    @objc private func loginButtonTapped() {
        presenter?.didTapOnSignInButton(
            email: emailTextField.text,
            password: passwordTextField.text
        )
    }
    
    @objc private func forgotPasswordButtonWasClicked() {
        presentAlertWithTextField(
            title: "Reset Password",
            actionCancel: ActionAlertModel(actionText: "Cancel", actionHandler: {}),
            actionComplete: ActionAlertModel(actionText: "Reset", actionHandler: {}),
            placeHolder: "Please enter your email"
        ) { email in
            self.presenter?.didTapOnForgetPassword(email: email)
        }
    }
}

extension LoginViewController: LoginViewInput {}
