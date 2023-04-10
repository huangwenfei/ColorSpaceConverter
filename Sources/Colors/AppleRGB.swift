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
    
    public var illuminant: Illuminant = .default
    
    // MARK: Color Elements
    public var red: Element = 0
    public var green: Element = 0
    public var blue: Element = 0
    
    public var isUpscale: Bool = true
    
    public var primaries: Matrix {
        .init([0.6250, 0.3400, 0.2800, 0.5950, 0.1550, 0.0700], 3, 2)
    }
    
    public var gamma: Double { 1.8 }
    
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
    
    // MARK: Normal Init
    public init() {  }
    
    // MARK: Gamma Map
    public func linear() -> [Element] {
        elements.map { channel in
            Self.gammaCoder(
                channel: channel, exponent: gamma
            )
        }
    }
    
    public func nonlinear() -> [Element] {
        elements.map { channel in
            Self.gammaCoder(
                channel: channel, exponent: 1 / gamma
            )
        }
    }
    
}
