import UIKit
import SnapKit

extension AdminDishesViewController {
    struct Appearance {
        let leadingTrailingInset: CGFloat = 26.0
    }
}

final class AdminDishesViewController: BaseViewController {

    private let appearance = Appearance()
    var presenter: AdminDishesPresenterProtocol?
    
    var categoryDescription: String = ""
    var viewModels: [DishesCollectionViewCell.ViewModel] = []
   
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
            AdminDishesHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: AdminDishesHeaderView.identifier
        )
        collectionView.register(
            DishesCollectionViewCell.self,
            forCellWithReuseIdentifier: DishesCollectionViewCell.identifier
        )
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        return collectionView
    }()
    
    private lazy var newDishButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add New Dish", for: .normal)
        button.setTitleColor(.background, for: .normal)
        button.titleLabel?.font = .font(.regular, size: 14.0)
        button.addTarget(self, action: #selector(newDishButtonTapped), for: .touchUpInside)
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
        presenter?.viewWillAppear()
    }

    private func setupUI() {
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(collectionView)
        view.addSubview(newDishButton)
    }

    private func makeConstraints() {
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(appearance.leadingTrailingInset)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        newDishButton.snp.makeConstraints { make in
            make.width.equalTo(192.0)
            make.height.equalTo(50.0)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(57.0)
        }
    }
    
    @objc private func newDishButtonTapped() {
        presenter?.createNewDishTapped()
    }
}

extension AdminDishesViewController: AdminDishesViewInput {
    func updateTitle(title: String) {
        self.title = title
    }
    
    func updateItems(description: String, viewModels: [DishesCollectionViewCell.ViewModel]) {
        categoryDescription = description
        self.viewModels = viewModels
        collectionView.reloadData()
    }
    
}

extension AdminDishesViewController: UICollectionViewDataSource {
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


extension AdminDishesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        presenter?.dishTapped(at: indexPath.row)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(
            collectionView,
            viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
            at: indexPath
        )
        return headerView.systemLayoutSizeFitting(
            CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )

    }
    
}

extension AdminDishesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return .init(width: (collectionView.frame.width - 16) / 2, height: 45 + 113)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let header = collectionView
            .dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: AdminDishesHeaderView.identifier,
                for: indexPath
            ) as! AdminDishesHeaderView
        header.updateText(text: categoryDescription)
        
        return header
    }
}
