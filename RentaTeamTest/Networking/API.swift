//
//  API.swift
//  RentaTeamTest
//
//  Created by Nikita Pavlov on 18.09.2020.
//  Copyright © 2020 Nikita Pavlov. All rights reserved.
//

import Foundation

class API {

    static var apiParameterPageNumber = 1

    static func apiPageUpdate(){
        print("FETCH, \(apiParameterPageNumber)")
        apiParameterPageNumber += 1
        API.parameters.updateValue("\(apiParameterPageNumber)", forKey: "page")
    }
    
    static let url = URL(string: "https://api.flickr.com/services/rest/") 
    
    static var parameters = [
        "method" : "flickr.interestingness.getList",
        "api_key" : "d7aba6ee0c29d736cb10e53a7603d4e7",
        "sort" : "relevance",
        "per_page" : "50",
        "page" : "1",
        "format" : "json",
        "nojsoncallback" : "1",
        "extras" : "url_q,url_z"
    ]
}
