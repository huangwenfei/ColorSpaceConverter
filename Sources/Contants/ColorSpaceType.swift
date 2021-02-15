//
//  ColorSpaceType.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2020/11/13.
//  Copyright © 2020 黄文飞. All rights reserved.
//

import Foundation

public enum ColorSpaceType: String {
    
    case unowned
    
    case Hex
    
    case sRGB
    case AppleRGB
    case AdobeRGB
    case BT2020RGB
    
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
        case Self.Hex.rawValue:       self = .Hex
        case Self.sRGB.rawValue:      self = .sRGB
        case Self.AppleRGB.rawValue:  self = .AppleRGB
        case Self.AdobeRGB.rawValue:  self = .AdobeRGB
        case Self.BT2020RGB.rawValue: self = .BT2020RGB
        case Self.HSV.rawValue:       self = .HSV
        case Self.HSL.rawValue:       self = .HSL
        case Self.CMY.rawValue:       self = .CMY
        case Self.CMYK.rawValue:      self = .CMYK
        case Self.XYZ.rawValue:       self = .XYZ
        case Self.xyY.rawValue:       self = .xyY
        case Self.Lab.rawValue:       self = .Lab
        case Self.Luv.rawValue:       self = .Luv
        case Self.LCHab.rawValue:     self = .LCHab
        case Self.LCHuv.rawValue:     self = .LCHuv
        case Self.IPT.rawValue:       self = .IPT
        case Self.Spectral.rawValue:  self = .Spectral
        default:                      self = .unowned
        }
    }
    
    public var isRgb: Bool {
        self == .sRGB ||
        self == .AppleRGB ||
        self == .AdobeRGB ||
        self == .BT2020RGB
    }
    
}

extension ColorSpaceType {
    
    public enum RGB: String {
        case unowned
        
        case sRGB
        case AppleRGB
        case AdobeRGB
        case BT2020RGB
        
        public init<C: Colorable>(color: C.Type) {
            switch "\(color)" {
            case Self.sRGB.rawValue:      self = .sRGB
            case Self.AppleRGB.rawValue:  self = .AppleRGB
            case Self.AdobeRGB.rawValue:  self = .AdobeRGB
            case Self.BT2020RGB.rawValue: self = .BT2020RGB
            default:                      self = .unowned
            }
        }
        
        public var colorSpace: ColorSpaceType {
            switch self {
            case .unowned:   return .unowned
            case .sRGB:      return .sRGB
            case .AppleRGB:  return .AppleRGB
            case .AdobeRGB:  return .AdobeRGB
            case .BT2020RGB: return .BT2020RGB
            }
        }
    }
    
}
