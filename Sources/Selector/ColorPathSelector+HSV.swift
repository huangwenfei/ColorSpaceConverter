//
//  ColorPathSelector+HSV.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2023/4/15.
//

import Foundation

extension ColorPathSelector {
    public struct HSVSelector {
        
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
            toAdobeWideGamutRGB.pathId: toAdobeWideGamutRGB
        ]
        
        public static let tosRGB: PathConverter = .init( .HSV ==> .sRGB ) {
            .init( Self.tosRGB(color: ($0.base as! HSV), infos: $1) )
        }
        
        public static let toAppleRGB: PathConverter = .init( .HSV ==> .AppleRGB ) {
            .init( Self.toAppleRGB(color: ($0.base as! HSV), infos: $1) )
        }
        
        public static let toAdobeRGB: PathConverter = .init( .HSV ==> .AdobeRGB ) {
            .init( Self.toAdobeRGB(color: ($0.base as! HSV), infos: $1) )
        }
        
        public static let toBT2020RGB: PathConverter = .init( .HSV ==> .BT2020RGB ) {
            .init( Self.toBT2020RGB(color: ($0.base as! HSV), infos: $1) )
        }
        
        public static let toBT709RGB: PathConverter = .init( .HSV ==> .BT709RGB ) {
            .init( Self.toBT709RGB(color: ($0.base as! HSV), infos: $1) )
        }

        public static let toDCIP3RGB: PathConverter = .init( .HSV ==> .DCIP3RGB ) {
            .init( Self.toDCIP3RGB(color: ($0.base as! HSV), infos: $1) )
        }

        public static let toDCIP3PRGB: PathConverter = .init( .HSV ==> .DCIP3PRGB ) {
            .init( Self.toDCIP3PRGB(color: ($0.base as! HSV), infos: $1) )
        }

        public static let toDisplayP3RGB: PathConverter = .init( .HSV ==> .DisplayP3RGB ) {
            .init( Self.toDisplayP3RGB(color: ($0.base as! HSV), infos: $1) )
        }

        public static let toCIERGB: PathConverter = .init( .HSV ==> .CIERGB ) {
            .init( Self.toCIERGB(color: ($0.base as! HSV), infos: $1) )
        }

        public static let toAdobeWideGamutRGB: PathConverter = .init( .HSV ==> .AdobeWideGamutRGB ) {
            .init( Self.toAdobeWideGamutRGB(color: ($0.base as! HSV), infos: $1) )
        }
        
    }
}

extension ColorPathSelector.HSVSelector {
    
    public static func toRGB<R: RGBColorable>(color: HSV, infos: [AnyHashable: Any]?) -> R {

        /// HSV to RGB conversion.
        ///
        /// H values are in degrees and are 0 to 1.0.
        /// S values are a percentage, 0.0 to 1.0.
        /// V values are a percentage, 0.0 to 1.0.
        ///

        let downable = color.downable()
        
        let h = downable.h * 360.0
        let s = downable.s
        let v = downable.v

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
    
    public static func tosRGB(color: HSV, infos: [AnyHashable: Any]?) -> sRGB {
        toRGB(color: color, infos: infos)
    }
    
    public static func toAppleRGB(color: HSV, infos: [AnyHashable: Any]?) -> AppleRGB {
        toRGB(color: color, infos: infos)
    }
    
    public static func toAdobeRGB(color: HSV, infos: [AnyHashable: Any]?) -> AdobeRGB {
        toRGB(color: color, infos: infos)
    }
    
    public static func toBT2020RGB(color: HSV, infos: [AnyHashable: Any]?) -> BT2020RGB {
        toRGB(color: color, infos: infos)
    }
    
    public static func toBT709RGB(color: HSV, infos: [AnyHashable: Any]?) -> BT709RGB {
        toRGB(color: color, infos: infos)
    }

    public static func toDCIP3RGB(color: HSV, infos: [AnyHashable: Any]?) -> DCIP3RGB {
        toRGB(color: color, infos: infos)
    }

    public static func toDCIP3PRGB(color: HSV, infos: [AnyHashable: Any]?) -> DCIP3PRGB {
        toRGB(color: color, infos: infos)
    }

    public static func toDisplayP3RGB(color: HSV, infos: [AnyHashable: Any]?) -> DisplayP3RGB {
        toRGB(color: color, infos: infos)
    }

    public static func toCIERGB(color: HSV, infos: [AnyHashable: Any]?) -> CIERGB {
        toRGB(color: color, infos: infos)
    }

    public static func toAdobeWideGamutRGB(color: HSV, infos: [AnyHashable: Any]?) -> AdobeWideGamutRGB {
        toRGB(color: color, infos: infos)
    }
    
}
