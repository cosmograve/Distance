//
//  UserManager.swift
//  DistanceTestApp
//
//  Created by Алексей Авер on 02.04.2023.
//

import Foundation
import CoreLocation


class UserManager {
    
    static var shared = UserManager()
    var users: [User] = []
    
    weak var delegate: UserManagerDelegate?
    
    let names = ["Алексей", "Анастасия", "Александр", "Александра", "Софья", "Андрей", "Максим", "Светлана", "Виктор", "Евгений", "Татьяна", "Михаил", "Виталий"]
    let avatars = ["1","2","3","4","5","6","7","8","9","10","11","12","13"]
    
    func getRandomLocation() -> CLLocation {
        let latitude = Double.random(in: 54...56)
        let longitude = Double.random(in: 82...84)
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func setUsers() {
        LocationManager.shared.getUserLocation { location in
            let selfUser = User(id: UUID(),
                                name: "Я",
                                location: location,
                                distance: 0,
                                avatar: "9")
            self.users.append(selfUser)
        }
        for _ in 1...20 {
            let name = names.randomElement() ?? ""
            let location = getRandomLocation()
            let avatar = avatars.randomElement() ?? ""
            let user = User(id: UUID(),
                            name: name,
                            location: location,
                            distance: 0,
                            avatar: avatar)
            users.append(user)
        }
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            self.updateLocations()
        }
    }
    
    func updateLocations() {
        for user in 0..<users.count - 1 {
            let latitudeOffset = Double.random(in: -0.005...0.005)
            let longitudeOffset = Double.random(in: -0.005...0.005)
            let location = users[user].location
            let updatedLocation = CLLocation(latitude: location.coordinate.latitude + latitudeOffset, longitude: location.coordinate.longitude + longitudeOffset)
            users[user] = User(id: users[user].id, name: users[user].name, location: updatedLocation, distance: 0, avatar: users[user].avatar)
            self.delegate?.didUpdateLocation(user: users[user])

        }
    }

    
}
