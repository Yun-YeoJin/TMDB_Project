//
//  PosterView.swift
//  TMDB
//
//  Created by 윤여진 on 2022/08/09.
//

import UIKit

class PosterView: UIView {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var netflixButton: UIButton!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        let view = UINib(nibName: "PosterView", bundle: nil).instantiate(withOwner: self).first as! UIView
        view.frame = bounds
        view.backgroundColor = .black
        self.addSubview(view)
    }
}
