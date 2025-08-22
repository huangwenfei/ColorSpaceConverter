# ColorSpaceConverter
Conversion of various color models.

# Architecture

## Overall

<img width="2524" height="1864" alt="Graph RGB Combine" src="https://github.com/user-attachments/assets/bc8b5a95-9477-441b-acb8-3fae3c2ca3ba" />

## RGB Only

<img width="4372" height="1204" alt="Graph RGB Only 2" src="https://github.com/user-attachments/assets/1aebe3ba-7a62-42e6-bd0c-2a05a1e94a03" />

# Installation

Install via Swift package manager as a `dependency`:

```swift
.package(url: "https://github.com/huangwenfei/ColorSpaceConverter", from: "0.1.9")
```

Install via Cocoapods:

```ruby
pod 'ColorSpaceConverter'
```

# Usage

## import

```swift
import ColorSpaceConverter
```

## Protocol

In addition to the `struct Spectral: SpectralColorableProtocol` is special, other color model is to follow the `NormalColorableProtocol`.

## Converter

### Creating colors

```swift

/// RGB

let intRgb = AppleRGB(red: 50, green: 100, blue: 12); /// red [0, 255]

let floatRgb = AppleRGB(red: 0.1, green: 0.3, blue: 0.5, isUpscale: true); /// red [0, 1]
let floatRgb = AppleRGB(red: 50, green: 100, blue: 12, isUpscale: false); /// red [0, 255]

let intIlluminantRgb = AppleRGB(red: 50, green: 100, blue: 12, illuminant: .two(.d65)); /// red [0, 255], illuminant: 2 Degrees, D65 light

/// Hex

let intHex = Hex(red: 50, green: 100, blue: 12, alpha: 255); /// red [0, 255]
let floatHex = Hex(red: 0.1, green: 0.3, blue: 0.5, alpha: 1.0); /// red [0, 1]

/// Other
let xyz = XYZ(x: 0.1, y: 0.2, z: 0.3, isUpscale: true, illuminant: .two(.d65)); /// x [0, 1]

let lab = Lab(l: 0.1, a: 0.2, b: 0.3, isUpscale: true, illuminant: .two(.d65)); /// l [0, 1]

```

`isUpscale`: 
- RGB: `false` -> [0, 1], `true` -> [0, 255]
- XYZ: `false` -> [0, 1], `true` -> x [0, 95.047], y [0, 100], z [0, 108.883]
- CMYK: `false` -> [0, 1], `true` -> [0, 100]

### Normal -> Normal

```swift

let rgb = ...;
let hsl = Converter.convert(from: rgb, to: HSL.self)
let hslIlluminant = Converter.convert(from: rgb, to: HSL.self, toIlluminant: .ten(.d50)) /// 10 Degrees, D50 light

let xyz = ...;
let hsv = Converter.convert(from: xyz, to: HSV.self, througthRGB: AppleRGB.self) /// xyz -> apple rgb -> HSV

```

### Special -> Normal

```swift

let spectral = Spectral(v_340nm: ...);
let hsl = Converter.convert(from: spectral, to: HSL.self) /// spectral -> xyz -> srgb -> hsl
let hsl = Converter.convert(from: spectral, to: HSL.self, througthRGB: AppleRGB.self) /// spectral -> xyz -> apple rgb -> hsl

```

### Normal -> Special

```swift

let hsl = ...;
let spectral = Converter.convert(from: hsl, to: Spectral.self) /// hsl -> srgb -> xyz -> spectral
let spectral = Converter.convert(from: hsl, to: Spectral.self, througthRGB: AppleRGB.self) /// hsl -> apple rgb -> xyz -> spectral

```

