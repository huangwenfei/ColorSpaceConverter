//
//  CIERGB.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2023/4/7.
//

import Foundation

public struct CIERGB: RGBColorable {
    
    // MARK: RGBProtocol
    public var colorSpace: ColorSpaceType { .CIERGB }
    
    public var illuminant: Illuminant = .two ~ .e
    
    // MARK: Color Elements
    public var red: Element = 0
    public var green: Element = 0
    public var blue: Element = 0
    
    public var isUpscale: Bool = true
    
    public var primaries: Matrix { Illuminant.rgbPrimaries[.CIERGB]! }
    
    public var gamma: Double { TransferFunction.CIERGB.gamma }
    
    public var xyzToRgbMatrices: Matrix {
        Math.inv(rgbToXyzMatrices)!
    }
    
    public var rgbToXyzMatrices: Matrix {
        .init(
            [
                0.4900, 0.3100, 0.2000,
                0.1769, 0.8124, 0.0107,
                0.0000, 0.0099, 0.9901
            ],
            3, 3
        )
    }
    
    // MARK: Normal Init
    public init() {  }
    
    // MARK: Gamma Map
    public func eotfEncoding() -> TransferFunction.Elements {
        TransferFunction.CIERGB.eotfEncoding(elements)
    }
    
    public func eotfDecoding() -> TransferFunction.Elements {
        TransferFunction.CIERGB.eotfDecoding(elements)
    }
    
}
