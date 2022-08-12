//
//  TheaterViewController.swift
//  TMDB
//
//  Created by 윤여진 on 2022/08/11.
//

import UIKit
import MapKit
import CoreLocation


class TheaterViewController: UIViewController {
    
    let list = TheaterList()
    
    let locationManager = CLLocationManager()
    
    var currentRegion: CLLocationCoordinate2D?
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var gotoCurrentLocationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        locationManager.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterButtonClicked))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        gotoCurrentLocationButton.setImage(UIImage(systemName: "location.circle.fill"), for: .normal)
        gotoCurrentLocationButton.setTitle("현재 위치 찾기", for: .normal)
        gotoCurrentLocationButton.addTarget(self, action: #selector(foundCurrentLocationButtonClicked), for: .touchUpInside)
    }
    
    @objc func foundCurrentLocationButtonClicked() {
        
        setRegionAndAnnotation(currentRegion!, "현재 위치", 500)
        
    }
    
    @objc func filterButtonClicked() {
        
        showTheaterListToSelectAlert()
        
    }
    
    func setRegionAndAnnotation(_ center: CLLocationCoordinate2D, _ title: String, _ distance: Double) {
        
        //지도 중심 기반으로 보여질 범위 설정
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: distance, longitudinalMeters: distance)
        mapView.setRegion(region, animated: true)
        
        //지도에 핀 추가
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = title
        mapView.addAnnotation(annotation)
    }
}


extension TheaterViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let coordinate = locations.last?.coordinate {
            
            setRegionAndAnnotation(coordinate, "현재 위치", 300)
            currentRegion = coordinate
            
        }
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
    }
    
}
// 위치 관련된 User Defined Methods
extension TheaterViewController {
    
    func checkUserDeviceLocationServiceAuthorization() {
        
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            //인스턴스를 통해 locationManager가 가지고 있는 상태를 가져옴.
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        //iOS 위치 서비스 활성화 여부 체크: locationServicesEnabled
        if CLLocationManager.locationServicesEnabled() {
            //위치 서비스가 활성화 되어 있음 => 위치 권한 요청 가능 => 위치 권한을 요청
            checkUserCurrentLocationAuthorization(authorizationStatus)
        } else {
            print("위치 서비스가 꺼져 있어 위치 권한 요청이 불가합니다.")
        }
        
    }
    
    func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
            
        case .notDetermined:
            print("NOTDETERMINED")
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted, .denied:
            print("DENIED, 아이폰 설정으로 유도")
            
            let center = CLLocationCoordinate2D(latitude: 37.517829, longitude: 126.886270)
            setRegionAndAnnotation(center, "청년취업사관학교 영등포 캠퍼스", 300)
            showRequestLocationServiceAlert()
            
        case .authorizedWhenInUse:
            print("WHEN IN USE")
            
            locationManager.startUpdatingLocation()
            
        default:
            print("DEFAULT")
        }
    }
    
    
    
    func showTheaterListToSelectAlert() {
        
        let showTheaterListToSelectAlert = UIAlertController(title: "영화관 선택", message: "", preferredStyle: .actionSheet)
        
        let seeAll = UIAlertAction(title: "전체보기", style: .default) { _ in
            self.mapView.removeAnnotations(self.mapView.annotations)
            for item in self.list.mapAnnotations {
                self.setRegionAndAnnotation(CLLocationCoordinate2D(latitude: item.latitude , longitude: item.longitude), item.location, 500)
            }
        }
        let megaBox = UIAlertAction(title: "메가박스", style: .default) { value in
            setAnnotation(value)
        }
        let lotteCinema = UIAlertAction(title: "롯데시네마", style: .default) {value in
            setAnnotation(value)
        }
        let cgv = UIAlertAction(title: "CGV", style: .default) { value in
            setAnnotation(value)
        }
        
        func setAnnotation(_ value: UIAlertAction) {
            self.mapView.removeAnnotations(self.mapView.annotations)
            for item in self.list.mapAnnotations {
                if item.type == value.title {
                    self.setRegionAndAnnotation(CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude), item.location, 1500)
                }
            }
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        showTheaterListToSelectAlert.addAction(megaBox)
        showTheaterListToSelectAlert.addAction(lotteCinema)
        showTheaterListToSelectAlert.addAction(cgv)
        showTheaterListToSelectAlert.addAction(seeAll)
        showTheaterListToSelectAlert.addAction(cancel)
        
        present(showTheaterListToSelectAlert, animated: true, completion: nil)
    }
    
    func showRequestLocationServiceAlert() {
        
        let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
            
        }
        let cancel = UIAlertAction(title: "취소", style: .default)
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(goSetting)
        
        present(requestLocationServiceAlert, animated: true, completion: nil)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        checkUserDeviceLocationServiceAuthorization()
        
    }
    
    //iOS 14.0 미만
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
}

extension TheaterViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        locationManager.stopUpdatingLocation()
    }
}
