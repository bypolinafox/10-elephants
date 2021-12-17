//
//  ErrorUtils.swift
//  Ten Elephants
//
//  Created by Полина Скалкина on 11.12.2021.
//

import Foundation

final class NetworkService: NetworkServiceProtocol {
    private lazy var delayCounter = ExponentialBackoffDelayCalculator()

    func getMealDetails(id: String, completion: @escaping MealsCompletion) {
        request(type: .detailsById(id: id)) { [weak self] (result: Result<
            Meals,
            NetworkFetchingError
        >) in
            completion(result)
            guard let self = self else { return }
            if case .failure = result {
                let newDelay = self.delayCounter.countDelay()
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

    func getRandomMeals(completion: @escaping MealsCompletion) {
        request(type: .randomMeals) { [weak self] (result: Result<Meals, NetworkFetchingError>) in
            completion(result)
            guard let self = self else { return }
            if case .failure = result {
                let newDelay = self.delayCounter.countDelay()
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

    func getRandomCocktails(completion: @escaping CocktailCompletion) {
        request(type: .randomCocktails) { [weak self] (result: Result<Drinks, NetworkFetchingError>) in
            completion(result)
            guard let self = self else { return }
            if case .failure = result {
                let newDelay = self.delayCounter.countDelay()
                DispatchQueue.main.asyncAfter(
                    deadline: .now() + newDelay, execute: { [weak self] in
                        self?.getRandomCocktails(completion: completion)
                    }
                )
            } else {
                self.delayCounter.resetDelay()
            }
        }
    }

    func getFullIngredientsList(completion: @escaping (Result<
        FullIngredients,
        NetworkFetchingError
    >) -> Void) {
        request(type: .ingrediendsList, completion: completion)
    }

    func getFilteredMealList(ingredient: String, completion: @escaping MealsCompletion) {
        request(type: .mealsByIngredient(
            ingredient: ingredient
        )) { [weak self] (result: Result<Meals, NetworkFetchingError>) in
            completion(result)
            guard let self = self else { return }
            if case .failure = result {
                let newDelay = self.delayCounter.countDelay()
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

    func getMealListFiltered(by ingridients: [String], completion: @escaping MealsCompletion) {
        request(type: .mealsByMultipleIngredients(
            ingredients: ingridients
        )) { [weak self] (result: Result<Meals, NetworkFetchingError>) in
            guard let self = self else { return }
            switch result {
            case let .success(items):
                let group = DispatchGroup()
                let queue = DispatchQueue(label: "writeToResult")
                var result = [Meal]()

                for meal in items.meals {
                    group.enter()
                    self.getMealDetails(id: meal.id) { res in
                        defer {
                            group.leave()
                        }
                        switch res {
                        case let .success(items):
                            guard !items.meals.isEmpty else { return }
                            let loadedMeal = items.meals[0]
                            queue.sync {
                                result.append(loadedMeal)
                            }
                        case .failure:
                            return
                        }
                    }
                }
                group.notify(queue: queue, execute: {
                    completion(.success(Meals(meals: result)))
                })
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func searchMealByName(name: String, completion: @escaping MealsCompletion) {
        request(
            type: .mealsByName(name: name),
            completion: completion
        )
    }

    func getLatestMeals(completion: @escaping MealsCompletion) {
        request(
            type: .latestMeals,
            completion: completion
        )
    }
}

extension NetworkService {
    private func request<T: Decodable>(
        type: RequestType,
        completion: @escaping (Result<T, NetworkFetchingError>) -> Void
    ) {
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
