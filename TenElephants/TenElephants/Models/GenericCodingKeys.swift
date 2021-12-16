//
//  CodingKeys.swift
//  Ten Elephants
//
//  Created by Дарья Домрачева on 09.12.2021.
//

import Foundation

final class GenericCodingKeys: CodingKey {
    var stringValue: String
    var intValue: Int?

    required init?(stringValue: String) {
        self.stringValue = stringValue
    }

    required init?(intValue: Int) {
        self.intValue = intValue
        stringValue = "\(intValue)"
    }
}
