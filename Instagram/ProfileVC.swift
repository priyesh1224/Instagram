//
//  ProfileVC.swift
//  Instagram
//
//  Created by PRIYESH  on 27/05/17.
//  Copyright © 2017 PRIYESH . All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase


class ProfileVC: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    
    @IBOutlet weak var imgbtn: UIButton!
    @IBOutlet weak var profileimage: UIImageView!
    @IBOutlet weak var username: UITextField!
    var selectedimg = UIImage()
    var imgpicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        imgpicker.delegate=self
        // Do any additional setup after loading the view.
    }

   
    

    @IBAction func profileimagepressed(_ sender: Any) {
        present(imgpicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let img = info[UIImagePickerControllerOriginalImage] as? UIImage
              self.selectedimg=img!
        imgbtn.setBackgroundImage(selectedimg, for: .normal)
        
        
        imgpicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func donebtnpressed(_ sender: Any) {
        let meta = FIRStorageMetadata()
        meta.contentType = "image/jpeg"
        if let image = self.selectedimg as? UIImage {
            if let im = UIImageJPEGRepresentation(image, 0.2) {
            DataServices.ds.storageprofilepics.child(KeychainWrapper.standard.string(forKey: "auth")!).put(im, metadata: meta) { (meta , error) in
                if let url = meta?.downloadURL()?.absoluteString {
                    DataServices.ds.usersdb.child(KeychainWrapper.standard.string(forKey: "auth")!).child("profilepic").updateChildValues(["profileurl":url])
                }
            }
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    /* MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
