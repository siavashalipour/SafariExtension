//
//  UrlListViewController.swift
//  SafariExtension
//
//  Created by siavash abbasalipour on 16/5/17.
//  Copyright © 2017 Siavash. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class UrlListViewController: UIViewController {
  
  // MARK:- Outlet
  @IBOutlet weak var tableView: UITableView!
  
  // MARK:- Public Property
  var selectedGroup: Group?

  // MARK:- View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    title = selectedGroup?.title ?? ""
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == Constants.SegueIdentifier.showWebView {
      if let vc = segue.destination as? UrlWebViewController {
        vc.urlString = sender as? String
      }
    }
  }
}
// MARK:- UITableViewDelegate, UITableViewDataSource
extension UrlListViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let item = selectedGroup?.urlItems[indexPath.row]
    performSegue(withIdentifier: Constants.SegueIdentifier.showWebView, sender: item?.urlString)
    
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.basicCell, for: indexPath)
    
    let item = selectedGroup?.urlItems[indexPath.row]
    cell.textLabel!.text = item?.urlString
    cell.detailTextLabel?.text = "Note: \(item?.note ?? "")"
    
    return cell
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return selectedGroup?.urlItems.count ?? 0
  }
}
