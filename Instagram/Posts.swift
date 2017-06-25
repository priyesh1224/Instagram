//
//  Posts.swift
//  Instagram
//
//  Created by PRIYESH  on 01/05/17.
//  Copyright © 2017 PRIYESH . All rights reserved.
//

import Foundation
class Posts {
    
    private var _caption : String = ""
    private var _imageurl : String = ""
    private var _likes : Int = 0
    private var _postKey : String = ""
    private var _profileimgurl = ""
    var profileimgurl : String {
        return _profileimgurl
    }
    var caption : String {
        return _caption
    }
    var imageurl : String {
        return _imageurl
    }
    var likes : Int {
        return _likes
    }
    var postKey : String{
        return _postKey
    }
    init(postkey : String,postData : Dictionary<String,AnyObject>)
    {
        if let pk : String = postkey {
        self._postKey = pk
        }
        if let capt = postData["caption"]
        {
            self._caption = capt as! String
        }
        if let img = postData["imageurl"] {
            self._imageurl = img as! String
        }
        if let purl = postData["profileimgurl"]
        {
            self._profileimgurl = purl as! String
        }
        //if let likes = postData["likes"] {
        //    self._likes = likes as! Int
        //}
    DataServices.ds.postsdb.child(postkey).updateChildValues(postData)
    }
    
    
}
