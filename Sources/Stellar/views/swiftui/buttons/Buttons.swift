//
//  Buttons.swift
//  Stellar
//
//  Created by Jesse Spencer on 2/1/21.
//  Copyright © 2021 Jesse Spencer. All rights reserved.
//

import SwiftUI

// MARK: - Leading Image
public
struct LeadingImageButton: View {
    
    let title: String
    let image: Image
    let onTap: () -> Void
    
    public var body: some View {
        Button(action: { self.onTap() }) {
            HStack {
                image
                Text(title)
                Spacer()
            }
        }
    }
}

// MARK: - List Link
/// A view with a title and trailing chevron to indicate that a tap will navigate into a corresponding view using a navigation stack.
public
struct ListLink: View {
    let title: String
    let image: Image
    
    public var body: some View {
        HStack {
            image
            Text(title)
            Spacer()
            Image(systemName: "chevron.right")
                .padding()
        }
        .offset(.init(width: 15, height: 0))
        .padding(.horizontal)
    }
}

// MARK: - Back Button

/// The system standard back button with chevron.
public
struct BackButton: View {
    
    let title: String
    let onTap: () -> Void
    
    public var body: some View {
        LeadingImageButton(title: title, image: Image(systemName: "chevron.left"), onTap: onTap)
            .imageScale(.large)
    }
    
}

// MARK: - Cancel
/// A button that says "Cancel".
public
struct CancelButton: View {
    let tapHandler: () -> Void
    
    public
    init(tapHandler: @escaping () -> Void) {
        self.tapHandler = tapHandler
    }
    
    public var body: some View {
        Button(action: {
            self.tapHandler()
        }) {
            Text("Cancel")
        }
    }
}

// MARK: - Done
/// A button that says "Done".
public
struct DoneButton: View {
    let tapHandler: () -> Void
    
    public
    init(tapHandler: @escaping () -> Void) {
        self.tapHandler = tapHandler
    }
    
    public var body: some View {
        Button(action: {
            self.tapHandler()
        }) {
            Text("Done")
        }
    }
}

// MARK: - Completion
/// A circle that toggles its fill, using the provided binding.
public
struct CompletionButton: View {
    
    var onTap: () -> Void = { }
    @Binding var isComplete: Bool
    let size: CGSize
    let color: Color
    
    public var body: some View {
        
        Button(action: {
            self.onTap()
            self.isComplete.toggle()
        }) {
            Circle()
                .fill(Color.clear)
                .frame(width: size.width, height: size.height)
                .conditionalModifier(self.isComplete, CompleteModifier(color: color), IncompleteModifier(color: color))
        }
        .buttonStyle(ButtonPressStyle())
    }
    
    // -- Modifiers
    struct IncompleteModifier: ViewModifier {
        let color: Color
        
        func body(content: Content) -> some View {
            content.overlay(
                Circle()
                    .stroke(lineWidth: 4)
                    .foregroundColor(color)
            )
        }
    }
    
    struct CompleteModifier: ViewModifier {
        let color: Color
        
        func body(content: Content) -> some View {
            content.overlay(
                Circle()
                    .fill(color)
            )
        }
    }
    // --
}



// MARK: - Edit
/// A button for toggling an editing binding. Use this as a simple bypass to the environment EditMode.
public
struct JSEditButton: View {
    
    @Binding var isEditing: Bool
    
    var onTap: ((_ isEditing: Bool) -> Void) = { _ in }
    
    public var body: some View {
        Group {
            if isEditing {
                Button(action: {
                    withAnimation {
                        self.isEditing = false
                        self.onTap(self.isEditing)
                    }
                }, label: {
                    Text("Done")
                })
            }
            else {
                Button(action: {
                    withAnimation {
                        self.isEditing = true
                        self.onTap(self.isEditing)
                    }
                }, label: {
                    Text("Edit")
                })
            }
        }
    }
}

// MARK: - New Tag
public
struct NewTagButton: View {
    
    let onTap: () -> Void
    
    public init(onTap: @escaping () -> Void) {
        self.onTap = onTap
    }
    
    public var body: some View {
        Button(action: {
            self.onTap()
        }) {
            Text("Add New Tag")
        }
        .buttonStyle(ButtonPressStyle())
        .background(Color.blue)
    }
    
}

// MARK: - Tag
@available(*, deprecated, message: "Use an NLButton with a button factory object instead.")
public
struct TagButton: View {
    let onTap: () -> Void
    
    public init(onTap: @escaping () -> Void = {}) {
        self.onTap = onTap
    }
    
    public var body: some View {
        Button(action: {
            self.onTap()
        }) {
            Image(systemName: "tag.fill")
        }
    }
}

// MARK: - Date
@available(*, deprecated, message: "Use an NLButton with a button factory object instead.")
public
struct DateButton: View {
    let onTap: () -> Void
    
    public init(onTap: @escaping () -> Void = {}) {
        self.onTap = onTap
    }
    
    public var body: some View {
        Button(action: {
            self.onTap()
        }) {
            Image(systemName: "calendar")
        }
    }
}

// MARK: - Recurrence
@available(*, deprecated, message: "Use an NLButton with a button factory object instead.")
public
struct RecurrenceButton: View {
    let onTap: () -> Void
    
    public var body: some View {
        Button(action: {
            self.onTap()
        }) {
            Image(systemName: "repeat")
        }
    }
}

// MARK: - Subtasks
public
struct SubtasksButton: View {
    let onTap: () -> Void
    
    public init(onTap: @escaping () -> Void = {}) {
        self.onTap = onTap
    }
    
    public var body: some View {
        Button(action: {
            self.onTap()
        }) {
            Image(systemName: "list.bullet")
        }
    }
}

// MARK: - list selection
@available(*, deprecated, message: "Use an NLButton with a button factory object instead.")
public
struct ListSelectionButton: View {
    let onTap: () -> Void
    public var body: some View {
        Button(action: onTap) {
            Image(systemName: "folder.fill")
        }
    }
}

// MARK: - trash
@available(*, deprecated, message: "Use an NLButton with a button factory object instead.")
public
struct TrashButton: View {
    let onTap: () -> Void
    public var body: some View {
        Image(systemName: "trash.fill")
    }
}

// MARK: - previews
#if DEBUG
struct MiscelaneousButtons_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            LeadingImageButton(title: "Leading image button", image: Image(systemName: "sunrise")) {}
            ListLink(title: "List link", image: Image(systemName: "moon"))
            BackButton(title: "Back") {}
            CancelButton {}
            DoneButton {}
            Group {
                CompletionButton(onTap: {}, isComplete: .constant(true), size: .init(width: 35, height: 35), color: .blue)
                CompletionButton(onTap: {}, isComplete: .constant(false), size: .init(width: 35, height: 35), color: .blue)
            }
            Group {
                JSEditButton(isEditing: .constant(true)) { (editing) in }
                JSEditButton(isEditing: .constant(false)) { (editing) in }
            }
            NewTagButton {}
            SubtasksButton {}
        }
        .previewLayout(.sizeThatFits)
    }
}
#endif
