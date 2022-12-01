//
//  SAlignment.swift
//  
//
//  Created by Jesse Spencer on 11/19/21.
//

public
struct SAlignment: Equatable, Hashable {
    
    public
    var horizontal: SHorizontalAlignment
    public
    var vertical: SVerticalAlignment
    
    public
    init(horizontal: SHorizontalAlignment,
         vertical: SVerticalAlignment) {
        self.horizontal = horizontal
        self.vertical = vertical
    }
}
// MARK: defaults
extension SAlignment {
    public static let topLeading = Self(horizontal: .leading,
                                        vertical: .top)
    public static let top = Self(horizontal: .center,
                                 vertical: .top)
    public static let topTrailing = Self(horizontal: .trailing,
                                         vertical: .top)
    public static let leading = Self(horizontal: .leading,
                                     vertical: .center)
    public static let center = Self(horizontal: .center,
                                    vertical: .center)
    public static let trailing = Self(horizontal: .trailing,
                                      vertical: .center)
    public static let bottomLeading = Self(horizontal: .leading,
                                           vertical: .bottom)
    public static let bottom = Self(horizontal: .center,
                                    vertical: .bottom)
    public static let bottomTrailing = Self(horizontal: .trailing,
                                            vertical: .bottom)
}
