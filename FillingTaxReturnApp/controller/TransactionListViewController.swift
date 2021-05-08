//
//  TransactionListViewController.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/04/26.
//

import UIKit

class TransactionListViewController: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet weak var dateCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateCollectionView.dataSource = self
        dateCollectionView.delegate = self
        
        dateCollectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
//        dateCollectionView.collectionViewLayout = UICollectionViewLayout()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TransactionListViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath)
        
        if let cell = cell as? DateCell {
            cell.setupCell(date: Date())
            cell.backgroundColor = .white
//            cell.cornerRadius = 5
//            cell.borderColor = .black
//            cell.layer.borderWidth = 0.5
        }
        
        return cell
    }
}

extension TransactionListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace : CGFloat = 80
        let cellSize : CGFloat = self.view.bounds.width/3 - horizontalSpace
        return CGSize.init(width: horizontalSpace, height: 50)
    }
    
}
