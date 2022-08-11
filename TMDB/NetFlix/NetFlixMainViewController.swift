//
//  NetFlixMainViewController.swift
//  TMDB
//
//  Created by 윤여진 on 2022/08/09.
//

import UIKit

import Kingfisher

class NetFlixMainViewController: UIViewController {
    
    var episodeList: [[String]] = []

    var recommendList: [NetFlixData] = []
    
    @IBOutlet weak var bannerCollecionView: UICollectionView!
    
    @IBOutlet weak var mainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainTableView.delegate = self
        mainTableView.dataSource = self

        bannerCollecionView.delegate = self
        bannerCollecionView.dataSource = self
        bannerCollecionView.register(UINib(nibName: "PosterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PosterCollectionViewCell")
        
        bannerCollecionView.isPagingEnabled = true
        bannerCollecionView.collectionViewLayout = collectionViewLayout()
        
        NetFlixTMDBAPIManager.shared.requestImage { value in
            self.episodeList = value
            self.mainTableView.reloadData()
        }
        
        RecommendAPIManager.shared.requestTMDBAPI(movie_id: 28) { list in
            dump(list)
            self.recommendList = list
            self.bannerCollecionView.reloadData()
        }
    
    }
    

}

extension NetFlixMainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return episodeList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NetFlixTableViewCell", for: indexPath) as? NetFlixTableViewCell else { return UITableViewCell() }
        
        cell.titleLabel.text = NetFlixTMDBAPIManager.shared.tvList[indexPath.section].0
        
        cell.contentCollectionView.delegate = self
        cell.contentCollectionView.dataSource = self
        cell.contentCollectionView.register(UINib(nibName: "PosterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PosterCollectionViewCell")
        cell.contentCollectionView.reloadData()
        
        cell.contentCollectionView.tag = indexPath.section
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
        
    }
    
}

extension NetFlixMainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == bannerCollecionView ? recommendList.count :  episodeList[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCollectionViewCell", for: indexPath) as? PosterCollectionViewCell else { return UICollectionViewCell() }
        
        if collectionView == bannerCollecionView {
            cell.posterView.posterImageView.backgroundColor = .black
            cell.posterView.titleLabel.text = "\(recommendList[indexPath.item].title)"
            cell.posterView.originalTitleLabel.text = "orginal_title: \(recommendList[indexPath.item].original_title)"
            cell.posterView.releaseDateLabel.text = "\(recommendList[indexPath.item].releaseDate)"
            cell.posterView.overviewLabel.text = "\(recommendList[indexPath.item].overview)"
            let url = URL(string: "\(EndPoint.imageURL)\(recommendList[indexPath.item].posterImage)")
            cell.posterView.posterImageView.kf.setImage(with: url)
            
        } else {
            let url = URL(string: "\(EndPoint.imageURL)\(episodeList[collectionView.tag][indexPath.item])")
            cell.posterView.posterImageView.kf.setImage(with: url)
            cell.posterView.posterImageView.backgroundColor = .black
            cell.posterView.titleLabel.text = ""
            cell.posterView.originalTitleLabel.text = ""
            cell.posterView.overviewLabel.text = ""
            cell.posterView.releaseDateLabel.text = ""
        }
        
        return cell
    }
    
    func collectionViewLayout() -> UICollectionViewFlowLayout {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: bannerCollecionView.frame.height)
        layout.estimatedItemSize = .zero
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return layout
    }
    
    
}
