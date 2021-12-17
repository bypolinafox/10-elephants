//
//  ErrorUtils.swift
//  Ten Elephants
//
//  Created by Полина Скалкина on 11.12.2021.
//

import Foundation

protocol NetworkServiceProtocol {
    typealias MealsCompletion = (Result<Meals, NetworkFetchingError>) -> Void
    typealias CocktailCompletion = (Result<Drinks, NetworkFetchingError>) -> Void

    func getMealDetails(id: String, completion: @escaping MealsCompletion)

    func getRandomMeals(completion: @escaping MealsCompletion)

    func getFullIngredientsList(completion: @escaping (Result<
        FullIngredients,
        NetworkFetchingError
    >) -> Void)

    func getFilteredMealList(ingredient: String, completion: @escaping MealsCompletion)

    func getMealListFiltered(by ingredients: [String], completion: @escaping MealsCompletion)

    func searchMealByName(name: String, completion: @escaping MealsCompletion)

    func getLatestMeals(completion: @escaping MealsCompletion)

    func getRandomCocktails(completion: @escaping CocktailCompletion)
}

enum NetworkFetchingError: Error {
    case unableToMakeURL
    case noResponseData
    case parsingError
    case serverError(error: Error)
}
