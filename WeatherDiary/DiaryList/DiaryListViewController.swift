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

    @IBAction func addDiaryButtonClicked(_ sender: UIBarButtonItem) {
        let sb = UIStoryboard(name: StoryboardName.Weather.rawValue, bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: WeatherViewController.reuseIdentifier) as? WeatherViewController else { return }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension DiaryListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DiaryDataManager.shared.diaryList.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiaryListCollectionViewCell.reuseIdentifier, for: indexPath) as? DiaryListCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
    
    func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 16
        let width = UIScreen.main.bounds.width - (spacing * 3)
        layout.itemSize = CGSize(width: width / 2, height: width / 2)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.scrollDirection = .vertical
        
        return layout
    }
    
}
