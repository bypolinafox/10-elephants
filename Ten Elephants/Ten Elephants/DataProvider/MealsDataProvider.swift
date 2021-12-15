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

    func fetchRandomPreviewMeals(completionHandler: @escaping MealsFetchCompletion)
}
