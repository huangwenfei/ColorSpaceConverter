//
//  RGBColor.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2023/4/13.
//

import Foundation

public struct RGBColor: RGBColorable {
    
    // MARK: RGBProtocol
    public var colorSpace: ColorSpaceType = .unknown
    
    public var illuminant: Illuminant = .default
    
    // MARK: Color Elements
    public var red: Element = 0
    public var green: Element = 0
    public var blue: Element = 0
    
    public var isUpscale: Bool = true
    
    public var primaries: Matrix = .init()

    public var gamma: Double = TransferFunction.LinearRGB.gamma
    
    public var xyzToRgbMatrices: Matrix = .init(
        [
            1, 0, 0,
            0, 1, 0,
            0, 0, 1
        ],
        3, 3
    )
    
    public var rgbToXyzMatrices: Matrix = .init(
        [
            1, 0, 0,
            0, 1, 0,
            0, 0, 1
        ],
        3, 3
    )
    
    // MARK: Normal Init
    public init() {  }
    
    // MARK: Gamma Map
    fileprivate typealias CodingClosure = TransferFunction.CodingClosure
    
    fileprivate var eotfEncodingClosure: CodingClosure = {
        TransferFunction.LinearRGB.eotfEncoding($0)
    }
    
    fileprivate var eotfDecodingClosure: CodingClosure = {
        TransferFunction.LinearRGB.eotfDecoding($0)
    }
    
    public func eotfEncoding() -> TransferFunction.Elements {
        eotfEncodingClosure(elements)
    }
    
    public func eotfDecoding() -> TransferFunction.Elements {
        eotfDecodingClosure(elements)
    }
    
    // MARK: - Equatable -
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.colorSpace == rhs.colorSpace &&
        lhs.red == rhs.red &&
        lhs.green == rhs.green &&
        lhs.blue == rhs.blue &&
        lhs.isUpscale == rhs.isUpscale &&
        lhs.illuminant == rhs.illuminant &&
        lhs.primaries == rhs.primaries &&
        lhs.gamma == rhs.gamma &&
        lhs.xyzToRgbMatrices == rhs.xyzToRgbMatrices &&
        lhs.rgbToXyzMatrices == rhs.rgbToXyzMatrices
    }
    
}

extension RGBColor {
    
    public init<RGB: RGBColorable>(mapping rgb: RGB) {
        self.init(rgb: rgb, illuminant: rgb.illuminant)
        self.colorSpace = rgb.colorSpace
        self.primaries = rgb.primaries
        self.gamma = rgb.gamma
        self.xyzToRgbMatrices = rgb.xyzToRgbMatrices
        self.rgbToXyzMatrices = rgb.rgbToXyzMatrices
        let coder = TransferFunction.funcs[.init(rawValue: rgb.colorSpace.rawValue)!]!
        self.eotfEncodingClosure = coder.encoding
        self.eotfDecodingClosure = coder.decoding
    }
    
}
