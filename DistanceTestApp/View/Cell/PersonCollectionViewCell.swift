//
//  PersonCollectionViewCell.swift
//  DistanceTestApp
//
//  Created by Алексей Авер on 02.04.2023.
//

import UIKit

class PersonCollectionViewCell: UICollectionViewCell {
    static let reusableIdentifier = String(describing: PersonCollectionViewCell.self)
    @IBOutlet weak var backView: UIView? {
        didSet {
            backView?.layer.cornerRadius = 8
            backView?.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel? {
        didSet {
            nameLabel?.textColor = .black
        }
    }
    
    @IBOutlet weak var distanceLabel: UILabel? {
        didSet {
            distanceLabel?.textColor = .darkGray
        }
    }
    
    @IBOutlet weak var personImage: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

}
