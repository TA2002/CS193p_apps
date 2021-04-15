//
//  Array+Only.swift
//  Memorize
//
//  Created by Tarlan Askaruly on 12.04.2021.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1  ? first : nil
    }
}
