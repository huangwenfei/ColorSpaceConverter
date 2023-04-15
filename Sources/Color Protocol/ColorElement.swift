//
//  ColorElement.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2023/4/15.
//

import Foundation

public protocol ColorElement {
    typealias Element = Double
    typealias Range = MathRange<Element>
    typealias Vector = MathVector<Element>
    typealias Matrix = MathMatrix<Element>
}
