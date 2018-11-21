//
//  VictorProfileController.swift
//  CVApp
//
//  Created by Victor Chang on 13/10/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit
import SafariServices

protocol WebViewDelegate {
    func toWebPage(url: String?)
}

class VictorProfileController: UICollectionViewController, WebViewDelegate, UIViewControllerTransitioningDelegate {
    
    func toWebPage(url: String?) {
        guard let url = url else { return }
        if let url = URL(string: url) {
            let config = SFSafariViewController.Configuration()
            let viewController = SFSafariViewController(url: url, configuration: config)
            viewController.preferredBarTintColor = UIColor.black
            viewController.preferredControlTintColor = UIColor.white
            viewController.transitioningDelegate = self //use default modal presentation instead of push
//            present(viewController, animated: true, completion: nil)
            present(viewController, animated: true) {
                var frame = viewController.view.frame
                frame.size = CGSize(width: frame.width, height: frame.height + 44.0)
                viewController.view.frame = frame
            }
        }
    }
    
    private var cellId = "cellId"
    private var headerId = "victorHeader"
    var photos = Photo.allPhotos()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.title = "About Me"
        navigationController?.navigationBar.prefersLargeTitles = true
        collectionView.backgroundColor = .white
        collectionView.register(VictorProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(VictorProfileCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView?.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

extension VictorProfileController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! VictorProfileHeader
            header.webViewDelegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
//        return CGSize(width: view.frame.width, height: (view.frame.height / 3))
//        let size = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
//        return size
        
        return CGSize(width: self.collectionView.bounds.width, height: 258)
        
    }
}

extension VictorProfileController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

//        let width = (view.frame.width - 2) / 2
//        return CGSize(width: width, height: width)

        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: itemSize)

    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        
        if let cell = cell as? VictorProfileCell {
            cell.photo = photos[indexPath.item]
        }
        return cell
        
    }
}
