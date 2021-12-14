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
                networkService: networkService
        )
        let likeItem = UITabBarItem()
        likeItem.title = "Like"
        likeItem.image = UIImage(systemName: "heart")
        likeC.tabBarItem = likeItem

        let trendC = TrendPageController()
        let trendItem = UITabBarItem()
        trendItem.title = "Trend"
        trendItem.image = UIImage(systemName: "chart.line.uptrend.xyaxis")
        trendC.tabBarItem = trendItem

        let searchC = SearchPageController(
            networkService: networkService,
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
