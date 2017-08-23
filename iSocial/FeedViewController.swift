//
//  FeedViewController.swift
//  iSocial
//
//  Created by Alejandro Mamchur on 8/18/17.
//  Copyright © 2017 Alejandro Mamchur. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var posts = [Post]()
    private var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    private var imageSelected = false
    
    @IBOutlet weak var captionField: FancyTextField!
    @IBOutlet weak var imageAdd: CircleImageView!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        DataService.ds.REF_POSTS.observe(.value, with: {(snapshot) in
            
            self.posts = []
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    if let postDict = snap.value as? Dictionary<String, Any>{
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.posts.reverse()
            self.tableView.reloadData()
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostTableViewCell {
            if let img = FeedViewController.imageCache.object(forKey: post.imageUrl as NSString){
                cell.configureCell(post: post, img: img)
            } else {
                cell.configureCell(post: post)
            }
            return cell
        } else {
            return PostTableViewCell()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            imageAdd.image = image
            imageSelected = true
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    @IBAction func addImageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func postButtonTapped(_ sender: Any) {
        guard let caption = captionField.text, caption != "" else {
            return
        }
        guard let img = imageAdd.image, imageSelected == true else {
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 2.0) {
            let imgUid = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            DataService.ds.REF_POST_IMAGES.child(imgUid).put(imgData, metadata: metadata) {(metadata,error) in if error == nil {
                if let downloadUrl = metadata?.downloadURL()?.absoluteString {
                    self.postToFirebase(imageUrl: downloadUrl)
                }
                }
            }
        }
    }
    
    func postToFirebase(imageUrl: String){
        let post: Dictionary<String, Any> = [
            "caption": captionField.text!,
            "imageUrl": imageUrl,
            "likes": 0
        ]
        
        let fireBasePost = DataService.ds.REF_POSTS.childByAutoId()
        fireBasePost.setValue(post)
        
        self.imageSelected = false
        self.captionField.text = ""
        self.imageAdd.image = UIImage(named: "add-image")
        
        
        tableView.reloadData()
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        KeychainWrapper.defaultKeychainWrapper.remove(key: KEY_UID)
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
}
