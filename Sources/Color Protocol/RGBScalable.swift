//
//  RGBScalable.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2023/4/15.
//

import Foundation

public protocol RGBScalable: ColorScalable {
    
    var red: Element { get set }
    var green: Element { get set }
    var blue: Element { get set }
    
    static var redUpperRange: Range { get }
    static var greenUpperRange: Range { get }
    static var blueUpperRange: Range { get }
    static var alphaUpperRange: Range { get }
    
    static var redDownerRange: Range { get }
    static var greenDownerRange: Range { get }
    static var blueDownerRange: Range { get }
    static var alphaDownerRange: Range { get }
    
}

extension RGBScalable {
    
    public func downable() -> Self {
        
        var result = self
        
        if isUpscale {
            result.red   /= 255
            result.green /= 255
            result.blue  /= 255
        }
        
        result.isUpscale = false
        
        return result
    }
    
    public func uppable() -> Self {
        
        var result = self
        
        if !isUpscale {
            result.red   *= 255
            result.green *= 255
            result.blue  *= 255
        }
        
        result.isUpscale = true
        
        return result
    }
    
}

extension RGBScalable {
    
    public static var redUpperRange: ColorElement.Range {
        .init(0, 255)
    }
    
    public static var greenUpperRange: ColorElement.Range {
        redUpperRange
    }
    
    public static var blueUpperRange: ColorElement.Range {
        redUpperRange
    }
    
    public static var alphaUpperRange: ColorElement.Range {
        redUpperRange
    }
    
    
    public static var redDownerRange: ColorElement.Range {
        .init(0, 1)
    }
    
    public static var greenDownerRange: ColorElement.Range {
        redDownerRange
    }
    
    public static var blueDownerRange: ColorElement.Range {
        redDownerRange
    }
    
    public static var alphaDownerRange: ColorElement.Range {
        redDownerRange
    }
    
}
