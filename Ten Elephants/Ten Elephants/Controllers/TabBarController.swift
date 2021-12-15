//
//  TabBarController.swift
//  Ten Elephants
//
//  Created by Kirill Denisov on 09.12.2021.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let dataProvider = UserDefaultsDataProvider()

        let TrendC = TrendPageController()
        let trendItem = UITabBarItem()
        trendItem.title = "Trend"
        trendItem.image = UIImage(systemName: "chart.line.uptrend.xyaxis")
        TrendC.tabBarItem = trendItem

        let SearchC = SearchPageController()
        let searchItem = UITabBarItem()
        searchItem.title = "Search"
        searchItem.image = UIImage(systemName: "magnifyingglass")
        SearchC.tabBarItem = searchItem

        let MealC = MealPageController(mealData:
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
                ingredients: nil),
                dataProvider: dataProvider
        )
        )

        let mealItem = UITabBarItem()
        mealItem.title = "Meal"
        mealItem.image = UIImage(systemName: "heart.text.square")
        MealC.tabBarItem = mealItem

        self.viewControllers = [
            TrendC,
            SearchC,
            MealC
        ]
    }
}
