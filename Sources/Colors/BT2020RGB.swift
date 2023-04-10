//
//  BT2020RGB.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2020/11/13.
//  Copyright © 2020 黄文飞. All rights reserved.
//

import Foundation

public struct BT2020RGB: RGBColorable {
    
    // MARK: RGBProtocol
    public var colorSpace: ColorSpaceType { .BT2020RGB }
    
    public var illuminant: Illuminant = .default
    
    // MARK: Color Elements
    public var red: Element = 0
    public var green: Element = 0
    public var blue: Element = 0
    
    public var isUpscale: Bool = true
    
    public var primaries: Matrix {
        .init([0.7080, 0.2920, 0.1700, 0.7970, 0.1310, 0.0460], 3, 2)
    }
    
    public var gamma: Double { 2.4 }
    
    public var xyzToRgbMatrices: Matrix {
        .init(
            [
                 1.716651187971269, -0.355670783776393, -0.253366281373660,
                -0.666684351832489,  1.616481236634939,  0.015768545813911,
                 0.017639857445311, -0.042770613257809,  0.942103121235474
            ],
            3, 3
        )
    }
    
    public var rgbToXyzMatrices: Matrix {
        .init(
            [
                0.636958048301291, 0.144616903586208, 0.168880975164172,
                0.262700212011267, 0.677998071518871, 0.059301716469862,
                0.000000000000000, 0.028072693049087, 1.060985057710791
            ],
            3, 3
        )
    }
    
    // MARK: Normal Init
    public init() {  }
    
    // MARK: Gamma Map
    public func linear() -> [Element] {
        
//        if kwargs.get("is_12_bits_system"):
//            a, b, c = 1.0993, 0.0181, 0.081697877417347  # noqa
//        else:
//            a, b, c = 1.099, 0.018, 0.08124794403514049  # noqa
        
        let a = 1.099, c = 0.08124794403514049
        
        return elements.map { channel in
            channel <= c
                ? channel / 4.5
                : Math.spow((channel + (a - 1)) / a, 1 / 0.45)
        }
    }
    
    public func nonlinear() -> [Element] {
//        if kwargs.get("is_12_bits_system") {
//            let a = 1.0993, b = 0.0181
//        } else {
//            let a = 1.099, b = 0.018
//        }
        
        let a = 1.099, b = 0.018
        
        return elements.map { channel in
            channel < b
                ? channel * 4.5
                : a * Math.spow(channel, 0.45) - (a - 1)
        }
    }
    
}
