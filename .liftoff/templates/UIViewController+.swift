
//
//  UIViewController+.swift
//  <%= project_name %>
//
//  Created by <%= author %> on <%= Time.now.strftime("%-m/%-d/%y") %>
//  Copyright (c) <%= Time.now.strftime('%Y') %> <%= company %>. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

// UI Helpers
extension UIViewController {

  class func createFromStoryboard(name: String)
  -> UIViewController? {
      let storyboard = UIStoryboard(name:name, bundle: nil)
      let controller = storyboard.instantiateInitialViewController() as?
                       UIViewController
      let _ = controller?.view // Make sure controllers view is loaded
      return controller
  }

  func rx_validation(ui: UIView)
  (_ validation: Observable<Bool>)
  -> Disposable {
    return validation >- subscribeNext { ui.hidden = $0 }
  }

  func rx_validation(ui: UILabel, _ message: String)
  (_ validation: Observable<Bool>)
  -> Disposable {
    return validation >- subscribeNext {
      ui.hidden = $0
      ui.text = message
    }
  }

}
