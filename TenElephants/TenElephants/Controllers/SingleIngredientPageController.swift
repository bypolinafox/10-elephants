//
//  SingleIngredientPageController.swift
//  TenElephants
//
//  Created by Дарья Домрачева on 17.12.2021.
//

import Foundation
import UIKit
import Combine

final class SingleIngredientPageController: UIViewController {
    private enum Constants {
        static let closeButtonSize = CGSize(width: 40, height: 40)
        static let closeButtonTopMargin: CGFloat = 16
        static let closeButtonRightMargin: CGFloat = -16
        static let defaultEmoji: String = "😋"
        static let loadingScreenAppearanceDuration: TimeInterval = 0.5
        static let urlLinkBeginning: String = "https://www.themealdb.com/images/ingredients/"
        static let imgFormat: String = ".png"
    }
    private var cancellable: AnyCancellable? {
        willSet {
            cancellable?.cancel()
        }
    }
    deinit {
        print("deinit")
    }

    private let factory = MealViewFactory()
    private var imageLoader: ImageLoader
    private var preloadedIngredient: IngredientUIData? // is received from init
    private let dataProvider: IngredientsDataProvider

    private lazy var scrollView = factory.makeScrollView()
    private lazy var contentStackView = factory.makeContentStackView()
    private lazy var roundCornerButton = factory.makeRoundButtonWithBlur(type: .close)
    private lazy var ingredientImageView = factory.makeMealImageView()
    private lazy var titleView = factory.makeTitleView()
    private lazy var titleLabel = factory.makeTitleLabel()
    private lazy var descriptionStack = factory.makeRecipeStack()
    private lazy var descriptionLabel = factory.makeRecipeLabel()
    private lazy var textStackView = factory.makeTextStackView()
    private lazy var loadingScreen = factory.makeLoadingScreen(isHidden: true)
    private let imageContainerView = UIView()

    // is used in extension UIScrollViewDelegate
    private var previousStatusBarHidden = false

    init(
        ingredient: IngredientUIData?,
        imageLoader: ImageLoader,
        dataProvider: IngredientsDataProvider
    ) {
        self.preloadedIngredient = ingredient
        self.imageLoader = imageLoader
        self.dataProvider = dataProvider
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("Init from coder is not avaible")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // load data
        loadIngredientData()

        // configuring views
        view.backgroundColor = .systemBackground
        setTranslatingToConstraints()
        addSubviews()
        setScrollView()
        configureImageContainer()
        configureIngredientImage()
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

    // MARK: - setLiked, close, reload

    // executes when close button is pressed
    @objc private func close() {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - working with data

    private func loadIngredientData() {
        if let ingredient = preloadedIngredient {
            fillIngredientData(ingredient: ingredient)
            return
        }
    }

    private func makeDescriptionText() -> UITextView {
        let label = UITextView()
        label.font = UIFont.systemFont(ofSize: 16)
        label.isScrollEnabled = true
//        label.frame = scrollView.frame
//        label.numberOfLines = 0
        return label
    }

    private func constructThumbnailLink(title: String) -> String {
        let urlLink = "\(Constants.urlLinkBeginning)\(title)\(Constants.imgFormat)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        print(urlLink)
        return "\(Constants.urlLinkBeginning)\(title)\(Constants.imgFormat)"
    }

    private func fillIngredientData(ingredient: IngredientUIData){
        if let title = ingredient.title {
            let link = constructThumbnailLink(title: title)
            loadImage(link: link)
        }
        titleLabel.text = ingredient.title
        print(ingredient.description ?? "no")
        if let description = ingredient.description, !description.isEmpty {
            descriptionStack.isHidden = false
            descriptionLabel.text = description
        } else { descriptionStack.isHidden = true }
    }

    // MARK: - changing appearance

    private func setLoadingScreenAppearance(shouldHide: Bool, animated: Bool) {
        loadingScreen.setAppearance(shouldHide: shouldHide, animated: animated)
    }

    private func loadImage(link linkOriginal: String) {
        if let link = linkOriginal.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            cancellable = imageLoader.loadImage(thumbnailLink: link).sink { [unowned self] image in
                self.ingredientImageView.image = image
            }
        }
    }

    // MARK: - configuring view funcs

    private func setTranslatingToConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        ingredientImageView.translatesAutoresizingMaskIntoConstraints = false
        titleView.translatesAutoresizingMaskIntoConstraints = false
        descriptionStack.translatesAutoresizingMaskIntoConstraints = false
        roundCornerButton.translatesAutoresizingMaskIntoConstraints = false
    }

    private func addSubviews() {
        view.addSubview(scrollView)
        view.addSubview(roundCornerButton)
        view.addSubview(loadingScreen)
        titleView.addArrangedSubview(titleLabel)
        descriptionStack.addArrangedSubview(descriptionLabel)
        scrollView.addSubview(imageContainerView)
        scrollView.addSubview(ingredientImageView)
        scrollView.addSubview(textStackView)
        textStackView.addArrangedSubview(titleView)
        textStackView.addArrangedSubview(descriptionStack)
    }

    private func setScrollView() {
        scrollView.delegate = self
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
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
            ),
        ])
    }
    private func configureTextContainer() {
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: textStackView.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
//        NSLayoutConstraint.activate([
//            descriptionLabel.topAnchor.constraint(equalTo: textContainerView.topAnchor),
//            descriptionLabel.leadingAnchor.constraint(equalTo: textContainerView.leadingAnchor),
//            descriptionLabel.trailingAnchor.constraint(equalTo: textContainerView.trailingAnchor),
//            descriptionLabel.bottomAnchor.constraint(equalTo: textContainerView.bottomAnchor),
//        ])
    }

    private func configureIngredientImage() {
        ingredientImageView.contentMode = .scaleAspectFill
        ingredientImageView.clipsToBounds = true

        let mealImageTopConstraint = ingredientImageView.topAnchor.constraint(equalTo: view.topAnchor)
        mealImageTopConstraint.priority = .defaultHigh

        let mealImageHeightConstraint = ingredientImageView.heightAnchor
            .constraint(greaterThanOrEqualTo: imageContainerView.heightAnchor)
        mealImageHeightConstraint.priority = .required

        NSLayoutConstraint.activate([
            ingredientImageView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor),
            ingredientImageView.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor),
            ingredientImageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor),
            mealImageTopConstraint, mealImageHeightConstraint,
        ])
    }

    private func configureTextStackView() {
        NSLayoutConstraint.activate([
            textStackView.topAnchor.constraint(equalTo: ingredientImageView.bottomAnchor),
            textStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            textStackView.widthAnchor.constraint(equalTo: view.widthAnchor),
            textStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
    }

    private func configureCloseButton() {
        roundCornerButton.addTarget(self, action: #selector(close), for: .touchUpInside)
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
                .constraint(equalToConstant: Constants.closeButtonSize.width),
        ])
    }

    private func configureLoadingScreen() {
        NSLayoutConstraint.activate([
            loadingScreen.topAnchor.constraint(equalTo: view.topAnchor),
            loadingScreen.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingScreen.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingScreen.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

extension SingleIngredientPageController: UIScrollViewDelegate {
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