//
//  ViewController.swift
//  SafariExtension
//
//  Created by siavash abbasalipour on 16/5/17.
//  Copyright © 2017 Siavash. All rights reserved.
//

import UIKit
import RealmSwift

class GroupViewController: UIViewController {

  // MARK:- View Outlet
  @IBOutlet weak var tableView: UITableView!
  
  // MARK: Properties
  fileprivate var groupList: Results<Group> {
    get {
      return Constants.realm.objects(Group.self)
    }
  }
  // MARK:- View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    Constants.setupInitialGroups()
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == Constants.SegueIdentifier.showUrl {
      if let vc = segue.destination as? UrlListViewController {
        vc.selectedGroup = sender as? Group
      }
    }
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK:- Actions
  @IBAction func addNew(_ sender: Any) {
    // create the UIAlertController
    let alertController: UIAlertController = UIAlertController(title: "New Group", message: "What is your Group name?", preferredStyle: .alert)
    
    alertController.addTextField { (_) in}
    
    let action_cancel = UIAlertAction.init(title: "Cancel", style: .cancel) { (_) -> Void in}
    alertController.addAction(action_cancel)
    
    let action_add = UIAlertAction.init(title: "Add", style: .default) { (UIAlertAction) -> Void in
      let textField = (alertController.textFields?.first)! as UITextField
      // add the created Group to Realm DB and update the tableView
      let aGroup = Group()
      aGroup.title = textField.text!
      aGroup.name = textField.text!
      
      try! Constants.realm.write({
        Constants.realm.add(aGroup)
        self.tableView.insertRows(at: [IndexPath.init(row: self.groupList.count-1, section: 0)], with: .automatic)
      })
    }
    alertController.addAction(action_add)
    present(alertController, animated: true, completion: nil)
  }

}
// MARK:- UITableViewDelegate, UITableViewDataSource
extension GroupViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let item = groupList[indexPath.row]
    performSegue(withIdentifier: Constants.SegueIdentifier.showUrl, sender: item)
    
  }
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    
    if (editingStyle == .delete){
      let item = groupList[indexPath.row]
      try! Constants.realm.write({
        Constants.realm.delete(item)
      })
      tableView.deleteRows(at:[indexPath], with: .automatic)
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.basicCell, for: indexPath)
    
    let item = groupList[indexPath.row]
    cell.textLabel!.text = item.title
    return cell
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return groupList.count
  }
}
