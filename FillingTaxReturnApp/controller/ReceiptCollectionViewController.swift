//
//  ReceiptCollectionViewController.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/03/21.
//

import UIKit

class ReceiptCollectionViewController: UIViewController, UICollectionViewDataSource {
    
    private var receipts: [Receipt] = AppDataModel.getReceipts()
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        receipts = AppDataModel.getReceipts()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        collectionView.register(UINib(nibName: "ReceiptViewCell", bundle: nil), forCellWithReuseIdentifier: "ReceiptViewCell")
        
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
//        collectionView.minimumInteritemSpacing = 8
        
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

extension ReceiptCollectionViewController{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return receipts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReceiptViewCell", for: indexPath)
        
        if let cell = cell as? ReceiptViewCell{
            cell.setupCell(receipt: receipts[indexPath.row])
            cell.layer.cornerRadius = 10
        }
        
        return cell
    }
}

extension ReceiptCollectionViewController: UICollectionViewDelegateFlowLayout {
    // [1]
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: cellWidth - 1, height: cellWidth * 5/3)
    }

    private var cellWidth: CGFloat {
        let availableWidth = collectionView.bounds.inset(by: collectionView.adjustedContentInset).width
        let interColumnSpace = CGFloat(8)
        let numColumns = CGFloat(2)
        let numInterColumnSpaces = numColumns - 1
        
        print(((availableWidth - interColumnSpace * numInterColumnSpaces) / numColumns).rounded(.down))

        return ((availableWidth - interColumnSpace * numInterColumnSpaces) / numColumns).rounded(.down)
    }
}
