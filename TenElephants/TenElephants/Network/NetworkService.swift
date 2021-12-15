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

    func getMealDetails(id: String, completion: @escaping mealsCompletion) {
        let getMealByIdOp = FetchingDataOperation(
            type: .detailsById(id: id),
            delayCounter: delayCounter,
            completion: completion
        )
        opQueue.fetchingQueue.addOperation(getMealByIdOp)
    }

    func getRandomMeals(completion: @escaping mealsCompletion) {
        let getRandomMealsOp = FetchingDataOperation(
            type: .randomMeals,
            delayCounter: delayCounter,
            completion: completion
        )
        opQueue.fetchingQueue.addOperation(getRandomMealsOp)
    }

    func getFullIngredientsList(completion: @escaping (Result<
        FullIngredients,
        NetworkFetchingError
    >) -> Void) {
        let getFullIngredientsOp = FetchingDataOperation(
            type: .ingrediendsList,
            delayCounter: delayCounter,
            completion: completion
        )
        opQueue.fetchingQueue.addOperation(getFullIngredientsOp)
    }

    func getFilteredMealList(ingredient: String, completion: @escaping mealsCompletion) {
        let getFilteredMealList = FetchingDataOperation(
            type: .mealsByIngredient(ingredient: ingredient),
            delayCounter: delayCounter,
            completion: completion
        )
        opQueue.fetchingQueue.addOperation(getFilteredMealList)
    }

    func getFilteredMealList(ingredients: [String], completion: @escaping mealsCompletion) {
        let getFilteredMealList = FetchingDataOperation(
            type: .mealsByMultipleIngredients(ingredients: ingredients),
            delayCounter: delayCounter,
            completion: completion
        )
        opQueue.fetchingQueue.addOperation(getFilteredMealList)
    }

    func searchMealByName(name: String, completion: @escaping mealsCompletion) {
        let getSearchMealByNameOp = FetchingDataOperation(
            type: .mealsByName(name: name),
            delayCounter: delayCounter,
            completion: completion
        )
        opQueue.fetchingQueue.addOperation(getSearchMealByNameOp)
    }

    func getLatestMeals(completion: @escaping mealsCompletion) {
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
        queue.maxConcurrentOperationCount = 1
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
        completion: @escaping ((Result<T, NetworkFetchingError>) -> Void)
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
        print("Starting")
        isFinished = false
        isExecuting = true
        main()
    }

    override func main() {
        guard let url = type.url else {
            completion(.failure(NetworkFetchingError.unableToMakeURL))
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in

            if let error = error {
                self?.completion(.failure(.serverError(error: error)))

                guard let self = self else {
                    return
                }

                let newDelay: Double = self.delayCounter.countDelay()

                print("Retry after \(newDelay)")

                sleep(UInt32(newDelay))
                self.main()
                return
            }

            self?.delayCounter.resetDelay()

            do {
                guard let data = data else {
                    self?.completion(.failure(NetworkFetchingError.noResponseData))
                    return
                }

                let result = try JSONDecoder().decode(T.self, from: data)
                self?.completion(.success(result))
            } catch {
                self?.completion(.failure(.parsingError))
            }
        }.resume()
    }

    func finish() {
        isExecuting = false
        isFinished = true
    }
}
