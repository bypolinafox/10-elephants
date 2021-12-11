//
//  MealsDataProvider.swift
//  Ten Elephants
//
//  Created by Дарья Домрачева on 10.12.2021.
//

import Foundation

enum MealsDataProviderErrors: Error {
    case unparsableData
}

protocol MealsDataProvider {
    typealias MealsFetchCompletion = (Result<Meals, MealsDataProviderErrors>) -> Void

    func fetchRandomMeals(completionHandler: @escaping MealsFetchCompletion)
    func fetchRandomPreviewMeals(completionHandler: @escaping MealsFetchCompletion)
}
