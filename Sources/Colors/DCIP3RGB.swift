//
//  DCIP3RGB.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2023/4/7.
//

import Foundation

public struct DCIP3RGB: RGBColorable {
    
    // MARK: RGBProtocol
    public var colorSpace: ColorSpaceType { .DCIP3RGB }
    
    /// *DCI-P3* colourspace whitepoint name.
    /// Warnings
    /// --------
    /// DCI-P3 illuminant has no associated spectral distribution. DCI has no
    /// official reference spectral measurement for this whitepoint. The closest
    /// matching spectral distribution is Kinoton 75P projector.
    public var illuminant: Illuminant = .two ~ .dci_p3
    
    // MARK: Color Elements
    public var red: Element = 0
    public var green: Element = 0
    public var blue: Element = 0
    
    public var isUpscale: Bool = true
    
    public var primaries: Matrix { Illuminant.rgbPrimaries[.DCIP3RGB]! }
    
    public var gamma: Double { TransferFunction.DCIP3RGB.gamma }
    
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
        TransferFunction.DCIP3RGB.eotfEncoding(elements)
    }
    
    public func eotfDecoding() -> TransferFunction.Elements {
        TransferFunction.DCIP3RGB.eotfDecoding(elements)
    }
    
}

public struct DCIP3PRGB: RGBColorable {
    
    // MARK: RGBProtocol
    public var colorSpace: ColorSpaceType { .DCIP3PRGB }
    
    /// *DCI-P3* colourspace whitepoint name.
    /// Warnings
    /// --------
    /// DCI-P3 illuminant has no associated spectral distribution. DCI has no
    /// official reference spectral measurement for this whitepoint. The closest
    /// matching spectral distribution is Kinoton 75P projector.
    public var illuminant: Illuminant = .two ~ .dci_p3
    
    // MARK: Color Elements
    public var red: Element = 0
    public var green: Element = 0
    public var blue: Element = 0
    
    public var isUpscale: Bool = true
    
    public var primaries: Matrix { Illuminant.rgbPrimaries[.DCIP3PRGB]! }
    
    public var gamma: Double { TransferFunction.DCIP3PRGB.gamma }
    
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
        TransferFunction.DCIP3PRGB.eotfEncoding(elements)
    }
    
    public func eotfDecoding() -> TransferFunction.Elements {
        TransferFunction.DCIP3PRGB.eotfDecoding(elements)
    }
    
}
