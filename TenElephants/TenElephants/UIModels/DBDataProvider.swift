//
// Created by Kirill Denisov on 13.12.2021.
//

import Foundation

protocol DBDataProvider {
    func isLiked(_ id: String) -> Bool
    func setIsLiked(_ id: String)
}

final class UserDefaultsDataProvider: DBDataProvider {
    private enum Constants {
        static let userDefaultsKey: String = "Favourites"
    }

    private var data: [String] {
        get {
            let obj = UserDefaults.standard.object(forKey: Constants.userDefaultsKey)
            return obj as? [String] ?? [String]()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.userDefaultsKey)
        }
    }

    func isLiked(_ id: String) -> Bool {
        data.contains(where: { $0 == id })
    }

    func setIsLiked(_ id: String) {
        switch isLiked(id) {
        case true:
            if let itemToRemoveIndex = data.firstIndex(of: id) {
                data.remove(at: itemToRemoveIndex)
            }
        case false:
            data.append(id)
        }
    }
}
