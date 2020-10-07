//
//  ImageModel.swift
//  RentaTeamTest
//
//  Created by Nikita Pavlov on 20.09.2020.
//  Copyright © 2020 Nikita Pavlov. All rights reserved.
//

import Foundation

struct FlickrData: Codable {
    var photos: Photos?
    var stat: String?
}

struct Photos: Codable {
    var page, pages, total, perpage: Int?
    var photo: [Photo]?
}

struct Photo: Codable {
    //var widthZ: Int?
    var urlZ: String?
    //var secret: String?
    //var isfamily: Int?
    //var owner: String?
    var urlQ: String?
    //var ispublic: Int?
    //var server: String?
    //var heightZ, farm, isfriend: Int?
    var title: String
    //var heightQ, widthQ: Int?
    //var id: String?
    var loadedDate: String

    init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        urlZ = try values.decodeIfPresent(String.self, forKey: .urlZ)
        urlQ = try values.decodeIfPresent(String.self, forKey: .urlQ)
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? "untitled"
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: date)
        loadedDate = dateString
    }

    enum CodingKeys: String, CodingKey {
        //case widthZ = "width_z"
        case urlZ = "url_z"
        //case secret, isfamily, owner
        case urlQ = "url_q"
        //case ispublic, server
        //case heightZ = "height_z"
        //case farm, isfriend,
        case title
        //case heightQ = "height_q"
        //case widthQ = "width_q"
        //case id
    }
}
