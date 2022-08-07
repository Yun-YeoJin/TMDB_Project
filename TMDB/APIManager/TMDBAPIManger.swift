//
//  TMDBAPIManger.swift
//  TMDB
//
//  Created by 윤여진 on 2022/08/05.
//

import UIKit

import Alamofire
import Kingfisher
import SwiftyJSON

class RequestMovieDataAPIManager {
    
    static let shared = RequestMovieDataAPIManager()
    
    private init() { }
    
    func requestTMDBAPI(media_type: String, time_window: String, completionHandler: @escaping ([MovieInfoStruct]) -> () ) {
        
        let url = "\(EndPoint.tmdbURL)/trending/\(media_type)/\(time_window)?api_key=\(APIKey.TMDB)"
        
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
          
                
                let list = json["results"].arrayValue.map { MovieInfoStruct(movieTitle: $0["title"].stringValue, moviePoster: $0["poster_path"].stringValue, movieOverView: $0["overview"].stringValue, movieRank: $0["vote_average"].stringValue, moviereleaseDate: $0["release_date"].stringValue, movieID: $0["id"].intValue, movieBackGroundPoster: $0["backdrop_path"].stringValue) }
                
                completionHandler(list)
    
                
            case .failure(let error):
                print(error)
                
                //let totalPage = json["total_pages"].intValue

                //                for movie in json["results"].arrayValue {
                //                    let movieTitle = movie["title"].stringValue
                //                    let moviePoster = movie["poster_path"].stringValue
                //                    let movieOverView = movie["overview"].stringValue
                //                    let movieRank = movie["vote_average"].stringValue
                //                    let moviereleaseDate = movie["release_date"].stringValue
                //                    let movieID = movie["id"].intValue
                //                    let movieBackGroundPoster = movie["backdrop_path"].stringValue
                //
                //                    let movieData = MovieInfoStruct(movieTitle: movieTitle, moviePoster: moviePoster, movieOverView: movieOverView, movieRank: movieRank, moviereleaseDate: moviereleaseDate, movieID: movieID, movieBackGroundPoster: movieBackGroundPoster)
                //                }
            }
            
        }
        
        
    }
}



class RequestActorAPIManager {
    
    private init() {}
    
    static let shared = RequestActorAPIManager()
    
    func requestActorAPI(movieData: MovieInfoStruct, completionHandler: @escaping ([ActorInfoStruct], [CrewInfoStruct]) -> () ) {
        
        let url = "\(EndPoint.tmdbURL)/movie/\(movieData.movieID)/credits?api_key=\(APIKey.TMDB)"
        
        AF.request(url, method: .get).validate().responseData(queue: .global()) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                //for Actor in json["cast"].arrayValue {
                
                //                    let actorImage = URL(string: "https://image.tmdb.org/t/p/w400/\(Actor["profile_path"].stringValue)")
                //
                //                    let actorData = ActorInfoStruct (
                //                        name: Actor["name"].stringValue,
                //                        nickname: Actor["character"].stringValue,
                //                        actorImage: actorImage!
                //                        )
                
                let actor = json["cast"].arrayValue.map { ActorInfoStruct(name: $0["name"].stringValue, nickname: $0["character"].stringValue, actorImage: $0["profile_path"].stringValue) }
                let crew = json["crew"].arrayValue.map { CrewInfoStruct(name: $0["name"].stringValue, department: $0["known_for_department"].stringValue) }
                
                
                completionHandler(actor, crew)
                
                //self.actorList.append(actorData)
                //self.tableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
}

class RequestMovieVideoAPIManager {
    
    private init() {}
    
    static let shared = RequestMovieVideoAPIManager()
    
    func requestMovieVideoAPI(movieID: Int, completionHandler: @escaping (String) -> () ) {
        
        let webURL = "\(EndPoint.tmdbURL)/movie/\(movieID))/videos?api_key=\(APIKey.TMDB)"
        
        AF.request(webURL, method: .get).validate(statusCode: 200...400).responseData(queue: .global()) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                completionHandler(json["results"][0]["key"].stringValue)
                
                
            case .failure(let error):
                
                print(error)
            }
            
        }
    }
}
