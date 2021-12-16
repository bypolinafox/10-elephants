//
//  IngredientsDataProvider.swift
//  TenElephants
//
//  Created by Полина Скалкина on 17.12.2021.
//

import Foundation

protocol IngredientsDataProvider {
    func fetchIngredientsList(completionHandler: @escaping (Result<
        IngredientsUIData,
        NetworkFetchingError
    >) -> Void)
}
