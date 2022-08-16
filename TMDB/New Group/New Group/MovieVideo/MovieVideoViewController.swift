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
    
    public var movieKey = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      playMovieVideoURL(key: movieKey) //movieKey 받아옴
     
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
    
    private func playMovieVideoURL(key: String) {
        
        guard let url = URL(string: "https://www.youtube.com/watch?v=\(key)") else { return }
        
        let request = URLRequest(url: url)
        
        webView.load(request)
        
    }
  

    
    
    
}

