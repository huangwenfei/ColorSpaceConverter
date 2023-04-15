//
//  RGBColor.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2023/4/13.
//

import Foundation

public struct RGBColor: RGBCommonColorable {
    
    // MARK: RGBProtocol
    public var colorSpace: ColorSpaceType { .RGBColor }
    
    public var rgbColorSpace: ColorSpaceType.RGB = .sRGB
    
    public var illuminant: Illuminant = .default
    
    // MARK: Color Elements
    public var red: Element = 0
    public var green: Element = 0
    public var blue: Element = 0
    
    public var isUpscale: Bool = true
    
    public var primaries: Matrix = .init()

    public var gamma: Double = TransferFunction.LinearRGB.gamma
    
    public var xyzToRgbMatrices: Matrix = Self.convertIdentity
    public var rgbToXyzMatrices: Matrix = Self.convertIdentity
    
    // MARK: Normal Init
    public init() {  }
    
    // MARK: Gamma Map
    public var eotfEncodingClosure: CodingClosure = {
        TransferFunction.LinearRGB.eotfEncoding($0)
    }
    
    public var eotfDecodingClosure: CodingClosure = {
        TransferFunction.LinearRGB.eotfDecoding($0)
    }
    
}
