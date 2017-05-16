//
//  Constants.swift
//  SafariExtension
//
//  Created by siavash abbasalipour on 16/5/17.
//  Copyright © 2017 Siavash. All rights reserved.
//

import Foundation
import RealmSwift

struct Constants {

  static var realm: Realm {
    let groupId: String = "group.siavash.SafariExtension"
    let dbName: String = "db.realm"
    let directory: URL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupId)!
    
    let fileURL = directory.appendingPathComponent(dbName)
    return try! Realm(fileURL: fileURL)
  }
  struct SegueIdentifier {
    static let showUrl: String = "showUrls"
    static let showWebView: String = "showWebView"
  }
  struct CellIdentifier {
    static let basicCell: String = "Cell"
  }
  static func setupInitialGroups() {
    let realm = Constants.realm
    let groups = List<Group>()
    for item in realm.objects(Group.self) {
      groups.append(item)
    }
    if groups.count < 1 { // add 4 default groups
      for i in 0...3 {
        let group = Group.init()
        group.title = "Group \(i)"
        try! realm.write {
          realm.add(group)
        }
        groups.append(group)
      }
    }
  }
}
