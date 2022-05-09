import UIKit
import SnapKit

extension ConsumerFavoritesViewController {
    struct Appearance {
        let leadingTrailingInset: CGFloat = 26.0
    }
}

final class ConsumerFavoritesViewController: BaseViewController {

    private let appearance = Appearance()
    var presenter: ConsumerFavoritesPresenterProtocol?
    
    var viewModels: [DishesCollectionViewCell.ViewModel] = []
    
    var isLoaded = false
    
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(red: 0.829, green: 0.389, blue: 0.163, alpha: 1).cgColor,
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
        label.text = "Favourites"
        label.textColor = .textPrimary
        label.font = .font(.extraBold, size: 32.0)
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.keyboardDismissMode = .interactive
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        flowLayout.minimumLineSpacing = 24
        flowLayout.minimumInteritemSpacing = 0
        collectionView.register(
            DishesCollectionViewCell.self,
            forCellWithReuseIdentifier: DishesCollectionViewCell.identifier
        )
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        return collectionView
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
        view.addSubview(collectionView)
    }

    private func makeConstraints() {
        gradientView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(10)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(appearance.leadingTrailingInset)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(23.0)
        }
    }
}

extension ConsumerFavoritesViewController: ConsumerFavoritesViewInput {
    func updateView(viewModels: [DishesCollectionViewCell.ViewModel]) {
        self.viewModels = viewModels
        collectionView.reloadData()
    }
    
}

extension ConsumerFavoritesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DishesCollectionViewCell.identifier,
            for: indexPath) as? DishesCollectionViewCell
        else { return UICollectionViewCell() }
        
        cell.viewModel = viewModels[indexPath.row]
        return cell
    }
}


extension ConsumerFavoritesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        presenter?.dishTapped(at: indexPath.row)
    }
}

extension ConsumerFavoritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return .init(width: (collectionView.frame.width - 16) / 2, height: 45 + 113 + 36 + 9)
    }
    
}
