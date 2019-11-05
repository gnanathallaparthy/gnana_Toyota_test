//
//  SuperHeroCell.swift
//  Toyota
//
//  Created by Gnana Thallaparthy on 03/11/19.
//  Copyright © 2019 Epam. All rights reserved.
//

import UIKit

class SuperHeroCell: UITableViewCell {

    @IBOutlet weak var imageViewSuperHero: UIImageView!
    @IBOutlet weak var labelBatman: UILabel!
    @IBOutlet weak var labelScore: UILabel!
    
    func uploadData(_ dict: [String: Any]) {
        self.labelBatman.text = dict[Keys.Name] as? String ?? ""
        let score = dict[Keys.Score] as? Int ?? 0
        self.labelScore.text = "\(score)"
        let imageName = dict[Keys.Picture] as? String ?? ""
        imageViewSuperHero.image = UIImage(named: imageName)
    }
}
