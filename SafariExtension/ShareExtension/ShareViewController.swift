//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by siavash abbasalipour on 16/5/17.
//  Copyright © 2017 Siavash. All rights reserved.
//

import UIKit
import Social
import RealmSwift
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {
  
  // MARK:- Private Properties
  fileprivate var groups: List<Group> {
    get {
      return List(Constants.realm.objects(Group.self))
    }
    set {}
  }
  fileprivate var url: URL?
  fileprivate var selectedGroup: Group?
  
  // MARK:- SLComposeServiceViewController
  override func isContentValid() -> Bool {
    // Do validation of contentText and/or NSExtensionContext attachments here
    return true
  }
  
  override func didSelectPost() {
    // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
    // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
    self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    let item = URLItem()
    // setup the URLItem with the page url
    item.urlString = url?.absoluteString ?? ""
    // add the note that has been entered in the `TextView` - by default the Text in the `TextView` is the URL placeholder - we can't change it. it is a getter only property
    item.note = contentText
    // fetch the `selectedGroup` from realm DB - and once found append to it's `urlItems`
    if let selectedGroup = selectedGroup {
      if let realmSelectedGroup = Constants.realm.objects(Group.self).filter("title == '\(selectedGroup.title)'").first {
        try! Constants.realm.write {
          realmSelectedGroup.urlItems.append(item)
          Constants.realm.add(realmSelectedGroup)
        }
      }
    }
  }
  
  override func configurationItems() -> [Any]! {
    if let group = SLComposeSheetConfigurationItem() {
      group.title = "Selected Group"
      group.value = selectedGroup?.title
      group.tapHandler = {
        let vc = ShareGroupViewController()
        vc.groupList = self.groups
        vc.delegate = self
        self.pushConfigurationViewController(vc)
      }
      return [group]
    }
    return nil
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    getURL()
    Constants.setupInitialGroups()
    selectedGroup = groups.first
  }
  // MARK:- Private Helper
  
  /// Use this method to run the `GetURL.js` file to get the page URL
  private func getURL() {
    let extensionItem = extensionContext?.inputItems.first as! NSExtensionItem
    let itemProvider = extensionItem.attachments?.first as! NSItemProvider
    let propertyList = String(kUTTypePropertyList)
    if itemProvider.hasItemConformingToTypeIdentifier(propertyList) {
      itemProvider.loadItem(forTypeIdentifier: propertyList, options: nil, completionHandler: { (item, error) -> Void in
        guard let dictionary = item as? NSDictionary else { return }
        OperationQueue.main.addOperation {
          if let results = dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary,
            let urlString = results["URL"] as? String,
            let url = URL(string: urlString) {
            self.url = url
          }
        }
      })
    } else {
      print("error")
    }
  }
}
// MARK:- ShareGroupViewControllerDelegate
extension ShareViewController: ShareGroupViewControllerDelegate {
  func selected(group: Group) {
    selectedGroup = group
    reloadConfigurationItems()
    popConfigurationViewController()
  }
}
