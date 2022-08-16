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

fileprivate enum Header: String, CaseIterable {
    case OverView
    case Actor
    case Crew
}

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var backgroundPosterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    var movieData: MovieInfoStruct?
    var actorList: [ActorInfoStruct] = []
    var crewList: [CrewInfoStruct] = []
    
    let hud = JGProgressHUD()
    
    private var overViewImage = "chevron.down"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MovieDetailTableViewCell", bundle: nil), forCellReuseIdentifier: MovieDetailTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: "OverViewTableViewCell", bundle: nil), forCellReuseIdentifier: OverViewTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: "CrewTableViewCell", bundle: nil), forCellReuseIdentifier: CrewTableViewCell.reuseIdentifier)
        
        
        movieTitleLabel.text = movieData?.movieTitle
        movieTitleLabel.font = .boldSystemFont(ofSize: 22)
        movieTitleLabel.textColor = .white
        
        headerViewDesign(data: movieData!)
        
        requestActor()
        
        navigationItem.title = " 영화 상세 "
        
    }
    
    fileprivate func requestActor() {
        
        guard let movieData = movieData else {
            return
        }
        
        RequestActorAPIManager.shared.requestActorAPI(movieData: movieData) { actorList, crewList in
            self.actorList = actorList
            self.crewList = crewList
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    fileprivate func headerViewDesign(data: MovieInfoStruct) {
        
        let postImageURL = URL(string: EndPoint.imageURL + data.moviePoster)
        posterImageView.kf.setImage(with: postImageURL)
        let backImageURL = URL(string: EndPoint.imageURL + data.movieBackGroundPoster)
        backgroundPosterImageView.kf.setImage(with: backImageURL)
        posterImageView.contentMode = .scaleAspectFill
        backgroundPosterImageView.contentMode = .scaleAspectFill
        
        movieTitleLabel.text = data.movieTitle
        movieTitleLabel.font = .boldSystemFont(ofSize: 22)
        movieTitleLabel.textColor = .white
        
        
    }
    
    
    
    
}

extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return Header.OverView.rawValue
        } else if section == 1 {
            return Header.Actor.rawValue
        } else {
            return Header.Crew.rawValue
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
        } else if section == 1 {
            return actorList.count
        } else {
            return crewList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OverViewTableViewCell.reuseIdentifier, for: indexPath) as? OverViewTableViewCell else { return UITableViewCell() }
            
            cell.overViewLabel.text = movieData?.movieOverView
            cell.overViewArrowButton.setImage(UIImage(systemName: overViewImage), for: .normal)
            
            return cell
            
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailTableViewCell.reuseIdentifier, for: indexPath) as? MovieDetailTableViewCell else { return UITableViewCell() }
            
            
            let actorImageURL = URL(string: EndPoint.imageURL + actorList[indexPath.item].actorImage)
            cell.actorImageView.kf.setImage(with: actorImageURL)
            
            cell.actorNameLabel.text = actorList[indexPath.row].name
            cell.actorNickNameLabel.text = actorList[indexPath.row].nickname
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CrewTableViewCell.reuseIdentifier, for: indexPath) as? CrewTableViewCell else { return UITableViewCell() }
            
            cell.crewNameLabel.text = crewList[indexPath.row].name
            cell.crewDepartmentLabel.text = crewList[indexPath.row].department
            
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
