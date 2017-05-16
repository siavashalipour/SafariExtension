//
//  ShareGroupViewController.swift
//  SafariExtension
//
//  Created by siavash abbasalipour on 16/5/17.
//  Copyright © 2017 Siavash. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

protocol ShareGroupViewControllerDelegate: class {
  func selected(group: Group)
}

class ShareGroupViewController: UIViewController {
  // MARK:- Properties
  // setup the TableView
  private lazy var tableView: UITableView = {
    let tableView = UITableView(frame: self.view.frame)
    tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    tableView.dataSource = self
    tableView.delegate = self
    tableView.backgroundColor = .clear
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.CellIdentifier.basicCell)
    return tableView
  }()
  var groupList: List<Group> {
    get {
      return List(Constants.realm.objects(Group.self))
    }
    set {
      
    }
  }
  weak var delegate: ShareGroupViewControllerDelegate?
  
  // MARK:- View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  // MARK:- Private Helper
  private func setupUI() {
    UINavigationBar.appearance().tintColor = UIColor.black
    title = "Select Group"
    view.addSubview(tableView)
  }
}
// MARK:- UITableViewDataSource
extension ShareGroupViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return groupList.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.basicCell, for: indexPath)
    cell.textLabel?.text = groupList[indexPath.row].title
    cell.backgroundColor = .clear
    return cell
  }
}
// MARK:- UITableViewDelegate
extension ShareGroupViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    delegate?.selected(group: groupList[indexPath.row])
  }
}
