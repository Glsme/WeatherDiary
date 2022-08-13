//
//  DiaryDataManager.swift
//  WeatherDiary
//
//  Created by Seokjune Hong on 2022/08/13.
//

import Foundation

class DiaryDataManager {
    static let shared = DiaryDataManager()
    private init() { }
    
    var diaryList: [DiaryModel] = []
}
