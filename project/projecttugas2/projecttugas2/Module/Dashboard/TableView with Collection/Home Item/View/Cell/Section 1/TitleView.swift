//
//  TitleView.swift
//  projecttugas2
//
//  Created by Phincon on 30/10/23.
//

import UIKit

class TitleView: UIViewController {
    let dataTitle: [String] = ["Latte", "Cappucino", "Espresso", "Americano"]

    
    @IBOutlet weak var collectionTitle: UICollectionView!
    
        override func awakeFromNib() {
        super.awakeFromNib()
            setup()
    }
    
    func setup() {
        collectionTitle.delegate = self
        collectionTitle.dataSource = self
        collectionTitle.registerCellWithNib(TitleCollectionViewCell.self)
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 30, left: 40, bottom: 30, right: 40)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
extension ItemDashboardTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.showsHorizontalScrollIndicator = false
        
        let cell = collectionTitle.dequeueReusableCell(withReuseIdentifier: "TitleCollectionViewCell", for: indexPath) as! TitleCollectionViewCell
        cell.labelText.text =  dataTitle[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataTitle.count
    }
}
