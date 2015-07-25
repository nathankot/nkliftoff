//
//  RxHelpers.swift
//  <%= project_name %>
//
//  Created by <%= author %> on <%= Time.now.strftime("%-m/%-d/%y") %>
//  Copyright (c) <%= Time.now.strftime('%Y') %> <%= company %>. All rights reserved.
//

import RxSwift

public func forward<A>
(target: Variable<A>)
(_ source: Observable<A>)
-> Observable<A> {
  return source >- map {
    sendNext(target, $0)
    return $0
  }
}

public func forwardSubscribe<A>
(target: Variable<A>)
(_ source: Observable<A>)
-> Disposable {
  return source >- subscribeNext {
    sendNext(target, $0)
  }
}

public func with<A, B>
(base: Observable<B>)
(_ other: Observable<A>)
-> Observable<(A, B)> {
  return combineLatest(base, other) { (b, a) in
    return (a, b)
  }
}

public func and
(base: Observable<Bool>)
(_ other: Observable<Bool>)
-> Observable<Bool> {
  return combineLatest(base, other) { $0 && $1 }
}

public func or
(base: Observable<Bool>)
(_ other: Observable<Bool>)
-> Observable<Bool> {
  return combineLatest(base, other) { $0 || $1 }
}

public func not
(base: Observable<Bool>)
-> Observable<Bool> {
  return base >- map { $0 == false }
}
