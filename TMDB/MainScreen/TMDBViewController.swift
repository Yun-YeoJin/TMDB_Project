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
    
    var movieKey = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        
        collectionView.register(UINib(nibName: TMDBCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: TMDBCollectionViewCell.reuseIdentifier)
        
        
        
        requestMovieAPI()
        
        collectionViewDesign()
      
        
       
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.star"), style: .plain, target: .none, action: #selector(listButtonClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: .none, action: #selector(magnifyingglassButtonClicked))
    }
    
    @objc func magnifyingglassButtonClicked() {
        
    }
    @objc func listButtonClicked() {
        
    }
    
    func formattedDate(dataString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let date = formatter.date(from: dataString) {
            formatter.dateFormat = "dd / MM / yyyy"
            return formatter.string(from: date)
        } else { return "" }
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
    
    func requestMovieAPI() {
        RequestMovieDataAPIManager.shared.requestTMDBAPI(media_type: "movie", time_window: "week") { list in
            self.movieList.append(contentsOf: list)
            self.collectionView.reloadData()
        }
    }
    
    
    // 영화 예고편 보여주기
    func requestMovieVideoAPI(movieID: Int) {
        RequestMovieVideoAPIManager.shared.requestMovieVideoAPI(movieID: movieID) { movieKey in
            self.movieKey = movieKey
            DispatchQueue.main.async {
                let sb = UIStoryboard(name: "MovieVideo", bundle: nil)
                guard let vc = sb.instantiateViewController(withIdentifier: "MovieVideoViewController") as? MovieVideoViewController else { return }
                
                vc.movieKey = self.movieKey //movieKey값을 넘겨준다.
                
                self.present(vc, animated: true)
                
                
            }
        }
    }
            

}
extension TMDBViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if movieList.count - 1 == indexPath.item && movieList.count < totalPage {
                changePage += 1
                requestMovieAPI()
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
        
        cell.releaseDateLabel.text = "개봉일: " + formattedDate(dataString: movieList[indexPath.item].moviereleaseDate)
        cell.releaseDateLabel.textColor = .darkGray
        cell.rankLabel.text = "평점: \(movieList[indexPath.item].movieRank)점"
        cell.titleLabel.text = "\(movieList[indexPath.item].movieTitle)"
        cell.overviewLabel.text = "\(movieList[indexPath.item].movieOverView)"
        
        let posterURL = URL(string: EndPoint.imageURL + movieList[indexPath.item].moviePoster)
        cell.movieImageView.kf.setImage(with: posterURL)
        cell.gotoDetailLabel.text = "자세한 정보"
        
        cell.behindgroundView.layer.cornerRadius = 10
        cell.behindgroundView.layer.borderWidth = 1
       
        cell.behindgroundView.layer.shadowColor = UIColor.black.cgColor
        cell.behindgroundView.layer.shadowOpacity = 0.5
        cell.behindgroundView.layer.shadowRadius = 10
        
        cell.clipButton.tag = indexPath.item // tag값 설정
        
        cell.clipButton.addTarget(self, action: #selector(clipButtonClicked), for: .touchUpInside)
    
        return cell
        
    
    }
    @objc func clipButtonClicked(_ sender: UIButton) {
        
        requestMovieVideoAPI(movieID: movieList[sender.tag].movieID)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let sb = UIStoryboard(name: "MovieDetail", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        
        vc.movieData = movieList[indexPath.item] //데이터 넘겨줌
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}



