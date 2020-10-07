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

    private let realm: Realm
    private let backgroundQueue: DispatchQueue

    init(realm: Realm, backgroundQueue: DispatchQueue) {
        self.realm = realm
        self.backgroundQueue = backgroundQueue
    }

    
}
