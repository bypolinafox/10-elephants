import Foundation

enum RequestType {
    case detailsById(id: String)
    case randomMeals
    case ingrediendsList
    case mealsByIngredient(ingredient: String)
    case mealsByMultipleIngredients(ingredients: [String])
    case mealsByName(name: String)
    case latestMeals
    case randomCocktails
}

extension RequestType {
    private var params: [String: String] {
        switch self {
        case let .detailsById(id):
            return ["i": id]
        case .randomMeals:
            return [:]
        case .ingrediendsList:
            return ["i": "list"]
        case let .mealsByIngredient(ingredient: ingredient):
            return ["i": ingredient]
        case let .mealsByMultipleIngredients(ingredients: ingredients):
            return ["i": ingredients.joined(separator: ",")]
        case let .mealsByName(name: name):
            return ["s": name]
        case .latestMeals:
            return [:]
        case .randomCocktails:
            return [:]
        }
    }

    private var drinks: Bool {
        switch self {
        case .randomCocktails:
            return true
        default:
            return false
        }
    }

    var url: URL? {
        makeUrl(params: params, drinks: drinks)
    }

    private var path: String {
        switch self {
        case .detailsById:
            return "lookup"
        case .randomMeals:
            return "randomselection"
        case .ingrediendsList:
            return "list"
        case .mealsByIngredient:
            return "filter"
        case .mealsByMultipleIngredients:
            return "filter"
        case .mealsByName:
            return "search"
        case .latestMeals:
            return "latest"
        case .randomCocktails:
             return "random"
        }
    }

    private func makeUrl(params: [String: String], drinks: Bool = false) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = drinks ? NetworkKeys.drinkhost : NetworkKeys.mealhost
        urlComponents.path = "/api/json/v2/\(NetworkKeys.apiKey)/\(path).php"

        var queryItems: [URLQueryItem] = []

        for (paramName, paramValue) in params {
            queryItems.append(URLQueryItem(name: paramName, value: paramValue))
        }

        urlComponents.queryItems = queryItems
        return urlComponents.url
    }
}

fileprivate enum NetworkKeys {
    static let drinkhost: String = "www.thecocktaildb.com"
    static let mealhost: String = "www.themealdb.com"
    static let apiKey: Int = 9_973_533
}
