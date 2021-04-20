//
//  SListRow.swift
//  
//
//  Created by Jesse Spencer on 3/8/21.
//

import UIKit

public
struct SListRow {
    
    var contentConfiguration: SContentConfiguration?
    var backgroundConfiguration: UIBackgroundConfiguration? = nil
    var accessories: [UICellAccessory] = []
    
    // -- selection
    var isSelectable: Bool = true
    
    var tapHandler: OnTapHandler?
    
    public
    init(contentConfiguration: SContentConfiguration?) {
        self.contentConfiguration = contentConfiguration
    }
}

// MARK: - api
public
extension SListRow {
    
    func selectable(_ selectable: Bool) -> Self {
        var modified = self
        modified.isSelectable = selectable
        return modified
    }
    
    func accessories(_ accessories: [UICellAccessory]) -> Self {
        var modified = self
        modified.accessories = accessories
        return modified
    }
    
    func background(_ configuration: UIBackgroundConfiguration?) -> Self {
        var modified = self
        modified.backgroundConfiguration = configuration
        return modified
    }
    
    // MARK: - taps
    func onTap(_ handler: @escaping OnTapHandler) -> Self {
        var modified = self
        modified.tapHandler = handler
        return modified
    }
}

// MARK: - blank rows
public
extension SListRow {
    /// A row which contains no content. Useful for recovering from errors.
    static var blank: Self {
        .init(contentConfiguration: nil)
    }
}

// MARK: - typealiases
public
extension SListRow {
    typealias OnTapHandler = () -> Void
}
