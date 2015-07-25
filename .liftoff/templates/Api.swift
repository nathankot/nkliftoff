//
//  Api.swift
//  <%= project_name %>
//
//  Created by <%= author %> on <%= Time.now.strftime("%-m/%-d/%y") %>
//  Copyright (c) <%= Time.now.strftime('%Y') %> <%= company %>. All rights reserved.
//

import Foundation
import Alamofire
import func Swiftz.fst
import RealmSwift

public enum Api : URLRequestConvertible {

    /// Convenience shared instance of `Manager`
    public static let manager: Alamofire.Manager = {
        let configuration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        let m = Alamofire.Manager(configuration: configuration)
        m.startRequestsImmediately = true
        return m
    }()

    public static let baseURL = "http://acme.dev"

    // Set this if a Bearer token is required
    public static var apiKey: String? { return nil }

    // Build an api URL using the given path, this function will
    // prepend the base component.
    public static func urlWithPath(p: String) -> NSURL {
      return NSURL(string: Api.baseURL)!.URLByAppendingPathComponent(p)
    }

    /// All our available routes represented as enum's
    case CREATE(RequestConvertible)
    case UPDATE(RequestConvertible)
    case DESTROY(RequestConvertible)
    case LIST(String)
    case UPLOAD(UploadRequestConvertible)

    public var method: Alamofire.Method {
        switch self {
        case .CREATE: return .POST
        case .UPLOAD: return .POST
        case .UPDATE: return .PATCH
        case .DESTROY: return .DELETE
        case .LIST: return .GET
        }
    }

    public var path: String {
        switch self {
        case .CREATE(let e): return e.baseRequestPath()
        case .UPDATE(let e): return e.requestPath()
        case .DESTROY(let e): return e.requestPath()
        case .LIST(let p): return p
        case .UPLOAD(let e): return e.baseRequestPath()
        }
    }

    public var json: [String: AnyObject]? {
        switch self {
        case .CREATE(let e): return e.encodeJSON()
        case .UPDATE(let e): return e.encodeJSON()
        default: return nil
        }
    }

    public var URLRequest: NSURLRequest {
      let request = NSMutableURLRequest(URL: Api.urlWithPath(path))

      request.HTTPMethod = method.rawValue
      request.setValue("application/json", forHTTPHeaderField: "Accept")

      if let k = Api.apiKey {
        request.setValue("Bearer \(k)", forHTTPHeaderField: "Authorization")
      }

      switch self {
      case .UPLOAD(let e):
        if let ct = e.fileContentType() {
          request.setValue(ct, forHTTPHeaderField: "Content-Type")
        }
      default: break
      }

      let finalRequest = Alamofire.ParameterEncoding.JSON.encode(request, parameters: json).0

      // @see https://goo.gl/wgXgBa
      // for an explanation on why this is necessary to test the request body
      if Env.isTesting {
        let r: NSMutableURLRequest = finalRequest.mutableCopy() as! NSMutableURLRequest
        if r.HTTPBody != nil {
          NSURLProtocol.setProperty(r.HTTPBody!, forKey: "HTTPBody", inRequest: r)
        }
        return r
      } else {
        return finalRequest
      }

    }

}
