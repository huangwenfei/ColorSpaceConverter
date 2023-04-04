//
//  MathVector.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2023/4/3.
//

import Foundation

public struct MathVector<T>: Hashable where T: MathElement {
    
    // MARK: - Properties -
    public var values: [T]
    
    public var count: Int { values.count }
    
    // MARK: - Init -
    public init() {
        values = []
    }
    
    public init(values: [T] = []) {
        self.values = values
    }
    
    public init(_ v: [T]) {
        self.values = v
    }
    
}
