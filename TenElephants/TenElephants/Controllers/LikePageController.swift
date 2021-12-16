//
// Created by Kirill Denisov on 14.12.2021.
//

import UIKit

final class LikePageController: UIViewController {
    lazy var nothingFoundView: NothingFoundStack = {
        let nfv = NothingFoundStack(
                emoji: "💔",
                title: "Nothing Liked",
                description: "Press ❤️ button to can save your favourite recipes here"
        )
        nfv.isHidden = true
        return nfv
    }()

    var viewModel: UIMeals
    let provider: DBDataProvider
    var imageFetcher: CachedImageFetcher
    let netDataProvider: MealsDataProviderNetwork

    private enum Constants {
        static let reuseId: String = "FavCell"
        static let cellHeight: CGFloat = 100
        static let cellWidth: CGFloat = 343
    }

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return view
    }()

    init(
        dataProvider: DBDataProvider,
        imageFetcher: CachedImageFetcher,
        networkDataProvider: MealsDataProviderNetwork
    ) {
        netDataProvider = networkDataProvider
        viewModel = UIMeals(meals: [])
        provider = dataProvider
        self.imageFetcher = imageFetcher
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("Init from coder is not available")
    }

    func openSingleMeal(meal: UIMeal) {
        let singleMealController = MealPageController(mealData: meal, imageFetcher: imageFetcher)

        singleMealController.modalPresentationStyle = .fullScreen
        singleMealController.modalTransitionStyle = .coverVertical

        present(singleMealController, animated: true, completion: nil)
    }

    func getData(completion: @escaping ([UIMeal]) -> Void) {
        let likeList = provider.likeList()
        let resultArray = NSMutableArray(capacity: likeList.count)
        resultArray.fillWithEmpty(likeList.count)

        let group = DispatchGroup()
        for (index, element) in likeList.enumerated() {
            let id = element
            group.enter()
            netDataProvider.fetchMealDetails(by: id) { [weak self] result in
                defer {
                    group.leave()
                }
                guard let provider = self?.provider else { return }

                switch result {
                case let .success(meals):
                    let uiItem = UIMeal(
                        mealObj: meals.meals.first!,
                        dataProvider: provider
                    )
                    resultArray.replaceObject(at: index, with: uiItem)
                case .failure:
                    return
                }
            }
        }
        group.notify(queue: DispatchQueue.main) {
            guard let meals = resultArray.convertToArray() as? [UIMeal] else {
                return
            }
            completion(meals)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)
        view.addSubview(nothingFoundView)

        NSLayoutConstraint.activate([
            nothingFoundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nothingFoundView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            nothingFoundView.leftAnchor.constraint(equalTo: view.leftAnchor),
            nothingFoundView.rightAnchor.constraint(equalTo: view.rightAnchor)

        ])

        collectionView.backgroundColor = .systemBackground
        collectionView.register(PreviewCellView.self, forCellWithReuseIdentifier: Constants.reuseId)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData(completion: { [self] meals in

            self.nothingFoundView.isHidden = !(meals.count == 0)

            viewModel = UIMeals(meals: meals)
            collectionView.reloadData()
        })
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}

// MARK: - UICollectionViewDataSource

extension LikePageController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let reusableCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.reuseId,
            for: indexPath
        )
        guard let cell = reusableCell as? PreviewCellView else {
            return reusableCell
        }

        if viewModel.meals.isEmpty {
            cell.indicator.startAnimating()
        } else {
            cell.indicator.stopAnimating()
            cell.indicator.hidesWhenStopped = true
            let item = viewModel.meals[indexPath.row]
            cell.titleLabel.text = item.name
            guard let link = item.thumbnailLink,
                  let url = NSURL(string: link) else {
                return cell
            }
            imageFetcher.fetch(url: url) { image in
                cell.imageView.image = image
            }
        }
        return cell
    }

    func numberOfSections(in _: UICollectionView) -> Int {
        1
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        viewModel.meals.count
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meal = viewModel.meals[indexPath.row]
        openSingleMeal(meal: meal)
    }
}

extension LikePageController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _: UICollectionView,
        layout _: UICollectionViewLayout,
        sizeForItemAt _: IndexPath
    ) -> CGSize {
        .init(width: Constants.cellWidth, height: Constants.cellHeight)
    }
}
