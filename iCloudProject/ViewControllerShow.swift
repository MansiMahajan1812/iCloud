//
//  ViewControllerShow.swift
//  iCloudProject
//
//  Created by Mansi Mahajan on 7/9/18.
//  Copyright © 2018 Mansi Mahajan. All rights reserved.
//

import UIKit
import CloudKit

class ViewControllerShow: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var privateDatabase: CKDatabase!
    @IBOutlet weak var tableViewOutlet: UITableView!
   
    var array: Array<CKRecord> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        reloadData()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadData() {
        let container = CKContainer.default()
        privateDatabase = container.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "UserDetails", predicate: predicate)
        
        privateDatabase.perform(query, inZoneWith: nil) { (results, error) -> Void in
            if error != nil {
                print("-------------------------\(error?.localizedDescription)")
                //MBProgressHUD.hide(for: self.view, animated: true)
            }
            else {
                print(results)
                //self.tableViewOutlet.delegate = self
                print("----------------\(self.array)")
                for result in results! {
                        self.array.append(result)
                   print(result)
                }
                
                
                OperationQueue.main.addOperation({ () -> Void in
                    self.tableViewOutlet.reloadData()
                })
            }
        }
    }

  
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if array.count != 0 {
        return array.count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        if array.count != 0 {
            cell.name.text = array[indexPath.row].value(forKey: "Name") as? String
            cell.age.text = String(array[indexPath.row].value(forKey: "Age") as! Int)
            cell.mobile.text = String(array[indexPath.row].value(forKeyPath: "Mobile") as! Int)
            cell.branch.text = array[indexPath.row].value(forKey: "Branch") as? String
            let imageAsset: CKAsset = array[indexPath.row].value(forKey: "Photo") as! CKAsset
            cell.imageSet?.image = UIImage(contentsOfFile: imageAsset.fileURL.path)
            //cell.imageSet?.contentMode = UIViewContentMode.scaleAspectFill
        }
        return cell
        
    }

    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteRecord(index: indexPath)
        }
    }
 
    
    func deleteRecord(index: IndexPath){
        let selectedRecordID = array[index.row].recordID
        privateDatabase.delete(withRecordID: selectedRecordID, completionHandler: { (recordID, error) -> Void in
            if error != nil {
                print(error)
            }
            else {
                OperationQueue.main.addOperation({ () -> Void in
                    self.array.remove(at: index.row)
                    // delete the table view row
                    self.tableViewOutlet.deleteRows(at: [index], with: .fade)
                    //                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                                    self.tableViewOutlet.reloadData()
                })
            }
        })
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewControllerEdit") as! ViewControllerEdit
        vc.recordId = array[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
