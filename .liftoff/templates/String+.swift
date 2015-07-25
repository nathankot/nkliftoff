
//
//  String+.swift
//  <%= project_name %>
//
//  Created by <%= author %> on <%= Time.now.strftime("%-m/%-d/%y") %>
//  Copyright (c) <%= Time.now.strftime('%Y') %> <%= company %>. All rights reserved.
//

import Foundation

extension String {

  public var localized: String {
    return NSLocalizedString(
        self,
        tableName: nil,
        bundle: NSBundle.mainBundle(),
        value: "", comment: "")
  }

}
