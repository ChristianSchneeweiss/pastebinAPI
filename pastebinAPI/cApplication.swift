//
//  cApplication.swift
//  pastebinAPI
//
//  Created by Christian Schneeweiss on 28.11.18.
//  Copyright © 2018 Christian Schneeweiss. All rights reserved.
//

import Foundation
import Cocoa

extension URL {
    func open() {
        NSWorkspace.shared.open(self)
    }
}


class Tools {
    
    private init() {
        
    }
    
    public static func getClipboardString() -> String {
        let pasteboard = NSPasteboard.general
        
        var clipboardItems: [String] = []
        for element in pasteboard.pasteboardItems! {
            if let str = element.string(forType: NSPasteboard.PasteboardType(rawValue: "public.utf8-plain-text")) {
                clipboardItems.append(str)
            }
        }
        
        // Access the item in the clipboard
        let firstClipboardItem = clipboardItems.first ?? "Empty clipboard" // Good Morning
//        print(firstClipboardItem)
        return firstClipboardItem
    }
}
