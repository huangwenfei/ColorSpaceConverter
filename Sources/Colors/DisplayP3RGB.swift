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
    
    public var illuminant: Illuminant = .two ~ .d65
    
    // MARK: Color Elements
    public var red: Element = 0
    public var green: Element = 0
    public var blue: Element = 0
    
    public var isUpscale: Bool = true
    
    /// is same as DIC-P3
    public var primaries: Matrix { Illuminant.rgbPrimaries[.DisplayP3RGB]! }
    
    public var gamma: Double { TransferFunction.DisplayP3RGB.gamma }
    
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
    public func eotfEncoding() -> TransferFunction.Elements {
        TransferFunction.DisplayP3RGB.eotfEncoding(elements)
    }
    
    public func eotfDecoding() -> TransferFunction.Elements {
        TransferFunction.DisplayP3RGB.eotfDecoding(elements)
    }
    
}
