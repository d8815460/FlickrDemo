//
//  PhotoCell.swift
//  FlickrDemo
//
//  Created by 陳駿逸 on 2020/3/3.
//  Copyright © 2020 陳駿逸. All rights reserved.
//

import UIKit
import RealmSwift

protocol PhotoCellDelegate {
    func didSelectLikeButton(photo: Photo, cell: PhotoCell)
    func didSelectLikeButton(dbPhoto: DBPhoto, cell: PhotoCell)
}

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    var delegate: PhotoCellDelegate?
    
    var photo:Photo? {
        didSet {
            title.text = self.photo?.title ?? ""
            self.image.image = UIImage()
            fetchImage(self.photo?.url_m ?? "")
            let id = (self.photo?.id)!
            if let realm = try? Realm(), (realm.objects(DBPhoto.self).count) > 0, let photo = realm.objects(DBPhoto.self).filter("id = '\(id)'").first {
                likeButton.isSelected = photo.islike
            } else {
                likeButton.isSelected = false
            }
        }
    }
    
    var dbPhoto:DBPhoto? {
        didSet {
            title.text = self.dbPhoto?.title ?? ""
            self.image.image = UIImage()
            fetchImage(self.dbPhoto?.url_m ?? "")
            likeButton.isSelected = self.dbPhoto?.islike ?? false
        }
    }
    
    private func fetchImage(_ url: String) {
        if url == "" {
            self.image.image = UIImage()
            return
        }
        let imageURL = URL(string: url)
        let task = URLSession.shared.dataTask(with: imageURL!) { (data, response, error) in
            if error == nil {
                let downloadImage = UIImage(data: data!)!
                DispatchQueue.main.async(){
                    self.image.image = downloadImage
                }
            }
        }
        task.resume()
    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        if photo != nil {
            self.delegate?.didSelectLikeButton(photo: self.photo!, cell: self)
        } else {
            self.delegate?.didSelectLikeButton(dbPhoto: self.dbPhoto!, cell: self)
        }
    }
}
