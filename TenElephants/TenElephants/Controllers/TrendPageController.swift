//
//  TrendPageController.swift
//  Ten Elephants
//
//  Created by Kirill Denisov on 09.12.2021.
//

import UIKit

final class TrendPageController: UIViewController {
    var viewModelH = Meals(meals: []) {
        didSet {
            collectionView.reloadData()
        }
    }

    var viewModelV = Meals(meals: []) {
        didSet {
            collectionView.reloadData()
        }
    }

    let mealsDataProvider: MealsDataProvider
    let imageLoader: ImageLoader
    private let openSingleMeal: (Meal) -> Void

    enum Section: Int {
        case horizontal
        case vertical
    }

    private enum Constants {
        static let headerV: String = "Hot recipes"
        static let headerH: String = "Trends"
        static let reuseIdH: String = "hCell"
        static let reuseIdV: String = "vCell"
        static let reuseHead: String = "headerView"

        static let cellsToShowV: Int = 5
        static let cellsToShowH: Int = 2

        static let widthH: CGFloat = 300
        static let heightH: CGFloat = 250

        static let interGroupSpacing: CGFloat = 20
        static let itemContentInsets = NSDirectionalEdgeInsets(
            top: 0.0, leading: 0.0, bottom: 0.0, trailing: 16.0
        )
        static let sectionContentInsets = NSDirectionalEdgeInsets(
            top: 1.0, leading: 16.0, bottom: 16.0, trailing: 16.0
        )
        static let collectionViewTopInset: CGFloat = 5
    }

    init(
        mealsDataProvider: MealsDataProvider,
        imageLoader: ImageLoader,
        openSingleMeal: @escaping (Meal) -> Void
    ) {
        self.mealsDataProvider = mealsDataProvider
        self.imageLoader = imageLoader
        self.openSingleMeal = openSingleMeal
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var compositionalLayout: UICollectionViewCompositionalLayout = {
        let layout = UICollectionViewCompositionalLayout { [weak self]
            (
                sectionIndex: Int,
                _: NSCollectionLayoutEnvironment
            ) -> NSCollectionLayoutSection? in
                guard let section = Section(rawValue: sectionIndex)
                else { fatalError("No section provided") }
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
        view.contentInset.top = Constants.collectionViewTopInset
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
            widthDimension: .estimated(Constants.widthH),
            heightDimension: .absolute(Constants.heightH)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 1
        )

        // section properties
        let section = NSCollectionLayoutSection(group: group)

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

        // group properties
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(150)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitem: item,
            count: 1
        )

        // section properties
        let section = NSCollectionLayoutSection(group: group)
        let headerView = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(44)
            ),
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
        collectionView.backgroundColor = .systemBackground
        collectionView.register(WideCellView.self, forCellWithReuseIdentifier: Constants.reuseIdH)
        collectionView.register(
            PreviewCellView.self,
            forCellWithReuseIdentifier: Constants.reuseIdV
        )
        collectionView.register(
            HeaderCollectionView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: Constants.reuseHead
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInsetAdjustmentBehavior = .scrollableAxes
        collectionView.reloadData()
    }

    func fetchData(for section: Section) {
        mealsDataProvider.fetchRandomPreviewMeals {
            switch $0 {
            case let .success(items):
                DispatchQueue.main.async {
                    switch section {
                    case .horizontal:
                        self.viewModelH = items
                    case .vertical:
                        self.viewModelV = items
                    }
                }
            case .failure:
                return
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureLayout()
        fetchData(for: .horizontal)
        fetchData(for: .vertical)

        view.addSubview(collectionView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}

// MARK: - UICollectionViewDataSource

extension TrendPageController: UICollectionViewDataSource {
    func numberOfSections(in _: UICollectionView) -> Int {
        2
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let s = Section(rawValue: section) else { fatalError("No section provided") }
        switch s {
        case .horizontal:
            return viewModelH.meals.isEmpty ? Constants.cellsToShowH : viewModelH.meals.count
        case .vertical:
            return viewModelV.meals.isEmpty ? Constants.cellsToShowV : viewModelV.meals.count
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let section = Section(rawValue: indexPath.section)
        else { fatalError("No section provided") }
        switch section {
        case .horizontal:
            let reusableCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: Constants.reuseIdH,
                for: indexPath
            )
            guard let cell = reusableCell as? WideCellView else {
                return reusableCell
            }

            cell.isLoading = false
            if viewModelH.meals.isEmpty {
                cell.isLoading = true
                cell.configure(titleText: "Loading...")
            } else {
                let item = viewModelH.meals[indexPath.row]
                cell.configure(
                    titleText: item.name,
                    area: item.area,
                    category: item.category,
                    thumbnailLink: item.thumbnailLink,
                    imageLoader: imageLoader
                )
            }
            return cell
        case .vertical:
            let reusableCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: Constants.reuseIdV,
                for: indexPath
            )
            guard let cell = reusableCell as? PreviewCellView else {
                return reusableCell
            }

            if viewModelV.meals.isEmpty {
                cell.indicator.startAnimating()
                cell.configure(titleText: nil)
            } else {
                cell.indicator.stopAnimating()
                cell.indicator.hidesWhenStopped = true
                let item = viewModelV.meals[indexPath.row]
                cell.configure(
                    titleText: item.name,
                    thumbnailLink: item.thumbnailLink,
                    imageLoader: imageLoader
                )
            }
            return cell
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let reusableView = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: "headerView",
                for: indexPath
            )

            guard let headerView = reusableView as? HeaderCollectionView else {
                return reusableView
            }
            guard let section = Section(rawValue: indexPath.section)
            else { fatalError("No section provided") }
            switch section {
            case .vertical:
                headerView.setTitle(Constants.headerV, style: .medium)
            case .horizontal:
                headerView.setTitle(Constants.headerH, style: .big)
            }
            return headerView
        } else {
            return UICollectionReusableView()
        }
    }
}

// MARK: - UICollectionViewDelegate

extension TrendPageController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else {
            assertionFailure("No section provided")
            return
        }
        switch section {
        case .horizontal:
            guard !viewModelH.meals.isEmpty else { return }
            let item = viewModelH.meals[indexPath.row]
            openSingleMeal(item)
        case .vertical:
            guard !viewModelV.meals.isEmpty else { return }
            let item = viewModelV.meals[indexPath.row]
            openSingleMeal(item)
        }
    }
}
