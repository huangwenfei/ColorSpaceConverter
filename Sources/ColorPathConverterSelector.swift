//
//  ColorPathConverterSelector.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2020/12/28.
//  Copyright © 2020 黄文飞. All rights reserved.
//

import Foundation

import Accelerate
//import simd

public struct ColorPathConverterSelector {
    
    // MARK: - Selector
    public typealias Selector = (_ from: AnyColorable, _ infos: [AnyHashable: Any]?) -> AnyColorable
    
    public static let selectors: [PathId: PathConverter] = [
        SpectralToXYZ.pathId:   SpectralToXYZ,
        
        LabToLCHab.pathId:      LabToLCHab,
        LabToXYZ.pathId:        LabToXYZ,
        
        LuvToLCHuv.pathId:      LuvToLCHuv,
        LuvToXYZ.pathId:        LuvToXYZ,
        
        LCHabToLab.pathId:      LCHabToLab,
        
        LCHuvToLuv.pathId:      LCHuvToLuv,
        
        xyYToXYZ.pathId:        xyYToXYZ,
        
        XYZToxyY.pathId:        XYZToxyY,
        XYZToLuv.pathId:        XYZToLuv,
        XYZToLab.pathId:        XYZToLab,
        XYZTosRGB.pathId:       XYZTosRGB,
        XYZToAppleRGB.pathId:   XYZToAppleRGB,
        XYZToAdobeRGB.pathId:   XYZToAdobeRGB,
        XYZToBT2020RGB.pathId:  XYZToBT2020RGB,
        XYZToIPT.pathId:        XYZToIPT,
        
        sRGBToXYZ.pathId:       sRGBToXYZ,
        AppleRGBToXYZ.pathId:   AppleRGBToXYZ,
        AdobeRGBToXYZ.pathId:   AdobeRGBToXYZ,
        BT2020RGBToXYZ.pathId:  BT2020RGBToXYZ,
        
        sRGBToHSV.pathId:       sRGBToHSV,
        AppleRGBToHSV.pathId:   AppleRGBToHSV,
        AdobeRGBToHSV.pathId:   AdobeRGBToHSV,
        BT2020RGBToHSV.pathId:  BT2020RGBToHSV,
        
        sRGBToHSL.pathId:       sRGBToHSL,
        AppleRGBToHSL.pathId:   AppleRGBToHSL,
        AdobeRGBToHSL.pathId:   AdobeRGBToHSL,
        BT2020RGBToHSL.pathId:  BT2020RGBToHSL,
        
        sRGBToCMY.pathId:       sRGBToCMY,
        AppleRGBToCMY.pathId:   AppleRGBToCMY,
        AdobeRGBToCMY.pathId:   AdobeRGBToCMY,
        BT2020RGBToCMY.pathId:  BT2020RGBToCMY,
        
        HSVTosRGB.pathId:       HSVTosRGB,
        HSVToAppleRGB.pathId:   HSVToAppleRGB,
        HSVToAdobeRGB.pathId:   HSVToAdobeRGB,
        HSVToBT2020RGB.pathId:  HSVToBT2020RGB,
        
        HSLTosRGB.pathId:       HSLTosRGB,
        HSLToAppleRGB.pathId:   HSLToAppleRGB,
        HSLToAdobeRGB.pathId:   HSLToAdobeRGB,
        HSLToBT2020RGB.pathId:  HSLToBT2020RGB,
        
        CMYTosRGB.pathId:       CMYTosRGB,
        CMYToAppleRGB.pathId:   CMYToAppleRGB,
        CMYToAdobeRGB.pathId:   CMYToAdobeRGB,
        CMYToBT2020RGB.pathId:  CMYToBT2020RGB,
        
        CMYToCMYK.pathId:       CMYToCMYK,
        
        CMYKToCMY.pathId:       CMYKToCMY,
        
        IPTToXYZ.pathId:        IPTToXYZ
    ]
    
    public static func selector(byPathId pathId: PathId) -> PathConverter? {
        selectors[pathId]
    }
    
    // MARK: - Single Paths
    // MARK: Spectral
    public static let SpectralToXYZ: PathConverter = .init( .Spectral ==> .XYZ ) {
        let color = $0.base as! Spectral
        var infos = $1
        let illuminant = infos?["\(Illuminant.self)"] as! Illuminant
        infos?["\(Illuminant.self)"] = nil
        let xyz = Self.SpectralToXYZ(
            color: color,
            illuminant: illuminant.spectral ?? .default,
            infos: infos
        )
        return .init(xyz)
    }
    
    // MARK: Lab
    public static let LabToLCHab: PathConverter = .init( .Lab ==> .LCHab ) {
        .init( Self.LabToLCHab(color: ($0.base as! Lab), infos: $1) )
    }
    
    public static let LabToXYZ: PathConverter = .init( .Lab ==> .XYZ ) {
        .init( Self.LabToXYZ(color: ($0.base as! Lab), infos: $1) )
    }
    
    // MARK: Luv
    public static let LuvToLCHuv: PathConverter = .init( .Luv ==> .LCHuv ) {
        .init( Self.LuvToLCHuv(color: ($0.base as! Luv), infos: $1) )
    }
    
    public static let LuvToXYZ: PathConverter = .init( .Luv ==> .XYZ ) {
        .init( Self.LuvToXYZ(color: ($0.base as! Luv), infos: $1) )
    }
    
    // MARK: LCHab
    public static let LCHabToLab: PathConverter = .init( .LCHab ==> .Lab ) {
        .init( Self.LCHabToLab(color: ($0.base as! LCHab), infos: $1) )
    }
    
    // MARK: LCHuv
    public static let LCHuvToLuv: PathConverter = .init( .LCHuv ==> .Luv ) {
        .init( Self.LCHuvToLuv(color: ($0.base as! LCHuv), infos: $1) )
    }
    
    // MARK: xyY
    public static let xyYToXYZ: PathConverter = .init( .xyY ==> .XYZ ) {
        .init( Self.xyYToXYZ(color: ($0.base as! xyY), infos: $1) )
    }
    
    // MARK: XYZ
    public static let XYZToxyY: PathConverter = .init( .XYZ ==> .xyY ) {
        .init( Self.XYZToxyY(color: ($0.base as! XYZ), infos: $1) )
    }
    
    public static let XYZToLuv: PathConverter = .init( .XYZ ==> .Luv ) {
        .init( Self.XYZToLuv(color: ($0.base as! XYZ), infos: $1) )
    }
    
    public static let XYZToLab: PathConverter = .init( .XYZ ==> .Lab ) {
        .init( Self.XYZToLab(color: ($0.base as! XYZ), infos: $1) )
    }
    
    public static let XYZTosRGB: PathConverter = .init( .XYZ ==> .sRGB ) {
        let color = $0.base as! XYZ
        var infos = $1
        let illuminant = infos?["\(Illuminant.self)"] as! Illuminant
        infos?["\(Illuminant.self)"] = nil
        return .init(
            Self.XYZTosRGB(color: color, illuminant: illuminant, infos: infos)
        )
    }
    
    public static let XYZToAppleRGB: PathConverter = .init( .XYZ ==> .AppleRGB ) {
        let color = $0.base as! XYZ
        var infos = $1
        let illuminant = infos?["\(Illuminant.self)"] as! Illuminant
        infos?["\(Illuminant.self)"] = nil
        return .init(
            Self.XYZToAppleRGB(color: color, illuminant: illuminant, infos: infos)
        )
    }
    
    public static let XYZToAdobeRGB: PathConverter = .init( .XYZ ==> .AdobeRGB ) {
        let color = $0.base as! XYZ
        var infos = $1
        let illuminant = infos?["\(Illuminant.self)"] as! Illuminant
        infos?["\(Illuminant.self)"] = nil
        return .init(
            Self.XYZToAdobeRGB(color: color, illuminant: illuminant, infos: infos)
        )
    }
    
    public static let XYZToBT2020RGB: PathConverter = .init( .XYZ ==> .BT2020RGB ) {
        let color = $0.base as! XYZ
        var infos = $1
        let illuminant = infos?["\(Illuminant.self)"] as! Illuminant
        infos?["\(Illuminant.self)"] = nil
        return .init(
            Self.XYZToBT2020RGB(color: color, illuminant: illuminant, infos: infos)
        )
    }
    
    public static let XYZToIPT: PathConverter = .init( .XYZ ==> .IPT ) {
        .init( Self.XYZToIPT(color: ($0.base as! XYZ), infos: $1) )
    }
    
    // MARK: RGB
    public static let sRGBToXYZ: PathConverter = .init( .sRGB ==> .XYZ ) {
        let color = $0.base as! sRGB
        var infos = $1
        let illuminant = infos?["\(Illuminant.self)"] as! Illuminant
        infos?["\(Illuminant.self)"] = nil
        return .init(
            Self.sRGBToXYZ(color: color, illuminant: illuminant, infos: infos)
        )
    }
    
    public static let AppleRGBToXYZ: PathConverter = .init( .AppleRGB ==> .XYZ ) {
        let color = $0.base as! AppleRGB
        var infos = $1
        let illuminant = infos?["\(Illuminant.self)"] as! Illuminant
        infos?["\(Illuminant.self)"] = nil
        return .init(
            Self.AppleRGBToXYZ(color: color, illuminant: illuminant, infos: infos)
        )
    }
    
    public static let AdobeRGBToXYZ: PathConverter = .init( .AdobeRGB ==> .XYZ ) {
        let color = $0.base as! AdobeRGB
        var infos = $1
        let illuminant = infos?["\(Illuminant.self)"] as! Illuminant
        infos?["\(Illuminant.self)"] = nil
        return .init(
            Self.AdobeRGBToXYZ(color: color, illuminant: illuminant, infos: infos)
        )
    }
    
    public static let BT2020RGBToXYZ: PathConverter = .init( .BT2020RGB ==> .XYZ ) {
        let color = $0.base as! BT2020RGB
        var infos = $1
        let illuminant = infos?["\(Illuminant.self)"] as! Illuminant
        infos?["\(Illuminant.self)"] = nil
        return .init(
            Self.BT2020RGBToXYZ(color: color, illuminant: illuminant, infos: infos)
        )
    }
    
    public static let sRGBToHSV: PathConverter = .init( .sRGB ==> .HSV ) {
        .init( Self.sRGBToHSV(color: ($0.base as! sRGB), infos: $1) )
    }
    
    public static let AppleRGBToHSV: PathConverter = .init( .AppleRGB ==> .HSV ) {
        .init( Self.AppleRGBToHSV(color: ($0.base as! AppleRGB), infos: $1) )
    }
    
    public static let AdobeRGBToHSV: PathConverter = .init( .AdobeRGB ==> .HSV ) {
        .init( Self.AdobeRGBToHSV(color: ($0.base as! AdobeRGB), infos: $1) )
    }
    
    public static let BT2020RGBToHSV: PathConverter = .init( .BT2020RGB ==> .HSV ) {
        .init( Self.BT2020RGBToHSV(color: ($0.base as! BT2020RGB), infos: $1) )
    }
    
    public static let sRGBToHSL: PathConverter = .init( .sRGB ==> .HSL ) {
        .init( Self.sRGBToHSL(color: ($0.base as! sRGB), infos: $1) )
    }
    
    public static let AppleRGBToHSL: PathConverter = .init( .AppleRGB ==> .HSL ) {
        .init( Self.AppleRGBToHSL(color: ($0.base as! AppleRGB), infos: $1) )
    }
    
    public static let AdobeRGBToHSL: PathConverter = .init( .AdobeRGB ==> .HSL ) {
        .init( Self.AdobeRGBToHSL(color: ($0.base as! AdobeRGB), infos: $1) )
    }
    
    public static let BT2020RGBToHSL: PathConverter = .init( .BT2020RGB ==> .HSL ) {
        .init( Self.BT2020RGBToHSL(color: ($0.base as! BT2020RGB), infos: $1) )
    }
    
    public static let sRGBToCMY: PathConverter = .init( .sRGB ==> .CMY ) {
        .init( Self.sRGBToCMY(color: ($0.base as! sRGB), infos: $1) )
    }
    
    public static let AppleRGBToCMY: PathConverter = .init( .AppleRGB ==> .CMY ) {
        .init( Self.AppleRGBToCMY(color: ($0.base as! AppleRGB), infos: $1) )
    }
    
    public static let AdobeRGBToCMY: PathConverter = .init( .AdobeRGB ==> .CMY ) {
        .init( Self.AdobeRGBToCMY(color: ($0.base as! AdobeRGB), infos: $1) )
    }
    
    public static let BT2020RGBToCMY: PathConverter = .init( .BT2020RGB ==> .CMY ) {
        .init( Self.BT2020RGBToCMY(color: ($0.base as! BT2020RGB), infos: $1) )
    }
    
    // MARK: HSV
    public static let HSVTosRGB: PathConverter = .init( .HSV ==> .sRGB ) {
        .init( Self.HSVTosRGB(color: ($0.base as! HSV), infos: $1) )
    }
    
    public static let HSVToAppleRGB: PathConverter = .init( .HSV ==> .AppleRGB ) {
        .init( Self.HSVToAppleRGB(color: ($0.base as! HSV), infos: $1) )
    }
    
    public static let HSVToAdobeRGB: PathConverter = .init( .HSV ==> .AdobeRGB ) {
        .init( Self.HSVToAdobeRGB(color: ($0.base as! HSV), infos: $1) )
    }
    
    public static let HSVToBT2020RGB: PathConverter = .init( .HSV ==> .BT2020RGB ) {
        .init( Self.HSVToBT2020RGB(color: ($0.base as! HSV), infos: $1) )
    }
    
    // MARK: HSL
    public static let HSLTosRGB: PathConverter = .init( .HSL ==> .sRGB ) {
        .init( Self.HSLTosRGB(color: ($0.base as! HSL), infos: $1) )
    }
    
    public static let HSLToAppleRGB: PathConverter = .init( .HSL ==> .AppleRGB ) {
        .init( Self.HSLToAppleRGB(color: ($0.base as! HSL), infos: $1) )
    }
    
    public static let HSLToAdobeRGB: PathConverter = .init( .HSL ==> .AdobeRGB ) {
        .init( Self.HSLToAdobeRGB(color: ($0.base as! HSL), infos: $1) )
    }
    
    public static let HSLToBT2020RGB: PathConverter = .init( .HSL ==> .BT2020RGB ) {
        .init( Self.HSLToBT2020RGB(color: ($0.base as! HSL), infos: $1) )
    }
    
    // MARK: CMY
    public static let CMYTosRGB: PathConverter = .init( .CMY ==> .sRGB ) {
        .init( Self.CMYTosRGB(color: ($0.base as! CMY), infos: $1) )
    }
    
    public static let CMYToAppleRGB: PathConverter = .init( .CMY ==> .AppleRGB ) {
        .init( Self.CMYToAppleRGB(color: ($0.base as! CMY), infos: $1) )
    }
    
    public static let CMYToAdobeRGB: PathConverter = .init( .CMY ==> .AdobeRGB ) {
        .init( Self.CMYToAdobeRGB(color: ($0.base as! CMY), infos: $1) )
    }
    
    public static let CMYToBT2020RGB: PathConverter = .init( .CMY ==> .BT2020RGB ) {
        .init( Self.CMYToBT2020RGB(color: ($0.base as! CMY), infos: $1) )
    }
    
    public static let CMYToCMYK: PathConverter = .init( .CMY ==> .CMYK ) {
        .init( Self.CMYToCMYK(color: ($0.base as! CMY), infos: $1) )
    }
    
    // MARK: CMYK
    public static let CMYKToCMY: PathConverter = .init( .CMYK ==> .CMY ) {
        .init( Self.CMYKToCMY(color: ($0.base as! CMYK), infos: $1) )
    }
    
    // MARK: IPT
    public static let IPTToXYZ: PathConverter = .init( .IPT ==> .XYZ ) {
        .init( Self.IPTToXYZ(color: ($0.base as! IPT), infos: $1) )
    }
    
    // MARK: - RGB Paths
    
    #if false
    //MARK: RGB -> HSL
    public static let sRGB_2_HSL:      [PathConverter] = [ sRGBToHSL      ]
    public static let AppleRGB_2_HSL:  [PathConverter] = [ AppleRGBToHSL  ]
    public static let AdobeRGB_2_HSL:  [PathConverter] = [ AdobeRGBToHSL  ]
    public static let BT2020RGB_2_HSL: [PathConverter] = [ BT2020RGBToHSL ]
    
    //MARK: RGB -> HSV
    public static let sRGB_2_HSV:      [PathConverter] = [ sRGBToHSV      ]
    public static let AppleRGB_2_HSV:  [PathConverter] = [ AppleRGBToHSV  ]
    public static let AdobeRGB_2_HSV:  [PathConverter] = [ AdobeRGBToHSV  ]
    public static let BT2020RGB_2_HSV: [PathConverter] = [ BT2020RGBToHSV ]
    
    //MARK: RGB -> CMY
    public static let sRGB_2_CMY:      [PathConverter] = [ sRGBToCMY      ]
    public static let AppleRGB_2_CMY:  [PathConverter] = [ AppleRGBToCMY  ]
    public static let AdobeRGB_2_CMY:  [PathConverter] = [ AdobeRGBToCMY  ]
    public static let BT2020RGB_2_CMY: [PathConverter] = [ BT2020RGBToCMY ]
    #endif
    
    public typealias RgbSelectorTuple = (pathId: PathId, converters: [PathConverter])
    
    public static let rgbSelectors: [PathId: [PathConverter]] = [
        sRGB_2_CMYK.pathId: sRGB_2_CMYK.converters
    ]
    
    //MARK: RGB -> CMYK
    public static let sRGB_2_CMYK: RgbSelectorTuple = (
        .sRGB ==> .CMYK, [ sRGBToCMY, CMYToCMYK ]
    )
    
    public static let AppleRGB_2_CMYK: RgbSelectorTuple = (
        .AppleRGB ==> .CMYK, [ AppleRGBToCMY, CMYToCMYK ]
    )
    
    public static let AdobeRGB_2_CMYK: RgbSelectorTuple = (
        .AdobeRGB ==> .CMYK, [ AdobeRGBToCMY, CMYToCMYK ]
    )
    
    public static let BT2020RGB_2_CMYK: RgbSelectorTuple = (
        .BT2020RGB ==> .CMYK, [ BT2020RGBToCMY, CMYToCMYK ]
    )
    
    #if false
    //MARK: RGB -> XYZ
    public static let sRGB_2_XYZ:      [PathConverter] = [ sRGBToXYZ      ]
    public static let AppleRGB_2_XYZ:  [PathConverter] = [ AppleRGBToXYZ  ]
    public static let AdobeRGB_2_XYZ:  [PathConverter] = [ AdobeRGBToXYZ  ]
    public static let BT2020RGB_2_XYZ: [PathConverter] = [ BT2020RGBToXYZ ]
    #endif
    
    //MARK: RGB -> xyY
    public static let sRGB_2_xyY: RgbSelectorTuple = (
        .sRGB ==> .xyY, [ sRGBToXYZ, XYZToxyY ]
    )
    public static let AppleRGB_2_xyY: RgbSelectorTuple = (
        .AppleRGB ==> .xyY, [ AppleRGBToXYZ, XYZToxyY ]
    )
    public static let AdobeRGB_2_xyY: RgbSelectorTuple = (
        .AdobeRGB ==> .xyY, [ AdobeRGBToXYZ, XYZToxyY ]
    )
    public static let BT2020RGB_2_xyY: RgbSelectorTuple = (
        .BT2020RGB ==> .xyY, [ BT2020RGBToXYZ, XYZToxyY ]
    )
    
    //MARK: RGB -> Lab
    public static let sRGB_2_Lab: RgbSelectorTuple = (
        .sRGB ==> .Lab, [ sRGBToXYZ, XYZToLab ]
    )
    public static let AppleRGB_2_Lab: RgbSelectorTuple = (
        .AppleRGB ==> .Lab, [ AppleRGBToXYZ, XYZToLab ]
    )
    public static let AdobeRGB_2_Lab: RgbSelectorTuple = (
        .AdobeRGB ==> .Lab, [ AdobeRGBToXYZ, XYZToLab ]
    )
    public static let BT2020RGB_2_Lab: RgbSelectorTuple = (
        .BT2020RGB ==> .Lab, [ BT2020RGBToXYZ, XYZToLab ]
    )
    
    //MARK: RGB -> LCHab
    public static let sRGB_2_LCHab: RgbSelectorTuple = (
        .sRGB ==> .LCHab, [ sRGBToXYZ, XYZToLab, LabToLCHab ]
    )
    
    public static let AppleRGB_2_LCHab: RgbSelectorTuple = (
        .AppleRGB ==> .LCHab, [ AppleRGBToXYZ, XYZToLab, LabToLCHab ]
    )
    
    public static let AdobeRGB_2_LCHab: RgbSelectorTuple = (
        .AdobeRGB ==> .LCHab, [ AdobeRGBToXYZ, XYZToLab, LabToLCHab ]
    )
    
    public static let BT2020RGB_2_LCHab: RgbSelectorTuple = (
        .BT2020RGB ==> .LCHab, [ BT2020RGBToXYZ, XYZToLab, LabToLCHab ]
    )
    
    //MARK: RGB -> Luv
    public static let sRGB_2_Luv: RgbSelectorTuple = (
        .sRGB ==> .Luv, [ sRGBToXYZ, XYZToLuv ]
    )
    public static let AppleRGB_2_Luv: RgbSelectorTuple = (
        .AppleRGB ==> .Luv, [ AppleRGBToXYZ, XYZToLuv  ]
    )
    public static let AdobeRGB_2_Luv: RgbSelectorTuple = (
        .AdobeRGB ==> .Luv, [ AdobeRGBToXYZ, XYZToLuv  ]
    )
    public static let BT2020RGB_2_Luv: RgbSelectorTuple = (
        .BT2020RGB ==> .Luv, [ BT2020RGBToXYZ, XYZToLuv ]
    )
    
    //MARK: RGB -> LCHuv
    public static let sRGB_2_LCHuv: RgbSelectorTuple = (
        .sRGB ==> .LCHuv, [ sRGBToXYZ, XYZToLuv, LuvToLCHuv ]
    )
    
    public static let AppleRGB_2_LCHuv: RgbSelectorTuple = (
        .AppleRGB ==> .LCHuv, [ AppleRGBToXYZ, XYZToLuv, LuvToLCHuv ]
    )
    
    public static let AdobeRGB_2_LCHuv: RgbSelectorTuple = (
        .AdobeRGB ==> .LCHuv, [ AdobeRGBToXYZ, XYZToLuv, LuvToLCHuv ]
    )
    
    public static let BT2020RGB_2_LCHuv: RgbSelectorTuple = (
        .BT2020RGB ==> .LCHuv, [ BT2020RGBToXYZ, XYZToLuv, LuvToLCHuv ]
    )
    
    //MARK: RGB -> IPT
    public static let sRGB_2_IPT: RgbSelectorTuple = (
        .sRGB ==> .IPT, [ sRGBToXYZ, XYZToIPT ]
    )
    public static let AppleRGB_2_IPT: RgbSelectorTuple = (
        .AppleRGB ==> .IPT, [ AppleRGBToXYZ, XYZToIPT ]
    )
    public static let AdobeRGB_2_IPT: RgbSelectorTuple = (
        .AdobeRGB ==> .IPT, [ AdobeRGBToXYZ, XYZToIPT ]
    )
    public static let BT2020RGB_2_IPT: RgbSelectorTuple = (
        .BT2020RGB ==> .IPT, [ BT2020RGBToXYZ, XYZToIPT ]
    )
    
}

extension ColorPathConverterSelector {
    
    // MARK: - Spectral
    /// need Illuminant
    public static func SpectralToXYZ(color: Spectral, illuminant: SpectralIlluminant? = nil, infos: [AnyHashable: Any]?) -> XYZ {

        guard color.illuminant.canToNormal else {
            #if DEBUG
            fatalError("Color \(color.illuminant) can not convert to normal illuminant.")
            #else
            return .init()
            #endif
        }
        
        /// - Tag: If the user provides an illuminant_override numpy array, use it.
        var referenceIllum: SpectralIlluminant
        if let illuminant = illuminant {
            
            guard illuminant.canToNormal else {
                #if DEBUG
                fatalError("Color \(illuminant) can not used to xyz color.")
                #else
                return .init()
                #endif
            }
            
            referenceIllum = illuminant
            
        } else {
            /// - Tag: Otherwise, look up the illuminant from known standards based on the value of 'illuminant' pulled from the SpectralColor object.
            referenceIllum = color.illuminant
        }
        
        /// - Tag: Get the spectral distribution of the selected standard observer.
        var stdObserverXyz = color.illuminant.angle.values
        
        /// - Tag: This is a NumPy array containing the spectral distribution of the color.
        var sample = color.elements

        /// - Tag: The denominator is constant throughout the entire calculation for X, Y, and Z coordinates. Calculate it once and re-use.
        let count = stdObserverXyz.y.count
        var denom = [Spectral.Element](repeating: 0, count: count)
        stdObserverXyz.y.withUnsafeMutableBufferPointer { angle in
            referenceIllum.lamp.values.withUnsafeMutableBufferPointer { lamp in
                vDSP_vmulD(
                    angle.baseAddress!, vDSP_Stride(1),
                    lamp.baseAddress!, vDSP_Stride(1),
                    &denom, vDSP_Stride(1),
                    vDSP_Length(count)
                )
            }
        }

        /// - Tag: This is also a common element in the calculation whereby the sample
        /// - Tag: NumPy array is multiplied by the reference illuminant's power distribution
        /// - Tag: (which is also a NumPy array).
        var sampleByRefIllum = [Spectral.Element](repeating: 0, count: count)
        sample.withUnsafeMutableBufferPointer { color in
            referenceIllum.lamp.values.withUnsafeMutableBufferPointer { lamp in
                vDSP_vmulD(
                    color.baseAddress!, vDSP_Stride(1),
                    lamp.baseAddress!, vDSP_Stride(1),
                    &sampleByRefIllum, vDSP_Stride(1),
                    vDSP_Length(count)
                )
            }
        }

        /// - Tag: Calculate the numerator of the equation to find X.
        var xNumerator = [Spectral.Element](repeating: 0, count: count)
        sampleByRefIllum.withUnsafeMutableBufferPointer { colorLamp in
            stdObserverXyz.x.withUnsafeMutableBufferPointer { angle in
                vDSP_vmulD(
                    colorLamp.baseAddress!, vDSP_Stride(1),
                    angle.baseAddress!, vDSP_Stride(1),
                    &xNumerator, vDSP_Stride(1),
                    vDSP_Length(count)
                )
            }
        }
        
        var yNumerator = [Spectral.Element](repeating: 0, count: count)
        sampleByRefIllum.withUnsafeMutableBufferPointer { colorLamp in
            stdObserverXyz.y.withUnsafeMutableBufferPointer { angle in
                vDSP_vmulD(
                    colorLamp.baseAddress!, vDSP_Stride(1),
                    angle.baseAddress!, vDSP_Stride(1),
                    &yNumerator, vDSP_Stride(1),
                    vDSP_Length(count)
                )
            }
        }
        
        var zNumerator = [Spectral.Element](repeating: 0, count: count)
        sampleByRefIllum.withUnsafeMutableBufferPointer { colorLamp in
            stdObserverXyz.z.withUnsafeMutableBufferPointer { angle in
                vDSP_vmulD(
                    colorLamp.baseAddress!, vDSP_Stride(1),
                    angle.baseAddress!, vDSP_Stride(1),
                    &zNumerator, vDSP_Stride(1),
                    vDSP_Length(count)
                )
            }
        }
        
        let denomSum = cblas_dasum(.init(denom.count), denom, 1)
        let xNumeratorSum = cblas_dasum(.init(xNumerator.count), xNumerator, 1)
        let yNumeratorSum = cblas_dasum(.init(yNumerator.count), yNumerator, 1)
        let zNumeratorSum = cblas_dasum(.init(zNumerator.count), zNumerator, 1)
        
        let x = xNumeratorSum / denomSum
        let y = yNumeratorSum / denomSum
        let z = zNumeratorSum / denomSum

        return .init(
            x: x, y: y, z: z, illuminant: referenceIllum.normal!
        )
        
    }
    
    // MARK: - Lab
    /// Convert from CIE Lab to LCH(ab).
    public static func LabToLCHab(color: Lab, infos: [AnyHashable: Any]?) -> LCHab {
        
        let l = color.l
        let a = sqrt(pow(color.a, 2) + pow(color.b, 2))
        var b = atan2(color.b, color.a)

        if b > 0 {
            b = (b / .pi) * 180
        } else {
            b = 360 - (fabs(b) / .pi) * 180
        }
        
        return .init(
            l: l, a: a, b: b, illuminant: color.illuminant
        )
        
    }
    
    public static func LabToXYZ(color: Lab, infos: [AnyHashable: Any]?) -> XYZ {
        
        let illum = color.illuminant.lamp.xyz
        var y = (color.l + 16.0) / 116.0
        var x = color.a / 500.0 + y
        var z = y - color.b / 200.0

        if pow(y, 3) > DeltaE.e {
            y = pow(y, 3)
        } else {
            y = (y - 16.0 / 116.0) / 7.787
        }
        
        if pow(x, 3) > DeltaE.e {
            x = pow(x, 3)
        } else {
            x = (x - 16.0 / 116.0) / 7.787
        }

        if pow(z, 3) > DeltaE.e {
            z = pow(z, 3)
        } else {
            z = (z - 16.0 / 116.0) / 7.787
        }
        
        x = illum.x * x
        y = illum.y * y
        z = illum.z * z

        return .init(
            x: x, y: y, z: z, illuminant: color.illuminant
        )
    
    }
    
    // MARK: - Luv
    /// Convert from CIE Luv to LCH(uv).
    public static func LuvToLCHuv(color: Luv, infos: [AnyHashable: Any]?) -> LCHuv {
        
        let l = color.l
        let u = sqrt(pow(color.u, 2) + pow(color.v, 2.0))
        var v = atan2(color.v, color.u)

        if v > 0 {
            v = (v / .pi) * 180
        } else {
            v = 360 - (fabs(v) / .pi) * 180
        }
        
        return .init(
            l: l, u: u, v: v, illuminant: color.illuminant
        )
    
    }
    
    public static func LuvToXYZ(color: Luv, infos: [AnyHashable: Any]?) -> XYZ {
        
        let illum = color.illuminant.lamp.xyz
        
        /// - Tag: Without Light, there is no color. Short-circuit this and avoid some zero division errors in the `var_a_frac` calculation.
        guard color.l > 0.0 else {
            return .init(
                x: 0, y: 0, z: 0, illuminant: color.illuminant
            )
        }

        /// - Tag: Various variables used throughout the conversion.
        let cieKTimesE = DeltaE.k * DeltaE.e
        let uSub0 = (4 * illum.x) / (illum.x + 15 * illum.y + 3 * illum.z)
        let vSub0 = (9 * illum.y) / (illum.x + 15 * illum.y + 3 * illum.z)
        let u = color.u / (13 * color.l) + uSub0
        let v = color.v / (13 * color.l) + vSub0

        /// - Tag: Y-coordinate calculations.
        let y: XYZ.Element
        if color.l > cieKTimesE {
            y = pow((color.l + 16) / 116, 3)
        } else {
            y = color.l / DeltaE.e
        }
            
        /// - Tag: X-coordinate calculation.
        let x = y * 9 * u / (4 * v)
        
        /// - Tag: Z-coordinate calculation.
        let z = y * (12 - 3 * u - 20 * v) / (4 * v)

        return .init(
            x: x, y: y, z: z, illuminant: color.illuminant
        )
    
    }
    
    // MARK: - LCHab
    public static func LCHabToLab(color: LCHab, infos: [AnyHashable: Any]?) -> Lab {
    
        let l = color.l
        let a = cos(radians(color.b)) * color.a
        let b = sin(radians(color.b)) * color.a
        
        return .init(
            l: l, a: a, b: b, illuminant: color.illuminant
        )
    
    }
    
    // MARK: - LCHuv
    public static func LCHuvToLuv(color: LCHuv, infos: [AnyHashable: Any]?) -> Luv {
        
        let l = color.l
        let u = cos(radians(color.v)) * color.u
        let v = sin(radians(color.v)) * color.u
        
        return .init(
            l: l, u: u, v: v, illuminant: color.illuminant
        )
    
    }
    
    // MARK: - xyY
    public static func xyYToXYZ(color: xyY, infos: [AnyHashable: Any]?) -> XYZ {
        
        /// - Tag: avoid division by zero
        let x: XYZ.Element
        let y: XYZ.Element
        let z: XYZ.Element
        if color.y == 0 {
            x = 0
            y = 0
            z = 0
        } else {
            x = (color.x * color.Y) / color.y
            y = color.Y
            z = ((1 - color.x - color.y) * y) / color.y
        }

        return .init(
            x: x, y: y, z: z, illuminant: color.illuminant
        )
    
    }
    
    // MARK: - XYZ
    public static func XYZToxyY(color: XYZ, infos: [AnyHashable: Any]?) -> xyY {
        
        let xyzSum = color.elements.reduce(0) { $0 + $1 }
        
        /// - Tag: avoid division by zero
        let x: xyY.Element
        let y: xyY.Element
        if xyzSum == 0 {
            x = 0
            y = 0
        } else {
            x = color.x / xyzSum
            y = color.y / xyzSum
        }
        
        let Y = color.y

        return .init(
            x: x, y: y, Y: Y, illuminant: color.illuminant
        )
    
    }
    
    public static func XYZToLuv(color: XYZ, infos: [AnyHashable: Any]?) -> Luv {
        
        let tempX = color.x
        var tempY = color.y
        let tempZ = color.z
        let denom = tempX + (15 * tempY) + (3 * tempZ)
        
        /// - Tag: avoid division by zero
        var u: Luv.Element
        var v: Luv.Element
        if denom == 0 {
            u = 0
            v = 0
        } else {
            u = (4 * tempX) / denom
            v = (9 * tempY) / denom
        }

        let illum = color.illuminant.lamp.xyz
        
        tempY = tempY / illum.y
        if tempY > DeltaE.e {
            tempY = pow(tempY, (1 / 3))
        } else {
            tempY = (7.787 * tempY) + (16 / 116)
        }

        let refU = (4 * illum.x) / (illum.x + (15 * illum.y) + (3 * illum.z))
        let refV = (9 * illum.y) / (illum.x + (15 * illum.y) + (3 * illum.z))

        let l = (116 * tempY) - 16
        u = 13 * l * (u - refU)
        v = 13 * l * (v - refV)

        return .init(
            l: l, u: u, v: v, illuminant: color.illuminant
        )
    
    }
    
    public static func XYZToLab(color: XYZ, infos: [AnyHashable: Any]?) -> Lab {
        
        func clamp(_ v: Element) -> Element {
            if v > DeltaE.e {
                return pow(v, (1.0 / 3.0))
            } else {
                return (7.787 * v) + (16.0 / 116.0)
            }
        }
        
        let illum = color.illuminant.lamp.xyz
        
        let tempX = clamp(color.x / illum.x)
        let tempY = clamp(color.y / illum.y)
        let tempZ = clamp(color.z / illum.z)

        let l = (116 * tempY) - 16
        let a = 500 * (tempX - tempY)
        let b = 200 * (tempY - tempZ)
        return .init(
            l: l, a: a, b: b, illuminant: color.illuminant
        )
    
    }
    
    public static func XYZToRGB<R: RGBColorable>(color: XYZ, illuminant: Illuminant, infos: [AnyHashable: Any]?) -> R {
        
        var tempX = color.x
        var tempY = color.y
        var tempZ = color.z
        
        /// - Tag: If the XYZ values were taken with a different reference white than the native reference white of the target RGB space, a transformation matrix must be applied.
        if color.illuminant != illuminant {
            /// - Tag: Get the adjusted XYZ values, adapted for the target illuminant.
            ChromaticAdaptation.adaptation(
                x: &tempX, y: &tempY, z: &tempZ,
                xyzIlluminant: color.illuminant, illuminant: illuminant
            )
        }
        
        /// - Tag: Apply an RGB working space matrix to the XYZ values (matrix mul).
        let (r, g, b) = applyRGBMatrix(
            var1: tempX, var2: tempY, var3: tempZ, rgbType: R.self, isToRgb: true
        )

        /// - Tag: v
        let linearChannels = [r, g, b]
        
        /// - Tag: V
        var nonlinearChannels = [Element](repeating: 0, count: linearChannels.count)
        if R.self == sRGB.self {
            
            for (idx, channel) in linearChannels.enumerated() {
                nonlinearChannels[idx] = (
                    channel <= 0.0031308
                        ? channel * 12.92
                        : 1.055 * pow(channel, 1 / 2.4) - 0.055
                )
            }
            
        } else if R.self == BT2020RGB.self {
//            if kwargs.get("is_12_bits_system") {
//                let a = 1.0993, b = 0.0181
//            } else {
//                let a = 1.099, b = 0.018
//            }
            
            let a = 1.099, b = 0.018
            
            for (idx, channel) in linearChannels.enumerated() {
                nonlinearChannels[idx] = (
                    channel < b
                        ? channel * 4.5
                        : a * pow(channel, 0.45) - (a - 1)
                )
            }
            
        } else {
            
            /// - Tag: If it's not sRGB...
            for (idx, channel) in linearChannels.enumerated() {
                nonlinearChannels[idx] = pow(channel, 1 / R.gamma)
            }
            
        }
        
        return .init(
            red: nonlinearChannels[0],
            green: nonlinearChannels[1],
            blue: nonlinearChannels[2],
            illuminant: illuminant,
            isUpscale: false
        )
    
    }
    
    public static func XYZTosRGB(color: XYZ, illuminant: Illuminant, infos: [AnyHashable: Any]?) -> sRGB {
        XYZToRGB(color: color, illuminant: illuminant, infos: infos)
    }
    
    public static func XYZToAppleRGB(color: XYZ, illuminant: Illuminant, infos: [AnyHashable: Any]?) -> AppleRGB {
        XYZToRGB(color: color, illuminant: illuminant, infos: infos)
    }
    
    public static func XYZToAdobeRGB(color: XYZ, illuminant: Illuminant, infos: [AnyHashable: Any]?) -> AdobeRGB {
        XYZToRGB(color: color, illuminant: illuminant, infos: infos)
    }
    
    public static func XYZToBT2020RGB(color: XYZ, illuminant: Illuminant, infos: [AnyHashable: Any]?) -> BT2020RGB {
        XYZToRGB(color: color, illuminant: illuminant, infos: infos)
    }
    
    public static func XYZToIPT(color: XYZ, infos: [AnyHashable: Any]?) -> IPT {

        /// NOTE: XYZ values need to be adapted to 2 degree D65

        /** Reference:
         Fairchild, M. D. (2013). Color appearance models, 3rd Ed. (pp. 271-272).
         John Wiley & Sons.
        */

        guard color.illuminant == .two(.d65) else {
            #if DEBUG
            fatalError("XYZColor for XYZ->IPT conversion needs to be D65 adapted.")
            #else
            return .init()
            #endif
        }
        
        let transMatrix = IPT.xyzToLmsMatrices

        let xyzValues = color.elements
        let valueM = xyzValues.count
        let valueN = 1
        
        var lmsValues = Math.mul(
            mat1: transMatrix,
            mat2: (xyzValues, valueM, valueN)
        ).values

        #if true
//        var signLmsValues = lmsValues.map { sign($0) }
        var signLmsValues = Math.sign(lmsValues)
        #else
        /// - Tag: Get the zero elements from lmsValues.
        var ones = [Element](repeating: 1, count: lmsValues.count)
        var oneZeros = [Element](repeating: 0, count: ones.count)
        vDSP_vmulD(
            &ones, vDSP_Stride(1),
            &lmsValues, vDSP_Stride(1),
            &oneZeros, vDSP_Stride(1),
            vDSP_Length(oneZeros.count)
        )
        
        /// - Tag: Copy Signs from lmsValues to oneZeros.
        var signCount: Int32 = .init(lmsValues.count)
        var signLmsValues = [Element](repeating: 0, count: lmsValues.count)
        vvcopysign(&signLmsValues, &oneZeros, &lmsValues, &signCount)
        
        #endif
        
        var lmsCount: Int32 = .init(lmsValues.count)
        var absLmsValues = [Element](repeating: 0, count: lmsValues.count)
        vvfabs(&absLmsValues, &lmsValues, &lmsCount)
        
        var lmsPrimeTemp = [Element](repeating: 0, count: lmsValues.count)
        vDSP_vmulD(
            &signLmsValues, vDSP_Stride(1),
            &absLmsValues, vDSP_Stride(1),
            &lmsPrimeTemp, vDSP_Stride(1),
            vDSP_Length(lmsPrimeTemp.count)
        )
        
        var exponents = [Element](repeating: 0.43, count: lmsValues.count)
        
        var lmsPrime = [Element](repeating: 0, count: lmsValues.count)
        vvpow(&lmsPrime, &exponents, &lmsPrimeTemp, &lmsCount)
        
        let lmsToIptMat = IPT.lmstoIptMatrices
        
        /// `3 X 3 * 3 X 1`
        let iptValues = Math.mul(
            mat1: lmsToIptMat,
            mat2: (lmsPrime, lmsPrime.count, 1)
        ).values
        
        return .init(array: iptValues)
        
    }
    
    // MARK: - RGB
    public static func RGBToXYZ<T: RGBColorable>(color: T, illuminant: Illuminant?, infos: [AnyHashable: Any]?) -> XYZ {
        
        /// RGB to XYZ conversion. Expects RGB values between 0 and 255.
        /// Based off of: http://www.brucelindbloom.com/index.html?Eqn_RGB_to_XYZ.html

        let downColor = color.downable()
        
        /// - Tag: Will contain linearized RGB channels (removed the gamma func).
        var linearChannels = [Element](repeating: 0, count: 3)

        if T.self == sRGB.self {

            for (idx, channel) in downColor.elements.enumerated() {
                linearChannels[idx] = (
                    channel <= 0.04045
                        ? channel / 12.92
                        : pow((channel + 0.055) / 1.055, 2.4)
                )
            }
            
        } else if T.self == BT2020RGB.self {
//            if kwargs.get("is_12_bits_system"):
//                a, b, c = 1.0993, 0.0181, 0.081697877417347  # noqa
//            else:
//                a, b, c = 1.099, 0.018, 0.08124794403514049  # noqa
            
            let a = 1.099, c = 0.08124794403514049
            
            for (idx, channel) in downColor.elements.enumerated() {
                linearChannels[idx] = (
                    channel <= c
                        ? channel / 4.5
                        : pow((channel + (a - 1)) / a, 1 / 0.45)
                )
            }

        } else {
            /// - Tag: If it's not sRGB...
            
            for (idx, channel) in downColor.elements.enumerated() {
                linearChannels[idx] = pow(channel, T.gamma)
            }
            
        }
        
        /// - Tag: Apply an RGB working space matrix to the XYZ values (matrix mul).
        let (x, y, z) = applyRGBMatrix(
            var1: linearChannels[0],
            var2: linearChannels[1],
            var3: linearChannels[2],
            rgbType: T.self,
            isToRgb: false
        )

        let targetIlluminant: Illuminant
        if let illuminant = illuminant {
            targetIlluminant = illuminant
        } else {
            targetIlluminant = color.illuminant
        }

        /// - Tag: The illuminant of the original RGB object. This will always match the RGB colorspace's native illuminant.
        let illuminant = color.illuminant
        var xyz: XYZ = .init(x: x, y: y, z: z, illuminant: illuminant)
        
        /// - Tag: This will take care of any illuminant changes for us (if source illuminant != target illuminant).
        xyz.applyAdaptation(illuminant: targetIlluminant)

        return xyz
        
    }
    
    public static func sRGBToXYZ(color: sRGB, illuminant: Illuminant?, infos: [AnyHashable: Any]?) -> XYZ {
        RGBToXYZ(color: color, illuminant: illuminant, infos: infos)
    }
    
    public static func AppleRGBToXYZ(color: AppleRGB, illuminant: Illuminant?, infos: [AnyHashable: Any]?) -> XYZ {
        RGBToXYZ(color: color, illuminant: illuminant, infos: infos)
    }
    
    public static func AdobeRGBToXYZ(color: AdobeRGB, illuminant: Illuminant?, infos: [AnyHashable: Any]?) -> XYZ {
        RGBToXYZ(color: color, illuminant: illuminant, infos: infos)
    }
    
    public static func BT2020RGBToXYZ(color: BT2020RGB, illuminant: Illuminant?, infos: [AnyHashable: Any]?) -> XYZ {
        RGBToXYZ(color: color, illuminant: illuminant, infos: infos)
    }
    
    public static func RGBToHSV<T: RGBColorable>(color: T, infos: [AnyHashable: Any]?) -> HSV {
        
        /// Converts from RGB to HSV.
        ///
        /// H values are in degrees and are 0 to 360.
        /// S values are a percentage, 0.0 to 1.0.
        /// V values are a percentage, 0.0 to 1.0.

        let downColor = color.downable()
        
        let r = downColor.red
        let g = downColor.green
        let b = downColor.blue

        let max = Swift.max(r, g, b)
        let min = Swift.min(r, g, b)

        let h = __RGBToHue(red: r, green: g, blue: b, min: min, max: max)

        let s: Element
        if max == 0 {
            s = 0
        } else {
            s = 1.0 - (min / max)
        }

        let v = max

        return .init(h: h, s: s, v: v, illuminant: color.illuminant)
        
    }
    
    public static func sRGBToHSV(color: sRGB, infos: [AnyHashable: Any]?) -> HSV {
        RGBToHSV(color: color, infos: infos)
    }
    
    public static func AppleRGBToHSV(color: AppleRGB, infos: [AnyHashable: Any]?) -> HSV {
        RGBToHSV(color: color, infos: infos)
    }
    
    public static func AdobeRGBToHSV(color: AdobeRGB, infos: [AnyHashable: Any]?) -> HSV {
        RGBToHSV(color: color, infos: infos)
    }
    
    public static func BT2020RGBToHSV(color: BT2020RGB, infos: [AnyHashable: Any]?) -> HSV {
        RGBToHSV(color: color, infos: infos)
    }
    
    public static func RGBToHSL<T: RGBColorable>(color: T, infos: [AnyHashable: Any]?) -> HSL {
        
        /// Converts from RGB to HSL.
        ///
        /// H values are in degrees and are 0 to 360.
        /// S values are a percentage, 0.0 to 1.0.
        /// L values are a percentage, 0.0 to 1.0.
 
        let downColor = color.downable()
        
        let r = downColor.red
        let g = downColor.green
        let b = downColor.blue

        let max = Swift.max(r, g, b)
        let min = Swift.min(r, g, b)

        let h = __RGBToHue(red: r, green: g, blue: b, min: min, max: max)
        let l = 0.5 * (max + min)

        let s: Element
        if max == min {
            s = 0
        } else if l <= 0.5 {
            s = (max - min) / (2.0 * l)
        } else {
            s = (max - min) / (2.0 - (2.0 * l))
        }

        return .init(h: h, s: s, l: l, illuminant: color.illuminant)
        
    }
    
    public static func sRGBToHSL(color: sRGB, infos: [AnyHashable: Any]?) -> HSL {
        RGBToHSL(color: color, infos: infos)
    }
    
    public static func AppleRGBToHSL(color: AppleRGB, infos: [AnyHashable: Any]?) -> HSL {
        RGBToHSL(color: color, infos: infos)
    }
    
    public static func AdobeRGBToHSL(color: AdobeRGB, infos: [AnyHashable: Any]?) -> HSL {
        RGBToHSL(color: color, infos: infos)
    }
    
    public static func BT2020RGBToHSL(color: BT2020RGB, infos: [AnyHashable: Any]?) -> HSL {
        RGBToHSL(color: color, infos: infos)
    }
    
    public static func RGBToCMY<T: RGBColorable>(color: T, infos: [AnyHashable: Any]?) -> CMY {
    
        let downColor = color.downable()
        
        let r = downColor.red
        let g = downColor.green
        let b = downColor.blue
        
        /// NOTE: CMYK and CMY values range from 0.0 to 1.0
        let c = 1.0 - r
        let m = 1.0 - g
        let y = 1.0 - b

        return .init(c: c, m: m, y: y, illuminant: color.illuminant)
        
    }
    
    public static func sRGBToCMY(color: sRGB, infos: [AnyHashable: Any]?) -> CMY {
        RGBToCMY(color: color, infos: infos)
    }
    
    public static func AppleRGBToCMY(color: AppleRGB, infos: [AnyHashable: Any]?) -> CMY {
        RGBToCMY(color: color, infos: infos)
    }
    
    public static func AdobeRGBToCMY(color: AdobeRGB, infos: [AnyHashable: Any]?) -> CMY {
        RGBToCMY(color: color, infos: infos)
    }
    
    public static func BT2020RGBToCMY(color: BT2020RGB, infos: [AnyHashable: Any]?) -> CMY {
        RGBToCMY(color: color, infos: infos)
    }
    
    // MARK: - HSV
    public static func HSVToRGB<R: RGBColorable>(color: HSV, infos: [AnyHashable: Any]?) -> R {

        /// HSV to RGB conversion.
        ///
        /// H values are in degrees and are 0 to 360.
        /// S values are a percentage, 0.0 to 1.0.
        /// V values are a percentage, 0.0 to 1.0.

        let h = color.h
        let s = color.s
        let v = color.v

        let hFloored = floor(h)
        let hSubI = Int(hFloored / 60.0) % 6
        let varF = (h / 60.0) - floor(hFloored / 60.0)
        
        let varP = v * (1.0 - s)
        let varQ = v * (1.0 - varF * s)
        let varT = v * (1.0 - (1.0 - varF) * s)

        let r: Element
        let g: Element
        let b: Element
        switch hSubI {
        case 0:
            r = v
            g = varT
            b = varP
            
        case 1:
            r = varQ
            g = v
            b = varP
            
        case 2:
            r = varP
            g = v
            b = varT
            
        case 3:
            r = varP
            g = varQ
            b = v
            
        case 4:
            r = varT
            g = varP
            b = v
            
        case 5:
            r = v
            g = varP
            b = varQ
            
        default:
            #if DEBUG
            fatalError("Unable to convert HSL->RGB due to value error.")
            #else
            return .init()
            #endif
        }

        return .init(
            red: r, green: g, blue: b,
            illuminant: color.illuminant,
            isUpscale: false
        )
        
    }
    
    public static func HSVTosRGB(color: HSV, infos: [AnyHashable: Any]?) -> sRGB {
        HSVToRGB(color: color, infos: infos)
    }
    
    public static func HSVToAppleRGB(color: HSV, infos: [AnyHashable: Any]?) -> AppleRGB {
        HSVToRGB(color: color, infos: infos)
    }
    
    public static func HSVToAdobeRGB(color: HSV, infos: [AnyHashable: Any]?) -> AdobeRGB {
        HSVToRGB(color: color, infos: infos)
    }
    
    public static func HSVToBT2020RGB(color: HSV, infos: [AnyHashable: Any]?) -> BT2020RGB {
        HSVToRGB(color: color, infos: infos)
    }
    
    // MARK: - HSL
    public static func HSLToRGB<R: RGBColorable>(color: HSL, infos: [AnyHashable: Any]?) -> R {
        
        let h = color.h
        let s = color.s
        let l = color.l

        let varQ: Element
        if l < 0.5 {
            varQ = l * (1.0 + s)
        } else {
            varQ = l + s - (l * s)
        }

        let varP = 2.0 * l - varQ

        /// - Tag: H normalized to range `[0,1]`
        let hSubK = h / 360.0

        let tSubR = hSubK + (1.0 / 3.0)
        let tSubG = hSubK
        let tSubB = hSubK - (1.0 / 3.0)

        let r = __CalcHSLToRGBComponents(q: varQ, p: varP, C: tSubR)
        let g = __CalcHSLToRGBComponents(q: varQ, p: varP, C: tSubG)
        let b = __CalcHSLToRGBComponents(q: varQ, p: varP, C: tSubB)

        return .init(
            red: r, green: g, blue: b,
            illuminant: color.illuminant,
            isUpscale: false
        )
        
    }
    
    public static func HSLTosRGB(color: HSL, infos: [AnyHashable: Any]?) -> sRGB {
        HSLToRGB(color: color, infos: infos)
    }
    
    public static func HSLToAppleRGB(color: HSL, infos: [AnyHashable: Any]?) -> AppleRGB {
        HSLToRGB(color: color, infos: infos)
    }
    
    public static func HSLToAdobeRGB(color: HSL, infos: [AnyHashable: Any]?) -> AdobeRGB {
        HSLToRGB(color: color, infos: infos)
    }
    
    public static func HSLToBT2020RGB(color: HSL, infos: [AnyHashable: Any]?) -> BT2020RGB {
        HSLToRGB(color: color, infos: infos)
    }
    
    // MARK: - CMY
    public static func CMYToRGB<R: RGBColorable>(color: CMY, infos: [AnyHashable: Any]?) -> R {

        /// NOTE: Returned values are in the range of 0-255.

        let r = 1.0 - color.c
        let g = 1.0 - color.m
        let b = 1.0 - color.y

        return .init(
            red: r, green: g, blue: b,
            illuminant: color.illuminant,
            isUpscale: false
        )
        
    }
    
    public static func CMYTosRGB(color: CMY, infos: [AnyHashable: Any]?) -> sRGB {
        CMYToRGB(color: color, infos: infos)
    }
    
    public static func CMYToAppleRGB(color: CMY, infos: [AnyHashable: Any]?) -> AppleRGB {
        CMYToRGB(color: color, infos: infos)
    }
    
    public static func CMYToAdobeRGB(color: CMY, infos: [AnyHashable: Any]?) -> AdobeRGB {
        CMYToRGB(color: color, infos: infos)
    }
    
    public static func CMYToBT2020RGB(color: CMY, infos: [AnyHashable: Any]?) -> BT2020RGB {
        CMYToRGB(color: color, infos: infos)
    }
    
    public static func CMYToCMYK(color: CMY, infos: [AnyHashable: Any]?) -> CMYK {
    
        /// NOTE: CMYK and CMY values range from 0.0 to 1.0
        
        var varK: Element = 1.0
        if color.c < varK { varK = color.c }
        if color.m < varK { varK = color.m }
        if color.y < varK { varK = color.y }

        let c: Element
        let m: Element
        let y: Element
        if varK == 1 {
            c = 0.0
            m = 0.0
            y = 0.0
        } else {
            c = (color.c - varK) / (1.0 - varK)
            m = (color.m - varK) / (1.0 - varK)
            y = (color.y - varK) / (1.0 - varK)
        }
        let k = varK

        return .init(c: c, m: m, y: y, k: k, illuminant: color.illuminant)
        
    }
    
    // MARK: - CMYK
    public static func CMYKToCMY(color: CMYK, infos: [AnyHashable: Any]?) -> CMY {
        
        /// NOTE: CMYK and CMY values range from 0.0 to 1.0

        let c = color.c * (1.0 - color.k) + color.k
        let m = color.m * (1.0 - color.k) + color.k
        let y = color.y * (1.0 - color.k) + color.k

        return .init(c: c, m: m, y: y, illuminant: color.illuminant)
        
    }
    
    // MARK: - IPT
    public static func IPTToXYZ(color: IPT, infos: [AnyHashable: Any]?) -> XYZ {
        
        /// - Tag: Inv
        guard let lmsToIptInv = Math.inv(IPT.lmstoIptMatrices) else {
            #if DEBUG
            fatalError("lmsToIpt can not invertible.")
            #else
            return .init()
            #endif
        }

        /// - Tag: lmsToIptInv * iptValues
        let iptValues = color.elements
        
        let lmsValueMat = Math.mul(
            mat1: lmsToIptInv,
            mat2: (iptValues, iptValues.count, 1)
        )
        
        var lmsValues = lmsValueMat.values
        
        /// - Tag: Sign Lms
//        var signLmsValues = lmsValues.map { sign($0) }
        var signLmsValues = Math.sign(lmsValues)
        
        /// - Tag: ABS Lms
        let lmsCount = lmsValues.count
        var lmsCountInt32: Int32 = .init(lmsCount)
        var absLmsValues = [Element](repeating: 0, count: lmsCount)
        vvfabs(&absLmsValues, &lmsValues, &lmsCountInt32)
        
        var lmsPrimeTemp = [Element](repeating: 0, count: lmsCount)
        vDSP_vmulD(
            &signLmsValues, vDSP_Stride(1),
            &absLmsValues, vDSP_Stride(1),
            &lmsPrimeTemp, vDSP_Stride(1),
            vDSP_Length(lmsPrimeTemp.count)
        )
        
        var exponents = [Element](repeating: 1.0 / 0.43, count: lmsCount)
        
        var lmsPrime = [Element](repeating: 0, count: lmsCount)
        vvpow(&lmsPrime, &exponents, &lmsPrimeTemp, &lmsCountInt32)

        /// - Tag: Inv
        guard let xyzToLmsInv = Math.inv(IPT.xyzToLmsMatrices) else {
            #if DEBUG
            fatalError("xyzToLms can not invertible.")
            #else
            return .init()
            #endif
        }
        
        let xyzValues = Math.mul(
            mat1: xyzToLmsInv,
            mat2: (lmsPrime, lmsPrime.count, 1)
        ).values
        
        return .init(
            x: xyzValues[0], y: xyzValues[1], z: xyzValues[2],
            illuminant: .two(.d65)
        )
        
    }
    
}

//MARK: Converter Helper
extension ColorPathConverterSelector {
    
    public typealias Element = ColorElement.Element
    
    private static func applyRGBMatrix<RGB: RGBColorable>(var1: Element, var2: Element, var3: Element, rgbType: RGB.Type, isToRgb: Bool = true) -> (v1: Element, v2: Element, v3: Element) {
        
//        Applies an RGB working matrix to convert from XYZ to RGB.
//        The arguments are tersely named var1, var2, and var3 to allow for the
//        passing of XYZ _or_ RGB values. var1 is X for XYZ, and R for RGB. var2 and
//        var3 follow suit.
        
        /// - Tag: Retrieve the appropriate transformation matrix from the constants.
        let transMatrix = RGB.matrices(isToRgb: isToRgb)
        
        /// - Tag: Stuff the RGB/XYZ values into a NumPy matrix for conversion.
        let values = [var1, var2, var3]
        let valueM = values.count
        let valueN = 1
        
        let resultMatrix = Math.mul(
            mat1: transMatrix,
            mat2: (values: values, rows: .init(valueM), columns: .init(valueN))
        ).values

        /// - Tag: Clamp these values to a valid range.
        
        return (
            max(resultMatrix[0], 0),
            max(resultMatrix[1], 0),
            max(resultMatrix[2], 0)
        )
    }
    
    /// For RGBToHSL and RGBToHSV, the Hue (H) component is calculated in the same way.
    public static func __RGBToHue(red: Element, green: Element, blue: Element, min: Element, max: Element) -> Element {
        
        guard max != min else { return 0 }
        
        if max == red {
            return (
                60.0 * ((green - blue) / (max - min)) + 360
            ).truncatingRemainder(dividingBy: 360.0)
        }
        
        if max == green {
            return 60.0 * ((blue - red) / (max - min)) + 120
        }
        
        if max == blue {
            return 60.0 * ((red - green) / (max - min)) + 240.0
        }
        
        return 0
    }
    
    /// This is used in HSLToRGB conversions on R, G, and B.
    public static func __CalcHSLToRGBComponents(q: Element, p: Element, C: Element) -> Element {

        var C = C
        if C < 0 { C += 1.0 }
        if C > 1 { C -= 1.0 }

        /// - Tag: Computing C of vector (Color R, Color G, Color B)
        if C < (1.0 / 6.0) {
            return p + ((q - p) * 6.0 * C)
        } else if (1.0 / 6.0) <= C && C < 0.5 {
            return q
        } else if 0.5 <= C && C < (2.0 / 3.0) {
            return p + ((q - p) * 6.0 * ((2.0 / 3.0) - C))
        } else {
            return p
        }
        
    }
    
}

// MARK: - Math
internal func radians(_ degrees: Double) -> Double { .pi * degrees / 180 }
internal func degrees(_ radians: Double) -> Double { radians * 180 / .pi }
