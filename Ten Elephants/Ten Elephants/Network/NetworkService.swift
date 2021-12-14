//
//  ErrorUtils.swift
//  Ten Elephants
//
//  Created by Полина Скалкина on 11.12.2021.
//

import Foundation

final class NetworkService: NetworkServiceProtocol {
    private lazy var delayCounter = ExponentialBackoffDelayCalculator()
    
    func getMealDetails(id: Int, completion: @escaping mealsCompletion) {
        request(type: .detailsById(id: id)) { [weak self] (result: Result<Meals, NetworkFetchingError>) in
            completion(result)
            guard let self = self else { return }
            if case .failure = result {
                let newDelay = self.delayCounter.countDelay()
                print("Retry after \(newDelay)")
                DispatchQueue.main.asyncAfter(
                    deadline: .now() + newDelay, execute: { [weak self] in
                        self?.getMealDetails(id: id, completion: completion)
                    }
                )
            } else {
                self.delayCounter.resetDelay()
            }
        }
    }
    
    func getRandomMeals(completion: @escaping mealsCompletion) {
        request(type: .randomMeals) { [weak self] (result: Result<Meals, NetworkFetchingError>) in
            completion(result)
            guard let self = self else { return }
            if case .failure = result {
                let newDelay = self.delayCounter.countDelay()
                print("Retry after \(newDelay)")
                DispatchQueue.main.asyncAfter(
                    deadline: .now() + newDelay, execute: { [weak self] in
                        self?.getRandomMeals(completion: completion)
                    }
                )
            } else {
                self.delayCounter.resetDelay()
            }
        }
    }

    func getFullIngredientsList(completion: @escaping (Result<FullIngredients, NetworkFetchingError>) -> Void) {
        request(type: .ingrediendsList, completion: completion)
    }
    
    func getFilteredMealList(ingredient: String, completion: @escaping mealsCompletion) {
        request(type: .mealsByIngredient(ingredient: ingredient)) { [weak self] (result: Result<Meals, NetworkFetchingError>) in
            completion(result)
            guard let self = self else { return }
            if case .failure = result {
                let newDelay = self.delayCounter.countDelay()
                print("Retry after \(newDelay)")
                DispatchQueue.main.asyncAfter(
                    deadline: .now() + newDelay, execute: { [weak self] in
                        self?.getFilteredMealList(ingredient: ingredient, completion: completion)
                    }
                )
            } else {
                self.delayCounter.resetDelay()
            }
        }
    }
    
}

extension NetworkService {
    
    private func request<T: Decodable>(type: RequestType, completion: @escaping (Result<T, NetworkFetchingError>) -> Void) {
        guard let url = type.url else {
            completion(.failure(NetworkFetchingError.unableToMakeURL))
            return
        }
        
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
