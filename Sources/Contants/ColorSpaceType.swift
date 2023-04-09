//
//  ColorSpaceType.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2020/11/13.
//  Copyright © 2020 黄文飞. All rights reserved.
//

import Foundation

public enum ColorSpaceType: String {
    
    case unknown
    
    case Hex
    
    case sRGB
    case AppleRGB
    case AdobeRGB
    case BT2020RGB
    case BT709RGB
    case DICP3RGB
    case DICP3PRGB
    case DisplayP3RGB
    case CIERGB
    case AdobeWideGamutRGB
    
    case HSV
    case HSL
    
    case CMY
    case CMYK
    
    case XYZ
    case xyY
    
    case Lab
    case Luv
    case LCHab
    case LCHuv
    
    case IPT
    
    case Spectral
    
    public init<C: Colorable>(color: C.Type) {
        switch "\(color)" {
        case Self.Hex.rawValue:                self = .Hex
        case Self.sRGB.rawValue:               self = .sRGB
        case Self.AppleRGB.rawValue:           self = .AppleRGB
        case Self.AdobeRGB.rawValue:           self = .AdobeRGB
        case Self.BT2020RGB.rawValue:          self = .BT2020RGB
        case Self.BT709RGB.rawValue:           self = .BT709RGB
        case Self.DICP3RGB.rawValue:           self = .DICP3RGB
        case Self.DICP3PRGB.rawValue:          self = .DICP3PRGB
        case Self.DisplayP3RGB.rawValue:       self = .DisplayP3RGB
        case Self.CIERGB.rawValue:             self = .CIERGB
        case Self.AdobeWideGamutRGB.rawValue:  self = .AdobeWideGamutRGB
        case Self.HSV.rawValue:                self = .HSV
        case Self.HSL.rawValue:                self = .HSL
        case Self.CMY.rawValue:                self = .CMY
        case Self.CMYK.rawValue:               self = .CMYK
        case Self.XYZ.rawValue:                self = .XYZ
        case Self.xyY.rawValue:                self = .xyY
        case Self.Lab.rawValue:                self = .Lab
        case Self.Luv.rawValue:                self = .Luv
        case Self.LCHab.rawValue:              self = .LCHab
        case Self.LCHuv.rawValue:              self = .LCHuv
        case Self.IPT.rawValue:                self = .IPT
        case Self.Spectral.rawValue:           self = .Spectral
        default:                               self = .unknown
        }
    }
    
    public var isRgb: Bool {
        self == .sRGB              ||
        self == .AppleRGB          ||
        self == .AdobeRGB          ||
        self == .BT2020RGB         ||
        self == .BT709RGB          ||
        self == .DICP3RGB          ||
        self == .DICP3PRGB         ||
        self == .DisplayP3RGB      ||
        self == .CIERGB            ||
        self == .AdobeWideGamutRGB
    }
    
}

extension ColorSpaceType {
    
    public enum RGB: String {
        case unknown
        
        case sRGB
        case AppleRGB
        case AdobeRGB
        case BT2020RGB
        case BT709RGB
        case DICP3RGB
        case DICP3PRGB
        case DisplayP3RGB
        case CIERGB
        case AdobeWideGamutRGB
        
        public init<C: Colorable>(color: C.Type) {
            switch "\(color)" {
            case Self.sRGB.rawValue:               self = .sRGB
            case Self.AppleRGB.rawValue:           self = .AppleRGB
            case Self.AdobeRGB.rawValue:           self = .AdobeRGB
            case Self.BT2020RGB.rawValue:          self = .BT2020RGB
            case Self.BT709RGB.rawValue:           self = .BT709RGB
            case Self.DICP3RGB.rawValue:           self = .DICP3RGB
            case Self.DICP3PRGB.rawValue:          self = .DICP3PRGB
            case Self.DisplayP3RGB.rawValue:       self = .DisplayP3RGB
            case Self.CIERGB.rawValue:             self = .CIERGB
            case Self.AdobeWideGamutRGB.rawValue:  self = .AdobeWideGamutRGB
            default:                               self = .unknown
            }
        }
        
        public var colorSpace: ColorSpaceType {
            switch self {
            case .unknown:            return .unknown
            case .sRGB:               return .sRGB
            case .AppleRGB:           return .AppleRGB
            case .AdobeRGB:           return .AdobeRGB
            case .BT2020RGB:          return .BT2020RGB
            case .BT709RGB:           return .BT709RGB
            case .DICP3RGB:           return .DICP3RGB
            case .DICP3PRGB:          return .DICP3PRGB
            case .DisplayP3RGB:       return .DisplayP3RGB
            case .CIERGB:             return .CIERGB
            case .AdobeWideGamutRGB:  return .AdobeWideGamutRGB
            }
        }
    }
    
}
