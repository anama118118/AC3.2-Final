//
//  FeedTableViewController.swift
//  AC3.2-Final
//
//  Created by Ana Ma on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseStorage
import FirebaseDatabase

class FeedTableViewController: UITableViewController {
    
    var databaseReference: FIRDatabaseReference!
    var posts: [Post] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Cache
    var cache = NSCache<NSString, NSData>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.databaseReference = FIRDatabase.database().reference().child("posts")
        tableView.estimatedRowHeight = 400
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getLinks()
    }
    
    func getLinks() {
        databaseReference.observeSingleEvent(of: .value, with: { (snapshot) in
            var newPosts: [Post] = []
            for child in snapshot.children {
                dump(child)
                if let snap = child as? FIRDataSnapshot,
                    let valueDict = snap.value as? [String:String] {
                    let post = Post(key: snap.key, comment: valueDict["comment"] ?? "No Comment Uploaded", userId: valueDict["userId"] ?? "")
                    //Newest posts will be at the top of the tableView
                    newPosts.insert(post, at: 0)
                    //newPosts.append(post)
                }
            }
            self.posts = newPosts
            self.tableView.reloadData()
        })
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedTableViewCellIdentifier", for: indexPath) as! FeedTableViewCell
        let post = posts[indexPath.row]
        cell.feedTextView.text = post.comment
        
        if let dataCache = self.cache.object(forKey: post.key as NSString){
            cell.feedImageView.image = UIImage(data: dataCache as Data)
        } else {
            let storage = FIRStorage.storage()
            let storageRef = storage.reference()
            let spaceRef = storageRef.child("images/\(post.key)")
            spaceRef.data(withMaxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print(error)
                } else {
                    let image = UIImage(data: data!)
                    cell.feedImageView.image = image
                    self.cache.setObject(data! as NSData, forKey: post.key as NSString)
                }
            }
        }
        return cell
    }
}
