
//
//  RxRequestHelpers.swift
//  <%= project_name %>
//
//  Created by <%= author %> on <%= Time.now.strftime("%-m/%-d/%y") %>
//  Copyright (c) <%= Time.now.strftime('%Y') %> <%= company %>. All rights reserved.
//

import RxSwift

public func requestStatus<T>
(base: Observable<(RequestError?, T)>)
-> Observable<RequestStatus<(RequestError?, T)>> {
  return base
  >- map { return RequestStatus.Completed($0 as (RequestError?, T)) }
  >- catch { _ in just(RequestStatus.Cancelled) }
  >- startWith(RequestStatus.Pending)
}

// Get any request that has been completed, this does NOT
// mean that the request is free of any network or response
// errors.
public func completedRequest<T>
(base: Observable<RequestStatus<T>>)
-> Observable<T> {
  return base >- filter { isCompleted($0) }
              >- map { fromCompleted($0)! }
}

// Get any request that has been completed without an error
public func successfulRequest<T>
(base: Observable<RequestStatus<(RequestError?, T)>>)
-> Observable<T> {
  return base
         >- completedRequest
         >- filter { (err, _) in return err == nil }
         >- filter { (_, o) in return o != nil }
         >- map { $1 }
}

// Any request that did not complete either through cancellation
// or error.
public func failedRequest<T>
(base: Observable<RequestStatus<(RequestError?, T)>>)
-> Observable<RequestStatus<(RequestError?, T)>> {
  return base >- filter { isFailed($0) }
}

// Get any request that is completed but with an error
public func erroredRequest<T>
(base: Observable<RequestStatus<(RequestError?, T)>>)
-> Observable<(RequestError, T)> {
  return base
         >- completedRequest
         >- filter { (e, _) in e != nil }
         >- map { ($0!, $1) }
}

// Completed request with an error that IS NOT network related
public func nonNetworkErrorRequest<T>
(base: Observable<RequestStatus<(RequestError?, T)>>)
-> Observable<(RequestError, T)> {
  return base
  >- erroredRequest
  >- filter { (err, _) in
    switch err {
    case .Connection: return false
    default: return true
    }
  }
}

// Get any request that failed due to network issues
public func networkErrorRequest<T>
(base: Observable<RequestStatus<(RequestError?, T)>>)
-> Observable<(RequestError, T)> {
  return base
  >- erroredRequest
  >- filter { (err, _) in
    switch err {
    case .Connection: return true
    default: return false
    }
  }
}
