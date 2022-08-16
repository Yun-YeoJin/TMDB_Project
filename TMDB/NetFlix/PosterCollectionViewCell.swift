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
    
       LabelDesign()
        
    }

    private func LabelDesign() {
        
        posterView.titleLabel.textColor = .white
        posterView.titleLabel.font = .boldSystemFont(ofSize: 15)
        posterView.originalTitleLabel.font = .systemFont(ofSize: 12)
        posterView.originalTitleLabel.textColor = .opaqueSeparator
        posterView.releaseDateLabel.font = .systemFont(ofSize: 13)
        posterView.releaseDateLabel.textColor = .white
        posterView.overviewLabel.font = .systemFont(ofSize: 11)
        posterView.overviewLabel.textColor = .white
        posterView.overviewLabel.numberOfLines = 0
        posterView.posterImageView.contentMode = .scaleAspectFit
    
    }
    
    
    
    

}
