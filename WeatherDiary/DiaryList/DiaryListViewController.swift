//
//  DiaryListViewController.swift
//  WeatherDiary
//
//  Created by Seokjune Hong on 2022/08/13.
//

import UIKit

class DiaryListViewController: UIViewController {

    @IBOutlet weak var diaryListCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        diaryListCollectionView.delegate = self
        diaryListCollectionView.dataSource = self
        diaryListCollectionView.register(UINib(nibName: DiaryListCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: DiaryListCollectionViewCell.reuseIdentifier)
        diaryListCollectionView.collectionViewLayout = collectionViewLayout()
    }

}

extension DiaryListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiaryListCollectionViewCell.reuseIdentifier, for: indexPath) as? DiaryListCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
    
    func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 8
        let width = UIScreen.main.bounds.width - (spacing * 3)
        layout.itemSize = CGSize(width: width / 2, height: width / 2)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.scrollDirection = .vertical
        
        return layout
    }
    
}
