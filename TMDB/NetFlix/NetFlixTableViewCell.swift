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

    func configureTitleLabel(_ data: NetFlixData) {
        titleLabel.text = data.title
    }
    
    func setupUI() {
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.backgroundColor = .clear
        contentCollectionView.backgroundColor = .clear
        
        contentCollectionView.collectionViewLayout = collectionViewLayout()
    }

    func collectionViewLayout() -> UICollectionViewFlowLayout {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: contentCollectionView.bounds.width / 3, height: 200)
        layout.estimatedItemSize = .zero
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return layout
    }
}
