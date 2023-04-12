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
    public var illuminant: Illuminant = .two(.dci)
    
    // MARK: Color Elements
    public var red: Element = 0
    public var green: Element = 0
    public var blue: Element = 0
    
    public var isUpscale: Bool = true
    
    public var primaries: Matrix {
        .init([0.6800, 0.3200, 0.2650, 0.6900, 0.1500, 0.0600], 3, 2)
    }
    
    public var gamma: Double { 2.6 }
    
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

public struct DCIP3PRGB: RGBColorable {
    
    // MARK: RGBProtocol
    public var colorSpace: ColorSpaceType { .DCIP3PRGB }
    
    /// *DCI-P3* colourspace whitepoint name.
    /// Warnings
    /// --------
    /// DCI-P3 illuminant has no associated spectral distribution. DCI has no
    /// official reference spectral measurement for this whitepoint. The closest
    /// matching spectral distribution is Kinoton 75P projector.
    public var illuminant: Illuminant = .two(.dci)
    
    // MARK: Color Elements
    public var red: Element = 0
    public var green: Element = 0
    public var blue: Element = 0
    
    public var isUpscale: Bool = true
    
    public var primaries: Matrix {
        .init([0.7400, 0.2700, 0.2200, 0.7800, 0.0900, -0.0900], 3, 2)
    }
    
    public var gamma: Double { 2.6 }
    
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
