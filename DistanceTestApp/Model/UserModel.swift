//
//  UserModel.swift
//  DistanceTestApp
//
//  Created by Алексей Авер on 02.04.2023.
//

import Foundation
import CoreLocation

class User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
    var id: UUID
    var name: String
    var location: CLLocation
    var distance: Double
    var avatar: String
    
    init(id: UUID, name: String, location: CLLocation, distance: Int, avatar: String) {
        self.id = id
        self.name = name
        self.location = location
        self.distance = 0
        self.avatar = avatar
    }
    
}
