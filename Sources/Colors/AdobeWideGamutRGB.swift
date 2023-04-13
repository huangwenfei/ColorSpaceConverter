//
//  AdobeWideGamutRGB.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2023/4/7.
//

import Foundation

public struct AdobeWideGamutRGB: RGBColorable {
    
    // MARK: RGBProtocol
    public var colorSpace: ColorSpaceType { .AdobeWideGamutRGB }
    
    public var illuminant: Illuminant = .two ~ .d50
    
    // MARK: Color Elements
    public var red: Element = 0
    public var green: Element = 0
    public var blue: Element = 0
    
    public var isUpscale: Bool = true
    
    public var primaries: Matrix {
        .init([0.7347, 0.2653, 0.1152, 0.8264, 0.1566, 0.0177], 3, 2)
    }
    
    /// 2.1245283019
    public var gamma: Double { TransferFunction.AdobeWideGamutRGB.gamma }
    
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
        TransferFunction.AdobeWideGamutRGB.eotfEncoding(elements)
    }
    
    public func eotfDecoding() -> TransferFunction.Elements {
        TransferFunction.AdobeWideGamutRGB.eotfDecoding(elements)
    }
    
}
