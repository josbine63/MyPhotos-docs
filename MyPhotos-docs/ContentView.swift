//
//  ContentView.swift
//  MyPhotos-docs
//
//  Created by Josblais on 2026-02-27.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: MyPhotos_docsDocument

    var body: some View {
        TextEditor(text: $document.text)
    }
}

#Preview {
    ContentView(document: .constant(MyPhotos_docsDocument()))
}
