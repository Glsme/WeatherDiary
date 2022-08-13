//
//  OpenWeatherMapAPIManager.swift
//  WeatherDiary
//
//  Created by Seokjune Hong on 2022/08/13.
//

import Foundation

import Alamofire
import SwiftyJSON

class OpenWeatherMapAPIManager {
    static let shared = OpenWeatherMapAPIManager()
    
    private init() { }
    
    func requestCurrentWeatherData(lat: Double, lon: Double) {
        //https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
        let url = "\(EndPoint.currentWeatherData)lat=\(lat)&lon=\(lon)&appid=\(APIKey.OPENWEATHER)"
        
        AF.request(url, method: .get).validate(statusCode: 200...500).responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                                
            case .failure(let error):
                print(error)
            }
        }
    }
}
