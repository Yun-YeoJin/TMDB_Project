//
//  PosterView.swift
//  TMDB
//
//  Created by 윤여진 on 2022/08/09.
//

import UIKit

class PosterView: UIView {

    @IBOutlet weak var posterImageView: UIImageView! {
        didSet {
            posterImageView.contentMode = .scaleToFill
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var originalTitleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var netflixButton: UIButton!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        let view = UINib(nibName: "PosterView", bundle: nil).instantiate(withOwner: self).first as! UIView
        view.frame = bounds
        view.backgroundColor = .clear
        self.addSubview(view)
    }
    
  
}
