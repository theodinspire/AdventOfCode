//
//  Date+FormatInit.swift
//  AdventOfCode
//
//  Created by Eric Cormack on 12/4/18.
//  Copyright © 2018 the Odin Spire. All rights reserved.
//

import Foundation

public extension DateFormatter {
    convenience init(from format: String) {
        self.init()

        self.dateFormat = format
    }
}
