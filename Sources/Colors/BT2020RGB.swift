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
    
    public var illuminant: Illuminant = .two ~ .d65
    
    // MARK: Color Elements
    public var red: Element = 0
    public var green: Element = 0
    public var blue: Element = 0
    
    public var isUpscale: Bool = true
    
    public var primaries: Matrix {
        .init([0.7080, 0.2920, 0.1700, 0.7970, 0.1310, 0.0460], 3, 2)
    }
    
    public var gamma: Double { TransferFunction.BT2020RGB.gamma }
    
    #if true
    public var xyzToRgbMatrices: Matrix {
        Math.inv(rgbToXyzMatrices)!
    }
    
    public var rgbToXyzMatrices: Matrix {
        Derivation.normalisedPrimaryMatrix(
            primaries: primaries,
            whitepoint: illuminant.whitePoint
        )
    }
    #else
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
    #endif
    
    // MARK: Normal Init
    public init() {  }
    
    // MARK: Gamma Map
    public func eotfEncoding() -> TransferFunction.Elements {
        TransferFunction.BT2020RGB.eotfEncoding(elements)
    }
    
    public func eotfDecoding() -> TransferFunction.Elements {
        TransferFunction.BT2020RGB.eotfDecoding(elements)
    }
    
}
