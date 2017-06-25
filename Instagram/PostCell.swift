//
//  PostCell.swift
//  Instagram
//
//  Created by PRIYESH  on 23/04/17.
//  Copyright © 2017 PRIYESH . All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {

    @IBOutlet weak var profilepic: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UIImageView!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var likes: UILabel!
    
    @IBOutlet weak var likebtn: UIButton!
    var liked = false
    
    @IBAction func likebtnpressed(_ sender: Any) {
        if liked == false {
        likebtn.setBackgroundImage(UIImage(named:"filled-heart"), for: .normal)
            liked = true
        }
        else{
            likebtn.setBackgroundImage(UIImage(named:"empty-heart"), for: .normal)
            liked = false
        }
    
    }
    
    
    func updateui(post : Posts,img : UIImage? = nil,pp : UIImage)
    {
       let pref = FIRStorage.storage().reference(forURL: post.profileimgurl)
        if pref != nil {
            pref.data(withMaxSize: 1*1024*1024, completion: { (data, error) in
                if error == nil {
                    if let imgdata = data {
                        self.profilepic.image = UIImage(data: imgdata)
                    }
                }
            })
            
            
            
            
        } 
        self.title.text = "New Post"
        self.caption.text = post.caption
        self.likes.text = "\(post.likes)"
        if img != nil {
            print("---------entered into if")
        self.content.image = img
        }else {
             print("---------entered into else")
            print(post.imageurl)

                let ref = FIRStorage.storage().reference(forURL: post.imageurl)
            print("post")
            print("--------------------------\(ref)")
                ref.data(withMaxSize: 1*1024*1024 ,completion : { (data,error) in
                    if error != nil {
                        print("--------------error")
                    }
                    print("downloading")
                    if let imgdata = data {
                        if let image = UIImage(data: imgdata)
                        {
                            self.content.image = image
                        
                            NewsFeed.localcache.setObject(image, forKey: NSString(string : post.imageurl))
                            print("added to cache")
                        }
                    }
             
                    
                    
                })
            
        }
    }
}

    
    
    
    

