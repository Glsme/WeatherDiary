//
//  WeatherViewController.swift
//  WeatherDiary
//
//  Created by Seokjune Hong on 2022/08/13.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.font = UIFont(name: Font.NotoSansMedium, size: 20)
        
        OpenWeatherMapAPIManager.shared.requestCurrentWeatherData(lat: 37.592682, lon: 127.016479)
    }
}
