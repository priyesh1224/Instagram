//
//  DataServices.swift
//  Instagram
//
//  Created by PRIYESH  on 01/05/17.
//  Copyright © 2017 PRIYESH . All rights reserved.
//

import Foundation
import Firebase
let ref : FIRDatabaseReference = FIRDatabase.database().reference()
let storage = FIRStorage.storage().reference()

class DataServices
{
    static let ds  = DataServices()
        private let posts:FIRDatabaseReference = ref.child("posts")
    private let users:FIRDatabaseReference = ref.child("users")
    private let stor = storage.child("post-pics")

    var  postsdb : FIRDatabaseReference {
        return posts
    }
    var  usersdb : FIRDatabaseReference{
        return users
    }
    var storageposts : FIRStorageReference {
        return stor
    }
    var storageprofilepics : FIRStorageReference {
        return storage.child("users")
    }
    func createUser(uid : String, userdata : Dictionary<String,String>){
        usersdb.child(uid).updateChildValues(userdata)
    
    }

}
