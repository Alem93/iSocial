//
//  Post.swift
//  iSocial
//
//  Created by Alejandro Mamchur on 8/20/17.
//  Copyright © 2017 Alejandro Mamchur. All rights reserved.
//

import Foundation
import Firebase

class Post {
    
    private var _caption: String!
    private var _imageUrl: String!
    private var _likes: Int!
    private var _postKey: String!
    private var _postRef: FIRDatabaseReference!
    
    var caption: String {
        return self._caption
    }
    
    var imageUrl: String {
        return self._imageUrl
    }
    
    var likes: Int {
        return self._likes
    }
    
    var postKey: String {
        return self._postKey
    }
    
    var postRef: FIRDatabaseReference {
        return self._postRef
    }
    
    
    init(caption: String, imageUrl: String, likes: Int) {
        self._caption = caption
        self._imageUrl = caption
        self._likes = likes
    }
    
    init(postKey: String, postData: Dictionary<String, Any>){
        self._postKey = postKey
        
        if let caption = postData["caption"] as? String {
            self._caption = caption
        }
        
        if let imageUrl = postData["imageUrl"] as? String {
            self._imageUrl = imageUrl
        }
        
        if let likes = postData["likes"] as? Int {
            self._likes = likes
        }
        
        _postRef = DataService.ds.REF_POSTS.child(_postKey)
    }
    
    func adjustLikes(addLike: Bool){
        if addLike {
            _likes = _likes + 1
        } else {
            _likes = _likes - 1
        }
        _postRef.child("likes").setValue(_likes)
    }
}








