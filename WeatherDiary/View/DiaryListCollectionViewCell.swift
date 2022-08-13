//
//  DiaryListCollectionViewCell.swift
//  WeatherDiary
//
//  Created by Seokjune Hong on 2022/08/13.
//

import UIKit

class DiaryListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setUI()
    }
    
    func setUI() {
        backView.layer.cornerRadius = 10
    }

}
