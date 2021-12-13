import Foundation

enum RequestType {
    case detailsById(id: Int)
    case randomMeals
    case ingrediendsList
    case mealsByIngredient(ingredient: String)
}

extension RequestType {
    
    private var params: [String: String] {
      switch self {
      case let .detailsById(id):
          return ["i": "\(id)"]
      case .randomMeals:
          return [:]
      case .ingrediendsList:
          return ["i": "list"]
      case let .mealsByIngredient(ingredient: ingredient):
          return ["i": ingredient]
      }
    }
    
    var url: URL? {
        return makeUrl(params: params)
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
        }
    }
    
    private func makeUrl(params: [String: String]) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = NetworkKeys.host
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
    static let host: String = "www.themealdb.com"
    static let apiKey: Int = 9973533
}
