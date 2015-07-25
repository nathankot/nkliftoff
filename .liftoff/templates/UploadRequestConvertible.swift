
//
//  UploadRequestConvertible.swift
//  <%= project_name %>
//
//  Created by <%= author %> on <%= Time.now.strftime("%-m/%-d/%y") %>
//  Copyright (c) <%= Time.now.strftime('%Y') %> <%= company %>. All rights reserved.
//

import Foundation

public protocol UploadRequestConvertible : RequestConvertible {
  func fileURL() -> NSURL?
  func fileContentType() -> String?
}
