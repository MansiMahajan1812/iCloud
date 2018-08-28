//
//  ViewControllerEdit.swift
//  iCloudProject
//
//  Created by Mansi Mahajan on 7/11/18.
//  Copyright © 2018 Mansi Mahajan. All rights reserved.
//

import UIKit
import CloudKit

class ViewControllerEdit: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
   
    @IBOutlet weak var branchEdit: UITextField!
    @IBOutlet weak var mobileEdit: UITextField!
    @IBOutlet weak var nameEdit: UITextField!
    @IBOutlet weak var ageEdit: UITextField!
    @IBOutlet weak var imageEdit: UIImageView!
    
    
    var recordId: CKRecord!
    let imagePicker = UIImagePickerController()
    var img: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        let imageAsset: CKAsset = recordId.value(forKey: "Photo") as! CKAsset
        imageEdit?.image = UIImage(contentsOfFile: imageAsset.fileURL.path)
        branchEdit.text = recordId.value(forKey: "Branch") as! String
        mobileEdit.text = String(recordId.value(forKey: "Mobile") as! Int)
        ageEdit.text = String(recordId.value(forKey: "Age") as! Int)
        nameEdit.text = recordId.value(forKey: "Name") as! String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func editAction(_ sender: UIButton) {
        let container = CKContainer.default()
        let publicDB = container.privateCloudDatabase
        if img == nil{
            img = imageEdit.image
        }
        let data = UIImagePNGRepresentation(img)
        let url = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(NSUUID().uuidString+".dat")
        do {
            try data?.write(to: url!)
        } catch let e as NSError {
            print("Error! \(e)");
            return
        }
        let userData = CKRecord(recordType: "UserDetails")
        userData.setValue(String(describing: branchEdit.text), forKey: "Branch")
        userData.setValue(Int(mobileEdit.text!), forKey: "Mobile")
        userData.setValue(Int(ageEdit.text!), forKey: "Age")
        userData.setValue(String(nameEdit.text!), forKey: "Name")
        let imageAsset = CKAsset(fileURL: url!)
        userData.setObject(imageAsset, forKey: "Photo")
        
        let saveRecordsOperation = CKModifyRecordsOperation(recordsToSave: [userData], recordIDsToDelete: [recordId.recordID])
        saveRecordsOperation.recordsToSave = [userData]
        saveRecordsOperation.savePolicy = .ifServerRecordUnchanged
        
        saveRecordsOperation.modifyRecordsCompletionBlock = { savedRecords, deletedRecordsIDs, error in
            OperationQueue.main.addOperation({ () -> Void in
                if error != nil {
                    print(error?.localizedDescription)
                    let alertController = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
                        _ = self.navigationController?.popViewController(animated: true)
                    })
                    alertController.addAction(action)
                    self.present(alertController, animated: true, completion: nil)
                    
                } else {
                    
                    let alertController = UIAlertController(title: "Success", message: "Data Saved Successfully on cloud.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
                        _ = self.navigationController?.popViewController(animated: true)
                    })
                    alertController.addAction(action)
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        }
        publicDB.add(saveRecordsOperation)
    }
    
    
    @IBAction func editImage(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageEdit.contentMode = .scaleAspectFit
            imageEdit.image = pickedImage
            img = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
}
