//
//  NetFlixTableViewCell.swift
//  TMDB
//
//  Created by 윤여진 on 2022/08/09.
//

import UIKit

class NetFlixTableViewCell: UITableViewCell {

    
    @IBOutlet weak var contentCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
   private func setupUI() {
        titleLabel.text = "넷플릭스 인기 콘텐츠"
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.backgroundColor = .clear
        contentCollectionView.backgroundColor = .clear
        
        contentCollectionView.collectionViewLayout = collectionViewLayout()
    }

    private func collectionViewLayout() -> UICollectionViewFlowLayout {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 240 , height: 180)
        layout.estimatedItemSize = .zero
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return layout
    }
}
