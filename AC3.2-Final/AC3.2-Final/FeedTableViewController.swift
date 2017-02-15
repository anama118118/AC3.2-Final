//
//  FeedTableViewController.swift
//  AC3.2-Final
//
//  Created by Ana Ma on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
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
        
        let storage = FIRStorage.storage()
        let storageRef = storage.reference()
        let spaceRef = storageRef.child("images/\(post.key)")
        spaceRef.data(withMaxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print(error)
            } else {
                // Data for "images/island.jpg" is returned
                let image = UIImage(data: data!)
                cell.feedImageView.image = image
            }
        }
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
