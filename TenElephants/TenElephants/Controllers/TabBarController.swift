//
//  TabBarController.swift
//  Ten Elephants
//
//  Created by Kirill Denisov on 09.12.2021.
//

import UIKit

final class TabBarController: UITabBarController {
    private var networkService = NetworkService()
    private var imageFetcher = CachedImageFetcher()
    private lazy var recentsProvider = RecentsProvider(networkService: networkService)
    private let dataProvider = UserDefaultsDataProvider()
    private lazy var networkDataProvider = MealsDataProviderNetwork(networkService: networkService)

    func openSingleMeal(meal: Meal) {
        let uiMeal = UIMeal(mealObj: meal, dataProvider: dataProvider)
        let singleMealController = MealPageController(mealData: uiMeal, imageFetcher: imageFetcher)

        singleMealController.modalPresentationStyle = .fullScreen
        singleMealController.modalTransitionStyle = .coverVertical

        self.present(singleMealController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let likeC = LikePageController(
                dataProvider: dataProvider,
                imageFetcher: imageFetcher,
                networkDataProvider: networkDataProvider
        )
        let likeItem = UITabBarItem()
        likeItem.title = "Like"
        likeItem.image = UIImage(systemName: "heart")
        likeC.tabBarItem = likeItem

        let trendC = TrendPageController(
            networkDataProvider: networkDataProvider,
            imageFetcher: imageFetcher
        )
        let trendItem = UITabBarItem()
        trendItem.title = "Trend"
        trendItem.image = UIImage(systemName: "chart.line.uptrend.xyaxis")
        trendC.tabBarItem = trendItem

        let searchC = SearchPageController(
            networkDataProvider: networkDataProvider,
            recentProvider: recentsProvider,
            imageFetcher: imageFetcher,
            openSingleMeal: { [weak self] meal in
                self?.openSingleMeal(meal: meal)
            }
        )

        let searchItem = UITabBarItem()
        searchItem.title = "Search"
        searchItem.image = UIImage(systemName: "magnifyingglass")
        searchC.tabBarItem = searchItem

        self.viewControllers = [
            trendC,
            searchC,
            likeC
        ]
    }
}
