//
//  StorageManager.swift
//  RentaTeamTest
//
//  Created by Nikita Pavlov on 01.10.2020.
//  Copyright © 2020 Nikita Pavlov. All rights reserved.
//

import Foundation
import RealmSwift

class StorageManager {

    func checkPageExist(page: Int) -> Bool {
        
        do {
          let realm = try Realm()
            return realm.object(ofType: FlickrAPIPage.self, forPrimaryKey: page) != nil
        } catch let error as NSError {
            print(error.localizedDescription)
            return false
        }
    }
    
    func saveJSONtoRealmAndReturnRealmObjects(_ apiParameterPageNumber: Int, _ json: FlickrData,
                         compeletion: @escaping (_ data: [FlickrPhotoRealm]?) -> ()){
        do {
            let realm = try Realm()
            let dataRealm = FlickrAPIPage()
            dataRealm.page = apiParameterPageNumber - 1
            
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

            if checkPageExist(page: dataRealm.page) {
                guard let oldData = realm.object(ofType: FlickrAPIPage.self, forPrimaryKey: dataRealm.page) else { return }
                
                do {
                    try realm.write {
                    realm.delete(oldData.flickrPhotos)
                    realm.add(dataRealm, update: .modified)
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                    compeletion(nil)
                    return
                }
            } else {
                
                do {
                    try realm.write {
                        realm.add(dataRealm)
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                    compeletion(nil)
                    return
                }
            }
            
            //print(Realm.Configuration.defaultConfiguration.fileURL!)

            let array = Array(dataRealm.flickrPhotos)
            compeletion(array)
        } catch let error as NSError {
            print(error.localizedDescription)
            compeletion(nil)
            return
        }
    }

    func fetchRealm(apiParameterPageNumber: Int,
                    compeletion: @escaping (_ data: [FlickrPhotoRealm]?) -> ()) {
        do {
            let realm = try Realm()
            if checkPageExist(page: apiParameterPageNumber) {
                if let oldData = realm.object(ofType: FlickrAPIPage.self, forPrimaryKey: apiParameterPageNumber) {
                    
                    let array = Array(oldData.flickrPhotos)
                    compeletion(array)
                }
            } else {
                print("No object for index \(apiParameterPageNumber)")
                compeletion(nil)
                return
            }
        } catch let error as NSError {
            print(error.localizedDescription)
            compeletion(nil)
            return
        }
    }
}
