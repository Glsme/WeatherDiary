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
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        checkUserDeviceLocationServiceAuthorization()
        
        descriptionLabel.font = UIFont(name: Font.NotoSansMedium, size: 14)
        locationLabel.font = UIFont(name: Font.NotoSansMedium, size: 18)
        iconImageView.layer.cornerRadius = iconImageView.frame.height / 2
        view.backgroundColor = UIColor.weatherBGColor
        
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(saveButtonClicked))
        
        diaryTextView.delegate = self
        diaryTextView.font = UIFont(name: Font.NotoSansMedium, size: 13)
        setTextViewPlaceHolder()
        
        cameraButton.layer.cornerRadius = cameraButton.frame.height / 2
        
    }
    
    @IBAction func cameraButtonClicked(_ sender: UIButton) {
        print(#function)
    }
    
    @objc func saveButtonClicked() {
//        print(#function)
        let sb = UIStoryboard(name: StoryboardName.DiaryList.rawValue, bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: DiaryListViewController.reuseIdentifier) as? DiaryListViewController else { return }
        UserDefaults.standard.set(DiaryDataManager.shared.diaryList, forKey: "diaryList")
        
        if diaryTextView.text.isEmpty || diaryTextView.text == "오늘의 당신의 하루는 어땠나요?" {
            showSaveWarningAlert()
        } else {
//            DiaryDataManager.shared.diaryList.last?.diary = diaryTextView.text
            print(DiaryDataManager.shared.diaryList)
//            vc.diaryListCollectionView.reloadData()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func showSaveWarningAlert() {
        let alert = UIAlertController(title: "주의", message: "오늘의 일기를 적은 후 저장해주세요.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
        
        alert.addAction(ok)
        present(alert, animated: true)
    }
}

extension WeatherViewController: UITextViewDelegate {
    func setTextViewPlaceHolder() {
        diaryTextView.text = "오늘의 당신의 하루는 어땠나요?"
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
            textView.text = "오늘의 당신의 하루는 어땠나요?"
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
            OpenWeatherMapAPIManager.shared.requestCurrentWeatherData(lat: latitude!, lon: longtitude!) { name, text, icon in
                self.locationLabel.text = name
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
