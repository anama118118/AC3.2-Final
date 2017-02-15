//
//  UploadViewController.swift
//  AC3.2-Final
//
//  Created by Ana Ma on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var uploadImageView: UIImageView!
    @IBOutlet weak var uploadTextField: UITextField!
    @IBOutlet var uploadImageViewTapGestureRecognizer: UITapGestureRecognizer!
    
    
    var imagePickerController: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFieldDelegates()
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
