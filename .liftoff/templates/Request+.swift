//
//  Request.swift
//  <%= project_name %>
//
//  Created by <%= author %> on <%= Time.now.strftime("%-m/%-d/%y") %>
//  Copyright (c) <%= Time.now.strftime('%Y') %> <%= company %>. All rights reserved.
//

import Alamofire
import RxCocoa
import RxSwift
import Argo
import func Swiftz.fst
import func Swiftz.snd
import func Swiftz.find

// Alamofire extensions that help with retrieving any `ResponseConvertible`
extension Alamofire.Request {

  public func responseObjects<T: ResponseConvertible>
  (completionHandler: (Int?, [T]?, RequestError?) -> ())
  -> Self {
    return self.responseJSON { (request, response, json_, e) in
      let jsonall = json_ as? [String: AnyObject]
      let rootKey = T.rootCollectionKey()

      let json: [AnyObject]? // We are looking for an array, so it can't be root
      if rootKey != nil && jsonall?.indexForKey(rootKey!) != nil {
        json = jsonall![rootKey!] as? [AnyObject]
      } else {
        json = nil
      }

      let objects: [T]?
      let serializationError: NSError?

      if let jsons = json {
        let raws: [(T?, NSError?)] = jsons.map { self.getObjectFromJSON($0 as? [String: AnyObject]) }
        let rawerrors = raws.map(snd).filter({ $0 != nil }).map({ $0! })
        objects = raws.map(fst).filter({ $0 != nil }).map({ $0! })
        serializationError = find(rawerrors) { $0 != nil }
      } else {
        objects = nil
        serializationError = nil
      }

      let error = self.computeError(response,
                               jsonall, // An array will never have `message`
                               e,
                               serializationError)

      completionHandler(
        response?.statusCode,
        objects,
        error)
    }
  }

  public func responseObject<T: ResponseConvertible>
  (completionHandler: (Int?, T?, RequestError?) -> ())
  -> Self {
    return self.responseJSON { (request, response, json_, e) in
        let rootKey = T.rootKey()
        let jsonall = json_ as? [String: AnyObject]
        let json: [String: AnyObject]?
        if rootKey != nil && jsonall?.indexForKey(rootKey!) != nil {
            json = jsonall![rootKey!] as? [String: AnyObject]
        } else {
            json = jsonall
        }

        let (object: T?, serializationError) = self.getObjectFromJSON(json)
        let error = self.computeError(response, json, e, serializationError)
        completionHandler(response?.statusCode, object, error)
    }
  }

  public func rx_responseObjects<T: ResponseConvertible>() -> Observable<(Int?, [T]?, RequestError?)> {
    return create { observer in
      self.responseObjects { (status: Int?, entities: [T]?, error: RequestError?) in
        sendNext(observer, (status, entities, error))
        sendCompleted(observer)
        return
      }

      return AnonymousDisposable { self.cancel() }
    }
  }

  public func rx_responseObject<T: ResponseConvertible>() -> Observable<(Int?, T?, RequestError?)> {
    return create { observer in
      self.responseObject { (status: Int?, entity: T?, error: RequestError?) in
        sendNext(observer, (status, entity, error))
        sendCompleted(observer)
        return
      }

      return AnonymousDisposable { self.cancel() }
    }
  }

  /// An rx wrapper around `responseJSON`, this also transforms the given
  /// `NSError` to our own `RequestError`
  public func rx_responseJSON() -> Observable<(Int?, [String: AnyObject]?, RequestError?)> {
    return create { observer in
      self.responseJSON { (_, response, json_, e) in
        let json = json_ as? [String: AnyObject]
        let error = self.computeError(response, json, e)
        sendNext(observer, (response?.statusCode, json, error))
        sendCompleted(observer)
      }
      return AnonymousDisposable { self.cancel() }
    }
  }

  // Merge all possible errors we could have gotten from this process into
  // a single `RequestError`
  private func computeError(response: NSHTTPURLResponse?,
                            _ json: [String: AnyObject?]?,
                            _ e: NSError?,
                            _ serializationError: NSError? = nil) -> RequestError? {
    let error: RequestError?
    if response != nil && contains(200..<300, response!.statusCode) != true {
        error = .Unknown(json?["message"] as? String ??
            "Server responded with error: \(response!.statusCode)")
    } else if e?.domain == NSURLErrorDomain && e?.code == -1004 {
        error = .Connection(e!.localizedDescription)
    } else if e?.domain == "jsondecode" {
        error = .Serialization(e!.localizedDescription)
    } else if serializationError?.domain == "jsondecode" {
        error = .Serialization(serializationError!.localizedDescription)
    } else if serializationError != nil {
        error = .Serialization(serializationError!.localizedDescription)
    } else if e != nil {
        error = .Runtime(e!.localizedDescription)
    } else {
        error = nil
    }

    return error
  }

  private func getObjectFromJSON<T: ResponseConvertible>
  (json: [String: AnyObject]?)
  -> (T?, NSError?) {
    if json == nil {
      return (nil, NSError(
                domain: "jsondecode",
                code: -1,
                userInfo: ["\(NSLocalizedDescriptionKey)":
                          "Server responded with incorrect format"]))
    }

    let j = JSON.parse(json!)
    let decoded = T.decode(j)
    switch decoded {
    case .Success(let box):
      return (box.value as? T, nil)
    case .TypeMismatch(let e):
      return (nil, NSError(
                domain: "jsondecode",
                code: 1,
                userInfo: ["\(NSLocalizedDescriptionKey)": e]))
    case .MissingKey(let e):
      return (nil, NSError(
                domain: "jsondecode",
                code: 2,
                userInfo: ["\(NSLocalizedDescriptionKey)": e]))
    }

  }

}
