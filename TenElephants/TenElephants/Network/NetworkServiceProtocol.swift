//
//  ErrorUtils.swift
//  Ten Elephants
//
//  Created by Полина Скалкина on 11.12.2021.
//

import Foundation

protocol NetworkServiceProtocol {
    typealias mealsCompletion = (Result<Meals, NetworkFetchingError>) -> Void

    func getMealDetails(id: String, completion: @escaping mealsCompletion)

    func getRandomMeals(completion: @escaping mealsCompletion)

    func getFullIngredientsList(completion: @escaping (Result<
        FullIngredients,
        NetworkFetchingError
    >) -> Void)

    func getFilteredMealList(ingredient: String, completion: @escaping mealsCompletion)

    func getMealListFiltered(by ingridients: [String], completion: @escaping mealsCompletion)

    func searchMealByName(name: String, completion: @escaping mealsCompletion)

    func getLatestMeals(completion: @escaping mealsCompletion)
}

enum NetworkFetchingError: Error {
    case unableToMakeURL
    case noResponseData
    case parsingError
    case serverError(error: Error)
}
