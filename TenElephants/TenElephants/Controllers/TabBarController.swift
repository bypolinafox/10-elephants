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

        let likeC = LikePageController(
            dataProvider: likeProvider,
            imageLoader: imageLoader,
            networkDataProvider: networkDataProvider
        )
        let likeItem = UITabBarItem()
        likeItem.title = "Like"
        likeItem.image = UIImage(systemName: "heart")
        likeC.tabBarItem = likeItem

        self.viewControllers = [
            trendC,
            searchC,
            randomC,
            likeC,
        ]
    }
}
