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
    
    public var illuminant: Illuminant = .two ~ .d65
    
    // MARK: Color Elements
    public var red: Element = 0
    public var green: Element = 0
    public var blue: Element = 0
    
    public var isUpscale: Bool = true
    
    public var primaries: Matrix { Illuminant.rgbPrimaries[.BT709RGB]! }
    
    public var gamma: Double { TransferFunction.BT709RGB.gamma }
    
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
    public func eotfEncoding() -> TransferFunction.Elements {
        TransferFunction.BT709RGB.eotfEncoding(elements)
    }
    
    public func eotfDecoding() -> TransferFunction.Elements {
        TransferFunction.BT709RGB.eotfDecoding(elements)
    }
    
}
