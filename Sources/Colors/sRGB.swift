//
//  sRGB.swift
//  ColorSpaceConverter
//
//  https://ninedegreesbelow.com/photography/srgb-luminance.html
//
//  Created by 黄文飞 on 2020/11/13.
//  Copyright © 2020 黄文飞. All rights reserved.
//

import Foundation

public struct sRGB: RGBColorable {
    
    // MARK: RGBProtocol
    public var colorSpace: ColorSpaceType { .sRGB }
    
    public var illuminant: Illuminant = .two ~ .d65
    
    // MARK: Color Elements
    public var red: Element = 0
    public var green: Element = 0
    public var blue: Element = 0
    
    public var isUpscale: Bool = true
    
    public var primaries: Matrix {
        .init([0.6400, 0.3300, 0.3000, 0.6000, 0.1500, 0.0600], 3, 2)
    }

    public var gamma: Double { TransferFunction.sRGB.gamma }
    
    public var xyzToRgbMatrices: Matrix {
        .init(
            [
                 3.2407100, -1.537260, -0.4985710,
                -0.9692580,  1.875990,  0.0415557,
                 0.0556352, -0.203996,  1.0570700
            ],
            3, 3
        )
    }
    
    public var rgbToXyzMatrices: Matrix {
        .init(
            [
                0.4124240, 0.357579, 0.1804640,
                0.2126560, 0.715158, 0.0721856,
                0.0193324, 0.119193, 0.9504440
            ],
            3, 3
        )
    }
    
    // MARK: Normal Init
    public init() {  }
    
    // MARK: Gamma Map
    public func eotfEncoding() -> TransferFunction.Elements {
        TransferFunction.sRGB.eotfEncoding(elements)
    }
    
    public func eotfDecoding() -> TransferFunction.Elements {
        TransferFunction.sRGB.eotfDecoding(elements)
    }
    
}
