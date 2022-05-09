import UIKit
import SnapKit

extension AdminDishViewViewController {
    struct Appearance {
        let leadingTrailingInset: CGFloat = 26.0
    }
}

final class AdminDishViewViewController: BaseViewController {
    
    private let appearance = Appearance()
    var presenter: AdminDishViewPresenterProtocol?
    
    private lazy var contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var dishImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var addImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.addPhoto, for: .normal)
        button.addTarget(self, action: #selector(addPhotoTapped), for: .touchUpInside)
        button.clipsToBounds = true
        button.tintColor = .black
        button.backgroundColor = .background
        button.layer.cornerRadius = 36 / 2
        button.sizeToFit()
        return button
    }()
    
    private lazy var ratingsImageView: UIImageView = {
        let image = UIImageView(image: .star)
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var ratingsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .background
        label.font = .font(.regular, size: 10.0)
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    private lazy var favoritesImageView: UIImageView = {
        let image = UIImageView(image: .favorite)
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var favoritesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .background
        label.font = .font(.regular, size: 10.0)
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    private lazy var ratingContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.4)
        return view
    }()
    
    private lazy var dishNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Dish Name:"
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
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Price:"
        label.textColor = .textPrimary
        label.font = .font(.extraBold, size: 20.0)
        label.textAlignment = .left
        label.sizeToFit()
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var priceTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.layer.cornerRadius = 12.0
        textField.textColor = .textSecondary
        textField.autocapitalizationType = .none
        textField.backgroundColor = .none
        textField.font = .font(.regular, size: 16.0)
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    private lazy var caloriesLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Calorie Count:"
        label.textColor = .textPrimary
        label.font = .font(.extraBold, size: 20.0)
        label.textAlignment = .left
        label.sizeToFit()
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var caloriesTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.layer.cornerRadius = 12.0
        textField.textColor = .textSecondary
        textField.autocapitalizationType = .none
        textField.backgroundColor = .none
        textField.font = .font(.regular, size: 16.0)
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Save Changes", for: .normal)
        button.setTitleColor(.background, for: .normal)
        button.titleLabel?.font = .font(.bold, size: 17.0)
        button.addTarget(self, action: #selector(saveDishButtonTapped), for: .touchUpInside)
        button.clipsToBounds = true
        button.backgroundColor = .brandGreen
        button.layer.cornerRadius = 12.0
        button.sizeToFit()
        return button
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Delete Dish", for: .normal)
        button.setTitleColor(.background, for: .normal)
        button.titleLabel?.font = .font(.bold, size: 17.0)
        button.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        button.clipsToBounds = true
        button.backgroundColor = .red
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
    
    private lazy var priceDividerView: UIView = {
        let divider = BaseViewController.dividerView
        divider.backgroundColor = .textSecondary.withAlphaComponent(0.4)
        return divider
    }()
    
    private lazy var caloriesDividerView: UIView = {
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
        addKeyBoardObserver()
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
        view.addSubview(contentScrollView)
        view.addSubview(addImageButton)
        view.addSubview(nameDividerView)
        view.addSubview(descriptionDividerView)
        view.addSubview(nameDividerView)
        view.addSubview(priceDividerView)
        view.addSubview(caloriesDividerView)
        [dishImageView,
         dishNameLabel,
         nameTextField,
         descriptionLabel,
         descriptionTextField,
         priceLabel,
         priceTextField,
         caloriesLabel,
         caloriesTextField,
         saveButton,
         deleteButton].forEach { contentScrollView.addSubview($0) }
        
        dishImageView.addSubview(ratingContainerView)
        [ratingsImageView,
         ratingsLabel,
         favoritesLabel,
         favoritesImageView
        ].forEach { ratingContainerView.addSubview($0) }
    }
    
    private func makeConstraints() {
        contentScrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        dishImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(25.0)
            make.leading.equalToSuperview().inset(appearance.leadingTrailingInset)
            make.height.equalTo(199)
            make.width.equalTo(341)
        }
        
        ratingContainerView.snp.makeConstraints { make in
            make.height.equalTo(20.0)
            make.bottom.leading.trailing.equalToSuperview()
        }
        
        ratingsLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(4.0)
            make.centerY.equalToSuperview()
        }
        
        ratingsImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(10.0)
            make.trailing.equalTo(ratingsLabel.snp.leading).offset(-2.0)
        }
        
        favoritesImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(4.0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(10.0)
        }
        
        favoritesLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(favoritesImageView.snp.trailing).offset(2.0)
        }
        
        addImageButton.snp.makeConstraints { make in
            make.centerY.equalTo(dishImageView.snp.top)
            make.width.height.equalTo(36)
            make.centerX.equalTo(dishImageView.snp.trailing)
        }
        
        dishNameLabel.snp.makeConstraints { make in
            make.top.equalTo(dishImageView.snp.bottom).offset(24.0)
            make.leading.trailing.equalToSuperview().inset(appearance.leadingTrailingInset)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(dishNameLabel.snp.bottom).offset(5.0)
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
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextField.snp.bottom).offset(24.0)
            make.leading.trailing.equalToSuperview().inset(appearance.leadingTrailingInset)
        }
        
        priceTextField.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(5.0)
            make.leading.equalTo(view.snp.leading).inset(appearance.leadingTrailingInset)
            make.trailing.equalTo(view.snp.trailing).inset(appearance.leadingTrailingInset)
            make.height.equalTo(33.0)
        }
        
        caloriesLabel.snp.makeConstraints { make in
            make.top.equalTo(priceTextField.snp.bottom).offset(24.0)
            make.leading.trailing.equalToSuperview().inset(appearance.leadingTrailingInset)
        }
        
        caloriesTextField.snp.makeConstraints { make in
            make.top.equalTo(caloriesLabel.snp.bottom).offset(5.0)
            make.leading.equalTo(view.snp.leading).inset(appearance.leadingTrailingInset)
            make.trailing.equalTo(view.snp.trailing).inset(appearance.leadingTrailingInset)
            make.height.equalTo(33.0)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(caloriesTextField.snp.bottom).offset(57)
            make.leading.equalTo(view.snp.leading).inset(appearance.leadingTrailingInset)
            make.trailing.equalTo(view.snp.trailing).inset(appearance.leadingTrailingInset)
            make.height.equalTo(56.0)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(saveButton.snp.bottom).offset(16)
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
        
        priceDividerView.snp.makeConstraints { make in
            make.bottom.equalTo(priceTextField)
            make.leading.trailing.equalTo(priceTextField)
        }
        
        caloriesDividerView.snp.makeConstraints { make in
            make.bottom.equalTo(caloriesTextField)
            make.leading.trailing.equalTo(caloriesTextField)
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

private extension AdminDishViewViewController {
    @objc private func saveDishButtonTapped() {
        presenter?.saveButtonPressed(
            image: dishImageView.image,
            dishName: nameTextField.text ?? "",
            description: descriptionTextField.text,
            calories: caloriesTextField.text ?? "",
            price: priceTextField.text ?? ""
        )
        view.endEditing(true)
    }
    
    @objc private func deleteTapped() {
        presenter?.deleteTapped()
    }
    
    @objc private func addPhotoTapped() {
        presenter?.addPhotoTapped()
    }
}

extension AdminDishViewViewController: AdminDishViewViewInput {
    func updateUI(model: DishModel) {
        title = model.dishName
        let data = Data(base64Encoded: model.imageString) ?? Data()
        dishImageView.image = UIImage(data: data)
        nameTextField.text = model.dishName
        descriptionTextField.text = model.dishDescription
        priceTextField.text = "\(model.price)"
        caloriesTextField.text = "\(model.calories)"
        favoritesLabel.text = "\(model.favoritesCount ?? 0)"
        ratingsLabel.text = "\(model.rating ?? 0)"
    }
    
    func updateImage(image: UIImage?) {
        DispatchQueue.main.async {
            self.dishImageView.image = image
        }
    }
}
