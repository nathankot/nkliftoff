
//
//  ViewModel.swift
//  <%= project_name %>
//
//  Created by <%= author %> on <%= Time.now.strftime("%-m/%-d/%y") %>
//  Copyright (c) <%= Time.now.strftime('%Y') %> <%= company %>. All rights reserved.
//

import Foundation
import RealmSwift

/// ViewModel's own their models, and are responsible for juggling between
/// the Network and the internal DB store.
///
/// View model instances should _never_ be responsible for starting or committing
/// transactions.
///
/// e.g
///     override func viewDidLoad() {
///       // In this case the model instance is already
///       // owned by the vc
///       model.beginWrite() // So we have control over the transaction
///       model.property = "new value"
///       model.save()
///       model.commitWrite()
///     }
///
///     public func getModelById(id: Int, handler: (ViewModel) -> ()) {
///       // In this case, the instance of model doesn't exist,
///       // so we let the view model handle the transaction.
///       // All methods similar to this should return objects
///       // that are already persisted in realm.
///       ViewModel.getById(id, withHandler: handler)
///     }
public class ViewModel {

  public var model: Model { return Model() }

  public var inWrite: Bool { return realm.inWriteTransaction }

  /// Specific instance of realm just for this
  /// ViewModel. Use on main thread only.
  public let realm = Realm()

  public func beginWrite() {
    if !inWrite { realm.beginWrite() }
  }

  public func commitWrite() {
    // Not wrapped in `inWrite`, because if this
    // ever happens, then something is wrong.
    realm.commitWrite()
  }

  public func cancelWrite() {
    if inWrite { realm.cancelWrite() }
  }

  public func addToRealm(update: Bool = true) {
    realm.add(model, update: true)
  }

  public func deleteFromRealm() {
    realm.delete(model)
  }

  public func isStored() -> Bool {
    return model.isStored()
  }

}
