//
//  ViewController.swift
//  DistanceTestApp
//
//  Created by Алексей Авер on 02.04.2023.
//

import UIKit
import CoreLocation
class ViewController: UIViewController {

    @IBOutlet weak var selectedImage: UIImageView?
    @IBOutlet weak var selectedNameLabel: UILabel?
    @IBOutlet weak var topView: UIView?
    @IBOutlet weak var collection: UICollectionView?
    
    var selectedUser: User?
    var currentLocation: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()
        UserManager.shared.delegate = self
        initCollection()
        setTopView()
        setTopViewInfo()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        collection?.reloadData()
    }

}

private extension ViewController {
    func initCollection() {
        guard let collection = collection else {
            return
        }
        
        collection.register(UINib(nibName: PersonCollectionViewCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: PersonCollectionViewCell.reusableIdentifier)
        collection.dataSource = self
        collection.delegate = self
        collection.backgroundColor = .clear
    }
    
    func setTopView() {
        topView?.layer.cornerRadius = 8
        topView?.layer.borderColor = UIColor.darkGray.cgColor
        topView?.layer.borderWidth = 2
        
    }
    
    func setTopViewInfo(){
        guard (selectedUser != nil) else {selectedImage?.image = UIImage(systemName: "square.and.arrow.down")
            selectedNameLabel?.text = "Выберите человека"
            return
            
        }
        selectedImage?.image = UIImage(named: selectedUser?.avatar ?? "")
        selectedNameLabel?.text = selectedUser?.name
        
    }
    
    func updateDistances(selectedUser: User) {
        let selectedUserId = selectedUser.id
        
        for i in 0..<UserManager.shared.users.count {
               let user = UserManager.shared.users[i]
               let distance = calculateDistance(user1: selectedUser, user2: user)
               if user.id == selectedUserId {
                   UserManager.shared.users[i].distance = 0
               } else {
                   UserManager.shared.users[i].distance = distance
               }
           }
           collection?.reloadData()
 
    }
    
    func calculateDistance(user1: User, user2: User) -> Double {
        let distanceInMeters = user1.location.distance(from: user2.location)
        return distanceInMeters
    }

}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? PersonCollectionViewCell {
            let user = UserManager.shared.users[indexPath.item]
            
            if selectedUser == user {
                cell.backView?.backgroundColor = UIColor.blue.withAlphaComponent(0.3)
                
            } else {
                cell.backView?.backgroundColor = UIColor.white
            }
            cell.nameLabel?.text = UserManager.shared.users[indexPath.item].name
            cell.personImage?.image = UIImage(named: UserManager.shared.users[indexPath.item].avatar)
            
            guard let currentLocation = currentLocation else {
                cell.distanceLabel?.text = String(format: "%.1f км", UserManager.shared.users[indexPath.item].distance / 1000)
                return
            }
            if user.id == selectedUser?.id {
                cell.distanceLabel?.text = "Выбран"
            } else {
                let distance = user.location.distance(from: currentLocation)
                cell.distanceLabel?.text = String(format: "%.1f км", distance/1000)
                
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           
        if selectedUser == UserManager.shared.users[indexPath.item] {
            selectedUser = nil
            currentLocation = nil
        } else {
            selectedUser = UserManager.shared.users[indexPath.item]
            currentLocation = selectedUser?.location
        }
        setTopViewInfo()
        collection?.reloadData()
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        UserManager.shared.users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonCollectionViewCell.reusableIdentifier, for: indexPath) as! PersonCollectionViewCell
        
        return cell
    }
    
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width,
                              height: 64)
    }
}


extension ViewController: UserManagerDelegate {
    func didUpdateLocation(user: User) {
        if let index = UserManager.shared.users.firstIndex(where: { $0.id == user.id }) {
            UserManager.shared.users[index].location = user.location
        }
        if let selectedUser = selectedUser, selectedUser.id == user.id {
            updateDistances(selectedUser: selectedUser)
        }
        collection?.reloadData()
    }
}
