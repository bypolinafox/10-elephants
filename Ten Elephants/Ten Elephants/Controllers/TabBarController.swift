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

        let TrendC = TrendPageController()
        let trendItem = UITabBarItem()
        trendItem.title = "Trend"
        trendItem.image = UIImage(systemName: "chart.line.uptrend.xyaxis")
        TrendC.tabBarItem = trendItem

        let SearchC = SearchPageController(
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
        SearchC.tabBarItem = searchItem

        let MealC = MealPageController(
            mealData:
            UIMeal(
                mealObj: Meal(
                    id: "testID",
                    name: "potato",
                    thumbnailLink: "https://www.themealdb.com/images/media/meals/uttupv1511815050.jpg",
                    category: "Category",
                    area: "Area",
                    instructions: "instructions instructions instructions instructions instructions instructions",
                    youTubeLink: nil,
                    tags: ["tag1", "tag2", "tag3", "tag4"],
                    ingredients: nil
                ),
                dataProvider: dataProvider
            ),
            imageFetcher: imageFetcher
        )
        let mealItem = UITabBarItem()
        mealItem.title = "Meal"
        mealItem.image = UIImage(systemName: "heart.text.square")
        MealC.tabBarItem = mealItem

        self.viewControllers = [
            TrendC,
            SearchC,
            MealC,
        ]
    }
}
