//
//  AListView.swift
//  StellarLists
//
//  Created by Jesse Spencer on 4/27/21.
//

import Foundation
import Stellar

struct AList: SView {
    var id: UUID = .init()
    
    var content: ViewHierarchyObject {
        list.content
    }
    
    private
    var list: SListView<SStaticListModel<String, String>> {
        .init(snapshot: .snapshot()
                .appendingSection("section")
                .appendingItems(["1", "2", "3"], toSection: "section")) { section, item, listState, configState in
            row(item: item)
        }
    }
    
    private
    func row(item: String) -> SListRow {
        let buttonConfig = ButtonConfiguration()
        let contentConfig = GoalRowContentConfiguration(
            titleTextContent: .init(labelConfiguration: .init(text: item),
                                    buttonConfiguration: buttonConfig))
        
        return .init(contentConfiguration: contentConfig)
    }
}
