//
//  MovieVideoViewController.swift
//  TMDB
//
//  Created by 윤여진 on 2022/08/05.
//

import UIKit

import Alamofire
import Kingfisher
import SwiftyJSON
import WebKit

class MovieVideoViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!


    var movieID : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestMovieVideoAPI()
     
    }
    
    @IBAction func goBackButtonClicked(_ sender: Any) {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    @IBAction func reloadButtonClicked(_ sender: Any) {
        webView.reload()
    }
    @IBAction func goForwardButtonClicked(_ sender: Any) {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    func requestMovieVideoAPI() {
        let webURL = "\(EndPoint.tmdbURL)/\(movieID!))/videos?api_key=\(APIKey.TMDB)"

        AF.request(webURL, method: .get).validate(statusCode: 200...400).responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)

                let urlValue = json["results"][0]["key"].stringValue

                guard let url = URL(string: "https://www.youtube.com/watch?v=\(urlValue)" ) else { return }

                let request = URLRequest(url: url)

                self.webView.load(request)

            case .failure(let error):

                print(error)
            }

        }
    }

    
    
    
}
