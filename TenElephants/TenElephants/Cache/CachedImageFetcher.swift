//
//  CachedImageFetcher.swift
//  Ten Elephants
//
//  Created by Kirill Denisov on 13.12.2021.
//

import Foundation
import UIKit

protocol Cancellable {
    func cancel()
}

extension URLSessionTask: Cancellable {}

final class CachedImageFetcher {
    private enum Constants {
        static let cacheCountLimit: Int = 25
    }

    init(countLimit: Int = Constants.cacheCountLimit) {
        self.cachedImages.countLimit = countLimit
    }

    private let cachedImages = NSCache<NSURL, UIImage>()
    private var loadingResponses = [NSURL: [(UIImage?) -> Swift.Void]]()

    private func image(url: NSURL) -> UIImage? {
        cachedImages.object(forKey: url)
    }

    func fetch(url: NSURL, completion: @escaping (UIImage?) -> Swift.Void) -> Cancellable? {
        if let cachedImage = image(url: url) {
            DispatchQueue.main.async {
                completion(cachedImage)
            }
            return nil
        }
        if loadingResponses[url] != nil {
            loadingResponses[url]?.append(completion)
            return nil
        } else {
            loadingResponses[url] = [completion]
        }
        let task = URLSession.shared.dataTask(with: url as URL) { [weak self] data, _, error in
            guard let responseData = data, let image = UIImage(data: responseData),
                  error == nil else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            self?.cachedImages.setObject(image, forKey: url)
            DispatchQueue.main.async {
                completion(image)
            }
        }
        task.resume()
        return task
    }
}
