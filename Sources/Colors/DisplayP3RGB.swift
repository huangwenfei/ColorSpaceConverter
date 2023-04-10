//
//  DisplayP3RGB.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2023/4/7.
//

import Foundation

public struct DisplayP3RGB: RGBColorable {
    
    // MARK: RGBProtocol
    public var colorSpace: ColorSpaceType { .DisplayP3RGB }
    
    public var illuminant: Illuminant = .default
    
    // MARK: Color Elements
    public var red: Element = 0
    public var green: Element = 0
    public var blue: Element = 0
    
    public var isUpscale: Bool = true
    
    /// is same as DIC-P3
    public var primaries: Matrix {
        .init([0.6800, 0.3200, 0.2650, 0.6900, 0.1500, 0.0600], 3, 2)
    }
    
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
    
    /// as same as sRGB
    public func linear() -> [Element] {
        elements.map { channel in
            channel <= 0.04045
                ? channel / 12.92
                : Math.spow((channel + 0.055) / 1.055, 2.4)
        }
    }
    
    /// as same as sRGB
    public func nonlinear() -> [Element] {
        elements.map { channel in
            channel <= 0.0031308
                ? channel * 12.92
                : 1.055 * Math.spow(channel, 1 / 2.4) - 0.055
        }
    }
    
}
