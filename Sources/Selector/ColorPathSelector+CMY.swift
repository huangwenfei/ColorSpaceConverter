//
//  ColorPathSelector+CMY.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2023/4/15.
//

import Foundation

extension ColorPathSelector {
    public struct CMYSelector {
        
        public typealias Element = ColorPathSelector.Element
        
        public static let selectors: ColorPathSelector.SelectorDict = [
            tosRGB.pathId:              tosRGB,
            toAppleRGB.pathId:          toAppleRGB,
            toAdobeRGB.pathId:          toAdobeRGB,
            toBT2020RGB.pathId:         toBT2020RGB,
            toBT709RGB.pathId:          toBT709RGB,
            toDCIP3RGB.pathId:          toDCIP3RGB,
            toDCIP3PRGB.pathId:         toDCIP3PRGB,
            toDisplayP3RGB.pathId:      toDisplayP3RGB,
            toCIERGB.pathId:            toCIERGB,
            toAdobeWideGamutRGB.pathId: toAdobeWideGamutRGB,
            
            toCMYK.pathId:              toCMYK
        ]
        
        public static let tosRGB: PathConverter = .init( .CMY ==> .sRGB ) {
            .init( Self.tosRGB(color: ($0.base as! CMY), infos: $1) )
        }
        
        public static let toAppleRGB: PathConverter = .init( .CMY ==> .AppleRGB ) {
            .init( Self.toAppleRGB(color: ($0.base as! CMY), infos: $1) )
        }
        
        public static let toAdobeRGB: PathConverter = .init( .CMY ==> .AdobeRGB ) {
            .init( Self.toAdobeRGB(color: ($0.base as! CMY), infos: $1) )
        }
        
        public static let toBT2020RGB: PathConverter = .init( .CMY ==> .BT2020RGB ) {
            .init( Self.toBT2020RGB(color: ($0.base as! CMY), infos: $1) )
        }
        
        public static let toBT709RGB: PathConverter = .init( .CMY ==> .BT709RGB ) {
            .init( Self.toBT709RGB(color: ($0.base as! CMY), infos: $1) )
        }

        public static let toDCIP3RGB: PathConverter = .init( .CMY ==> .DCIP3RGB ) {
            .init( Self.toDCIP3RGB(color: ($0.base as! CMY), infos: $1) )
        }

        public static let toDCIP3PRGB: PathConverter = .init( .CMY ==> .DCIP3PRGB ) {
            .init( Self.toDCIP3PRGB(color: ($0.base as! CMY), infos: $1) )
        }

        public static let toDisplayP3RGB: PathConverter = .init( .CMY ==> .DisplayP3RGB ) {
            .init( Self.toDisplayP3RGB(color: ($0.base as! CMY), infos: $1) )
        }

        public static let toCIERGB: PathConverter = .init( .CMY ==> .CIERGB ) {
            .init( Self.toCIERGB(color: ($0.base as! CMY), infos: $1) )
        }

        public static let toAdobeWideGamutRGB: PathConverter = .init( .CMY ==> .AdobeWideGamutRGB ) {
            .init( Self.toAdobeWideGamutRGB(color: ($0.base as! CMY), infos: $1) )
        }
        
        public static let toCMYK: PathConverter = .init( .CMY ==> .CMYK ) {
            .init( Self.toCMYK(color: ($0.base as! CMY), infos: $1) )
        }
        
    }
}

extension ColorPathSelector.CMYSelector {
    
    public static func toRGB<R: RGBColorable>(color: CMY, infos: [AnyHashable: Any]?) -> R {

        /// NOTE: Returned values are in the range of 0-255.
        
        let downable = color.downable()

        let r = 1.0 - downable.c
        let g = 1.0 - downable.m
        let b = 1.0 - downable.y

        return .init(
            red: r, green: g, blue: b,
            illuminant: color.illuminant,
            isUpscale: false
        )
        
    }
    
    public static func tosRGB(color: CMY, infos: [AnyHashable: Any]?) -> sRGB {
        toRGB(color: color, infos: infos)
    }
    
    public static func toAppleRGB(color: CMY, infos: [AnyHashable: Any]?) -> AppleRGB {
        toRGB(color: color, infos: infos)
    }
    
    public static func toAdobeRGB(color: CMY, infos: [AnyHashable: Any]?) -> AdobeRGB {
        toRGB(color: color, infos: infos)
    }
    
    public static func toBT2020RGB(color: CMY, infos: [AnyHashable: Any]?) -> BT2020RGB {
        toRGB(color: color, infos: infos)
    }
    
    public static func toBT709RGB(color: CMY, infos: [AnyHashable: Any]?) -> BT709RGB {
        toRGB(color: color, infos: infos)
    }

    public static func toDCIP3RGB(color: CMY, infos: [AnyHashable: Any]?) -> DCIP3RGB {
        toRGB(color: color, infos: infos)
    }

    public static func toDCIP3PRGB(color: CMY, infos: [AnyHashable: Any]?) -> DCIP3PRGB {
        toRGB(color: color, infos: infos)
    }

    public static func toDisplayP3RGB(color: CMY, infos: [AnyHashable: Any]?) -> DisplayP3RGB {
        toRGB(color: color, infos: infos)
    }

    public static func toCIERGB(color: CMY, infos: [AnyHashable: Any]?) -> CIERGB {
        toRGB(color: color, infos: infos)
    }

    public static func toAdobeWideGamutRGB(color: CMY, infos: [AnyHashable: Any]?) -> AdobeWideGamutRGB {
        toRGB(color: color, infos: infos)
    }
    
    public static func toCMYK(color: CMY, infos: [AnyHashable: Any]?) -> CMYK {
    
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
    
}
