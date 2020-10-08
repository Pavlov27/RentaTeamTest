//
//  InfinityScrollViewModel.swift
//  RentaTeamTest
//
//  Created by Nikita Pavlov on 18.09.2020.
//  Copyright © 2020 Nikita Pavlov. All rights reserved.
//

import UIKit
import Network
import Alamofire

class InfinityScrollViewModel {

    private let networking = NetworkManager()
    private var weConnected = true //Получить начальный статус?

    func getRandomImages(completion: @escaping (_ images: [FlickrPhotoRealm]?) -> ()) {
        
        connectionStatus()

        if weConnected {
            networking.fetchFlickrPhotos() { (flickrData) in
                completion(flickrData)
            }
        } else { //если вызываю StorageManager отсюда - крэш
            networking.fetchRealm(){ (flickrData) in
                completion(flickrData)
            }
        }
    }
}

extension InfinityScrollViewModel {

    private func connectionStatus(){
        if #available(iOS 12.0, *) {
            let monitor = NWPathMonitor()

        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                //print("We're connected!")
                self.weConnected = true
            } else {
                //print("No connection.")
                self.weConnected = false
            }
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    }
}
