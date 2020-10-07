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
//import SwiftyJSON

class NetworkManager {

    var apiParameterPageNumber = 1 // перенести в ViewModel

    func fetchFlickrPhotos (compeletion: @escaping (_ data: [FlickrPhotoRealm]?) -> ()) {
        
        AF.request(API.url!, method: .get, parameters: API.parameters).validate().responseData { (response) in
            switch response.result {
                case .success:
                    guard let data = response.data, let json = try? JSONDecoder().decode(FlickrData.self, from: data)
                    else {
                        print("Error while parsing Flickr data")
                        
                        let realm = try! Realm()
                        
                        func checkPageExist(page: Int) -> Bool {
                            return realm.object(ofType: FlickrAPIPage.self, forPrimaryKey: page) != nil
                        }
                        
                        if checkPageExist(page: self.apiParameterPageNumber - 1) {

                            if let oldData = realm.object(ofType: FlickrAPIPage.self, forPrimaryKey: self.apiParameterPageNumber - 1) {
                                
                                let array = Array(oldData.flickrPhotos)
                                compeletion(array)
                            }
                            
                            
                            
                            //compeletion(array)
                        } else {
                            print("Error while parsing Flickr data")
                            compeletion(nil)
                        }
                        
                        return
                    }
                    
//                    var config = Realm.Configuration(
//                        schemaVersion: 1,
//                        migrationBlock: { migration, oldSchemaVersion in
//                            if (oldSchemaVersion < 1) {}
//                    })
//                    config.deleteRealmIfMigrationNeeded = true
//                    Realm.Configuration.defaultConfiguration = config


                    let realm = try! Realm()
                    let dataRealm = FlickrAPIPage()
                    dataRealm.page = self.apiParameterPageNumber - 1
                    
                    if let photosFromAPI = json.photos?.photo {
                        for photo in photosFromAPI {
                            let realmPhoto = FlickrPhotoRealm()
                            realmPhoto.urlQ = photo.urlQ
                            realmPhoto.urlZ = photo.urlZ
                            realmPhoto.title = photo.title
                            realmPhoto.loadedDate = photo.loadedDate
                            
                            realmPhoto.photoID = UUID().uuidString
                            
                            dataRealm.photosID.append(realmPhoto.photoID)
                            
                            dataRealm.flickrPhotos.append(realmPhoto)
                        }
                    }
                    
                    func checkPageExist(page: Int) -> Bool {
                        return realm.object(ofType: FlickrAPIPage.self, forPrimaryKey: page) != nil
                    }

                    if checkPageExist(page: dataRealm.page) {
                        print("123 TRUE")
                        guard let oldData = realm.object(ofType: FlickrAPIPage.self, forPrimaryKey: dataRealm.page) else { return }
                        
                        try! realm.write {
                            realm.delete(oldData.flickrPhotos)
                            realm.add(dataRealm, update: .modified) //obj is of type CheckOutImageList
                            //realm.add(dataRealm.flickrPhotos, update: .modified)
                        }
                    } else {
                        print("123 FALSE")
                        try! realm.write {
                            realm.add(dataRealm)
                        }
                    }
                    
//                    try! realm.write {
//                        //guard let object = realm.object(ofType: FlickrAPIPage.self, forPrimaryKey: self.apiParameterPageNumber - 1) else { return }
//                        //realm.delete(object.flickrPhotos)
//                        for photo in dataRealm.photosID {
//                            guard let object = realm.object(ofType: FlickrAPIPage.self, forPrimaryKey: photo) else { return }
//                            realm.add(object, update: .modified)
//                        }
//
//                        realm.add(dataRealm)
//
//                        //realm.delete(object.flickrPhotos)
//                    }
                    
                    print(Realm.Configuration.defaultConfiguration.fileURL!)
                    let array = Array(dataRealm.flickrPhotos)
                compeletion(array)
                
                case .failure(let error):
                    //взять сохраненный JSON
                    print("Error while fetching from Flickr: \(error.localizedDescription)")
            }
        }
        print("FETCH, \(apiParameterPageNumber)")
        apiParameterPageNumber += 1
        API.parameters.updateValue("\(apiParameterPageNumber)", forKey: "page")
    }
    
    func fetchRealm(compeletion: @escaping (_ data: [FlickrPhotoRealm]?) -> ()) {
    let realm = try! Realm()
        //apiParameterPageNumber += 1
        
        func checkPageExist(page: Int) -> Bool {
            return realm.object(ofType: FlickrAPIPage.self, forPrimaryKey: page) != nil
        }
        
        if checkPageExist(page: self.apiParameterPageNumber) {

            if let oldData = realm.object(ofType: FlickrAPIPage.self, forPrimaryKey: self.apiParameterPageNumber) {
                
                let array = Array(oldData.flickrPhotos)
                compeletion(array)
            }
//            print("FETCH, \(apiParameterPageNumber)")
//            apiParameterPageNumber += 1
//            API.parameters.updateValue("\(apiParameterPageNumber)", forKey: "page")
        } else {
            return
        }
        print("FETCH, \(apiParameterPageNumber)")
        apiParameterPageNumber += 1
        API.parameters.updateValue("\(apiParameterPageNumber)", forKey: "page")
    }
}
