//
//  InfinityScrollViewModel.swift
//  RentaTeamTest
//
//  Created by Nikita Pavlov on 18.09.2020.
//  Copyright © 2020 Nikita Pavlov. All rights reserved.
//

import UIKit
import Network
import RealmSwift
//import SwiftyJSON

class InfinityScrollViewModel {
    
    var apiParameterPageNumber = 1

    let networking = NetworkManager()
    
    var weConnected = true

    func getRandomImages(completion: @escaping (_ images: [FlickrPhotoRealm]?) -> ()) {
        
        let monitor = NWPathMonitor()
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("We're connected!")
                self.weConnected = true
            } else {
                print("No connection.")
                self.weConnected = false
            }

            
            print(path.isExpensive)
        }
        
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)

        if weConnected {
            networking.fetchFlickrPhotos { (flickrData) in

//            let flickrImages = flickrData?.photos?.photo
            //let flickrImages = flickrData
                completion(flickrData)
            }
        } else {
            let realm = try! Realm()
            
            func checkPageExist(page: Int) -> Bool {
                return realm.object(ofType: FlickrAPIPage.self, forPrimaryKey: page) != nil
            }
            
            if checkPageExist(page: self.apiParameterPageNumber - 1) {

                if let oldData = realm.object(ofType: FlickrAPIPage.self, forPrimaryKey: self.apiParameterPageNumber - 1) {
                    
                    let array = Array(oldData.flickrPhotos)
                    completion(array)
                }
        }
    }
}
}
