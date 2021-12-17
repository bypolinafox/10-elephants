//
//  SearchPageController.swift
//  Ten Elephants
//
//  Created by Kirill Denisov on 09.12.2021.
//

import UIKit

final class SearchPageController: UIViewController {
    private enum Constants {
        static let recentMealsTitle = "Trending now"
        static let suggestionsTitle = "Maybe you are looking for"
        static let nothingFoundTitle = "Nothing found 😢"
        static let sideInsetValue: CGFloat = 16
        static let sideInsets = UIEdgeInsets(
            top: 0,
            left: sideInsetValue,
            bottom: 0,
            right: sideInsetValue
        )
        static let ingredientHeight: CGFloat = 35

        static let mealSuggestionHeight: CGFloat = 200
        static let mealSuggestionCellWidth: CGFloat = 250
        static let sectionSpacing: CGFloat = 10
        static let titleSpacing: CGFloat = 5
        static let mealSuggestionsHeight: CGFloat = 310

        static let blurAnimationDuration: TimeInterval = 0.5

        // cell IDs
        static let mealCellID = "mealCell"
        static let ingredientCellID = "ingredientCell"
        static let resultMealCellID = "resultMealCell"

        // cell types
        static let mealCellType = WideCellView.self
        static let ingredientCellType = IngredientSuggestionCell.self
        static let resultMealCellType = WideCellView.self
    }

    private lazy var suggestionScrollView = factory.makeSuggestionsScrollView()
    private lazy var suggestionStackView: UIStackView = factory.makeSuggestionStackView()
    private lazy var searchBar: UISearchBar = factory.makeSearchBar()
    private lazy var mealCollectionView: UICollectionView = factory.makeMealCollectionView()
    private lazy var mealSuggestionsStack: UIStackView = factory.makeMealSuggestionStackView()
    private lazy var mealSuggestionTitle: UILabel = factory.makeMealSuggestionTitle()
    private lazy var ingredientSuggestionsStack: UIStackView = factory
        .makeIngredientSuggestionStackView()
    private lazy var ingredientSuggestionTitle: UILabel = factory.makeIngredientSuggestionTitle()
    private lazy var ingregientCollectionView: UICollectionView = factory
        .makeIngredientCollectionView()
    private lazy var resultCollectionView: UICollectionView = factory.makeResultCollectionView()
    private lazy var blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
    private lazy var suggestionNothingFound = factory.makeNothingFoundStack()
    private lazy var resultNothingFound = factory.makeNothingFoundStack()
    private lazy var tapRecognizer = UITapGestureRecognizer(
        target: self,
        action: #selector(hideSuggestions)
    )

    private let factory = SearchPageViewFactory()
    private var netDataProvider: MealsDataProviderNetwork
    private var recentsProvider: RecentsProviderProtocol
    private var imageFetcher: CachedImageFetcher

    private var mealsToShow: [Meal] = []
    private var filters: [String] = []

    private var openSingleMeal: (Meal) -> Void

    private lazy var mealDataSource = MealSuggestionDataSource(
        cellWidth: Constants.mealSuggestionCellWidth,
        cellID: Constants.mealCellID,
        imageFetcher: imageFetcher,
        openSingleMeal: openSingleMeal
    )
    private lazy var ingredientDataSource = IngredientDataSource(
        cellID: Constants.ingredientCellID,
        updateParentFilters: { [weak self] newFilters in
            // we pass it to dataSource so we can respond to touches in CollectionView
            guard let self = self else { return }

            let searchText = self.searchBar.nonOptionalText
            self.filters = newFilters
            guard !newFilters.isEmpty else {
                self.search(searchText: searchText)
                return
            }

            self.searchByIngredients(filters: newFilters, searchText: searchText)
        }
    )

    private lazy var resultDataSource = ResultMealDataSource(
        cellHeight: Constants.mealSuggestionsHeight,
        insetValue: Constants.sideInsetValue,
        cellID: Constants.resultMealCellID,
        imageFetcher: imageFetcher,
        openSingleMeal: openSingleMeal
    )

    init(
        networkDataProvider: MealsDataProviderNetwork,
        recentProvider: RecentsProviderProtocol,
        imageFetcher: CachedImageFetcher,
        openSingleMeal: @escaping (Meal) -> Void
    ) {
        self.netDataProvider = networkDataProvider
        self.recentsProvider = recentProvider
        self.imageFetcher = imageFetcher
        self.openSingleMeal = openSingleMeal
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - viewDidLoad()

    override func viewDidLoad() {
        super.viewDidLoad()
        showRecentMeals()

        // configuring views
        view.backgroundColor = .systemBackground
        addSubviews()
        configureCollectionViewSources()
        configureSearchBar()
        configureResultCollectionView()
        configureScrollView()
        configureStackView()
        configureMealSuggestions()
        configureIngredientSuggestions()
        configureSuggestionsLayout()
        configureNothingFoundStacks()

        tapRecognizer.delegate = self
        suggestionScrollView.addGestureRecognizer(tapRecognizer)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        blurView.frame = self.view.frame
    }

    // MARK: - responding to data changes

    private func reloadCollectionViewsData() {
        mealCollectionView.reloadData()
        ingregientCollectionView.reloadData()
        resultCollectionView.reloadData()
        updateSuggestionLayout()
    }

    private func filterMeals(meals: [Meal], searchWord: String) -> [Meal] {
        guard !searchWord.isEmpty else { return meals }

        return meals.filter { meal in
            guard let name = meal.name else { return false }
            return name.lowercased().contains(searchWord.lowercased())
        }
    }

    private func showRecentMeals() {
        filters = []
        recentsProvider.getRecentMeals { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(items):
                DispatchQueue.main.async {
                    self.filters = []
                    self.mealsToShow = items.meals
                    self.mealDataSource.meals = self.mealsToShow
                    self.resultDataSource.meals = self.mealsToShow
                    self.reloadCollectionViewsData()
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }

    private func updateSuggestionLayout() {
        guard !mealsToShow.isEmpty else {
            mealSuggestionTitle.isHidden = true
            setNothingFoundStackAppearance(isHidden: false)
            return
        }

        setNothingFoundStackAppearance(isHidden: true)
        mealSuggestionTitle.isHidden = false

        guard searchBar.nonOptionalText.isEmpty, filters.isEmpty else {
            mealSuggestionTitle.text = Constants.suggestionsTitle
            return
        }

        mealSuggestionTitle.text = Constants.recentMealsTitle
    }

    private func search(searchText: String) {
        guard !searchText.isEmpty else {
            showRecentMeals()
            return
        }
        netDataProvider.searchMealByName(name: searchText) { [weak self] result in
            guard let self = self else { return }
            guard self.filters.isEmpty else {
                self.searchByIngredients(filters: self.filters, searchText: searchText)
                return
            }

            switch result {
            case let .success(items):
                self.mealsToShow = items.meals
            case let .failure(error):
                print(error.localizedDescription)
                self.mealsToShow = [] // nothing found
            }
            DispatchQueue.main.async {
                self.mealDataSource.meals = self.mealsToShow
                self.resultDataSource.meals = self.mealsToShow
                self.reloadCollectionViewsData()
            }
        }
    }

    private func searchByIngredients(filters: [String], searchText: String) {
        netDataProvider.fetchMealListFiltered(by: filters) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case let .success(items):
                    let filteredMeals = self.filterMeals(meals: items.meals, searchWord: searchText)
                    self.mealsToShow = filteredMeals
                case let .failure(error):
                    print(error.localizedDescription)
                    self.mealsToShow = []
                }

                self.mealDataSource.meals = self.mealsToShow
                self.resultDataSource.meals = self.mealsToShow
                self.reloadCollectionViewsData()
            }
        }
    }
}

extension SearchPageController: UISearchBarDelegate {
    func searchBar(_: UISearchBar, textDidChange _: String) {
        NSObject.cancelPreviousPerformRequests(
            withTarget: self,
            selector: #selector(reloadSuggestions),
            object: nil
        )
        self.perform(#selector(reloadSuggestions), with: nil, afterDelay: 0.5)
    }

    func searchBarSearchButtonClicked(_: UISearchBar) {
        updateSuggestionLayout(isHidden: true)
    }

    func searchBarCancelButtonClicked(_: UISearchBar) {
        updateSuggestionLayout(isHidden: true)
    }

    func searchBarTextDidBeginEditing(_: UISearchBar) {
        updateSuggestionLayout(isHidden: false)
    }

    @objc private func reloadSuggestions() {
        search(searchText: searchBar.nonOptionalText)
    }
}

extension SearchPageController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: ingregientCollectionView) == true { return false }
        if touch.view?.isDescendant(of: mealCollectionView) == true { return false }
        return true
    }
}

// MARK: - configuring view funcs

extension SearchPageController {
    private func configureCollectionViewSources() {
        mealCollectionView.dataSource = mealDataSource
        mealCollectionView.delegate = mealDataSource
        mealCollectionView.register(
            Constants.mealCellType,
            forCellWithReuseIdentifier: Constants.mealCellID
        )

        ingregientCollectionView.dataSource = ingredientDataSource
        ingregientCollectionView.delegate = ingredientDataSource
        ingregientCollectionView.register(
            Constants.ingredientCellType,
            forCellWithReuseIdentifier: Constants.ingredientCellID
        )

        resultCollectionView.dataSource = resultDataSource
        resultCollectionView.delegate = resultDataSource
        resultCollectionView.register(
            Constants.resultMealCellType,
            forCellWithReuseIdentifier: Constants.resultMealCellID
        )
    }

    private func addSubviews() {
        view.addSubview(blurView)
        view.addSubview(resultCollectionView)
        view.addSubview(searchBar)
        view.addSubview(suggestionScrollView)
        view.addSubview(resultNothingFound)
        suggestionScrollView.addSubview(suggestionStackView)

        suggestionStackView.addArrangedSubview(ingredientSuggestionsStack)
        ingredientSuggestionsStack.addArrangedSubview(ingredientSuggestionTitle)
        ingredientSuggestionsStack.addArrangedSubview(ingregientCollectionView)

        suggestionStackView.addArrangedSubview(mealSuggestionsStack)
        mealSuggestionsStack.addArrangedSubview(mealSuggestionTitle)
        mealSuggestionsStack.addArrangedSubview(mealCollectionView)
        mealSuggestionsStack.addSubview(suggestionNothingFound)
    }

    private func configureSearchBar() {
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    private func configureResultCollectionView() {
        resultCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resultCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            resultCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            resultCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            resultCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func configureScrollView() {
        suggestionScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            suggestionScrollView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            suggestionScrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            suggestionScrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            suggestionScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        suggestionScrollView.layer.opacity = 0
        suggestionScrollView.layer.isHidden = true
    }

    private func configureStackView() {
        suggestionStackView.translatesAutoresizingMaskIntoConstraints = false
        suggestionStackView.axis = .vertical
        suggestionStackView.distribution = .fill
        suggestionStackView.alignment = .fill

        NSLayoutConstraint.activate([
            suggestionStackView.topAnchor.constraint(equalTo: suggestionScrollView.topAnchor),
            suggestionStackView.leftAnchor.constraint(equalTo: suggestionScrollView.leftAnchor),
            suggestionStackView.widthAnchor.constraint(equalTo: view.widthAnchor),
            suggestionStackView.bottomAnchor.constraint(equalTo: suggestionScrollView.bottomAnchor),
        ])
    }

    private func configureMealSuggestions() {
        self.mealCollectionView.backgroundColor = .clear
        NSLayoutConstraint.activate([
            mealCollectionView.heightAnchor
                .constraint(equalToConstant: Constants.mealSuggestionHeight),
            mealCollectionView.widthAnchor.constraint(equalTo: mealSuggestionsStack.widthAnchor),
        ])

        NSLayoutConstraint.activate([
            mealSuggestionTitle.leadingAnchor.constraint(
                equalTo: mealSuggestionsStack.leadingAnchor,
                constant: Constants.sideInsetValue
            ),
            mealSuggestionTitle.trailingAnchor.constraint(
                equalTo: mealSuggestionsStack.trailingAnchor,
                constant: -Constants.sideInsetValue
            ),
        ])
    }

    private func configureIngredientSuggestions() {
        self.ingregientCollectionView.backgroundColor = .clear
        NSLayoutConstraint.activate([
            ingregientCollectionView.heightAnchor
                .constraint(equalToConstant: Constants.ingredientHeight),
            ingregientCollectionView.widthAnchor
                .constraint(equalTo: ingredientSuggestionsStack.widthAnchor),
        ])

        NSLayoutConstraint.activate([
            ingredientSuggestionTitle.leadingAnchor.constraint(
                equalTo: ingredientSuggestionsStack.leadingAnchor,
                constant: Constants.sideInsetValue
            ),
            ingredientSuggestionTitle.trailingAnchor.constraint(
                equalTo: ingredientSuggestionsStack.trailingAnchor,
                constant: -Constants.sideInsetValue
            ),
        ])
    }

    private func configureSuggestionsLayout() {
        view.bringSubviewToFront(blurView)
        view.bringSubviewToFront(searchBar)
        view.bringSubviewToFront(suggestionScrollView)
        updateSuggestionLayout(isHidden: false)
        searchBar.becomeFirstResponder()
    }

    private func updateSuggestionLayout(isHidden: Bool) {
        searchBar.setShowsCancelButton(!isHidden, animated: true)
        switch isHidden {
        case true:
            searchBar.endEditing(true)
            UIView.animate(withDuration: Constants.blurAnimationDuration, animations: {
                self.blurView.layer.opacity = 0
                self.suggestionScrollView.layer.opacity = 0
            }, completion: { _ in
                self.blurView.isHidden = true
                self.suggestionScrollView.isHidden = true
            })
        case false:
            self.blurView.isHidden = false
            self.suggestionScrollView.isHidden = false
            UIView.animate(withDuration: Constants.blurAnimationDuration, animations: {
                self.blurView.layer.opacity = 1
                self.suggestionScrollView.layer.opacity = 1
            })
        }
    }

    private func configureNothingFoundStacks() {
        NSLayoutConstraint.activate([
            suggestionNothingFound.centerXAnchor
                .constraint(equalTo: mealSuggestionsStack.centerXAnchor),
            suggestionNothingFound.centerYAnchor
                .constraint(equalTo: mealSuggestionsStack.centerYAnchor),
        ])

        NSLayoutConstraint.activate([
            resultNothingFound.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultNothingFound.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        setNothingFoundStackAppearance(isHidden: true)
    }

    private func setNothingFoundStackAppearance(isHidden: Bool) {
        suggestionNothingFound.isHidden = isHidden
        resultNothingFound.isHidden = isHidden
    }

    // tap gesture recognizer action
    @objc private func hideSuggestions() {
        updateSuggestionLayout(isHidden: true)
    }
}

extension UISearchBar {
    var nonOptionalText: String {
        self.text ?? ""
    }
}
