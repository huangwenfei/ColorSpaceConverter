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

public struct TransferFunctionCoding {
    
    public typealias Closure = TransferFunction.CodingClosure
    
    public var encoding: Closure
    public var decoding: Closure
    
    public init(encoding: @escaping Closure, decoding: @escaping Closure) {
        self.encoding = encoding
        self.decoding = decoding
    }
    
    public init(_ encoding: @escaping Closure, _ decoding: @escaping Closure) {
        self.encoding = encoding
        self.decoding = decoding
    }
    
}

public struct TransferFunction {
    
    // MARK: - Types -
    public typealias Element = TransferFunctionProtocol.Element
    public typealias Elements = TransferFunctionProtocol.Elements
    
    public typealias CodingClosure = (_ elements: Elements) -> Elements
    
    // MARK: - Gamma -
    ///
    /// Defines the behaviour for ``a`` negative numbers and / or the
    /// definition return value:
    ///
    /// -   *Indeterminate*: The behaviour will be indeterminate and
    ///     definition return value might contain *nans*.
    /// -   *Mirror*: The definition return value will be mirrored around
    ///     abscissa and ordinate axis, i.e. Blackmagic Design: Davinci Resolve
    ///     behaviour.
    /// -   *Preserve*: The definition will preserve any negative number in
    ///     ``a``, i.e. The Foundry Nuke behaviour.
    /// -   *Clamp*: The definition will clamp any negative number in ``a`` to
    ///     0.
    ///
    public enum GammaNegativeNumberHandling: Int {
        case indeterminate, mirror, preserve, clamp
    }
    
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
    
    // MARK: - Funcs -
    public static var funcs: [ColorSpaceType.RGB: TransferFunctionCoding] = [
        .unknown:           .init(LinearRGB.eotfEncoding, LinearRGB.eotfDecoding),
        .sRGB:              .init(sRGB.eotfEncoding, sRGB.eotfDecoding),
        .AdobeRGB:          .init(AdobeRGB.eotfEncoding, AdobeRGB.eotfDecoding),
        .AppleRGB:          .init(AppleRGB.eotfEncoding, AppleRGB.eotfDecoding),
        .BT2020RGB:         .init(BT2020RGB.eotfEncoding, BT2020RGB.eotfDecoding),
        .BT709RGB:          .init(BT709RGB.eotfEncoding, BT709RGB.eotfDecoding),
        .DCIP3RGB:          .init(DCIP3RGB.eotfEncoding, DCIP3RGB.eotfDecoding),
        .DCIP3PRGB:         .init(DCIP3PRGB.eotfEncoding, DCIP3PRGB.eotfDecoding),
        .DisplayP3RGB:      .init(DisplayP3RGB.eotfEncoding, DisplayP3RGB.eotfDecoding),
        .CIERGB:            .init(CIERGB.eotfEncoding, CIERGB.eotfDecoding),
        .AdobeWideGamutRGB: .init(AdobeWideGamutRGB.eotfEncoding, AdobeWideGamutRGB.eotfDecoding)
    ]
    
}

// MARK: - Linear RGB -
extension TransferFunction {
    public struct LinearRGB: TransferFunctionProtocol {
        
        public static let gamma: Element = 1
        
        public static func eotfEncoding(_ elements: Elements) -> Elements {
            elements
        }
        
        public static func eotfDecoding(_ elements: Elements) -> Elements {
            elements
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
