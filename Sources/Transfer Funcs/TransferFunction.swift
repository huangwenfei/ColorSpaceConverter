//
//  TransferFunction.swift
//  ColorSpaceConverter iOS
//
//  Created by 黄文飞 on 2023/4/13.
//

import Foundation

public protocol TransferFunctionProtocol {
    
    typealias Element = ColorElement.Element
    typealias Elements = [Element]
    
    static var gamma: Double { get }
    
    static func eotfEncoding(_ elements: [Element]) -> [Element]
    static func eotfDecoding(_ elements: [Element]) -> [Element]
    
}

public struct TransferFunction {
    
    public typealias Element = TransferFunctionProtocol.Element
    public typealias Elements = TransferFunctionProtocol.Elements
    
    /// Define a typical gamma encoding / decoding function
    public static func gammaCoder(
        channel: Element,
        exponent: Element = 1,
        handling: GammaNegativeNumberHandling = .indeterminate
    ) -> Element {

        switch handling {
        case .indeterminate:
            return pow(channel, exponent)
        case .mirror:
            return Math.spow(channel, exponent)
        case .preserve:
            return channel <= 0 ? channel : pow(channel, exponent)
        case .clamp:
            return channel <= 0 ? 0 : pow(channel, exponent)
        }
        
    }
    
}

// MARK: - sRGB -
extension TransferFunction {
    public struct sRGB: TransferFunctionProtocol {
        
        public static let gamma: Element = 2.2
        
        /// `eotf_inverse_sRGB`
        public static func eotfEncoding(_ elements: Elements) -> Elements {
            elements.map { channel in
                channel <= 0.0031308
                    ? channel * 12.92
                    : 1.055 * Math.spow(channel, 1 / 2.4) - 0.055
            }
        }
        
        /// `eotf_sRGB`
        /// 0.04044990748269014 == eotfEncoding([0.0031308])
        public static func eotfDecoding(_ elements: Elements) -> Elements {
            elements.map { channel in
                channel <= 0.04044990748269014
                    ? channel / 12.92
                : Math.spow((channel + 0.055) / 1.055, 2.4)
            }
        }
        
    }
}

// MARK: - AdobeRGB -
extension TransferFunction {
    public struct AdobeRGB: TransferFunctionProtocol {
        
        public static let gamma: Element = 563.0 / 256.0
        
        public static func eotfEncoding(_ elements: Elements) -> Elements {
            elements.map { channel in
                TransferFunction.gammaCoder(
                    channel: channel, exponent: 1 / gamma
                )
            }
        }
        
        public static func eotfDecoding(_ elements: Elements) -> Elements {
            elements.map { channel in
                TransferFunction.gammaCoder(
                    channel: channel, exponent: gamma
                )
            }
        }
        
    }
}

// MARK: - AppleRGB -
extension TransferFunction {
    public struct AppleRGB: TransferFunctionProtocol {
        
        public static let gamma: Element = 1.8
        
        public static func eotfEncoding(_ elements: Elements) -> Elements {
            elements.map { channel in
                TransferFunction.gammaCoder(
                    channel: channel, exponent: 1 / gamma
                )
            }
        }
        
        public static func eotfDecoding(_ elements: Elements) -> Elements {
            elements.map { channel in
                TransferFunction.gammaCoder(
                    channel: channel, exponent: gamma
                )
            }
        }
        
    }
}

// MARK: - BT2020RGB -
extension TransferFunction {
    public struct BT2020RGB: TransferFunctionProtocol {
        
        public static let gamma: Element = 2.4
        
        public static func eotfEncoding(_ elements: Elements) -> Elements {
//        if kwargs.get("is_12_bits_system") {
//            let a = 1.0993, b = 0.0181
//        } else {
//            let a = 1.099, b = 0.018
//        }
            
            let a = 1.099, b = 0.018
            
            return elements.map { channel in
                channel < b
                ? channel * 4.5
                : a * Math.spow(channel, 0.45) - (a - 1)
            }
        }
        
        public static func eotfDecoding(_ elements: Elements) -> Elements {
//        if kwargs.get("is_12_bits_system"):
//            a, b, c = 1.0993, 0.0181, 0.081697877417347  # noqa
//        else:
//            a, b, c = 1.099, 0.018, 0.08124794403514049  # noqa
            
            let a = 1.099, c = 0.08124794403514049
            
            return elements.map { channel in
                channel <= c
                    ? channel / 4.5
                    : Math.spow((channel + (a - 1)) / a, 1 / 0.45)
            }
        }
        
    }
}

// MARK: - BT709RGB -
extension TransferFunction {
    public struct BT709RGB: TransferFunctionProtocol {
        
        public static let gamma: Element = BT2020RGB.gamma
        
        public static func eotfEncoding(_ elements: Elements) -> Elements {
            elements.map { channel in
                channel < 0.018
                    ? channel * 4.5
                    : 1.099 * Math.spow(channel, 0.45) - 0.099
            }
        }
        
        public static func eotfDecoding(_ elements: Elements) -> Elements {
            /// oetf_BT601(0.018) == 0.08124794403514046 (1.099 * pow(0.018, 0.45) - 0.099)
            elements.map { channel in
                channel < 0.08124794403514046
                ? channel / 4.5
                : Math.spow((channel + 0.099) / 1.099, 1 / 0.45)
            }
        }
        
    }
}

// MARK: - DCIP3RGB -
extension TransferFunction {
    public struct DCIP3RGB: TransferFunctionProtocol {
        
        public static let gamma: Element = 2.6
        
        public static func eotfEncoding(_ elements: Elements) -> Elements {
            elements.map { channel in
                TransferFunction.gammaCoder(
                    channel: channel, exponent: 1 / gamma
                )
            }
        }
        
        public static func eotfDecoding(_ elements: Elements) -> Elements {
            elements.map { channel in
                TransferFunction.gammaCoder(
                    channel: channel, exponent: gamma
                )
            }
        }
        
    }
}

// MARK: - DCIP3PRGB -
extension TransferFunction {
    public struct DCIP3PRGB: TransferFunctionProtocol {
        
        public static let gamma: Element = DCIP3RGB.gamma
        
        public static func eotfEncoding(_ elements: Elements) -> Elements {
            DCIP3RGB.eotfEncoding(elements)
        }
        
        public static func eotfDecoding(_ elements: Elements) -> Elements {
            DCIP3RGB.eotfDecoding(elements)
        }
        
    }
}

// MARK: - DisplayP3RGB -
extension TransferFunction {
    public struct DisplayP3RGB: TransferFunctionProtocol {
        
        public static let gamma: Element = 2.2
        
        public static func eotfEncoding(_ elements: Elements) -> Elements {
            sRGB.eotfEncoding(elements)
        }
        
        public static func eotfDecoding(_ elements: Elements) -> Elements {
            sRGB.eotfDecoding(elements)
        }
        
    }
}

// MARK: - CIERGB -
extension TransferFunction {
    public struct CIERGB: TransferFunctionProtocol {
        
        public static let gamma: Element = 2.2
        
        public static func eotfEncoding(_ elements: Elements) -> Elements {
            elements.map { channel in
                TransferFunction.gammaCoder(
                    channel: channel, exponent: 1 / gamma
                )
            }
        }
        
        public static func eotfDecoding(_ elements: Elements) -> Elements {
            elements.map { channel in
                TransferFunction.gammaCoder(
                    channel: channel, exponent: gamma
                )
            }
        }
        
    }
}

// MARK: - AdobeWideGamutRGB -
extension TransferFunction {
    public struct AdobeWideGamutRGB: TransferFunctionProtocol {
        
        public static let gamma: Element = AdobeRGB.gamma
        
        public static func eotfEncoding(_ elements: Elements) -> Elements {
            elements.map { channel in
                TransferFunction.gammaCoder(
                    channel: channel, exponent: 1 / gamma
                )
            }
        }
        
        public static func eotfDecoding(_ elements: Elements) -> Elements {
            elements.map { channel in
                TransferFunction.gammaCoder(
                    channel: channel, exponent: gamma
                )
            }
        }
        
    }
}
