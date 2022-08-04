//
//  ReusableViewProtocol.swift
//  TMDB
//
//  Created by 윤여진 on 2022/08/03.
//

import Foundation
import UIKit

protocol ReusableViewProtocol {
    
    static var reuseIdentifier: String { get }
    
}

extension UIViewController: ReusableViewProtocol {
    static var reuseIdentifier: String { // 연산 프로퍼티 get만 사용한다면 get 생략 가능
        get {
            return String(describing: self)
        }
    }
    //extension 저장 프로퍼티 불가능

}
extension UITableViewCell: ReusableViewProtocol {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    
}

extension UICollectionViewCell: ReusableViewProtocol {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    
}
