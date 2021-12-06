//
//  ImgurAPI.swift
//  Wallpaper App UIKit
//
//  Created by iakalann on 06/12/2021.
//

import UIKit

struct ImgurAPI {
    
    func downloadData(forHash hash: String,
                      _ completion: @escaping (Result<ImgurAlbumData, Error>) -> Void) {
        
        let url = URL(string: "https://api.imgur.com/3/album/\(hash)/images")!
        var request = URLRequest(url: url)
        
        request.setValue("Client-ID 14b6a26bfece2a8", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data,
                      let albumData = try? JSONDecoder().decode(ImgurAlbumData.self, from: data) {
                completion(.success(albumData))
            }
        }
        
        task.resume()
    }
    
    func downloadImage(from link: String,
                       _ completion: @escaping (Result<UIImage, Error>) -> ()) {
        
        guard let url = URL(string: link) else {
            completion(.failure(""))
            return
        }
        
        URLSession.shared.dataTask(with: url) { imageData, imageResponse, imageError in
            if let data = imageData,
               let image = UIImage(data: data) {
                completion(.success(image))
            } else if let error = imageError {
                completion(.failure(error))
            } else {
                completion(.failure(""))
            }
        }.resume()
    }
    
}

extension String: Error { }
