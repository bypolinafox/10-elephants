//
//  ErrorUtils.swift
//  Ten Elephants
//
//  Created by Полина Скалкина on 11.12.2021.
//

import Foundation

final class NetworkService: NetworkServiceProtocol {
    private lazy var delayCounter = ExponentialBackoffDelayCalculator()
    private lazy var opQueue = FetchingOperations()

    func getMealDetails(id: String, completion: @escaping MealsCompletion) {
        let getMealByIdOp = FetchingDataOperation(
            type: .detailsById(id: id),
            delayCounter: delayCounter,
            completion: completion
        )
        opQueue.fetchingQueue.addOperation(getMealByIdOp)
    }

    func getRandomMeals(completion: @escaping MealsCompletion) {
        let getRandomMealsOp = FetchingDataOperation(
            type: .randomMeals,
            delayCounter: delayCounter,
            completion: completion
        )
        opQueue.fetchingQueue.addOperation(getRandomMealsOp)
    }

    func getRandomCocktails(completion: @escaping CocktailCompletion) {
        let getCocktails = FetchingDataOperation(
            type: .randomCocktails,
            delayCounter: delayCounter,
            completion: completion
        )
        opQueue.fetchingQueue.addOperation(getCocktails)
    }

    func getFullIngredientsList(completion: @escaping (Result<
        FullIngredients,
        NetworkFetchingError
    >) -> Void) {
        let getFullIngredientsOp = FetchingDataOperation(
            type: .ingredientsList,
            delayCounter: delayCounter,
            completion: completion
        )
        opQueue.fetchingQueue.addOperation(getFullIngredientsOp)
    }

    func getFilteredMealList(ingredient: String, completion: @escaping MealsCompletion) {
        let getFilteredMealList = FetchingDataOperation(
            type: .mealsByIngredient(ingredient: ingredient),
            delayCounter: delayCounter,
            completion: completion
        )
        opQueue.fetchingQueue.addOperation(getFilteredMealList)
    }

    func getFilteredMealList(ingredients: [String], completion: @escaping MealsCompletion) {
        let getFilteredMealList = FetchingDataOperation(
            type: .mealsByMultipleIngredients(ingredients: ingredients),
            delayCounter: delayCounter,
            completion: completion
        )
        opQueue.fetchingQueue.addOperation(getFilteredMealList)
    }

    func searchMealByName(name: String, completion: @escaping MealsCompletion) {
        let getSearchMealByNameOp = FetchingDataOperation(
            type: .mealsByName(name: name),
            delayCounter: delayCounter,
            completion: completion
        )
        opQueue.fetchingQueue.addOperation(getSearchMealByNameOp)
    }

    func getLatestMeals(completion: @escaping MealsCompletion) {
        let getLatestMealsOp = FetchingDataOperation(
            type: .latestMeals,
            delayCounter: delayCounter,
            completion: completion
        )
        opQueue.fetchingQueue.addOperation(getLatestMealsOp)
    }
}

final class FetchingOperations {
    lazy var fetchingTasks: [IndexPath: Operation] = [:]
    lazy var fetchingQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "FetchingDataQueue"
        queue.maxConcurrentOperationCount = 4
        return queue
    }()
}

final class FetchingDataOperation<T>: Operation where T: Decodable {
    private let lockQueue = DispatchQueue(
        label: "com.swiftlee.asyncoperation",
        attributes: .concurrent
    )

    private let type: RequestType
    private let completion: (Result<T, NetworkFetchingError>) -> Void

    private let delayCounter: ExponentialBackoffDelayCalculator

    init(
        type: RequestType,
        delayCounter: ExponentialBackoffDelayCalculator,
        completion: @escaping (Result<T, NetworkFetchingError>) -> Void
    ) {
        self.type = type
        self.delayCounter = delayCounter
        self.completion = completion
    }

    override var isAsynchronous: Bool {
        true
    }

    private var _isExecuting: Bool = false
    private(set) override var isExecuting: Bool {
        get {
            lockQueue.sync { () -> Bool in
                _isExecuting
            }
        }
        set {
            willChangeValue(forKey: "isExecuting")
            lockQueue.sync(flags: [.barrier]) {
                _isExecuting = newValue
            }
            didChangeValue(forKey: "isExecuting")
        }
    }

    private var _isFinished: Bool = false
    private(set) override var isFinished: Bool {
        get {
            lockQueue.sync { () -> Bool in
                _isFinished
            }
        }
        set {
            willChangeValue(forKey: "isFinished")
            lockQueue.sync(flags: [.barrier]) {
                _isFinished = newValue
            }
            didChangeValue(forKey: "isFinished")
        }
    }

    override func start() {
        isFinished = false
        isExecuting = true
        main()
    }

    override func main() {
        guard let url = type.url else {
            completion(.failure(NetworkFetchingError.unableToMakeURL))
            finish()
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in

            if let error = error {
                self?.completion(.failure(.serverError(error: error)))

                guard let self = self else {
                    self?.finish()
                    return
                }

                let newDelay: Double = self.delayCounter.countDelay()

                sleep(UInt32(newDelay))
                self.finish()
                self.start()
                return
            }

            self?.delayCounter.resetDelay()

            do {
                guard let data = data else {
                    self?.completion(.failure(NetworkFetchingError.noResponseData))
                    self?.finish()
                    return
                }

                let result = try JSONDecoder().decode(T.self, from: data)
                self?.completion(.success(result))
                self?.finish()
            } catch {
                self?.completion(.failure(.parsingError))
                self?.finish()
            }
        }.resume()
    }

    func finish() {
        isExecuting = false
        isFinished = true
    }
}
