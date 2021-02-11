//
//  sRGB.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2020/11/13.
//  Copyright © 2020 黄文飞. All rights reserved.
//

import Foundation

public struct sRGB: RGBColorable {
    
    // MARK: RGBProtocol
    public var colorSpace: ColorSpaceType { .sRGB }
    
    public var illuminant: Illuminant = .default
    
    // MARK: Color Elements
    public var red: Element = 0
    public var green: Element = 0
    public var blue: Element = 0
    
    public var isUpscale: Bool = true

    public static var gamma: Double { 2.2 }
    
    public static var xyzToRgbMatrices: Matrix {
        (
            [
                 3.2407100, -1.537260, -0.4985710,
                -0.9692580,  1.875990,  0.0415557,
                 0.0556352, -0.203996,  1.0570700
            ],
            3, 3
        )
    }
    
    public static var rgbToXyzMatrices: Matrix {
        (
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
    
}
