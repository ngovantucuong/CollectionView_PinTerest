//
//  PostCollectionViewCell.swift
//  CollectionView_PinTerest
//
//  Created by ngovantucuong on 8/27/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var postImageViewLayoutContraint: NSLayoutConstraint!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var usernameLable: UILabel!
    @IBOutlet weak var captionLable: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var post: Post! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI() {
        self.profileImageView.image = post.createdBy.profileImage
        self.profileImageView.layer.cornerRadius = 3
        self.profileImageView.layer.masksToBounds = true
        
        self.usernameLable.text = post.createdBy.username
        self.timeAgoLabel.text = post.timeAgo
        self.captionLable.text = post.caption
        
        self.postImageView.image = post.image
        self.postImageView.layer.cornerRadius = 5.0
        self.postImageView.layer.masksToBounds = true
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? PinterestLayoutAttribute {
            postImageViewLayoutContraint.constant = attributes.photoHeight
        }
    }
}
