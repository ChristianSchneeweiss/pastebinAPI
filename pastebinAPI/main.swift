//
//  main.swift
//  pastebinAPI
//
//  Created by Christian Schneeweiss on 28.11.18.
//  Copyright © 2018 Christian Schneeweiss. All rights reserved.
//

import Foundation
import AppKit

let arguments = CommandLine.arguments

let format = arguments.first ?? "swift"

Paste.shared.APIKey = "5b346af27c71f8c92cfd03288eb218b9"

Paste.postClipboard(withFormat: format)
