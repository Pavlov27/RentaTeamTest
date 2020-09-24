//
//  InfinityScrollViewModel.swift
//  RentaTeamTest
//
//  Created by Nikita Pavlov on 18.09.2020.
//  Copyright © 2020 Nikita Pavlov. All rights reserved.
//

import UIKit
import SwiftyJSON

class InfinityScrollViewModel {

    let networking = NetworkManager()

    func getRandomImages(completion: @escaping (_ images: [FlickrImage]?) -> ()) {
        networking.fetchFlickrPhotos { (flickrData) in

            let flickrImagesJSON = flickrData?["photos"]["photo"]
            let flickrImages = flickrImagesJSON?.arrayValue.compactMap {
                FlickrImage(json: $0)
            }
            completion(flickrImages)
        }
    }
    
    func loadImageFromURL(url: String, completion: @escaping (_ images: UIImage?) -> ()) {
        networking.loadImage(url: url) { image in
            completion(image)
        }
    }
}
