//
//  ErrorUtils.swift
//  Ten Elephants
//
//  Created by Полина Скалкина on 11.12.2021.
//

import Foundation

protocol NetworkServiceProtocol {
    
    typealias mealsCompletion = (Result<Meals, NetworkFetchingError>) -> Void
    
    func getMealDetails(id: Int, completion: @escaping mealsCompletion)
    
    func getRandomMeals(completion: @escaping mealsCompletion)
    
//   TODO: Uncomment when fix Ingredients
//   func getFullIngredientsList(completion: @escaping (Result<[Ingredient], NetworkFetchingError>) -> Void)
    
    func getFilteredMealList(ingredient: String, completion: @escaping mealsCompletion)
    
}

enum NetworkFetchingError: Error {
    case unableToMakeURL
    case noResponseData
    case parsingError
    case serverError(error: Error)
}
