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

        present(singleMealController, animated: true, completion: nil)
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

        let trendNavC = UINavigationController()
        let trendC = TrendPageController(
            mealsDataProvider: networkDataProvider,
            imageLoader: imageLoader,
            openSingleMeal: { [weak self] meal in
                self?.openSingleMeal(meal: meal)
            }
        )
        let trendItem = UITabBarItem()
        trendItem.image = UIImage(systemName: "chart.line.uptrend.xyaxis")
        trendC.tabBarItem = trendItem
        trendC.title = "Trends"
        trendNavC.viewControllers = [trendC]
        trendNavC.navigationBar.prefersLargeTitles = true

        let searchNavC = UINavigationController()
        let searchC = SearchPageController(
            mealsDataProvider: networkDataProvider,
            recentsProvider: recentsProvider,
            imageLoader: imageLoader,
            openSingleMeal: { [weak self] meal in
                self?.openSingleMeal(meal: meal)
            }
        )
        let searchItem = UITabBarItem()
        searchItem.image = UIImage(systemName: "magnifyingglass")
        searchC.tabBarItem = searchItem
        searchC.title = "Search"
        searchNavC.viewControllers = [searchC]

        let ingredientsNavC = UINavigationController()
        let ingredientsC = IngredientsPageController(
            dataProvider: ingredientsDataProvider,
            openSingleIngredient: { [weak self] ingredient in
                self?.openSingleIngredient(ingredient: ingredient)
            }
        )
        let ingredientsItem = UITabBarItem()
        ingredientsItem.image = UIImage(systemName: "list.bullet.rectangle")
        ingredientsC.tabBarItem = ingredientsItem
        ingredientsC.title = "Ingredients"
        ingredientsNavC.viewControllers = [ingredientsC]
        ingredientsNavC.navigationBar.prefersLargeTitles = true

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

        let likeNavC = UINavigationController()
        let likeC = LikePageController(
            dataProvider: likeProvider,
            imageLoader: imageLoader,
            mealsDataProvider: networkDataProvider
        )
        let likeItem = UITabBarItem()
        likeItem.image = UIImage(systemName: "heart")
        likeC.tabBarItem = likeItem
        likeC.title = "Favourites"
        likeNavC.viewControllers = [likeC]
        likeNavC.navigationBar.prefersLargeTitles = true

        viewControllers = [
            trendNavC,
            searchNavC,
            randomC,
            ingredientsNavC,
            likeNavC,
        ]
    }
}
