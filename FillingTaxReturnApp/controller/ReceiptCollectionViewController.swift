//
//  ReceiptCollectionViewController.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/03/21.
//

import UIKit

class ReceiptCollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var receipts: [Receipt] = AppDataModel.getReceipts()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        receipts = AppDataModel.getReceipts()
        
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "ReceiptViewCell", bundle: nil), forCellWithReuseIdentifier: "ReceiptViewCell")
        
        let layout = UICollectionViewFlowLayout()
        let layoutWidth = collectionView.frame.width * 0.8
        layout.itemSize = CGSize(width: layoutWidth , height: layoutWidth * (5/3))
        collectionView.collectionViewLayout = layout
        
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

extension ReceiptCollectionViewController: UICollectionViewDataSource{
    
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
        }
        
        return cell
    }

}
