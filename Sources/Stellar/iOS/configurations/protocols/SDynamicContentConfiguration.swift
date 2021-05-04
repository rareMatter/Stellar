//
//  File.swift
//  
//
//  Created by Jesse Spencer on 3/28/21.
//

import Foundation

#warning("TODO: This will become internal when content configurations have become internal.")
/// A content configuration which can change size dynamically.
public
protocol SDynamicContentConfiguration: SContentConfiguration, SDynamicContentContainer {}
