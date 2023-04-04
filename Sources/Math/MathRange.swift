//
//  MathRange.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2023/4/3.
//

import Foundation

public struct MathRange<T>: Hashable where T: MathElement {
    
    // MARK: - Types -
    public typealias Tuple = (min: T, max: T)
    
    // MARK: - Properties -
    public var min: T
    public var max: T
    
    // MARK: - Init -
    public init() {
        min = 0
        max = 1
    }
    
    public init(min: T, max: T) {
        self.min = min
        self.max = max
    }
    
    public init(_ min: T, _ max: T) {
        self.min = min
        self.max = max
    }
    
    public init(_ v: Tuple) {
        self.min = v.min
        self.max = v.max
    }
    
}
