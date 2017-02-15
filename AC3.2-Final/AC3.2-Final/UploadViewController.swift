//
//  UploadViewController.swift
//  AC3.2-Final
//
//  Created by Ana Ma on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import AVFoundation

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // Outlets and variables
    @IBOutlet weak var uploadImageView: UIImageView!
    @IBOutlet weak var uploadTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var uploadImageViewTapGestureRecognizer: UITapGestureRecognizer!
    
    var imagePickerController: UIImagePickerController!
    var databaseReference: FIRDatabaseReference!
    
    // ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.databaseReference = FIRDatabase.database().reference().child("posts")
        setTextFieldDelegates()
        registerForKeyboardNotifications()
    }
    
    // Keyboard
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        if let info = notification.userInfo,
            let sizeString = info[UIKeyboardFrameBeginUserInfoKey] as? NSValue {

            let keyboardSize = sizeString.cgRectValue
            
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
            
            var rect = self.view.frame
            
            rect.size.height -= keyboardSize.height
            
            if let field = uploadTextField {
                if !rect.contains(field.frame.origin) {
                    scrollView.scrollRectToVisible(field.frame, animated: true)
                }
            }
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset = .zero;
        scrollView.scrollIndicatorInsets = .zero;
    }

    // Upload to Firebase
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        let linkRef = self.databaseReference.childByAutoId()
        print("==========Inside put image into FireBase!!!!!!==========")
        print("linkRef: \(linkRef)")
        
        guard self.uploadImageView.image != #imageLiteral(resourceName: "camera_icon") else {
            let errorAlertController = UIAlertController(title: "Need Image", message: "Please select a photo in Photo Library", preferredStyle: UIAlertControllerStyle.alert)
            let okay = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            errorAlertController.addAction(okay)
            self.present(errorAlertController, animated: true, completion: nil)
            return
        }
        
        if let image = self.uploadImageView.image,
            let uploadComment = self.uploadTextField.text {
            let storage = FIRStorage.storage()
            let storageRef = storage.reference(forURL: "gs://ac-32-final.appspot.com")
            let spaceRef = storageRef.child("images/\(linkRef.key)")
            
            let jpeg = UIImageJPEGRepresentation(image, 0.5)
            
            let metadata = FIRStorageMetadata()
            metadata.cacheControl = "public,max-age=300";
            metadata.contentType = "image/jpeg";
            
            let _ = spaceRef.put(jpeg!, metadata: metadata) { (metadata, error) in
                if error != nil {
                    let alertController = UIAlertController(title: "Upload Failded", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                    let okay = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okay)
                    self.present(alertController, animated: true, completion: nil)
                }
                guard metadata != nil else {
                    let alertController = UIAlertController(title: "Upload Failded", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                    let okay = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okay)
                    self.present(alertController, animated: true, completion: nil)
                    print("put error")
                    return
                }
                
                let alertController = UIAlertController(title: "Photo Uploaded", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                let okay = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okay)
                self.present(alertController, animated: true, completion: nil)
                print(linkRef.key)
                self.uploadImageView.image = #imageLiteral(resourceName: "camera_icon")
                self.uploadTextField.text = nil
                self.uploadTextField.placeholder = "Add a description..."
            }
            
            guard let currentUser = FIRAuth.auth()?.currentUser else { return }
            
            let post = Post(key: linkRef.key, comment: uploadComment, userId: currentUser.uid )
            let dict = post.asDictionary
            
            // put in the database
            linkRef.setValue(dict) { (error, reference) in
                if let error = error {
                    print(error)
                }
                else {
                    print(reference)
                    // put in storage
                    
                    // done editing
                    self.uploadTextField.text = nil
                    self.uploadTextField.placeholder = "Add a description"
                    self.view.endEditing(true)
                }
            }
        }
    }
    
    // Tap Image View for Photos Library
    @IBAction func uploadImageViewTapped(_ sender: UITapGestureRecognizer) {
        showImagePickerForSourceType(sourceType: .photoLibrary, from: sender)
    }
    
    // MARK: - Image Picture Methods
    private func showImagePickerForSourceType(sourceType: UIImagePickerControllerSourceType, from sender: UITapGestureRecognizer) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.modalPresentationStyle = .currentContext
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        imagePickerController.modalPresentationStyle = (sourceType == .camera) ? .fullScreen : .popover
        
        self.imagePickerController = imagePickerController
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.uploadImageView.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - TextField Delegate Methods
    func setTextFieldDelegates() {
        uploadTextField.delegate = self
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard textField.text?.isEmpty == false else { return true }
        switch textField {
        case uploadTextField:
            self.view.endEditing(true)
        default:
            return true
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}
