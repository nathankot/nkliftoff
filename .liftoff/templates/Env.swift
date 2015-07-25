//
//  Env.swift
//  <%= project_name %>
//
//  Created by <%= author %> on <%= Time.now.strftime("%-m/%-d/%y") %>
//  Copyright (c) <%= Time.now.strftime('%Y') %> <%= company %>. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

// All state must be accessed through view-models, in that light
// the environment itsel must also be accessed through a view-model.
public class Env {

  public static var env: [String:String] {
    return NSProcessInfo.processInfo().environment as! [String:String]
  }

  public static var isTesting: Bool {
    return env["TEST_MODE"] != nil
  }

  // This Observable is useful for re-computing models/properties
  // dependent on the DB.
  public static var rx_realmNotification: Observable<Void> {
    return create { observer in
      let r = Realm()
      let token = r.addNotificationBlock { (n, _) in sendNext(observer, ()) }
      return AnonymousDisposable { r.removeNotification(token) }
    }
  }

}
