//
//  HomeController.swift
//  CVApp
//
//  Created by Victor Chang on 09/10/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    
    private var posts = [Post]()
    var user: User?
    var header: HomeHeader?
    
    
    private var cellId = "cellId"
    private var headerId = "homeHeader"
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Home"
        
        setupCollectionView()
        setupHeaderSeparator()
        self.collectionView?.refreshControl?.endRefreshing()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        fetchAllposts()
        handleRefresh()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @objc fileprivate func handleRefresh() {

        print("Handling refresh...")
        posts.removeAll()
        collectionView?.reloadData()
        fetchAllposts()

        
    }
    
    fileprivate func setupCollectionView() {
        collectionView?.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        collectionView.register(HomeHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.contentInsetAdjustmentBehavior = .never
    }
    
    fileprivate func setupHeaderSeparator() {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = .init(top: 16, left: 0, bottom: 0, right: 0)
    }
    
    fileprivate func fetchPost() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.fetchPostWithUser(user: user)
        }
    }
    
    fileprivate func fetchPostWithUser(user: User) {
        
        let ref = Database.database().reference().child("posts").child(user.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.collectionView?.refreshControl?.endRefreshing()

            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else { return }
                
                var post = Post(user: user, dictionary: dictionary)
                post.id = key
                self.posts.append(post)
                self.posts.sort(by: { (p1, p2) -> Bool in
                    return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                })
                self.collectionView?.reloadData()
            })
           
        }) { (error) in
            print("Failed to fecth posts: ", error)
        }
    }
    fileprivate func fetchAllposts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("posts").observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userIdDictionary = snapshot.value as? [String: Any] else { return }
            
            userIdDictionary.forEach({ (key, value) in
                Database.fetchUserWithUID(uid: key, completion: { (user) in
                    self.fetchPostWithUser(user: user)
                })
            })
        }) { (error) in
            print("Failed to fetch following users id: ", error)
            }
        }

}

extension HomeController {
    
    
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let contentOffsetY = scrollView.contentOffset.y
//        print(contentOffsetY)
//
//        if contentOffsetY > 0 {
//            header?.animator.fractionComplete = 0
//            return
//        }
//
//        header?.animator.fractionComplete = abs(contentOffsetY) / 100
//    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as? HomeHeader
        
        return header!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: view.frame.width, height: view.frame.height / 4)
        return CGSize(width: view.frame.width, height: 300)
    }
}

extension HomeController {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = HomePostCell(frame: frame)
        dummyCell.post = posts[indexPath.item]
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 200)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)

        let height = max(40 + 8 + 8, estimatedSize.height)
        return CGSize(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
  
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell 
        cell.post = posts[indexPath.item]
        return cell
    }
    
}





