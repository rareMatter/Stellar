//
//  ButtonStyles.swift
//  Stellar
//
//  Created by Jesse Spencer on 12/2/19.
//  Copyright © 2019 Jesse Spencer. All rights reserved.
//

import SwiftUI

// MARK: - Completion Button Major Style
public
struct CompletionButtonMajorStyle: ButtonStyle {
	
	let isSelected: Bool
	
    public func makeBody(configuration: Self.Configuration) -> some View {
		configuration.label
			.conditionalModifier(self.isSelected,
								 CompleteModifier(),
								 IncompleteModifier())
			.padding()
			.compositingGroup()
			.opacity(configuration.isPressed ? 0.89 : 1.0)
			.scaleEffect(configuration.isPressed ? 0.8 : 1.0)
	}
	
	// -- Modifiers
	struct IncompleteModifier: ViewModifier {
		func body(content: Content) -> some View {
			content.background(
				Circle()
					.stroke(lineWidth: 4)
					.foregroundColor(.green)
					.frame(minWidth: 20, maxWidth: 23, minHeight: 20, maxHeight: 23)
			)
		}
	}
	
	struct CompleteModifier: ViewModifier {
		func body(content: Content) -> some View {
			content.background(
				Circle()
					.fill(Color.green)
					.frame(minWidth: 24, maxWidth: 27, minHeight: 24, maxHeight: 27)
			)
		}
	}
	// --
}

// MARK: - Completion Button Minor Style
public
struct CompletionButtonMinorStyle: ButtonStyle {
	
	let isSelected: Bool
	
    public func makeBody(configuration: Self.Configuration) -> some View {
		configuration.label
			.conditionalModifier(self.isSelected,
								 CompleteModifier(),
								 IncompleteModifier())
			.padding()
			.compositingGroup()
			.opacity(configuration.isPressed ? 0.89 : 1.0)
			.scaleEffect(configuration.isPressed ? 0.8 : 1.0)
	}
	
	// -- Modifiers
	struct IncompleteModifier: ViewModifier {
		func body(content: Content) -> some View {
			content.background(
				Circle()
					.stroke(lineWidth: 3)
					.foregroundColor(.gray)
					.frame(minWidth: 20, maxWidth: 20, minHeight: 20, maxHeight: 20)
			)
		}
	}
	
	struct CompleteModifier: ViewModifier {
		func body(content: Content) -> some View {
			content.background(
				Circle()
					.fill(Color.gray)
					.frame(minWidth: 20, maxWidth: 20, minHeight: 20, maxHeight: 20)
			)
		}
	}
	// --
}

// MARK: - Tag Button style
public
struct TagButtonStyle: ButtonStyle {
    public init() {}
    public func makeBody(configuration: Self.Configuration) -> some View {
		HStack(alignment: .center) {
			Image(systemName: "tag")
				.imageScale(.small)
				.padding(.vertical, 4)
				.padding(.horizontal, 2)
			
			configuration.label
		}
		.padding(4)
		.background(
			RoundedRectangle(cornerRadius: 4.0)
				.fill(Color.gray).opacity(0.35))
	}
}

// MARK: - Button Press Style
/// A style that adds a press-down animation.
public
struct ButtonPressStyle: ButtonStyle {
	
    public func makeBody(configuration: Self.Configuration) -> some View {
		configuration.label
			.padding()
			.compositingGroup()
			.opacity(configuration.isPressed ? 0.89 : 1.0)
			.scaleEffect(configuration.isPressed ? 0.8 : 1.0)
	}
}

// MARK: - Selectable
/// A button style that allows selection.
public
struct SelectableButtonStyle: ButtonStyle {
	
	let isSelected: Bool
	let size: CGSize
	
    public func makeBody(configuration: Self.Configuration) -> some View {
		configuration.label
			.frame(width: self.size.width, height: self.size.height)
			.conditionalModifier(self.isSelected, SelectedModifier(), PlainModifier())
	}
	
	// -- Modifiers
	struct SelectedModifier: ViewModifier {
		func body(content: Content) -> some View {
			content.background(
				RoundedRectangle(cornerRadius: 8)
					.foregroundColor(Color.blue)
			)
		}
	}
	
	struct PlainModifier: ViewModifier {
		func body(content: Content) -> some View {
			content.background(
				RoundedRectangle(cornerRadius: 8)
					.foregroundColor(Color.clear)
			)
		}
	}
	// --
	
}
