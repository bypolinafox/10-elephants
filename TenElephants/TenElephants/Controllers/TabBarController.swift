//
//  TabBarController.swift
//  Ten Elephants
//
//  Created by Kirill Denisov on 09.12.2021.
//

import UIKit

final class TabBarController: UITabBarController {
    private var networkService = NetworkService()
    private var imageLoader = ImageLoader()
    private lazy var recentsProvider = RecentsProvider(networkService: networkService)
    private let likeProvider = UserDefaultsDataProvider()

    private lazy var networkDataProvider = MealsDataProviderNetwork(networkService: networkService)

    private lazy var ingredientsDataProvider: IngredientsDataProvider =
        IngredientsDataProviderNetwork(networkService: networkService)

    func openSingleMeal(meal: Meal) {
        let uiMeal = UIMeal(mealObj: meal, dataProvider: likeProvider)
        let singleMealController = MealPageController(
            meal: uiMeal,
            imageLoader: imageLoader,
            dataProvider: networkDataProvider,
            likeProvider: likeProvider
        )

        singleMealController.modalPresentationStyle = .fullScreen
        singleMealController.modalTransitionStyle = .coverVertical

        self.present(singleMealController, animated: true, completion: nil)
    }

    func openSingleIngredient(ingredient: IngredientUIData) {
        let singleIngredientController = SingleIngredientPageController(
            ingredient: ingredient,
            imageLoader: imageLoader,
            dataProvider: ingredientsDataProvider
        )

        singleIngredientController.modalPresentationStyle = .fullScreen
        singleIngredientController.modalTransitionStyle = .coverVertical

        present(singleIngredientController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let trendC = TrendPageController(
            networkDataProvider: networkDataProvider,
            imageLoader: imageLoader,
            openSingleMeal: { [weak self] meal in
                self?.openSingleMeal(meal: meal)
            }
        )
        let trendItem = UITabBarItem()
        trendItem.title = "Trend"
        trendItem.image = UIImage(systemName: "chart.line.uptrend.xyaxis")
        trendC.tabBarItem = trendItem

        let searchC = SearchPageController(
            networkDataProvider: networkDataProvider,
            recentProvider: recentsProvider,
            imageLoader: imageLoader,
            openSingleMeal: { [weak self] meal in
                self?.openSingleMeal(meal: meal)
            }
        )
        let searchItem = UITabBarItem()
        searchItem.title = "Search"
        searchItem.image = UIImage(systemName: "magnifyingglass")
        searchC.tabBarItem = searchItem

        let ingredientsC = IngredientsPageController(
            dataProvider: ingredientsDataProvider,
            imageLoader: imageLoader,
            openSingleIngredient: { [weak self] ingredient in
                self?.openSingleIngredient(ingredient: ingredient)
            }
        )

        let ingredientsItem = UITabBarItem()
        ingredientsItem.title = "Ingredients"
        ingredientsItem.image = UIImage(systemName: "list.bullet.rectangle")
        ingredientsC.tabBarItem = ingredientsItem

        let randomC = MealPageController(
            meal: nil,
            imageLoader: imageLoader,
            dataProvider: networkDataProvider,
            likeProvider: likeProvider
        )
        let randomItem = UITabBarItem()
        randomItem.title = "Random"
        randomItem.image = UIImage(systemName: "dice")
        randomC.tabBarItem = randomItem

        let personNavC = UINavigationController()

        let likeC = LikePageController(
            dataProvider: likeProvider,
            imageLoader: imageLoader,
            networkDataProvider: networkDataProvider
        )
        let likeItem = UITabBarItem()
        likeItem.image = UIImage(systemName: "heart")
        likeC.tabBarItem = likeItem
        likeC.title = "Favourites"

        personNavC.viewControllers = [likeC]
        personNavC.navigationBar.prefersLargeTitles = true

        self.viewControllers = [
            trendC,
            searchC,
            randomC,
            ingredientsC,
            personNavC,
        ]
    }
}
