//
//  MealPageController.swift
//  Ten Elephants
//
//  Created by Kirill Denisov on 09.12.2021.
//
import UIKit

final class MealPageController: UIViewController {
    private enum Constants {
        static let heartSize = CGSize(width: 40, height: 40)
        static let closeButtonSize = CGSize(width: 40, height: 40)
        static let closeButtonTopMargin: CGFloat = 16
        static let closeButtonRightMargin: CGFloat = -16
        static let defaultEmoji: String = "😋"
    }

    private let factory = MealViewFactory()
    private let imageFetcher: CachedImageFetcher

    private lazy var scrollView = factory.makeScrollView()
    private lazy var contentStackView = factory.makeContentStackView()
    private lazy var closeButton = factory.makeCloseButton()
    private lazy var mealImageView = factory.makeMealImageView()
    private lazy var titleView = factory.makeTitleView()
    private lazy var titleLabel = factory.makeTitleLabel()
    private lazy var likeButton = factory.makeLikeButton()
    private lazy var ingridientStack = factory.makeIngridientsStack()
    private lazy var ingridientsLabel = factory.makeRecipeLabel()
    private lazy var recipeStack = factory.makeRecipeStack()
    private lazy var recipeLabel = factory.makeRecipeLabel()

    // используется в extension UIScrollViewDelegate
    private var previousStatusBarHidden = false

    let imageContainerView = UIView()

    var mealData: UIMeal

    init(mealData: UIMeal, imageFetcher: CachedImageFetcher) {
        self.mealData = mealData
        self.imageFetcher = imageFetcher
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("Init from coder is not avaible")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // putting data
        fillMealData()
        // configuring views
        view.backgroundColor = .systemBackground
        setTranslatingToConstraints()
        addSubviews()
        setScrollView()
        configureImageContainer()
        configureMealImage()
        configureTitleView()
        configureLikeButton()
        configureIngridientStack()
        configureRecipeStack()
        configureCloseButton()
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

    // MARK: - setLiked()

    // executes when like button is pressed
    @objc private func updateLike(_ sender: LikeButton) {
        sender.isLiked = !sender.isLiked
        mealData.isLiked = sender.isLiked
    }

    // executes when close button is pressed
    @objc private func close(_: CloseButton) {
        self.dismiss(animated: true, completion: nil)
    }

    private func loadImage(url: NSURL) {
        imageFetcher.fetch(url: url, completion: { [weak self] image in
            guard let self = self else { return }
            self.mealImageView.image = image
        })
    }

    private func fillMealData() {
        if let url = mealData.thumbnailLink.flatMap({ NSURL(string: $0) }) {
            loadImage(url: url)
        }
        titleLabel.text = mealData.name
        fillIngridients(mealData.ingredients)
        recipeLabel.text = mealData.instructions
        likeButton.isLiked = mealData.isLiked
    }

    private func fillIngridients(_ ingridients: [Ingredient]?) {
        guard let ingridients = ingridients else {
            ingridientStack.heightAnchor.constraint(equalToConstant: 0).isActive = true
            ingridientStack.isHidden = true
            return
        }
        for ingridient in ingridients {
            let ingridientCell = factory.makeIngridientCell(
                name: ingridient.name,
                measure: ingridient.measure ?? "",
                emoji: Constants.defaultEmoji
            )
            ingridientStack.addArrangedSubview(ingridientCell)
        }
    }

    // MARK: - configuring funcs

    private func setTranslatingToConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        mealImageView.translatesAutoresizingMaskIntoConstraints = false
        titleView.translatesAutoresizingMaskIntoConstraints = false
        ingridientStack.translatesAutoresizingMaskIntoConstraints = false
        recipeStack.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
    }

    private func addSubviews() {
        view.addSubview(scrollView)
        view.addSubview(closeButton)
        titleView.addArrangedSubview(titleLabel)
        titleView.addArrangedSubview(likeButton)
        ingridientStack.addArrangedSubview(ingridientsLabel)
        recipeStack.addArrangedSubview(recipeLabel)
        scrollView.addSubview(imageContainerView)
        scrollView.addSubview(mealImageView)
        scrollView.addSubview(titleView)
        scrollView.addSubview(ingridientStack)
        scrollView.addSubview(recipeStack)
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
            mealImageTopConstraint, mealImageHeightConstraint,
        ])
    }

    private func configureTitleView() {
        NSLayoutConstraint.activate([
            titleView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            titleView.topAnchor.constraint(equalTo: mealImageView.bottomAnchor),
            titleView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
    }

    private func configureLikeButton() {
        likeButton.addTarget(self, action: #selector(updateLike), for: .touchUpInside)
    }

    private func configureIngridientStack() {
        NSLayoutConstraint.activate([
            ingridientStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            ingridientStack.topAnchor.constraint(equalTo: titleView.bottomAnchor),
            ingridientStack.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
    }

    private func configureRecipeStack() {
        guard let instructions = mealData.instructions, !instructions.isEmpty else {
            recipeStack.heightAnchor.constraint(equalToConstant: 0).isActive = true
            recipeStack.isHidden = false
            return
        }
        NSLayoutConstraint.activate([
            recipeStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            recipeStack.topAnchor.constraint(equalTo: ingridientStack.bottomAnchor),
            recipeStack.widthAnchor.constraint(equalTo: view.widthAnchor),
            recipeStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
    }

    private func configureCloseButton() {
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: Constants.closeButtonRightMargin
            ),
            closeButton.topAnchor.constraint(
                equalTo: view.layoutMarginsGuide.topAnchor,
                constant: Constants.closeButtonTopMargin
            ),
            closeButton.heightAnchor.constraint(equalToConstant: Constants.closeButtonSize.height),
            closeButton.widthAnchor.constraint(equalToConstant: Constants.closeButtonSize.width),
        ])
    }
}

extension MealPageController: UIScrollViewDelegate {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

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
