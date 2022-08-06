//
//  OverViewTableViewCell.swift
//  TMDB
//
//  Created by 윤여진 on 2022/08/04.
//

import UIKit

class OverViewTableViewCell: UITableViewCell {

    @IBOutlet weak var overViewLabel: UILabel! {
        didSet {
            self.overViewLabel.textAlignment = .center
        }
    }
    @IBOutlet weak var overViewArrowButton: UIButton!
    
    

    
}
