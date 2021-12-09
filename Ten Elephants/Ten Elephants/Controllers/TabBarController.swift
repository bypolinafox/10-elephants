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

        
        let MealC = MealPageController(mealData: createFakeData().meals[0])
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
