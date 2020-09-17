//
//  HomeViewController.swift
//  Covid19App
//
//  Created by Hishara on 9/14/20.
//  Copyright © 2020 Hishara. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionViewNews: UICollectionView!
    
    let firebaseOP = FirebaseOP()
    
    var names = ["Anders", "Kristian", "Sofia", "John", "Jenny", "Lina", "Annie", "Katie", "Johanna"]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        addBottonStatView()
        registerNib()
        firebaseOP.loadNewsData()
    }
    
    func addBottonStatView() {
        let bottomSheetVC = StatBottomBarViewController()
        
        self.addChild(bottomSheetVC)
        self.view.addSubview(bottomSheetVC.view)
        bottomSheetVC.didMove(toParent: self)
        
        let height = view.frame.height
        let width  = view.frame.width
        bottomSheetVC.view.frame = CGRect(x: 0, y: view.frame.maxY, width: width, height: height)
    }
    
    func registerNib() {
        let nib = UINib(nibName: NewsCollectionViewCell.nibName, bundle: nil)
        collectionViewNews?.register(nib, forCellWithReuseIdentifier: NewsCollectionViewCell.reuseIdentifier)
        if let flowLayout = self.collectionViewNews?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        }
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

extension HomeViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return names.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionViewNews.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.reuseIdentifier,
                                                         for: indexPath) as? NewsCollectionViewCell {
            let name = names[indexPath.row]
            cell.configureCell(data: name)
            return cell
        }
        return UICollectionViewCell()
    }
    
}

extension HomeViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell: NewsCollectionViewCell = Bundle.main.loadNibNamed(NewsCollectionViewCell.nibName,
                                                                      owner: self,
                                                                      options: nil)?.first as? NewsCollectionViewCell else {
            return CGSize.zero
        }
        cell.configureCell(data: names[indexPath.row])
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        let size: CGSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return CGSize(width: size.width, height: 120)
    }
    
}
