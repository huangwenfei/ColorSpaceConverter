//
//  DICP3RGB.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2023/4/7.
//

import Foundation

public struct DICP3RGB: RGBColorable {
    
    // MARK: RGBProtocol
    public var colorSpace: ColorSpaceType { .DICP3RGB }
    
    public var illuminant: Illuminant = .default
    
    // MARK: Color Elements
    public var red: Element = 0
    public var green: Element = 0
    public var blue: Element = 0
    
    public var isUpscale: Bool = true
    
    public var primaries: Matrix {
        .init([0.7400, 0.2700, 0.2200, 0.7800, 0.0900, -0.0900], 3, 2)
    }
    
    public var gamma: Double { 2.2 }
    
    public var xyzToRgbMatrices: Matrix {
        .init(
            [
                 2.0414800, -0.564977, -0.3447130,
                -0.9692580,  1.875990,  0.0415557,
                 0.0134455, -0.118373,  1.0152700
            ],
            3, 3
        )
    }
    
    public var rgbToXyzMatrices: Matrix {
        .init(
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
