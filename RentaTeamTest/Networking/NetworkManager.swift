//
//  NetworkManager.swift
//  RentaTeamTest
//
//  Created by Nikita Pavlov on 18.09.2020.
//  Copyright © 2020 Nikita Pavlov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkManager {

    var apiParameterPageNumber = 1
    var imageCache = NSCache<NSString, UIImage>()

    func fetchFlickrPhotos (compeletion: @escaping (_ data: JSON?) -> ()) {
        
        AF.request(API.url!, method: .get, parameters: API.parameters).validate().responseData { (response) in
            switch response.result {
                case .success:
                    guard let data = response.data, let json = try? JSON(data: data) else {
                        print("Error while parsing Flickr data")
                        compeletion(nil)
                        return
                    }
                compeletion(json)
                
                case .failure(let error):
                    print("Error while fetching from Flickr: \(error.localizedDescription)")
            }
        }
        print("FETCH, \(apiParameterPageNumber)")
        apiParameterPageNumber += 1
        API.parameters.updateValue("\(apiParameterPageNumber)", forKey: "page")
    }

    func loadImage(url: String, compeletion: @escaping (_ image: UIImage?) -> ()) {

        if let cachedImage = imageCache.object(forKey: url as NSString) {
            DispatchQueue.main.async {
                compeletion(cachedImage)
            }
        } else {
            guard let url = URL(string: url) else { return }

            let session = URLSession.shared
            session.dataTask(with: url) { (data, response, error) in
                if let data = data, let image = UIImage(data: data) {
                    self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                    DispatchQueue.main.async {
                        compeletion(image)
                    }
                } else {
                    compeletion(nil)
                }
            }.resume()
        }
    }
}
