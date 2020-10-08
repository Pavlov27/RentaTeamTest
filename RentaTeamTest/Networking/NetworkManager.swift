//
//  NetworkManager.swift
//  RentaTeamTest
//
//  Created by Nikita Pavlov on 18.09.2020.
//  Copyright © 2020 Nikita Pavlov. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

class NetworkManager {

    private let storage = StorageManager()

    func fetchFlickrPhotos ( compeletion: @escaping (_ data: [FlickrPhotoRealm]?) -> ()) {
        
        AF.request(API.url!, method: .get, parameters: API.parameters).validate().responseData { [weak self] (response) in
            switch response.result {

                case .success:

                    guard let data = response.data, let json = try? JSONDecoder().decode(FlickrData.self, from: data)
                    else {
                        print("Error while parsing Flickr data")
                        return
                    }

                    self?.storage.saveJSONtoRealmAndReturnRealmObjects(API.apiParameterPageNumber,
                                                                       json) { (flickrPhotos) in
                        compeletion(flickrPhotos)
                    }
                
                case .failure(let error):
                    print("Error while fetching from Flickr: \(error.localizedDescription)")
            }
        }
        API.apiPageUpdate()
    }
    
    func fetchRealm(compeletion: @escaping (_ data: [FlickrPhotoRealm]?) -> ()) {

        storage.fetchRealm(apiParameterPageNumber: API.apiParameterPageNumber) { (flickrPhoto) in
                compeletion(flickrPhoto)
            }
        API.apiPageUpdate()
    }
}
