//
//  ReceiptCollectionViewController.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/03/21.
//

import UIKit

class ReceiptCollectionViewController: UIViewController, UICollectionViewDataSource {
    
    private var receipts: [Receipt] = AppDataModel.getReceipts()
    private var selectedCellsReceiptUUIDs: [UUID] = [UUID]()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    private var animator: UIViewPropertyAnimator!
    private var isSettingButtonsShowed = false
    private var didViewLoad = false
    
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
    
    override func viewDidLayoutSubviews() {
        if didViewLoad == false{
            buttonSetting()
            didViewLoad = true
        }
    }
    
    
    @IBAction func onSettingButtonClick(_ sender: Any){
        
        let visibleCells = collectionView.visibleCells as! [ReceiptViewCell]
        
        if isSettingButtonsShowed == false{
            for cell in visibleCells {
                cell.acitivateSettingMode()
                checkAlreadySelectedCell(receiptViewCell: cell)
            }
        }
        else {
            for cell in visibleCells {
                cell.inactivateSettingMode()
            }
            selectedCellsReceiptUUIDs.removeAll()
        }
        
        settingButtonAnimation()
    }
    
    private func buttonSetting(){
        trashButton.center = settingButton.center
        addButton.center = settingButton.center
        trashButton.isHidden = true
        addButton.isHidden = true
        trashButton.tintColor = UIColor.white
        addButton.tintColor = UIColor.white
    }
    
    private func settingButtonAnimation(){
        if isSettingButtonsShowed {
            animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut){
                self.trashButton.center.y += 100
                self.addButton.center.y += 50
                self.settingButton.transform = CGAffineTransform(rotationAngle: 0)
            }
            animator.addCompletion{ _ in
                self.trashButton.isHidden = true
                self.addButton.isHidden = true
            }
        }
        else{
            trashButton.isHidden = false
            addButton.isHidden = false
            animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut){
                self.trashButton.center.y -= 100
                self.addButton.center.y -= 50
                self.settingButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi/180*180)
            }
            
        }
        
        isSettingButtonsShowed = !isSettingButtonsShowed
        
        animator.startAnimation()
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? ReceiptViewCell{
            cell.setupCell(receipt: receipts[indexPath.row])
            if isSettingButtonsShowed{
                cell.acitivateSettingMode()
                checkAlreadySelectedCell(receiptViewCell: cell)
            }
            else{
                cell.inactivateSettingMode()
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReceiptViewCell", for: indexPath)
        
        if let cell = cell as? ReceiptViewCell{
            cell.setupCell(receipt: receipts[indexPath.row])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        if let cell = cell as? ReceiptViewCell{
            cell.onSelect()
            if cell.getIsCellSelected(){
                selectedCellsReceiptUUIDs.append(cell.getReceipt().id!)
            }
            else {
                let index = selectedCellsReceiptUUIDs.firstIndex(of: cell.getReceipt().id!)
                if let index = index{
                    selectedCellsReceiptUUIDs.remove(at: index)
                }
            }
        }
    }
    
    private func checkAlreadySelectedCell(receiptViewCell: ReceiptViewCell){
        if selectedCellsReceiptUUIDs.contains(receiptViewCell.getReceipt().id!){
            receiptViewCell.setIsCellSelected(selected: true)
        }
    }
}

extension ReceiptCollectionViewController: UICollectionViewDelegateFlowLayout {
    // [1]
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: cellWidth - 1, height: cellWidth * 9/5)
    }

    private var cellWidth: CGFloat {
        let availableWidth = collectionView.bounds.inset(by: collectionView.adjustedContentInset).width
        let interColumnSpace = CGFloat(8)
        let numColumns = CGFloat(2)
        let numInterColumnSpaces = numColumns - 1

        return ((availableWidth - interColumnSpace * numInterColumnSpaces) / numColumns).rounded(.down)
    }
}
