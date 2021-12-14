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

    enum Section: Int {
        case horizontal
        case vertical
    }

    private enum Constants {
        static let headerV:   String = "This may be interesting for you..."
        static let headerH:   String = "Trending now"
        static let reuseIdH:  String = "hCell"
        static let reuseIdV:  String = "vCell"
        static let reuseHead: String = "headerView"

        static let cellsToShowV: Int = 2
        static let cellsToShowH: Int = 5

        static let interGroupSpacing: CGFloat = 20
        static let itemContentInsets = NSDirectionalEdgeInsets(
            top: 0.0, leading: 8.0, bottom: 0.0, trailing: 8.0
        )
        static let sectionContentInsets = NSDirectionalEdgeInsets(
            top: 16.0, leading: 0.0, bottom: 16.0, trailing: 0.0
        )
    }
    
    private lazy var compositionalLayout: UICollectionViewCompositionalLayout = {
            let layout = UICollectionViewCompositionalLayout { [weak self]
                (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
                guard let section = Section(rawValue: sectionIndex) else { fatalError("No section provided") }
                switch section {
                case .horizontal:
                    return self?.setupHorizontalSection()
                case .vertical:
                    return self?.setupVerticalSection()
                }
            }
            return layout
        }()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
        return view
    }()
    
    private func setupHorizontalSection() -> NSCollectionLayoutSection {
        // item properties
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = Constants.itemContentInsets

        // group properties
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(300),
            heightDimension: .absolute(250)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 1
        )

        // section properties
        let section = NSCollectionLayoutSection(group: group)
        let headerView = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(44)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [headerView]
        
        section.contentInsets = Constants.sectionContentInsets
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary

        return section
    }
    
    private func setupVerticalSection() -> NSCollectionLayoutSection {
        // item properties
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = Constants.itemContentInsets

        // group properties
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(180)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitem: item,
            count: 1
        )
        
        // section properties
        let section = NSCollectionLayoutSection(group: group)
        let headerView = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(44)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [headerView]
        
        section.contentInsets = Constants.sectionContentInsets
        section.interGroupSpacing = Constants.interGroupSpacing
        
        return section
    }
    
    private func configureLayout() {
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor  = .systemBackground
        collectionView.register(WideCellView.self, forCellWithReuseIdentifier: Constants.reuseIdH)
        collectionView.register(PreviewCellView.self, forCellWithReuseIdentifier: Constants.reuseIdV)
        collectionView.register(
            HeaderCollectionView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: Constants.reuseHead
        )
        collectionView.dataSource = self
        collectionView.contentInsetAdjustmentBehavior = .scrollableAxes
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.configureLayout()
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
        
        self.view.addSubview(collectionView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}

// MARK: - UICollectionViewDataSource

extension TrendPageController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let s = Section(rawValue: section) else { fatalError("No section provided") }
        switch s {
        case .horizontal:
            return viewModel.meals.isEmpty ? Constants.cellsToShowH : viewModel.meals.count
        case .vertical:
            return viewModel.meals.isEmpty ? Constants.cellsToShowV : viewModel.meals.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = Section(rawValue: indexPath.section) else { fatalError("No section provided") }
        switch section {
        case .horizontal:
            let reusableCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.reuseIdH, for: indexPath)
            guard let cell = reusableCell as? WideCellView else {
                return reusableCell
            }

            guard !viewModel.meals.isEmpty else {return reusableCell}
            let item = viewModel.meals[indexPath.row]
            cell.titleLabel.text = item.name
            cell.subtitleLabel.text = item.id

            guard let link = item.thumbnailLink,
                  let url = NSURL(string: link) else {
                return cell
            }
            imageFetcher.fetch(url: url) { image in
                    cell.imageView.image = image
            }

            return cell
        case .vertical:
            let reusableCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.reuseIdV, for: indexPath)
            guard let cell = reusableCell as? PreviewCellView else {
                return reusableCell
            }

            guard !viewModel.meals.isEmpty else {return reusableCell}
            let item = viewModel.meals[indexPath.row]
            cell.titleLabel.text = item.name

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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            if kind == UICollectionView.elementKindSectionHeader {
                let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView", for: indexPath)

                guard let headerView = reusableView as? HeaderCollectionView else {
                    return reusableView
                }
                guard let section = Section(rawValue: indexPath.section) else { fatalError("No section provided") }
                switch section {
                case .vertical:
                    headerView.setText(Constants.headerV)
                case .horizontal:
                    headerView.setText(Constants.headerH)
                }
                return headerView
            } else {
                return UICollectionReusableView()
            }
        }
}
