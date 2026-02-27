//
//  MyPhotos_docsApp.swift
//  MyPhotos-docs
//
//  Created by Josblais on 2026-02-27.
//

import SwiftUI

@main
struct MyPhotos_docsApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: MyPhotos_docsDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
