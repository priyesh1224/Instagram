//
//  NewsFeed.swift
//  Instagram
//
//  Created by PRIYESH  on 14/04/17.
//  Copyright © 2017 PRIYESH . All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class NewsFeed: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var addimg: UIImageView!
    @IBOutlet weak var table: UITableView!
    var currentprofilepic = UIImage()
    var postarray = [Posts]()
    var currentuser = String()
    var imagepicker = UIImagePickerController()
    static var localcache: NSCache<NSString, UIImage> = NSCache()

    @IBOutlet weak var captionField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        imagepicker.allowsEditing =  true
        imagepicker.delegate = self
        self.table.delegate=self
        self.table.dataSource=self
        KeychainWrapper.standard.removeObject(forKey: "auth")
    //   self.currentuser = KeychainWrapper.standard.string(forKey: "auth")!
        DataServices.ds.postsdb.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.postarray.removeAll()
                for snap in snapshot {
                    if let postdict = snap.value as? Dictionary<String,AnyObject> {
                        let post = Posts(postkey: snap.key, postData: postdict)
                        print("$$$$$$$$$$$$$$$$$$$$\(snap.value)")
                        self.postarray.append(post)
                        self.table.reloadData()
                    }
                }
            }
        })

    }
    
    func updateprofilepictures(newpost : Posts)
    {
        let key = KeychainWrapper.standard.string(forKey: "auth")
        if let url : String =  newpost.profileimgurl
        {
            let ref = FIRStorage.storage().reference(forURL: url as! String)
            ref.data(withMaxSize: 1*1024*1024 ,completion : { (data,error) in
                if error != nil {
                }
                if let imgdata = data {
                    if let image = UIImage(data: imgdata)
                    {
                    self.currentprofilepic=image
                    }
                }
        })
        }
    
    }
    
    
    @IBAction func postBtnClicked(_ sender: Any) {
        if let cap = self.captionField.text {
            if let im = addimg.image {
                if im != UIImage(named: "add-image") {

                    if let imgdata = UIImageJPEGRepresentation(im, 0.2) {
                    let imguid = NSUUID().uuidString
                        let metadata = FIRStorageMetadata()
                        metadata.contentType = "image/jpeg"
                        DataServices.ds.storageposts.child(imguid).put(imgdata, metadata: metadata) { (metadata , error) in
                            let downloadurl = metadata?.downloadURL()?.absoluteString
                            let newpost = Posts(postkey: imguid, postData: ["caption":cap as AnyObject,"imageurl":downloadurl as AnyObject,"user": self.currentuser as AnyObject,"profileimgurl":"https://firebasestorage.googleapis.com/v0/b/ins" as AnyObject])
                    /*        DataServices.ds.postsdb.child(imguid).updateChildValues(["caption":cap as AnyObject,"imageurl":downloadurl as AnyObject,"user": self.currentuser as AnyObject,"profileimgurl":"https://firebasestorage.googleapis.com/v0/b/ins"]) */
                            
                            self.captionField.text = ""
                            self.addimg.image = UIImage(named: "add-image")
                            self.captionField.resignFirstResponder()

                        }
                                       }
                    table.reloadData()
                }
            }
        }
        
    }
    
    @IBAction func imagetapped(_ sender: Any) {
        present(imagepicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let im = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            self.addimg.image = im
            addimg.contentMode = .scaleAspectFit
            
        }
        imagepicker.dismiss(animated : true,completion: nil)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.postarray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell {
            if let img = NewsFeed.localcache.object(forKey: postarray[indexPath.row].imageurl as NSString) {
                cell.updateui(post: postarray[indexPath.row],img: img,pp:currentprofilepic)
            return cell
            }else {
                
                cell.updateui(post: postarray[indexPath.row],img: nil,pp:currentprofilepic)
                return cell
            }
        }
        return UITableViewCell()
    }
   
    
    @IBAction func signout(_ sender: Any) {
        KeychainWrapper.standard.remove(key: "auth")
        performSegue(withIdentifier: "gotologin", sender: nil)

    }

}
