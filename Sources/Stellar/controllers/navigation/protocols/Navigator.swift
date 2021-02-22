//
//  Navigator.swift
//  life-tool-1
//
//  Created by Jesse Spencer on 9/8/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import Foundation
import UIKit

/// Describes an object which is capable of performing navigation to destinations of the associated Destination type.
protocol Navigator {
	associatedtype Destination
	func go(to destination: Destination, withAnimation: Bool)
}
extension Navigator where Destination == Never {
	/// A Destination of Never represents a leaf location, which cannot navigate to a new destination.
	func go(to destination: Never, withAnimation: Bool) {}
}
