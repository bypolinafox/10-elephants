//
//  MealPageController.swift
//  Ten Elephants
//
//  Created by Kirill Denisov on 09.12.2021.
//
import UIKit
import Combine

final class MealPageController: UIViewController {
    private enum Constants {
        static let heartSize = CGSize(width: 40, height: 40)
        static let closeButtonSize = CGSize(width: 40, height: 40)
        static let closeButtonTopMargin: CGFloat = 16
        static let closeButtonRightMargin: CGFloat = -16
        static let defaultEmoji: String = "😋"
        static let loadingScreenAppearanceDuration: TimeInterval = 0.5
    }
    private var cancellable: AnyCancellable? {
        willSet {
            cancellable?.cancel()
        }
    }

    private let factory = MealViewFactory()
    private var imageLoader: ImageLoader
    private var preloadedMeal: UIMeal? // is received from init
    private var randomMeal: UIMeal? // loads from dataProvider
    private var randomCocktail: UICocktail?
    private let dataProvider: MealsDataProvider
    private let likeProvider: DBDataProvider

    private lazy var scrollView = factory.makeScrollView()
    private lazy var contentStackView = factory.makeContentStackView()
    private lazy var roundCornerButton = factory.makeRoundButtonWithBlur(
        type: preloadedMeal == nil ? .refresh : .close
    )
    private lazy var mealImageView = factory.makeMealImageView()
    private lazy var titleView = factory.makeTitleView()
    private lazy var titleLabel = factory.makeTitleLabel()
    private lazy var likeButton = factory.makeLikeButton()
    private lazy var ingredientStack = factory.makeIngredientsStack()
    private lazy var ingredientsLabel = factory.makeRecipeLabel()
    private lazy var recipeStack = factory.makeRecipeStack()
    private lazy var recipeLabel = factory.makeRecipeLabel()
    private lazy var textStackView = factory.makeTextStackView()
    private lazy var loadingScreen = factory.makeLoadingScreen(isHidden: true)
    private let imageContainerView = UIView()

    let refreshControl = UIRefreshControl()

    // используется в extension UIScrollViewDelegate
    private var previousStatusBarHidden = false

    init(
        meal: UIMeal?,
        imageLoader: ImageLoader,
        dataProvider: MealsDataProvider,
        likeProvider: DBDataProvider
    ) {
        self.preloadedMeal = meal
        self.imageLoader = imageLoader
        self.dataProvider = dataProvider
        self.likeProvider = likeProvider
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("Init from coder is not avaible")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // putting data
        loadMealData()

        // configuring views
        if preloadedMeal == nil {
            setLoadingScreenAppearance(shouldHide: false, animated: false)
            refreshControl.addTarget(self, action: #selector(reload), for: .valueChanged)
            scrollView.refreshControl = refreshControl
        }
        view.backgroundColor = .systemBackground
        setTranslatingToConstraints()
        addSubviews()
        setScrollView()
        configureImageContainer()
        configureMealImage()
        configureLikeButton()
        configureCloseButton()
        configureTextStackView()
        configureLoadingScreen()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.scrollIndicatorInsets = view.safeAreaInsets
        scrollView.contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: view.safeAreaInsets.bottom,
            right: 0
        )
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }

    override func motionBegan(_: UIEvent.EventSubtype, with _: UIEvent?) {
        loadCocktail()
    }

    // MARK: - setLiked, close, reload

    // executes when like button is pressed
    @objc private func updateLike(_ sender: LikeButton) {
        sender.isLiked = !sender.isLiked
        if preloadedMeal != nil {
            preloadedMeal!.isLiked = sender.isLiked
        } else if randomMeal != nil {
            randomMeal!.isLiked = sender.isLiked
        }
    }

    // executes when close button is pressed
    @objc private func close() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc private func reload() {
        self.loadMealData()
    }

    private func loadCocktail() {
        setLoadingScreenAppearance(shouldHide: false, animated: true)
        dataProvider.fetchRandomCocktail { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(items):
                guard !items.drinks.isEmpty else { return }
                self.randomCocktail = UICocktail(cocktailObj: items.drinks[0])
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.setLoadingScreenAppearance(shouldHide: true, animated: true)
                    self.fillDrinkData(drink: self.randomCocktail!)
                }
            case .failure:
                return
            }
        }
    }

    // MARK: - working with data

    private func loadMealData() {
        if let preloadedMeal = preloadedMeal {
            fillMealData(meal: preloadedMeal)
            return
        }

        setLoadingScreenAppearance(shouldHide: false, animated: true)
        // it loads several meals for now, should load just one
        dataProvider.fetchRandomPreviewMeals { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(items):
                guard !items.meals.isEmpty else { return }
                self.randomMeal = UIMeal(mealObj: items.meals[0], dataProvider: self.likeProvider)
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.setLoadingScreenAppearance(shouldHide: true, animated: true)
                    self.fillMealData(meal: self.randomMeal!)
                }
            case .failure:
                return
            }
        }
    }

    private func fillMealData(meal: UIMeal) {
        self.likeButton.isHidden = false

        if let link = meal.thumbnailLink {
            loadImage(link: link)
        }
        titleLabel.text = meal.name
        if let ingredients = meal.ingredients, !ingredients.isEmpty {
            ingredientStack.isHidden = false
            fillIngredients(meal.ingredients)
        } else { ingredientStack.isHidden = true }
        if let recipe = meal.instructions, !recipe.isEmpty {
            recipeStack.isHidden = false
            recipeLabel.text = recipe
        } else { recipeStack.isHidden = true }
        likeButton.isLiked = meal.isLiked
    }

    private func fillDrinkData(drink: UICocktail) {
        self.likeButton.isHidden = true
        if let link = drink.thumbnailLink {
            loadImage(link: link)
        }
        titleLabel.text = drink.name
        if let ingredients = drink.ingredients, !ingredients.isEmpty {
            ingredientStack.isHidden = false
            fillIngredients(drink.ingredients, drinks: true)
        } else { ingredientStack.isHidden = true }
        if let recipe = drink.instructions, !recipe.isEmpty {
            recipeStack.isHidden = false
            recipeLabel.text = recipe
        } else { recipeStack.isHidden = true }
    }

    // MARK: - changing appearance

    private func setLoadingScreenAppearance(shouldHide: Bool, animated: Bool) {
        loadingScreen.setAppearance(shouldHide: shouldHide, animated: animated)
    }

    private func loadImage(link: String) {
        cancellable = imageLoader.loadImage(thumbnailLink: link).sink { [unowned self] image in
            self.mealImageView.image = image
        }
    }

    private func fillIngredients(_ ingredients: [Ingredient]?, drinks: Bool = false) {
        guard let ingredients = ingredients else { return }
        clearIngredientsStack()
        for ingredient in ingredients {
            let ingredientCell = factory.makeIngredientCell(
                name: ingredient.name,
                measure: ingredient.measure ?? "",
                drinks: drinks
            )
            ingredientStack.addArrangedSubview(ingredientCell)
        }
    }

    private func clearIngredientsStack() {
        for subview in ingredientStack.arrangedSubviews where !(subview is UILabel) {
            ingredientStack.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
    }

    // MARK: - configuring view funcs

    private func setTranslatingToConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        mealImageView.translatesAutoresizingMaskIntoConstraints = false
        titleView.translatesAutoresizingMaskIntoConstraints = false
        ingredientStack.translatesAutoresizingMaskIntoConstraints = false
        recipeStack.translatesAutoresizingMaskIntoConstraints = false
        roundCornerButton.translatesAutoresizingMaskIntoConstraints = false
    }

    private func addSubviews() {
        view.addSubview(scrollView)
        view.addSubview(roundCornerButton)
        view.addSubview(loadingScreen)
        titleView.addArrangedSubview(titleLabel)
        titleView.addArrangedSubview(likeButton)
        ingredientStack.addArrangedSubview(ingredientsLabel)
        recipeStack.addArrangedSubview(recipeLabel)
        scrollView.addSubview(imageContainerView)
        scrollView.addSubview(mealImageView)
        scrollView.addSubview(textStackView)
        textStackView.addArrangedSubview(titleView)
        textStackView.addArrangedSubview(ingredientStack)
        textStackView.addArrangedSubview(recipeStack)
    }

    private func setScrollView() {
        scrollView.delegate = self
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func configureImageContainer() {
        let imageRatio: CGFloat = 0.75
        NSLayoutConstraint.activate([
            imageContainerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageContainerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageContainerView.heightAnchor.constraint(
                equalTo: imageContainerView.widthAnchor,
                multiplier: imageRatio
            )
        ])
    }

    private func configureMealImage() {
        mealImageView.contentMode = .scaleAspectFill
        mealImageView.clipsToBounds = true

        let mealImageTopConstraint = mealImageView.topAnchor.constraint(equalTo: view.topAnchor)
        mealImageTopConstraint.priority = .defaultHigh

        let mealImageHeightConstraint = mealImageView.heightAnchor
            .constraint(greaterThanOrEqualTo: imageContainerView.heightAnchor)
        mealImageHeightConstraint.priority = .required

        NSLayoutConstraint.activate([
            mealImageView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor),
            mealImageView.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor),
            mealImageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor),
            mealImageTopConstraint, mealImageHeightConstraint
        ])
    }

    private func configureTextStackView() {
        NSLayoutConstraint.activate([
            textStackView.topAnchor.constraint(equalTo: mealImageView.bottomAnchor),
            textStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            textStackView.widthAnchor.constraint(equalTo: view.widthAnchor),
            textStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }

    private func configureLikeButton() {
        likeButton.addTarget(self, action: #selector(updateLike), for: .touchUpInside)
    }

    private func configureCloseButton() {
        if preloadedMeal == nil {
            roundCornerButton.addTarget(self, action: #selector(reload), for: .touchUpInside)
        } else {
            roundCornerButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        }
        NSLayoutConstraint.activate([
            roundCornerButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: Constants.closeButtonRightMargin
            ),
            roundCornerButton.topAnchor.constraint(
                equalTo: view.layoutMarginsGuide.topAnchor,
                constant: Constants.closeButtonTopMargin
            ),
            roundCornerButton.heightAnchor
                .constraint(equalToConstant: Constants.closeButtonSize.height),
            roundCornerButton.widthAnchor
                .constraint(equalToConstant: Constants.closeButtonSize.width)
        ])
    }

    private func configureLoadingScreen() {
        NSLayoutConstraint.activate([
            loadingScreen.topAnchor.constraint(equalTo: view.topAnchor),
            loadingScreen.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingScreen.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingScreen.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension MealPageController: UIScrollViewDelegate {
    private var shouldHideStatusBar: Bool {
        let frame = titleLabel.convert(titleView.bounds, to: view)
        return frame.minY < view.safeAreaInsets.top
    }

    override var prefersStatusBarHidden: Bool {
        shouldHideStatusBar
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        .slide
    }

    func scrollViewDidScroll(_: UIScrollView) {
        if previousStatusBarHidden != shouldHideStatusBar {
            UIView.animate(withDuration: 0.2, animations: {
                self.setNeedsStatusBarAppearanceUpdate()
            })
            previousStatusBarHidden = shouldHideStatusBar
        }
    }
}
