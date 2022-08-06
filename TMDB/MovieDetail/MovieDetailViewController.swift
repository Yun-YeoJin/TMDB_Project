//
//  MovieDetailViewController.swift
//  TMDB
//
//  Created by 윤여진 on 2022/08/04.
//

import UIKit

import Alamofire
import SwiftyJSON
import JGProgressHUD
import Kingfisher

enum Header: String, CaseIterable {
    case overView
    case actor
}

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var backgroundPosterImageView: UIImageView!
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    let hud = JGProgressHUD()
    
    var detailList: MovieInfoStruct?
    var actorList: [ActorInfoStruct] = []
    
    var overViewImage = "chevron.down"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MovieDetailTableViewCell", bundle: nil), forCellReuseIdentifier: MovieDetailTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: "OverViewTableViewCell", bundle: nil), forCellReuseIdentifier: OverViewTableViewCell.reuseIdentifier)
        
        backgroundPosterImageView.kf.setImage(with: detailList?.movieBackGroundPoster)
        
        posterImageView.kf.setImage(with: detailList?.moviePoster)
        
        movieTitleLabel.text = detailList?.movieTitle
        movieTitleLabel.font = .boldSystemFont(ofSize: 22)
        movieTitleLabel.textColor = .white
        
        navigationItem.title = " 영화 상세 "
        
        requestDetailMovieAPI()
    }
    
    
    
    
    func requestDetailMovieAPI() {
        

        let url = "\(EndPoint.tmdbURL)/movie/\(detailList!.movieID )/credits?api_key=\(APIKey.TMDB)"

        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")


                for Actor in json["cast"].arrayValue {

                    let actorImage = URL(string: "https://image.tmdb.org/t/p/w400/\(Actor["profile_path"].stringValue)")

                    let actorData = ActorInfoStruct (
                        name: Actor["name"].stringValue,
                        nickname: Actor["character"].stringValue,
                        actorImage: actorImage!
                        )


                    self.actorList.append(actorData)

                }

                self.tableView.reloadData()

            case .failure(let error):
                print(error)
            }

        }
        
        
    }
    
    
    
}

extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return Header.overView.rawValue
        } else {
            return Header.actor.rawValue
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Header.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            let overView = overViewImage == "chevron.down" ? tableView.frame.size.height / 8 : UITableView.automaticDimension
            return overView
        } else {
            return tableView.frame.size.height / 8
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return actorList.count
        }
            
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OverViewTableViewCell.reuseIdentifier, for: indexPath) as? OverViewTableViewCell else { return UITableViewCell() }
            
            cell.overViewLabel.text = detailList?.movieOverView
            cell.overViewArrowButton.setImage(UIImage(systemName: overViewImage), for: .normal)
            
            return cell
            
        } else {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailTableViewCell.reuseIdentifier, for: indexPath) as? MovieDetailTableViewCell else { return UITableViewCell() }
        
        cell.actorNameLabel.text = actorList[indexPath.row].name
        cell.actorNickNameLabel.text = actorList[indexPath.row].nickname
        cell.actorImageView.kf.setImage(with: actorList[indexPath.row].actorImage)
        
        return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            if overViewImage == "chevron.down" {
                overViewImage = "chevron.up"
            } else {
                overViewImage = "chevron.down"
            }
            tableView.reloadData()
        }
    }
    
   
    
}
