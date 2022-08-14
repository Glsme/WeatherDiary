//
//  WeatherViewController.swift
//  WeatherDiary
//
//  Created by Seokjune Hong on 2022/08/13.
//

import UIKit
import CoreLocation

import Kingfisher

class WeatherViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var diaryTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        checkUserDeviceLocationServiceAuthorization()
        
        descriptionLabel.font = UIFont(name: Font.NotoSansMedium, size: 16)
        view.backgroundColor = UIColor.weatherBGColor
        
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(saveButtonClicked))
        
        diaryTextView.delegate = self
        diaryTextView.font = UIFont(name: Font.NotoSansMedium, size: 13)
        setTextViewPlaceHolder()
        
    }
    
    @objc func saveButtonClicked() {
        print(#function)
        let sb = UIStoryboard(name: StoryboardName.DiaryList.rawValue, bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: DiaryListViewController.reuseIdentifier) as? DiaryListViewController else { return }
        
        self.navigationController?.popViewController(animated: true)
    }
}

extension WeatherViewController: UITextViewDelegate {
    func setTextViewPlaceHolder() {
        diaryTextView.text = "오늘의 일기를 적어주세요"
        diaryTextView.textColor = UIColor.lightGray
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "오늘의 일기를 적어주세요"
            textView.textColor = UIColor.lightGray
        }
    }
}

extension WeatherViewController {
    func checkUserDeviceLocationServiceAuthorization() {
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            checkUserCurrentLocationAuthorization(authorizationStatus)
        } else {
            print("사용자의 위치 권한이 꺼져 있어 정보를 가져오지 못했습니다.")
        }
    }
    
    func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            print("NOT DETERMINED")
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("DENIED")
            showRequestLocationServiceAlert()
        case .authorizedWhenInUse:
            print("WHEN IN USE")
            locationManager.startUpdatingLocation()
            let latitude = locationManager.location?.coordinate.latitude
            let longtitude = locationManager.location?.coordinate.longitude
//            print(latitude)
            OpenWeatherMapAPIManager.shared.requestCurrentWeatherData(lat: latitude!, lon: longtitude!) { text, icon in
                self.descriptionLabel.text = text
                let url = "https://openweathermap.org/img/wn/\(icon)@2x.png"
                self.iconImageView.kf.setImage(with: URL(string: url))
            }
//            descriptionLabel.text = "\(DiaryDataManager.shared.diaryList.last?.temp)"
        default:
            print("DEFAULT")
        }
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
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserDeviceLocationServiceAuthorization()
    }
}
