//
//  RequestError.swift
//  <%= project_name %>
//
//  Created by <%= author %> on <%= Time.now.strftime("%-m/%-d/%y") %>
//  Copyright (c) <%= Time.now.strftime('%Y') %> <%= company %>. All rights reserved.
//

public enum RequestError {
    case Unknown(String)
    case Connection(String)
    case Runtime(String)
    case Serialization(String)

    public func getMessage() -> String? {
        switch self {
        case .Unknown(let error): return error
        case .Connection(let error): return error
        case .Runtime(let error): return error
        case .Serialization(let error): return error
        default: return nil
        }
    }
}
