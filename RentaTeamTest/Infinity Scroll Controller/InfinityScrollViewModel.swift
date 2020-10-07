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
    
    //var apiParameterPageNumber = 1

    let networking = NetworkManager()
    
    var weConnected = false

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
            networking.fetchRealm{ (flickrData) in

            //            let flickrImages = flickrData?.photos?.photo
                        //let flickrImages = flickrData
                            completion(flickrData)
                        }
    }
}
}
