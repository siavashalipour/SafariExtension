//
//  SharedEnteties.swift
//  SafariExtension
//
//  Created by siavash abbasalipour on 16/5/17.
//  Copyright © 2017 Siavash. All rights reserved.
//

import Foundation
import RealmSwift

class URLItem: Object {
  dynamic var urlString: String = ""
  dynamic var note: String = ""
}

class Group: Object {
  var urlItems = List<URLItem>()
  dynamic var title: String = ""
  dynamic var name: String = ""
}
