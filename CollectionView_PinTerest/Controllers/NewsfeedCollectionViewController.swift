//
//  NewsfeedCollectionViewController.swift
//  CollectionView_PinTerest
//
//  Created by ngovantucuong on 8/27/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

private let reuseIdentifier = "PostCell"

class NewsfeedCollectionViewController: UIViewController{

    @IBOutlet weak var collectionPost: UICollectionView!
    var post:[Post]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        collectionPost.dataSource = self
        collectionPost.delegate = self
        // Do any additional setup after loading the view.
        self.fetchPost()
        collectionPost.contentInset = UIEdgeInsets(top: 12, left: 4, bottom: 12, right: 4)
        if let layout = collectionPost.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchPost() {
        self.post = Post.fetchPosts()
        collectionPost.reloadData()
    }
}

extension NewsfeedCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let post = post {
            return post.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionPost.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PostCollectionViewCell
        cell.post = post?[indexPath.item]
        return cell
    }
}

extension NewsfeedCollectionViewController: PinterestLayoutDelegate {
    func collectionView(collectionView: UICollectionView, forHeightPhoToAt indexPath: IndexPath, with Width: CGFloat) -> CGFloat {
        if let post = post?[indexPath.item], let photo = post.image {
           let boundingRect = CGRect(x: 0, y: 0, width: Width, height: CGFloat(MAXFLOAT))
            let rect = AVMakeRect(aspectRatio: photo.size, insideRect: boundingRect)
            return rect.size.height
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, forHeightCaptionAt indexPath: IndexPath, with Width: CGFloat) -> CGFloat {
        if let post = post?[indexPath.item] {
            let topPadding: CGFloat = CGFloat(6.0)
            let bottomPadding: CGFloat = CGFloat(12.0)
            let captionFont = UIFont.systemFont(ofSize: 15.0)
            let heightCaption = self.height(for: post.caption! as NSString, with: captionFont, width: Width)
            let heightProfileImage: CGFloat = CGFloat(36.0)
            let height = topPadding + heightCaption + topPadding + heightProfileImage + bottomPadding
            return height
        }
        return 0
    }
    
    func height(for Text: NSString, with Font: UIFont, width: CGFloat) -> CGFloat{
        let text = NSString(string: Text)
        let maxHeight: CGFloat = CGFloat(64.0)
        let textAttributes = [NSAttributedStringKey.font: Font]
        let boudingRect = text.boundingRect(with: CGSize(width: width, height: maxHeight) , options:.usesLineFragmentOrigin, attributes: textAttributes, context: nil)
        return ceil(boudingRect.size.height)
    }
}
