//
//  UserUpdateProtocol.swift
//  DistanceTestApp
//
//  Created by Алексей Авер on 04.04.2023.
//

import Foundation

protocol UserManagerDelegate: AnyObject {
    func didUpdateLocation(user: User)
}
