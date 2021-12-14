//
//  ErrorUtils.swift
//  Ten Elephants
//
//  Created by Полина Скалкина on 11.12.2021.
//

import Foundation

final class NetworkService: NetworkServiceProtocol {
    
    func getMealDetails(id: Int, completion: @escaping mealsCompletion) {
        request(type: .detailsById(id: id), completion: completion)
    }
    
    func getRandomMeals(completion: @escaping mealsCompletion) {
        request(type: .randomMeals, completion: completion)
    }

    func getFullIngredientsList(completion: @escaping (Result<FullIngredients, NetworkFetchingError>) -> Void) {
        request(type: .ingrediendsList, completion: completion)
    }
    
    func getFilteredMealList(ingredient: String, completion: @escaping mealsCompletion) {
        request(
            type: .mealsByIngredient(ingredient: ingredient),
            completion: completion
        )
    }
    
}

extension NetworkService {
    private func request<T: Decodable>(type: RequestType, completion: @escaping (Result<T, NetworkFetchingError>) -> Void) {
        guard let url = type.url else {
            completion(.failure(NetworkFetchingError.unableToMakeURL))
            return
        }
        print(url)
        URLSession.shared.dataTask(with: url) {
            data, _, error in
            if let error = error {
                completion(.failure(.serverError(error: error)))
                return
            }
            
            do {
                guard let data = data else {
                    completion(.failure(NetworkFetchingError.noResponseData))
                    return
                }
                
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.parsingError))
            }
        }.resume()
    }
}

