//
//  Package.swift
//  Supportal
//
//  Created by Zachary A. Menken on 11/3/16.
//  Copyright © 2016 Oak Labs. All rights reserved.
//

import PackageDescription

let package = Package( name: "SlackKit",
        dependencies: [  
        .Package(url: "https://github.com/pvzig/SlackKit.git", majorVersion: 3) 
        ]
)