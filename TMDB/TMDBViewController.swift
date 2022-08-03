//
//  TMDBViewController.swift
//  TMDB
//
//  Created by 윤여진 on 2022/08/03.
//

import UIKit

import Alamofire
import SwiftyJSON
import Kingfisher

class TMDBViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var list: [TrendingModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: TMDBCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: TMDBCollectionViewCell.reuseIdentifier)
        
        requestTMDBAPI()
        
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 8
        let width = UIScreen.main.bounds.width - (spacing * 2)
        
        layout.itemSize = CGSize(width: width, height: width * 1.2)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = spacing
        collectionView.collectionViewLayout = layout
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.star"), style: .plain, target: .none, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: .none, action: #selector(magnifyingglassButtonClicked))
    }
    
    @objc func magnifyingglassButtonClicked() {
        
    }
    
    func requestTMDBAPI() {
        
        // list.removeAll()
        
        let media_type = "/movie" //all, movie, tv, person
        let time_window = "/week" //day, week
        let url = "\(EndPoint.tmdbURL)/trending\(media_type)\(time_window)?api_key=\(APIKey.TMDB)"
        
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                //title, overview, poster_path, release_date
                for movie in json["results"].arrayValue {
                    let movieTitle = movie["title"].stringValue
                    let movieOverview = movie["overview"].stringValue
                    let releaseDate = movie["release_date"].stringValue
                    let rank = movie["vote_average"].stringValue
                    let movieImage = "https://image.tmdb.org/t/p/w400\(movie["poster_path"].stringValue)"
                    
                    let movieData = TrendingModel(movieTitle: movieTitle, movieOverview: movieOverview, releaseDate: releaseDate, rank: rank, movieImage: movieImage)
                    
                    
                    self.list.append(movieData)
                    
                }
                
                self.collectionView.reloadData()
                
            case .failure(let error):
                print(error)
            }
            
        }
    }
}

extension TMDBViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TMDBCollectionViewCell.identifier, for: indexPath) as? TMDBCollectionViewCell else { return UICollectionViewCell() }
        
        cell.releaseDateLabel.text = "개봉일 : \(list[indexPath.item].releaseDate)"
        cell.genreLabel.text = "영화 평점: \(list[indexPath.item].rank)"
        cell.titleLabel.text = "제목: \(list[indexPath.item].movieTitle)"
        cell.overviewLabel.text = "\(list[indexPath.item].movieOverview)"
        
        let image_url = URL(string: list[indexPath.item].movieImage)
        cell.movieImageView.kf.setImage(with: image_url)
        cell.gotoDetailLabel.text = "자세한 정보"
        
        cell.behindgroundView.layer.cornerRadius = 10
        cell.behindgroundView.layer.borderWidth = 1
        
        
        return cell
    }
    
}

//extension TMDBViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.bounds.width, height: 80)
//    }
//
//}
