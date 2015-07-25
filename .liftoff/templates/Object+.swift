
//
//  Object+.swift
//  <%= project_name %>
//
//  Created by <%= author %> on <%= Time.now.strftime("%-m/%-d/%y") %>
//  Copyright (c) <%= Time.now.strftime('%Y') %> <%= company %>. All rights reserved.
//

import RealmSwift

extension Object {
  public func isStored() -> Bool {
    return realm != nil
  }
}