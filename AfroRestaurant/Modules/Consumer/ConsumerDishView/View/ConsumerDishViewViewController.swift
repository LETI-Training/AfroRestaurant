import UIKit
import SnapKit

extension ConsumerDishViewViewController {
    struct Appearance {
        let leadingTrailingInset: CGFloat = 26.0
    }
    
    struct ViewModel {
        let isLiked: Bool
        let isInCart: Bool
    }
}

final class ConsumerDishViewViewController: BaseViewController {
    
    private let appearance = Appearance()
    var presenter: ConsumerDishViewPresenterProtocol?
    
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
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var favoritesButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(favoritesButtonTapped), for: .touchUpInside)
        button.clipsToBounds = true
        button.tintColor = .black
        button.backgroundColor = .background
        button.layer.cornerRadius = 25
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
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapNewRateView(_:)))
        view.addGestureRecognizer(tapGestureRecognizer)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    @objc func didTapNewRateView(_ sender: UITapGestureRecognizer) {
        presenter?.didTapNewRateView()
    }
    
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
        textField.isUserInteractionEnabled = false
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
        textField.isUserInteractionEnabled = false
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
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton(frame: .zero)
       
        button.titleLabel?.font = .font(.bold, size: 17.0)
        button.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
        button.clipsToBounds = true
        button.backgroundColor = .brandGreen
        button.layer.cornerRadius = 25
        button.setTitleColor(.background, for: .normal)
        button.sizeToFit()
        return button
    }()
    
    private lazy var buyMealButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitleColor(.background, for: .normal)
        button.titleLabel?.font = .font(.bold, size: 17.0)
        button.setTitle("Buy Meal", for: .normal)
        button.backgroundColor = .brandGreen
        button.addTarget(self, action: #selector(buyMealTapped), for: .touchUpInside)
        button.clipsToBounds = true
        button.layer.cornerRadius = 25
        button.sizeToFit()
        return button
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
        presenter?.viewWillAppear()
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
        view.addSubview(contentScrollView)
        view.addSubview(favoritesButton)
        view.addSubview(descriptionDividerView)
        view.addSubview(priceDividerView)
        view.addSubview(caloriesDividerView)
        [dishImageView,
         descriptionLabel,
         descriptionTextField,
         priceLabel,
         priceTextField,
         caloriesLabel,
         caloriesTextField,
         buyMealButton,
         cartButton].forEach { contentScrollView.addSubview($0) }
        
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
            make.leading.equalTo(view.snp.leading).inset(30.0)
            make.trailing.equalTo(view.snp.trailing).inset(30.0)
            make.height.equalTo(290)
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
        
        favoritesButton.snp.makeConstraints { make in
            make.centerY.equalTo(dishImageView.snp.top)
            make.width.height.equalTo(66)
            make.centerX.equalTo(dishImageView.snp.trailing)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(dishImageView.snp.bottom).offset(24.0)
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
        
        cartButton.snp.makeConstraints { make in
            make.top.equalTo(caloriesTextField.snp.bottom).offset(10.0)
            make.leading.equalTo(view.snp.leading).inset(appearance.leadingTrailingInset)
            make.trailing.equalTo(view.snp.centerX).offset(-5.0)
            make.height.equalTo(50.0)
            make.bottom.lessThanOrEqualToSuperview().inset(20.0)
        }
        
        buyMealButton.snp.makeConstraints { make in
            make.top.equalTo(cartButton)
            make.trailing.equalTo(view.snp.trailing).inset(appearance.leadingTrailingInset)
            make.leading.equalTo(view.snp.centerX).offset(5.0)
            make.height.equalTo(50.0)
            make.bottom.lessThanOrEqualToSuperview()
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

private extension ConsumerDishViewViewController {
    @objc private func cartButtonTapped() {
        presenter?.cartButtonTapped()
    }
    
    @objc private func buyMealTapped() {
        presenter?.buyMealPressed()
    }
    
    @objc private func favoritesButtonTapped() {
        presenter?.addToFavoritesPressed()
    }
}

extension ConsumerDishViewViewController: ConsumerDishViewViewInput {
    func updateUI(model: DishModel, viewModel: ViewModel) {
        title = model.dishName
        let data = Data(base64Encoded: model.imageString) ?? Data()
        dishImageView.image = UIImage(data: data)
        descriptionTextField.text = model.dishDescription
        priceTextField.text = "\(model.price)"
        caloriesTextField.text = "\(model.calories)"
        
        viewModel.isLiked
        ? favoritesButton.setImage(.isAddedToFavs, for: .normal)
        : favoritesButton.setImage(.notInFavs, for: .normal)
        
        if viewModel.isInCart {
            cartButton.setTitle("Remove from cart", for: .normal)
            cartButton.backgroundColor = .red
        } else {
            cartButton.setTitle("Add To Cart", for: .normal)
            cartButton.backgroundColor = .textPrimary
        }
    }
    
    func updateRatings(rating: Double) {
        ratingsLabel.text = String(format: "%.1f", rating)
    }
    
    func updateLikes(likesCount: Int) {
        favoritesLabel.text = "\(likesCount)"
    }
}
