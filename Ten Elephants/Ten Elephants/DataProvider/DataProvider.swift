//
//  DataProvider.swift
//  Ten Elephants
//
//  Created by Дарья Домрачева on 10.12.2021.
//

import Foundation


protocol DataProvider {
    func fetchMealsDataRandom(completionHandler: @escaping (Meals?) -> Void)
    func fetchMealPreviewDataRandom(completionHandler: @escaping (Meals?) -> Void)
}
