//
//  MealsDataProvider.swift
//  Ten Elephants
//
//  Created by Дарья Домрачева on 10.12.2021.
//

import Foundation

enum MealsDataProviderErrors: Error {
    case unableToMakeURL
    case noResponseData
    case unparsableData
    case serverError(error: Error)
}

protocol MealsDataProvider {
    typealias MealsFetchCompletion = (Result<Meals, MealsDataProviderErrors>) -> Void
    typealias CocktailFetchCompletion = (Result<Drinks, MealsDataProviderErrors>) -> Void

    func fetchRandomPreviewMeals(completionHandler: @escaping MealsFetchCompletion)
    func fetchMealDetails(by id: String, completionHandler: @escaping MealsFetchCompletion)
    func fetchMealListFiltered(
        by ingredient: String,
        completionHandler: @escaping MealsFetchCompletion
    )
    func fetchMealListFiltered(
        by ingredients: [String],
        completionHandler: @escaping MealsFetchCompletion
    )
    func fetchLatestMeals(completionHandler: @escaping MealsFetchCompletion)
    func searchMealByName(name: String, completionHandler: @escaping MealsFetchCompletion)
    func fetchRandomCocktail(completionHandler: @escaping CocktailFetchCompletion)
}
