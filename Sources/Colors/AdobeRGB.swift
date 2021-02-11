//
//  AdobeRGB.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2020/11/13.
//  Copyright © 2020 黄文飞. All rights reserved.
//

import Foundation

public struct AdobeRGB: RGBColorable {
    
    // MARK: RGBProtocol
    public var colorSpace: ColorSpaceType { .AdobeRGB }
    
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
                 2.0414800, -0.564977, -0.3447130,
                -0.9692580,  1.875990,  0.0415557,
                 0.0134455, -0.118373,  1.0152700
            ],
            3, 3
        )
    }
    
    public static var rgbToXyzMatrices: Matrix {
        (
            [
                0.5767000, 0.1855560, 0.1882120,
                0.2973610, 0.6273550, 0.0752847,
                0.0270328, 0.0706879, 0.9912480
            ],
            3, 3
        )
    }
    
    // MARK: Normal Init
    public init() {  }
    
}
