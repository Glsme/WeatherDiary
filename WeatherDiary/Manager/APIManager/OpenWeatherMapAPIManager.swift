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
    
    let dateFormatter = DateFormatter()
    
    func requestCurrentWeatherData(lat: Double, lon: Double, complitionHandler: @escaping (String, String, String) -> () ) {
        //https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
        let url = "\(EndPoint.currentWeatherDataURL)lat=\(lat)&lon=\(lon)&appid=\(APIKey.OPENWEATHER)"
        
        AF.request(url, method: .get).validate(statusCode: 200...500).responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                
                let temp = Int(json["main"]["temp"].doubleValue - 273.15)
                let name = self.city[json["name"].stringValue] ?? json["name"].stringValue
                let humidity = json["main"]["humidity"].intValue
                let icon = json["weather"][0]["icon"].stringValue
                let id = json["weather"][0]["id"].intValue
                let weather = self.weatherDescKo[id] ?? "날씨"
//                for item in json["weather"].arrayValue {
//                    print(item["icon"].stringValue)
//                }
                
                self.dateFormatter.dateFormat = "yyyy-MM-dd"
                let date = self.dateFormatter.string(from: Date())
                
                let description = """
                    현재 온도는 \(temp)℃이고,
                    습도는 \(humidity)%이며,
                    날씨 키워드는
                    \(weather)입니다.
                    """
                DiaryDataManager.shared.diaryList.append(DiaryModel(temp: temp, humidity: humidity, weather: weather, text: description, icon: icon, date: date, name: name, diary: nil))
                
                
                complitionHandler(name ,description, icon)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    let city: [String: String] = [
        "Seoul": "서울"
    ]
    
    let weatherDescKo: [Int: String] = [
        201: "가벼운 비를 동반한 천둥구름",
        200: "비를 동반한 천둥구름",
        202: "폭우를 동반한 천둥구름",
        210: "약한 천둥구름",
        211: "천둥구름",
        212: "강한 천둥구름",
        221: "불규칙적 천둥구름",
        230: "약한 연무를 동반한 천둥구름",
        231: "연무를 동반한 천둥구름",
        232: "강한 안개비를 동반한 천둥구름",
        300: "가벼운 안개비",
        301: "안개비",
        302: "강한 안개비",
        310: "가벼운 적은비",
        311: "적은비",
        312: "강한 적은비",
        313: "소나기와 안개비",
        314: "강한 소나기와 안개비",
        321: "소나기",
        500: "악한 비",
        501: "중간 비",
        502: "강한 비",
        503: "매우 강한 비",
        504: "극심한 비",
        511: "우박",
        520: "약한 소나기 비",
        521: "소나기 비",
        522: "강한 소나기 비",
        531: "불규칙적 소나기 비",
        600: "가벼운 눈",
        601: "눈",
        602: "강한 눈",
        611: "진눈깨비",
        612: "소나기 진눈깨비",
        615: "약한 비와 눈",
        616: "비와 눈",
        620: "약한 소나기 눈",
        621: "소나기 눈",
        622: "강한 소나기 눈",
        701: "박무",
        711: "연기",
        721: "연무",
        731: "모래 먼지",
        741: "안개",
        751: "모래",
        761: "먼지",
        762: "화산재",
        771: "돌풍",
        781: "토네이도",
        800: "구름 한 점 없는 맑은 하늘",
        801: "약간의 구름이 낀 하늘",
        802: "드문드문 구름이 낀 하늘",
        803: "구름이 거의 없는 하늘",
        804: "구름으로 뒤덮인 흐린 하늘",
        900: "토네이도",
        901: "태풍",
        902: "허리케인",
        903: "한랭",
        904: "고온",
        905: "바람부는 날씨",
        906: "우박",
        951: "바람이 거의 없는 날씨",
        952: "약한 바람",
        953: "부드러운 바람",
        954: "중간 세기 바람",
        955: "신선한 바람",
        956: "센 바람",
        957: "돌풍에 가까운 센 바람",
        958: "돌풍",
        959: "심각한 돌풍",
        960: "폭풍",
        961: "강한 폭풍",
        962: "허리케인",
    ]

}
