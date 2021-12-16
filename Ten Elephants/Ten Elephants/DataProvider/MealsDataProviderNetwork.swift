//
//  MealsDataProviderNetwork.swift
//  Ten Elephants
//
//  Created by Дарья Домрачева on 14.12.2021.
//

import Foundation

final class MealsDataProviderNetwork: MealsDataProvider {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func fetchRandomPreviewMeals(completionHandler: @escaping MealsFetchCompletion) {
        (networkService as NetworkServiceProtocol).getRandomMeals { result in
            switch result {
            case let .success(meals):
                completionHandler(.success(meals))
            case let .failure(error):
                completionHandler(.failure(error.mealProviderError))
            }
        }
    }
}

extension NetworkFetchingError {
    var mealProviderError: MealsDataProviderErrors {
        switch self {
        case .unableToMakeURL:
            return .unableToMakeURL
        case .noResponseData:
            return .noResponseData
        case .parsingError:
            return .unparsableData
        case let .serverError(e):
            return .serverError(error: e)
        }
    }
}
