//
//  ColorHelper.swift
//  NightTime
//
//  Created by Florian Bauer on 12.07.24.
//

import SwiftUI

extension String {
    func deletingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
}
