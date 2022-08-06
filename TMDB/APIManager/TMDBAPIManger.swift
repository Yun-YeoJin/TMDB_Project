////
////  TMDBAPIManger.swift
////  TMDB
////
////  Created by 윤여진 on 2022/08/05.
////
//
//import UIKit
//
//import Alamofire
//import Kingfisher
//import SwiftyJSON
//
//class MovieSearchAPIManager {
//
//    static let shared = MovieSearchAPIManager()
//
//    private init() { }
//
//    typealias completionHandler = (Int, [String]) -> Void
//
//    func requestTMDBAPI (media_type: String, time_window: String, completionHandler: @escaping completionHandler) {
//        
//        let url = "\(EndPoint.tmdbURL)/trending/\(media_type)/\(time_window)?api_key=\(APIKey.TMDB)"
//        
//        AF.request(url, method: .get).validate().responseData { response in
//            switch response.result {
//            case .success(let value):
//                let json = JSON(value)
//                
//                for movie in json["results"].arrayValue {
//                    let totalPage = json["total_pages"].intValue
//                    
//                    let movieImage_url = URL(string: "https://image.tmdb.org/t/p/w400\(movie["poster_path"].stringValue)")
//                    let movieBackGroundImage_url = URL(string: "https://image.tmdb.org/t/p/w400\(movie["backdrop_path"].stringValue)")
//                    
//                    let movieData = MovieInfoStruct (
//                        movieTitle:  movie["title"].stringValue,
//                        moviePoster: movieImage_url!,
//                        movieOverView: movie["overview"].stringValue,
//                        movieRank: movie["vote_average"].stringValue,
//                        moviereleaseDate: movie["release_date"].stringValue,
//                        movieId: movie["id"].intValue,
//                        movieBackGroundPoster: movieBackGroundImage_url!
//                    )
//                    self.movieList.append(movieData)
//                }
//                       
//                
//                self.collectionView.reloadData()
//                    
// 
//            case .failure(let error):
//                print(error)
//            }
//            
//        }
//
//    }
//    
//
//
//}
