//
//  ImageLoadingManager.swift
//  KKBOXSongList
//
//  Created by Yi-Chin on 2020/10/16.
//

import UIKit

class ImageLoadingManager {
    static let shared = ImageLoadingManager()
    private var loadedImages = [URL: UIImage]()
    
    func loadImage(with url: URL, _ completion: @escaping (Result<UIImage, Error>) -> Void) {
        
        if let image = loadedImages[url] {
            completion(.success(image))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                self.loadedImages[url] = image
                completion(.success(image))
                return
            }
            
            guard let error = error else { return }
            
            guard (error as NSError).code == NSURLErrorCancelled else {
                completion(.failure(error))
                return
            }
        }
        task.resume()
    }
}

extension UIImageView {
    func loadImage(with url: URL) {
        return ImageLoadingManager.shared.loadImage(with: url) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.image = image
                }
            case .failure(let error) :
                print("Image Loading Error:", error)
            }
        }
    }
}
