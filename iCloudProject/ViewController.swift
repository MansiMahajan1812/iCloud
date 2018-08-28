//
//  ViewController.swift
//  iCloudProject
//
//  Created by Mansi Mahajan on 7/9/18.
//  Copyright © 2018 Mansi Mahajan. All rights reserved.
//

import UIKit
import CloudKit


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let container = CKContainer.default()
    var publicDB: CKDatabase!
    var imageUrl: URL!
    var img: UIImage!
    
    let imagePicker = UIImagePickerController()
    
    
    @IBOutlet weak var imageGet: UIImageView!
    @IBOutlet weak var branchGet: UITextField!
    @IBOutlet weak var mobileGet: UITextField!
    @IBOutlet weak var ageGet: UITextField!
    @IBOutlet weak var nameGet: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func submitAction(_ sender: UIButton) {
        saveData()
    }
    
    @IBAction func setImage(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageGet.contentMode = .scaleAspectFit
            imageGet.image = pickedImage
            img = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    func saveData() {
        let data = UIImagePNGRepresentation(img)
        let url = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(NSUUID().uuidString+".dat")
        do {
            try data?.write(to: url!)
        } catch let e as NSError {
            print("Error! \(e)");
            return
        }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewControllerShow") as! ViewControllerShow
        publicDB = container.publicCloudDatabase
        let userData = CKRecord(recordType: "UserDetails")
        userData.setValue(nameGet.text, forKey: "Name")
        userData.setValue(Int(ageGet.text!), forKey: "Age")
        userData.setValue(Int(mobileGet.text!), forKey: "Mobile")
        userData.setValue(branchGet.text, forKey: "Branch")
        
//        if imageUrl == nil {
//            imageUrl = URL(fileURLWithPath: Bundle.main.path(forResource: "Name", ofType: "jpg"))
//        }
        
        let imageAsset = CKAsset(fileURL: url!)
        userData.setObject(imageAsset, forKey: "Photo")
        
        publicDB.save(userData) { (record, error) in
            if error == nil {
                guard record != nil else { return }
                
                print("save records")
            }else{
                print(error?.localizedDescription)
            }
            do { try FileManager.default.removeItem(at: url!) }
            catch let e { print("Error deleting temp file: \(e)") }

        }
        self.navigationController?.pushViewController(vc, animated: true)
       
    }
    
    
    
   
}

