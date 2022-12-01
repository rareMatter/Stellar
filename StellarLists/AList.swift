//
//  AList.swift
//  StellarLists
//
//  Created by Jesse Spencer on 4/27/21.
//

import UIKit
import Stellar
import SwiftUI
import Combine

extension Int: Identifiable {
    public var id: Self { self }
}

struct AList: SContent {

    let theme = ColorTheme()
    
    var body: some SContent {
        SButton {
            
        } content: {
            SText("Button")
        }
        .background(SColor.blue)
//        .disabled(true)
//        .disabled(false)
//        SText("Second text")
//        SText("third text")
//        SText("fourth text")
//        SHStack {
//            SText("Some text")
//            SText("Second text")
//            SText("third text")
//            SText("fourth text")
//        }
//        SHStack {
//            SText("soemthing")
//        }
    }
    
    /*
    var content: ViewHierarchyObject {
        SList(0...9) { row in
            switch row {
                case 0:
                    SLeadingViewLabel(text: "Centered Leading view Centered Leading view Centered Leading view Centered Leading view",
                                      leadingView: UIImageView(image: UIImage(systemName: "circle")!))
                        .editingSelectable()
                        .accessories([UICellAccessory
                                        .disclosureIndicator(displayed: .always)])
                        .onTap {
                            debugPrint("Tapped SLeadingViewLabel.")
                        }
                        .background(theme.baseColors.accentColor)
                case 1:
                    SLeadingButtonLabel(text: "leading button label",
                                        buttonImage: UIImage(systemName: "square")!) {
                        // button action
                    }
                                        .disabled()
                                        .background(.blue)
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
                        .background(.green)
                        .cornerRadius(25)
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
                        .background(.yellow)
                        .cornerRadius(12)
                default:
                    SEmptyContent()
            }
        }
        .content
    }
     */
}

/// A description of a theme. This type allows you to provide your own type for arbitrary special colors. A theme allows dynamic color selection using environmental properties.
struct BaseColorTheme {
    
    /*
    //    focus colors
    /// Applied to surfaces which should stand out and match other stand-out surfaces, such as buttons.
    var accentColor: SDynamicColor = .init { scheme in
        .init(red: 225, green: 97, blue: 60, colorSpace: .displayP3)
    }
    /// Applied to surfaces in combination with the accent color. Use this color to add more interest to particular aspects of a surface while coordinating with the accent color.
    var highlightColor: SDynamicColor = .init { scheme in
        .orange
    }
    /// Applied to surfaces which are in the foreground (or uppermost context). This should be things such as text or symbols within buttons.
    var foregroundColor: SDynamicColor = .init { scheme in
        scheme == .light ? .white : .black
    }
    /// Applied to surfaces which currently have focus. Only one surface should have this color applied at a time.
    /// - Note: If this color is the same as accent color, the focus effect may be lost.
    var focusedColor: SDynamicColor = .init { scheme in
        .orange
    }
    
    //    backgrounds
    var baseBackground: SDynamicColor = .init { scheme in
        scheme == .light ? .black : .white
    }
    var secondaryBackground: SDynamicColor = .init { scheme in
        scheme == .light ? .black : .white
    }
    var tertiaryBackground: SDynamicColor = .init { scheme in
        scheme == .light ? .black : .white
    }
    var quaternaryBackground: SDynamicColor = .init { scheme in
        scheme == .light ? .black : .white
    }
     */
}

struct ListsColorTheme {
    var schedule: SColor = .orange
    var history: SColor = .purple
    var labels: SColor = .blue
    var unsorted: SColor = .yellow
}

struct ColorTheme {
    let baseColors: BaseColorTheme = .init()
    let listColors: ListsColorTheme = .init()
}
