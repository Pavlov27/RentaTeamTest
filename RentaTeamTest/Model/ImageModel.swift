//
//  ImageModel.swift
//  RentaTeamTest
//
//  Created by Nikita Pavlov on 20.09.2020.
//  Copyright © 2020 Nikita Pavlov. All rights reserved.
//

import Foundation
import SwiftyJSON

struct FlickrImage {
    var bigImageURL: String
    var smallImageURL: String
    var title: String
    var downloadingDate: String

    init?(json: JSON) {
        guard let urlQ = json["url_q"].string,
            let urlZ = json["url_z"].string,
            let title = json["title"].string else { return nil }
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: date)
        
        self.bigImageURL = urlZ
        self.smallImageURL = urlQ
        self.title = title
        self.downloadingDate = dateString
    }
}
