
//
//  <%= project_name %>Tests.swift
//  <%= project_name %>
//
//  Created by <%= author %> on <%= Time.now.strftime("%-m/%-d/%y") %>
//  Copyright (c) <%= Time.now.strftime('%Y') %> <%= company %>. All rights reserved.
//

import Quick
import Nimble
import OHHTTPStubs
import RealmSwift
import Foundation
import <%= project_name %>

class ProjectDataTestConfiguration : QuickConfiguration {

    override class func configure(configuration : Configuration) {

        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
                                                                .UserDomainMask, true)[0] as! String
        let realmPath = documentsPath.stringByAppendingPathComponent("test.realm")

        // set options on the configuration object
        configuration.beforeEach {
            Realm.defaultPath = realmPath
            deleteRealmFiles(realmPath)
            OHHTTPStubs.removeAllStubs()
            Env.user = nil
        }
    }

}

func deleteRealmFiles(path: String) {
    let fileManager = NSFileManager.defaultManager()
    fileManager.removeItemAtPath(path, error: nil)
    let lockPath = path + ".lock"
    fileManager.removeItemAtPath(lockPath, error: nil)
    return
}
