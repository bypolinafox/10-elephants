//
//  CodingKeys.swift
//  Ten Elephants
//
//  Created by Дарья Домрачева on 09.12.2021.
//

import Foundation

public class GenericCodingKeys: CodingKey {
    public var stringValue: String
    public var intValue: Int?

    required public init?(stringValue: String) {
        self.stringValue = stringValue
    }

    required public init?(intValue: Int) {
        self.intValue = intValue
        stringValue = "\(intValue)"
    }
}
