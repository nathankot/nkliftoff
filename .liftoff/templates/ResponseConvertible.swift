
//
//  ResponseConvertible.swift
//  <%= project_name %>
//
//  Created by <%= author %> on <%= Time.now.strftime("%-m/%-d/%y") %>
//  Copyright (c) <%= Time.now.strftime('%Y') %> <%= company %>. All rights reserved.
//

import Foundation
import Argo

public protocol ResponseConvertible : Decodable, AnyObject {
    static func rootKey() -> String?
    static func rootCollectionKey() -> String?
}
