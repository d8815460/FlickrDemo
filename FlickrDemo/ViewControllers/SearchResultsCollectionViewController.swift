//
//  SearchResultsCollectionViewController.swift
//  FlickrDemo
//
//  Created by 陳駿逸 on 2020/3/3.
//  Copyright © 2020 陳駿逸. All rights reserved.
//

import UIKit
import AVFoundation
import MJRefresh
import RealmSwift

private let reuseIdentifier = "PhotoCell"

class SearchResultsCollectionViewController: UICollectionViewController {
    
    var searchText: String?
    var limit:Int?
    private var photos:[Photo] = [Photo]()
    private var cellItemWidth = Float(0.0)
    private var page = 1
    private var hasMore = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        loadData()
    }
    
    private func configView() {
        title = "搜尋結果 \((searchText)!)"
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
        
        if self.hasMore == false { return }
        
        let searchURL = FlickrAPI.shared.flickrURLFromParameters(searchString: self.searchText!, perPageCount: "\(self.limit ?? 0)", page: "\(self.page)")
        
        FlickrAPI.shared.getPhotos(searchURL: searchURL.absoluteString) { (results, error) in
            if error == nil {
                let old = self.photos
                let new = results?.photos.photo
                let all = old + new!
                
                self.photos.removeAll()
                self.photos = all
                
                self.page = (results?.photos.page ?? 1) + 1
                self.hasMore = (results?.photos.page ?? 1) >= (results?.photos.page ?? 1)
                self.refrshLoadMoreControlWithFull(hasMore: self.hasMore)
                self.collectionView.reloadData()
                self.collectionView.layoutIfNeeded()
            } else {
                if let error = error {
                    self.showErrorAlert(error)
                }
            }
            self.endRefreshing()
        }
    }

    @objc func refresh() {
        collectionView.isScrollEnabled = false
        self.photos = [Photo]()
        self.page = 1
        if let layout = collectionView?.collectionViewLayout as? CustomClassLayout {
            layout.delegate = self
            layout.contentHeight = 0
        }
        self.loadData()
    }
    
    func endRefreshing() {
        if collectionView.mj_header != nil {
            self.collectionView.mj_header?.endRefreshing()
        }
        self.collectionView.isScrollEnabled = true
    }
    
    // MARK: -LoadMore
    func refrshLoadMoreControlWithFull(hasMore: Bool) {
        if self.collectionView.mj_footer == nil {
            self.collectionView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
                self.loadData()
            })
        }
        
        if hasMore == false {
            self.collectionView.mj_footer?.endRefreshingWithNoMoreData()
        } else {
            self.collectionView.mj_footer?.endRefreshing()
        }
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
}

extension SearchResultsCollectionViewController: CustomClassLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath, with width: CGFloat) -> CGFloat {
        let photo =  self.photos[indexPath.row]
        let boundingRect = CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        let ratio:CGSize?
        if photo.width_m == 0 {
            ratio = CGSize(width: 1, height: 1)
        } else {
            ratio = CGSize(width: CGFloat(photo.width_m ?? 0), height: CGFloat(photo.height_m ?? 0))
        }
        
        let rect =  AVMakeRect(aspectRatio: ratio!, insideRect: boundingRect)
        
        return rect.size.height + 50.0
    }
}

extension SearchResultsCollectionViewController: UICollectionViewDelegateFlowLayout {
    //UICollectionViewDataSource 代理
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        
        cell.photo = self.photos[indexPath.row]
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

extension SearchResultsCollectionViewController: PhotoCellDelegate {
    
    
    func didSelectLikeButton(photo: Photo, cell: PhotoCell) {
        let realm = try! Realm()
        if cell.likeButton.isSelected {
            cell.likeButton.isSelected = false
            let dbphoto = realm.object(ofType: DBPhoto.self, forPrimaryKey: photo.id)!
            try! realm.write {
                dbphoto.islike = false
            }
        } else {
            cell.likeButton.isSelected = true
            let dbphotoIsExisting = realm.objects(DBPhoto.self).filter("id = '\(photo.id)'").first
            if dbphotoIsExisting != nil {
                try! realm.write {
                    dbphotoIsExisting?.islike = true
                }
            } else {
                let dbphoto = DBPhoto()
                dbphoto.id = photo.id
                dbphoto.height_m = photo.height_m ?? 0
                dbphoto.width_m = photo.width_m ?? 0
                dbphoto.url_m = photo.url_m ?? ""
                dbphoto.islike = true
                try! realm.write {
                    realm.add(dbphoto)
                }
            }
            
        }
    }
    
    func didSelectLikeButton(dbPhoto: DBPhoto, cell: PhotoCell) {
        
    }
}
