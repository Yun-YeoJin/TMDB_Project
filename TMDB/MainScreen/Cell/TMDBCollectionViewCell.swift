//
//  TMDBCollectionViewCell.swift
//  TMDB
//
//  Created by 윤여진 on 2022/08/03.
//

import UIKit

class TMDBCollectionViewCell: UICollectionViewCell {

    static let identifier = "TMDBCollectionViewCell"
    
    @IBOutlet weak var behindgroundView: UIView!
     
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    @IBOutlet weak var rankLabel: UILabel!
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var gotoDetailLabel: UILabel!
    
    @IBOutlet weak var clipButton: UIButton!
    
    
    
}
