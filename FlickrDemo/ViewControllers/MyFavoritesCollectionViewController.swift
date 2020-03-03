//
//  MyFavoritesCollectionViewController.swift
//  FlickrDemo
//
//  Created by 陳駿逸 on 2020/3/3.
//  Copyright © 2020 陳駿逸. All rights reserved.
//

import UIKit
import RealmSwift
import MJRefresh
import AVFoundation

private let reuseIdentifier = "Cell"

class MyFavoritesCollectionViewController: UICollectionViewController {

    var photos:Results<DBPhoto>?
    private var cellItemWidth = Float(0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configView()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }

    private func configView() {
        if let layout = collectionView?.collectionViewLayout as? CustomClassLayout {
            layout.delegate = self
        }
        collectionView?.backgroundColor = UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        collectionView?.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
        // Hide the time
        header.lastUpdatedTimeLabel!.isHidden = true
        // Hide the status
        header.stateLabel!.isHidden = true
        collectionView?.mj_header = header
    }
    
    private func loadData() {
        let realm = try? Realm()
        photos = realm?.objects(DBPhoto.self).filter("islike = true")
        self.collectionView.reloadData()
        self.collectionView.layoutIfNeeded()
    }
    
    @objc func refresh() {
        collectionView.isScrollEnabled = false
        if let layout = collectionView?.collectionViewLayout as? CustomClassLayout {
            layout.delegate = self
            layout.contentHeight = 0
        }
        let realm = try? Realm()
        photos = realm?.objects(DBPhoto.self).filter("islike = true")
        self.endRefreshing()
        self.collectionView.reloadData()
        self.collectionView.layoutIfNeeded()
    }
    
    func endRefreshing() {
        if collectionView.mj_header != nil {
            self.collectionView.mj_header?.endRefreshing()
        }
        self.collectionView.isScrollEnabled = true
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
}

extension MyFavoritesCollectionViewController: CustomClassLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath, with width: CGFloat) -> CGFloat {
        if indexPath.row + 1 > self.photos!.count { return 0 }
        let photo =  self.photos?[indexPath.row]
        let boundingRect = CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        let ratio:CGSize?
        if photo?.width_m == 0 {
            ratio = CGSize(width: 1, height: 1)
        } else {
            ratio = CGSize(width: CGFloat(photo?.width_m ?? 1), height: CGFloat(photo?.height_m ?? 1))
        }
        
        let rect =  AVMakeRect(aspectRatio: ratio!, insideRect: boundingRect)
        
        return rect.size.height + 50.0
    }
}

extension MyFavoritesCollectionViewController: UICollectionViewDelegateFlowLayout {
    //UICollectionViewDataSource 代理
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        
        cell.dbPhoto = self.photos?[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        self.cellItemWidth = Float(itemSize)
        return CGSize(width: itemSize, height: itemSize)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator){
        super.viewWillTransition(to: size, with: coordinator)
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
}

extension MyFavoritesCollectionViewController: PhotoCellDelegate {
    func didSelectLikeButton(photo: Photo, cell: PhotoCell) {
        
    }
    
    func didSelectLikeButton(dbPhoto: DBPhoto, cell: PhotoCell) {
        let realm = try! Realm()
        if cell.likeButton.isSelected {
            cell.likeButton.isSelected = false
            try! realm.write {
                dbPhoto.islike = false
            }
        } else {
            cell.likeButton.isSelected = true
            try! realm.write {
                dbPhoto.islike = true
            }
        }
    }
}
