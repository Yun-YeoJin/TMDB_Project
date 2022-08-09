//
//  NetFlixInfo.swift
//  TMDB
//
//  Created by 윤여진 on 2022/08/09.
//

import Foundation

struct NetFlixData {
    let title: String
}

extension NetFlixData {
    static let list = [
        NetFlixData(title: "넷플릭스 인기 콘텐츠"),
        NetFlixData(title: "비슷한 콘텐츠"),
        NetFlixData(title: "액션/SF/스릴러"),
        NetFlixData(title: "미국 TV 프로그램"),
        NetFlixData(title: "한국 TV 프로그램"),
        NetFlixData(title: "한국 예능 인기 콘텐츠"),
        NetFlixData(title: "한국 영화 인기 콘텐츠")
    ]
}
