//
//  DataRealm.swift
//  RentaTeamTest
//
//  Created by Nikita Pavlov on 01.10.2020.
//  Copyright © 2020 Nikita Pavlov. All rights reserved.
//

import Foundation
import RealmSwift

class FlickrAPIPage: Object {
    let flickrPhotos = List<FlickrPhotoRealm>()
    @objc dynamic var page: Int = 0
    var photosID = List<String>()

    override static func primaryKey() -> String? {
        return "page"
    }
}

class FlickrPhotoRealm: Object {
    @objc dynamic var urlZ: String? = ""
    @objc dynamic var urlQ: String? = ""
    @objc dynamic var title: String = ""
    @objc dynamic var loadedDate: String = ""
    
    @objc dynamic var photoID: String = ""

    override static func primaryKey() -> String? {
      return "photoID"
    }
}

