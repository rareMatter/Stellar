//
//  SListRowData.swift
//  
//
//  Created by Jesse Spencer on 3/8/21.
//

import UIKit

public
struct SListRowData {
    
    var contentConfiguration: SContentConfiguration?
    var backgroundConfiguration: UIBackgroundConfiguration?
    var accessories: [UICellAccessory] = []
    
    public
    init(contentConfiguration: SContentConfiguration?, backgroundConfiguration: UIBackgroundConfiguration? = nil, accessories: [UICellAccessory] = []) {
        self.contentConfiguration = contentConfiguration
        self.backgroundConfiguration = backgroundConfiguration
        self.accessories = accessories
    }
}
public
extension SListRowData {
    /// A row which contains no content. Useful for recovering from errors.
    static var blank: Self {
        .init(contentConfiguration: nil)
    }
}
