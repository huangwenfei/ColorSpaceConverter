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
    
    public static var gamma: Double { 2.4 }
    
    public static var xyzToRgbMatrices: Matrix {
        (
            [
                 1.716651187971269, -0.355670783776393, -0.253366281373660,
                -0.666684351832489,  1.616481236634939,  0.015768545813911,
                 0.017639857445311, -0.042770613257809,  0.942103121235474
            ],
            3, 3
        )
    }
    
    public static var rgbToXyzMatrices: Matrix {
        (
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
    
}
