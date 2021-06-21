//
//  AList.swift
//  StellarLists
//
//  Created by Jesse Spencer on 4/27/21.
//

import UIKit
import Stellar

struct AList: SView {
    var id: UUID = .init()
    
    let model = SStaticListModel<Int, Int>(staticSnapshot: .snapshot()
                                            .appendingSection(0,
                                                              withItems: Array(0...9)))
    let searchTextModel = SearchTextStorage()
    
    var content: ViewHierarchyObject {
        SListView(listModel: model) { section, item, listState, configState in
            switch item {
                case 0:
                    SLeadingViewLabel(text: "Centered Leading view Centered Leading view Centered Leading view Centered Leading view",
                                      leadingView: UIImageView(image: UIImage(systemName: "circle")!))
                        .editingSelectable()
                        .accessories([UICellAccessory
                                        .disclosureIndicator(displayed: .always)])
                        .onTap {
                            debugPrint("Tapped SLeadingViewLabel.")
                        }
                        .background(.orange)
                case 1:
                    SLeadingButtonLabel(text: "leading button label",
                                        buttonImage: UIImage(systemName: "square")!) {
                        // button action
                    }
                    .disabled()
                    .background(.init(.systemTeal))
                case 2:
                    SLeadingCheckboxLabel(title: "leading checkbox",
                                          checkboxImage: UIImage(systemName: "square"),
                                          checkboxBackgroundColor: nil,
                                          subtitle: "A subtitle",
                                          subtitleLeadingView: UIImageView(image: UIImage(systemName: "circle")),
                                          trailingViews: [UIImageView(image: UIImage(systemName: "triangle")),
                                                          UIImageView(image: UIImage(systemName: "note.text"))]) {
                        // checkbox response
                    }
                case 3:
                    SLeadingViewLabel(text: "leading view label",
                                      leadingView: UIImageView(image: UIImage(systemName: "circle.fill")))
                case 4:
                    SLeadingViewTextEditor(text: "leading view text editor",
                                           placeholderText: "Type something...",
                                           leadingView: UIImageView(image: UIImage(systemName: "circle"))) { text in
                        // text changed
                    }
                case 5:
                    SButton(title: "button",
                            backgroundColor: nil) {
                        // Button action
                    }
                    .disabled(false)
                case 6:
                    SContextMenuButton(image: UIImage(systemName: "eyes.inverse")!,
                                       menuItems: [UIAction(title: "Do something", handler: { _ in } )])
                case 7:
                    SSearchBar(text: "search bar",
                               placeholderText: "Search something...") { searchText in
                        // search entered action
                        searchTextModel.searchText = searchText
                    } onSearchEnded: {
                        // search ended action
                    }
                    .disabled(false)
                case 8:
                    STextEditor(text: "Some text",
                                placeholderText: "Edit...") { text in
                        // update storage
                    }
                case 9:
                    CompositeContent(title: "This is a composite.")
//                    SEmptyContent()
                default:
                    SEmptyContent()
            }
        }
        .content
    }
}

struct CompositeContent: SContent {
    
    var title: String
    
    var body: some SContent {
        SLeadingViewLabel(text: title,
                          leadingView: UIView())
    }
}

final
class SearchTextStorage {
    var searchText = "" {
        didSet {
            debugPrint("Search bar text did update: \(searchText)")
        }
    }
}
