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
import JGProgressHUD




class TMDBViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let hub = JGProgressHUD()
    
    var movieList: [MovieInfoStruct] = []
    
    var changePage = 1
    var totalPage = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        
        collectionView.register(UINib(nibName: TMDBCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: TMDBCollectionViewCell.reuseIdentifier)
        collectionViewDesign()
        requestTMDBAPI()
        
       
        
       
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.star"), style: .plain, target: .none, action: #selector(listButtonClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: .none, action: #selector(magnifyingglassButtonClicked))
    }
    
    @objc func magnifyingglassButtonClicked() {
        
    }
    @objc func listButtonClicked() {
        
    }
    
    func collectionViewDesign() {
        
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 8
        let width = UIScreen.main.bounds.width - (spacing * 2)
        
        layout.itemSize = CGSize(width: width, height: width * 1.1)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = 6
        layout.minimumInteritemSpacing = spacing
        collectionView.collectionViewLayout = layout
        
    }
    
    func requestTMDBAPI() {
                
        let media_type = "/movie" //all, movie, tv, person
        let time_window = "/week" //day, week
        let url = "\(EndPoint.tmdbURL)/trending\(media_type)\(time_window)?api_key=\(APIKey.TMDB)"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                //title, overview, poster_path, release_date
                for movie in json["results"].arrayValue {
                    self.totalPage = json["total_pages"].intValue
                    
                    let movieImage_url = URL(string: "https://image.tmdb.org/t/p/w400\(movie["poster_path"].stringValue)")
                    let movieBackGroundImage_url = URL(string: "https://image.tmdb.org/t/p/w400\(movie["backdrop_path"].stringValue)")
                    
                    let movieData = MovieInfoStruct (
                        movieTitle:  movie["title"].stringValue,
                        moviePoster: movieImage_url!,
                        movieOverView: movie["overview"].stringValue,
                        movieRank: movie["vote_average"].stringValue,
                        moviereleaseDate: movie["release_date"].stringValue,
                        movieId: movie["id"].intValue,
                        movieBackGroundPoster: movieBackGroundImage_url!
                    )
                    
                    self.movieList.append(movieData)
                    
                }
                
                self.collectionView.reloadData()
                
            case .failure(let error):
                print(error)
            }
            
        }

    }
}
extension TMDBViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if movieList.count - 1 == indexPath.item && movieList.count < totalPage {
                changePage += 1
                requestTMDBAPI()
            }
        }
    }
    
}

extension TMDBViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TMDBCollectionViewCell.identifier, for: indexPath) as? TMDBCollectionViewCell else { return UICollectionViewCell() }
        
        cell.releaseDateLabel.text = "개봉일 : \(movieList[indexPath.item].moviereleaseDate)"
        cell.rankLabel.text = "평점: \(movieList[indexPath.item].movieRank)점"
        cell.titleLabel.text = "\(movieList[indexPath.item].movieTitle)"
        cell.overviewLabel.text = "\(movieList[indexPath.item].movieOverView)"
        
        cell.movieImageView.kf.setImage(with: movieList[indexPath.item].moviePoster)
        cell.gotoDetailLabel.text = "자세한 정보"
        
        cell.behindgroundView.layer.cornerRadius = 10
        cell.behindgroundView.layer.borderWidth = 1
        
        return cell
        
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let sb = UIStoryboard(name: "MovieDetail", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        
        vc.detailList = movieList[indexPath.item] //데이터 넘겨줌
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}



