//
//  DiaryListCollectionViewCell.swift
//  WeatherDiary
//
//  Created by Seokjune Hong on 2022/08/13.
//

import UIKit

class DiaryListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setUI()
    }
    
    func setUI() {
        backView.layer.cornerRadius = 10
        backView.backgroundColor = UIColor.weatherCollectionColor
        
        weatherLabel.font = UIFont(name: Font.NotoSansMedium, size: 16)
        dateLabel.font = UIFont(name: Font.NotoSansMedium, size: 13)
    }
    
}
