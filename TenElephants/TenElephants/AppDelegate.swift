//
//  AppDelegate.swift
//  Ten Elephants
//
//  Created by Kirill Denisov on 08.12.2021.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    let service = NetworkService()

    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        true
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options _: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
    }

    func application(_: UIApplication, didDiscardSceneSessions _: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

let data = """
{
    "meals": [
        {
            "idMeal": "52772",
            "strMeal": "Teriyaki Chicken Casserole",
            "strDrinkAlternate": null,
            "strCategory": "Chicken",
            "strArea": "Japanese",
            "strInstructions": "non-stick spray.\r\nCombine",
            "strMealThumb": "https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg",
            "strTags": "Meat,Casserole",
            "strYoutube": "https://www.youtube.com/watch?v=4aZr5hZXP_s",
            "strIngredient1": "soy sauce",
            "strIngredient2": "water",
            "strIngredient3": "brown sugar",
            "strIngredient4": "ground ginger",
            "strIngredient5": "minced garlic",
            "strIngredient6": "cornstarch",
            "strIngredient7": "chicken breasts",
            "strIngredient8": "stir-fry vegetables",
            "strIngredient9": "brown rice",
            "strIngredient10": "",
            "strIngredient11": "",
            "strIngredient12": "",
            "strIngredient13": "",
            "strIngredient14": "",
            "strIngredient15": "",
            "strIngredient16": null,
            "strIngredient17": null,
            "strIngredient18": null,
            "strIngredient19": null,
            "strIngredient20": null,
            "strMeasure1": "3/4 cup",
            "strMeasure2": "1/2 cup",
            "strMeasure3": "1/4 cup",
            "strMeasure4": "1/2 teaspoon",
            "strMeasure5": "1/2 teaspoon",
            "strMeasure6": "4 Tablespoons",
            "strMeasure7": "2",
            "strMeasure8": "1 (12 oz.)",
            "strMeasure9": "3 cups",
            "strMeasure10": "",
            "strMeasure11": "",
            "strMeasure12": "",
            "strMeasure13": "",
            "strMeasure14": "",
            "strMeasure15": "",
            "strMeasure16": null,
            "strMeasure17": null,
            "strMeasure18": null,
            "strMeasure19": null,
            "strMeasure20": null,
            "strSource": null,
            "strImageSource": null,
            "strCreativeCommonsConfirmed": null,
            "dateModified": null
        }
    ]
}
""".data(using: .utf8)!
