//
//  RequestStatus.swift
//  <%= project_name %>
//
//  Created by <%= author %> on <%= Time.now.strftime("%-m/%-d/%y") %>
//  Copyright (c) <%= Time.now.strftime('%Y') %> <%= company %>. All rights reserved.
//

public enum RequestStatus<T> {
    case Idle
    case Pending
    case Completed(T)
    case Cancelled
}


public func fromCompleted<T>(status: RequestStatus<T>) -> T? {
  switch status {
  case .Completed(let o): return o
  default: return nil
  }
}

public func isIdle<T>(status: RequestStatus<T>) -> Bool {
  switch status {
  case .Idle: return true
  default: return false
  }
}

public func isPending<T>(status: RequestStatus<T>) -> Bool {
  switch status {
  case .Pending: return true
  default: return false
  }
}

public func isCompleted<T>(status: RequestStatus<T>) -> Bool {
  switch status {
  case .Completed: return true
  default: return false
  }
}

public func isCancelled<T>(status: RequestStatus<T>) -> Bool {
  switch status {
  case .Cancelled: return true
  default: return false
  }
}

public func isFailed<T>(status: RequestStatus<(RequestError?, T)>) -> Bool {
  switch status {
  case .Cancelled: return true
  case .Completed((let e, let _)): return e != nil
  default: return false
  }
}
