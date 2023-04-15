//
//  AppleRGB.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2020/11/13.
//  Copyright © 2020 黄文飞. All rights reserved.
//

import Foundation

public struct AppleRGB: RGBColorable {
    
    // MARK: RGBProtocol
    public var colorSpace: ColorSpaceType { .AppleRGB }
    
    public var illuminant: Illuminant = .two ~ .d65
    
    // MARK: Color Elements
    public var red: Element = 0
    public var green: Element = 0
    public var blue: Element = 0
    
    public var isUpscale: Bool = true
    
    public var primaries: Matrix { Illuminant.rgbPrimaries[.AppleRGB]! }
    
    public var gamma: Double { TransferFunction.AppleRGB.gamma }
    
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
                 2.9515373, -1.2894116, -0.4738445,
                -1.0851093,  1.9908566,  0.0372026,
                 0.0854934, -0.2694964,  1.0912975
            ],
            3, 3
        )
    }
    
    public var rgbToXyzMatrices: Matrix {
        .init(
            [
                0.4497288, 0.3162486, 0.1844926,
                0.2446525, 0.6720283, 0.0833192,
                0.0251848, 0.1411824, 0.9224628
            ],
            3, 3
        )
    }
    #endif
    
    // MARK: Normal Init
    public init() {  }
    
    // MARK: Gamma Map
    public func eotfEncoding() -> TransferFunction.Elements {
        TransferFunction.AppleRGB.eotfEncoding(elements)
    }
    
    public func eotfDecoding() -> TransferFunction.Elements {
        TransferFunction.AppleRGB.eotfDecoding(elements)
    }
    
}
