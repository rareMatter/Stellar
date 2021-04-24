//
//  ToolbarContainerViewController.swift
//  
//
//  Created by Jesse Spencer on 4/23/21.
//

import UIKit
import SwiftUI
import SnapKit

/// A container view controller which accepts a content view controller and places a provided toolbar at the bottom of its view.
///
/// The content's bottom additional safe area inset is updated whenever the height of the toolbar can change.
///
/// The only visual content of this controller is determined by the toolbar you provide.
final
class ToolbarContainerViewController<Toolbar>: NLViewController where Toolbar: View {
    
    private
    let contentViewController: UIViewController
    
    private
    let toolbarHostingController: UIHostingController<Toolbar>
    
    // -- init
    
    init(contentViewController: UIViewController, @ViewBuilder toolbar: () -> Toolbar) {
        self.contentViewController = contentViewController
        self.toolbarHostingController = .init(rootView: toolbar())

        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // -- view lifecycle
    
    override
    func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
    }
    
    override
    func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // update safe area insets to allow content to adjust for toolbar height
        contentViewController.additionalSafeAreaInsets.bottom =
            toolbarHostingController.view.frame.height
    }
    
    /// Embeds and configures views in the hierarchy.
    private
    func configureHierarchy() {
        // configure view
        view.backgroundColor = nil
        
        // embed content
        embedChild(contentViewController)
        
        // embed toolbar
        embedChild(toolbarHostingController)
        toolbarHostingController.view.snp.remakeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        toolbarHostingController.view.backgroundColor = nil
    }
}
