//
//  RecentsProviderProtocol.swift
//  Ten Elephants
//
//  Created by Алексей Шерстнёв on 14.12.2021.
//

import Foundation

protocol RecentsProviderProtocol {
    typealias MealsCompletion = (Result<Meals, NetworkFetchingError>) -> Void
    
    func getRecentMeals(completion: @escaping MealsCompletion)
}
