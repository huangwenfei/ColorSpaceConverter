//
//  BT709RGB.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2023/4/7.
//

import Foundation

public struct BT709RGB: RGBColorable {
    
    // MARK: RGBProtocol
    public var colorSpace: ColorSpaceType { .BT709RGB }
    
    public var illuminant: Illuminant = .default
    
    // MARK: Color Elements
    public var red: Element = 0
    public var green: Element = 0
    public var blue: Element = 0
    
    public var isUpscale: Bool = true
    
    public var primaries: Matrix {
        .init([0.6400, 0.3300, 0.3000, 0.6000, 0.1500, 0.0600], 3, 2)
    }
    
    // TODO: Gamma ...
    public var gamma: Double { 2.2 }
    
    public var xyzToRgbMatrices: Matrix {
        Math.inv(rgbToXyzMatrices)!
    }
    
    public var rgbToXyzMatrices: Matrix {
        Derivation.normalisedPrimaryMatrix(
            primaries: primaries,
            whitepoint: illuminant.whitePoint
        )
    }
    
    // MARK: Normal Init
    public init() {  }
    
    // MARK: Gamma Map
    public func linear() -> [Element] {
        elements.map { channel in
            channel < 0.018
                ? channel * 4.5
                : 1.099 * Math.spow(channel, 0.45) - 0.099
        }
    }
    
    public func nonlinear() -> [Element] {
        /// oetf_BT601(0.018) == 0.08124794403514046 (1.099 * pow(0.018, 0.45) - 0.099)
        elements.map { channel in
            channel < 0.08124794403514046
                ? channel / 4.5
                : Math.spow((channel + 0.099) / 1.099, 1 / 0.45)
        }
    }
    
}
