// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal enum Assets {
    internal static let accentColor = ColorAsset(name: "AccentColor")
    internal static let antenna = ImageAsset(name: "antenna")
    internal static let arrow = ImageAsset(name: "arrow")
    internal static let badge = ImageAsset(name: "badge")
    internal static let bell = ImageAsset(name: "bell")
    internal static let cancelMatch = ImageAsset(name: "cancel_match")
    internal static let check = ImageAsset(name: "check")
    internal static let closeBig = ImageAsset(name: "close_big")
    internal static let closeSmall = ImageAsset(name: "close_small")
    internal static let faq = ImageAsset(name: "faq")
    internal static let filterControl = ImageAsset(name: "filter_control")
    internal static let friendsAct = ImageAsset(name: "friends_act")
    internal static let friendsInact = ImageAsset(name: "friends_inact")
    internal static let friendsPlus = ImageAsset(name: "friends_plus")
    internal static let homeAct = ImageAsset(name: "home_act")
    internal static let homeInact = ImageAsset(name: "home_inact")
    internal static let img = ImageAsset(name: "img")
    internal static let logout = ImageAsset(name: "logout")
    internal static let man = ImageAsset(name: "man")
    internal static let message = ImageAsset(name: "message")
    internal static let more = ImageAsset(name: "more")
    internal static let moreArrow = ImageAsset(name: "more_arrow")
    internal static let myAct = ImageAsset(name: "my_act")
    internal static let myInact = ImageAsset(name: "my_inact")
    internal static let notice = ImageAsset(name: "notice")
    internal static let permit = ImageAsset(name: "permit")
    internal static let place = ImageAsset(name: "place")
    internal static let plus = ImageAsset(name: "plus")
    internal static let qna = ImageAsset(name: "qna")
    internal static let search = ImageAsset(name: "search")
    internal static let sendAct = ImageAsset(name: "send_act")
    internal static let sendInact = ImageAsset(name: "send_inact")
    internal static let settingAlarm = ImageAsset(name: "setting_alarm")
    internal static let shopAct = ImageAsset(name: "shop_act")
    internal static let shopInact = ImageAsset(name: "shop_inact")
    internal static let siren = ImageAsset(name: "siren")
    internal static let toggleOff = ImageAsset(name: "toggle_off")
    internal static let toggleOn = ImageAsset(name: "toggle_on")
    internal static let woman = ImageAsset(name: "woman")
    internal static let write = ImageAsset(name: "write")
    internal static let socialLifeCuate = ImageAsset(name: "Social life-cuate")
    internal static let onboardingImg1 = ImageAsset(name: "onboarding_img1")
    internal static let onboardingImg2 = ImageAsset(name: "onboarding_img2")
  }
  internal enum Colors {
    internal static let black = ColorAsset(name: "black")
    internal static let white = ColorAsset(name: "white")
    internal static let brandGreen = ColorAsset(name: "brand_green")
    internal static let brandWhitegreen = ColorAsset(name: "brand_whitegreen")
    internal static let brandYellowgreen = ColorAsset(name: "brand_yellowgreen")
    internal static let gray1 = ColorAsset(name: "gray1")
    internal static let gray2 = ColorAsset(name: "gray2")
    internal static let gray3 = ColorAsset(name: "gray3")
    internal static let gray4 = ColorAsset(name: "gray4")
    internal static let gray5 = ColorAsset(name: "gray5")
    internal static let gray6 = ColorAsset(name: "gray6")
    internal static let gray7 = ColorAsset(name: "gray7")
    internal static let error = ColorAsset(name: "error")
    internal static let focus = ColorAsset(name: "focus")
    internal static let success = ColorAsset(name: "success")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
