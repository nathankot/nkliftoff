
//
//  RequestConvertible.swift
//  <%= project_name %>
//
//  Created by <%= author %> on <%= Time.now.strftime("%-m/%-d/%y") %>
//  Copyright (c) <%= Time.now.strftime('%Y') %> <%= company %>. All rights reserved.
//

import Foundation

/// An object that can be converted int
public protocol RequestConvertible : Encodable {
  func baseRequestPath() -> String
  func requestPath() -> String
}
