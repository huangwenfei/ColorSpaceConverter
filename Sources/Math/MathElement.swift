//
//  MathElement.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2023/4/3.
//

import Foundation

public protocol MathElement: BinaryFloatingPoint, SIMDScalar, Decodable, Encodable {
    
}

extension Double: MathElement {  }
