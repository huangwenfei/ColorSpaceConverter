//
//  ColorPathSelector+LCHab.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2023/4/15.
//

import Foundation

extension ColorPathSelector {
    public struct LCHabSelector {
        
        public static let selectors: ColorPathSelector.SelectorDict = [
            toLab.pathId: toLab
        ]
     
        public static let toLab: PathConverter = .init( .LCHab ==> .Lab ) {
            .init( Self.toLab(color: ($0.base as! LCHab), infos: $1) )
        }
        
    }
}

extension ColorPathSelector.LCHabSelector {
    
    public static func toLab(color: LCHab, infos: [AnyHashable: Any]?) -> Lab {
    
        let l = color.l
        let a = cos(Math.radians(color.b)) * color.a
        let b = sin(Math.radians(color.b)) * color.a
        
        return .init(
            l: l, a: a, b: b, illuminant: color.illuminant
        )
    
    }
    
}
