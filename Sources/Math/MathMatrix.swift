//
//  MathMatrix.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2023/4/3.
//

import Foundation

public struct MathMatrix<T>: Hashable where T: MathElement {
    
    // MARK: - Types -
    public typealias Tuple = (values: [T], rows: Int, columns: Int)
    
    // MARK: - Properties -
    public var values: [T]
    public var rows: Int
    public var columns: Int
    
    public var count: Int { rows * columns }
    
    // MARK: - Init -
    public init() {
        values = []
        rows = 0
        columns = 0
    }
    
    public init(values: [T], rows: Int, columns: Int) {
        self.values = values
        self.rows = rows
        self.columns = columns
    }
    
    public init(_ values: [T], _ rows: Int, _ columns: Int) {
        self.values = values
        self.rows = rows
        self.columns = columns
    }
    
    public init(_ v: Tuple) {
        self.values = v.values
        self.rows = v.rows
        self.columns = v.columns
    }
    
    public func rowColumnSwitch() -> Self {
        var result = self
        (result.rows, result.columns) = (columns, rows)
        return result
    }
    
    public func reshape(_ v: (rows: Int, columns: Int)) -> Self {
        var result = self
        (result.rows, result.columns) = (v.rows, v.columns)
        return result
    }
    
}
