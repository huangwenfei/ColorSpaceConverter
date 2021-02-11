//
//  Converter.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2020/11/13.
//  Copyright © 2020 黄文飞. All rights reserved.
//

import Foundation

public struct Converter { }

// MARK: - Normal Color ==> Normal Color
extension Converter {
    
    public static func convert<From, To>(
        from: From,
        to: To.Type,
        toIlluminant illuminant: Illuminant? = nil,
        infos: [AnyHashable: Any]? = nil
    ) -> To
        where From: NormalColorableProtocol, To: NormalColorableProtocol
    {
        
        _convert(
            from: from,
            to: to,
            toIlluminant: illuminant ?? from.illuminant,
            infos: infos
        )
    }
    
    public static func convert<From, To, RGB>(
        from: From,
        to: To.Type,
        througthRGB rgb: RGB.Type,
        toIlluminant illuminant: Illuminant? = nil,
        infos: [AnyHashable: Any]? = nil
    ) -> To
        where From: NormalColorableProtocol, To: NormalColorableProtocol, RGB: RGBColorable
    {
        
        _convert(
            from: from,
            to: to,
            througthRGB: rgb,
            toIlluminant: illuminant ?? from.illuminant,
            infos: infos
        )
    }
    
}

// MARK: - Spectral Color ==> Normal Color
extension Converter {
    
    public static func convert<From, To>(
        from: From,
        to: To.Type,
        toIlluminant illuminant: Illuminant? = nil,
        infos: [AnyHashable: Any]? = nil
    ) -> To
        where From: SpectralColorableProtocol, To: NormalColorableProtocol
    {
        
        _convert(
            from: from,
            to: to,
            througthRGB: sRGB.self,
            toIlluminant: illuminant ?? .default,
            infos: infos
        )
    }
    
    public static func convert<From, To, RGB>(
        from: From,
        to: To.Type,
        througthRGB rgb: RGB.Type,
        toIlluminant illuminant: Illuminant? = nil,
        infos: [AnyHashable: Any]? = nil
    ) -> To
        where From: SpectralColorableProtocol, To: NormalColorableProtocol, RGB: RGBColorable
    {
        
        _convert(
            from: from,
            to: to,
            througthRGB: rgb,
            toIlluminant: illuminant ?? .default,
            infos: infos
        )
    }
    
}

#if false
// MARK: - Normal Color ==> Spectral Color
extension Converter {
    
    public static func convert<From, To>(
        from: From,
        to: To.Type,
        toIlluminant illuminant: SpectralIlluminantOverlap = .default,
        infos: [AnyHashable: Any]?
    ) -> To
        where From: NormalColorableProtocol, To: SpectralColorableProtocol
    {
        
        _convert(
            from: from,
            to: to,
            througthRGB: sRGB.self,
            toIlluminant: illuminant.unoverlap,
            infos: infos
        )
    }
    
    public static func convert<From, To, RGB>(
        from: From,
        to: To.Type,
        througthRGB rgb: RGB.Type,
        toIlluminant illuminant: SpectralIlluminantOverlap = .default,
        infos: [AnyHashable: Any]?
    ) -> To
        where From: NormalColorableProtocol, To: SpectralColorableProtocol, RGB: RGBColorable
    {
        
        _convert(
            from: from,
            to: to,
            througthRGB: rgb,
            toIlluminant: illuminant.unoverlap,
            infos: infos
        )
    }
    
}
#endif

// MARK: - Privates
extension Converter {
    
    private static func _convert<From, To, Light>(
        from: From,
        to: To.Type,
        toIlluminant illuminant: Light,
        infos: [AnyHashable: Any]?
    ) -> To
        where From: Colorable, To: Colorable, Light: IlluminantProtocol
    {
        
        _convert(
            from: from,
            to: to,
            througthRGB: sRGB.self,
            toIlluminant: illuminant,
            infos: infos
        )
    }
    
    private static func _convert<From, To, Light, RGB>(
        from: From,
        to: To.Type,
        througthRGB rgb: RGB.Type,
        toIlluminant illuminant: Light,
        infos: [AnyHashable: Any]?
    ) -> To
        where From: Colorable, To: Colorable, Light: IlluminantProtocol, RGB: RGBColorable
    {
        
        guard "\(from.self)" != "\(to.self)" else { return from as! To }
        
        /// - Tag: Color Paths
        let converters = ColorPath(from: from.colorSpace, to: to)
            .generate(througthRGB: .init(color: rgb))
        
        /// - Tag: Replace RGB
        
        /// - Tag: Iter Paths
        let color: AnyColorable = converters.reduce(.init(from)) {
            $1.convert(from: $0, illuminant: illuminant, infos: infos)
        }
        
        return color.base as! To
    }
    
}
