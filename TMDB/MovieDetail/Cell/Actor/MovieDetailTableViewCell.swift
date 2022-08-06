//
//  MovieDetailTableViewCell.swift
//  TMDB
//
//  Created by 윤여진 on 2022/08/04.
//

import UIKit

class MovieDetailTableViewCell: UITableViewCell {
    
    static let identifier = "MovieDetailTableViewCell"
  
    @IBOutlet weak var actorImageView: UIImageView!
    
    @IBOutlet weak var actorNameLabel: UILabel!
    @IBOutlet weak var actorNickNameLabel: UILabel!
  
    
}
