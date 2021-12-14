//
//  TrendPageController.swift
//  Ten Elephants
//
//  Created by Kirill Denisov on 09.12.2021.
//

import UIKit

class TrendPageController: UIViewController {

    var viewModel = Meals(meals: [])
    let provider = MealsDataProviderStub()
    let imageFetcher = CachedImageFetcher()

    private enum Constants {
        static let reuseId: String = "Cell"
        static let cellHeight: CGFloat = 273
        static let cellWidth: CGFloat = 343
    }

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)

        collectionView.backgroundColor = .systemBackground
        collectionView.register(WideCellView.self, forCellWithReuseIdentifier: Constants.reuseId)
        collectionView.delegate = self
        collectionView.dataSource = self

        provider.fetchRandomPreviewMeals {
            switch $0 {
            case let .success(items):
                DispatchQueue.main.async {
                    self.viewModel = items
                    self.collectionView.reloadData()
                }
            case let .failure(error):
                fatalError(error.localizedDescription)
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}

// MARK: - UICollectionViewDataSource

extension TrendPageController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.meals.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reusableCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.reuseId,
                for: indexPath)

        guard let cell = reusableCell as? WideCellView else {
            return reusableCell
        }

        let item = viewModel.meals[indexPath.row]
        cell.titleLabel.text = item.name
        cell.subtitleLabel.text = item.category

        guard let link = item.thumbnailLink,
              let url = NSURL(string: link) else {
            return cell
        }
        imageFetcher.fetch(url: url) { image in
                cell.imageView.image = image
        }

        return cell
    }
}

extension TrendPageController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: Constants.cellWidth, height: Constants.cellHeight)
    }
}
