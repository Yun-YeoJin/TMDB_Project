//
//  PosterCollectionViewCell.swift
//  TMDB
//
//  Created by 윤여진 on 2022/08/09.
//

import UIKit

class PosterCollectionViewCell: UICollectionViewCell {


    @IBOutlet weak var posterView: PosterView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
        
    }
    
    func setupUI() {
        posterView.backgroundColor = .clear
        posterView.posterImageView.layer.cornerRadius = 10
        posterView.posterImageView.backgroundColor = .opaqueSeparator
        posterView.netflixButton.tintColor = .red
        
    }
    

}
