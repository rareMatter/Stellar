//
//  ListViewController.swift
//  Stellar
//
//  Created by Jesse Spencer on 6/26/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit
import SwiftUI
import Combine

/// A highly configurable list view controller with robust layout options.
///
/// - Note: ListMode transition animations have been disabled due to unwanted inherent UIKit animations when custom cell accessories are changed.
final
class ListViewController<Model: SListModel, Configuration: ListViewControllerConfiguration>: NLViewController, UICollectionViewDelegate, UICollectionViewDragDelegate, UICollectionViewDropDelegate where
    Model.SectionType == Configuration.SectionType,
    Model.ItemType == Configuration.ItemType {
	
	// -- collection view
	// default list layout
	private var defaultListLayoutConfiguration: UICollectionLayoutListConfiguration {
		var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
		
		config.leadingSwipeActionsConfigurationProvider = { [unowned self] indexPath in
			let itemID = self.itemInSnapshot(with: indexPath)
			swipedItem = itemID
			
            if let swipeConfig = configuration
                .leadingSwipeActions(for: itemID) {
				return swipeConfig
					.bridgeToUISwipeActionsConfiguration(withDataForAction: self.dataForSwipeAction(_:))
			}
			else {
				return nil
			}
		}
		config.trailingSwipeActionsConfigurationProvider = { [unowned self] indexPath in
			let itemID = itemInSnapshot(with: indexPath)
			swipedItem = itemID
			
			if let swipeConfig = configuration
                .trailingSwipeActions(for: itemID) {
				return swipeConfig
					.bridgeToUISwipeActionsConfiguration(withDataForAction: self.dataForSwipeAction(_:))
			}
			else {
				return nil
			}
		}
		
		config.showsSeparators = false
        
		return config
	}
	private var defaultListLayout: UICollectionViewLayout {
		UICollectionViewCompositionalLayout.list(using: defaultListLayoutConfiguration)
	}
	private var collectionView: UICollectionView!
    private var collectionDataSource: CollectionDataSource!
    
    // -- appearance defaults
    var backgroundColor: UIColor {
        didSet {
            collectionView.backgroundColor = backgroundColor
        }
    }
    
    // -- configuration
	/// Configuration used to control list behaviors and handle events.
	private var configuration: Configuration
	
    // -- model
    private let listModel: Model
    private var snapshot: Snapshot {
        get { listModel.snapshotSubject.value }
        set { listModel.snapshotSubject.value = newValue }
    }
    
	// -- list state
	/// The current state of the list.
	private let listState: State
	private var mode: ListMode {
		get { listState.mode }
		set { listState.mode = newValue }
	}
	private var editingSelections: Set<ItemID> {
		get { listState.editingSelections }
		set { listState.editingSelections = newValue }
	}
	
	// ephemeral state
	private var dragItems = DragItems()
	private var swipedItem: ItemID? = nil
	private var firstResponderItem: ItemID? = nil
	
    // interaction
    /// Data which is used to coordinate between interaction inputs during a discrete multiselection session.
    private var multiselectSessionData: MultiselectTransaction?
    /// A pan gesture used for multiselection interaction. This property is set when the list begins editing and removed when it leaves editing.
    private var panGesture: UIPanGestureRecognizer?
    /// A tap gesture used to forward taps within the pan gesture region.
    private var tapGesture: UITapGestureRecognizer?
    /// A touch gesture used to respond immediately during selection.
    private var touchGesture: TouchGestureRecognizer?
    /// The gesture delegate proxy class.
    private let gestureRecognizerDelegate: GestureRecognizerDelegate = .init()
    /// A view which is used to scope the pan gesture recognizer. This view shares its lifecycle with the pan gesture.
    private var panRegionView: UIView?
    
	// -- observation
	private var cancellables = Set<AnyCancellable>()

	// MARK: - init
	
    init(configuration: Configuration,
         listModel: Model,
         listState: State = .init(),
         layout: UICollectionViewLayout? = nil,
         backgroundColor: UIColor = .systemGroupedBackground,
         rowContentProvider: @escaping (SectionID, ItemID, State, UICellConfigurationState) -> SContentCell.Content) {
		
        self.configuration = configuration
        self.listModel = listModel
		self.listState = listState
        self.backgroundColor = backgroundColor
        
		super.init(nibName: nil, bundle: nil)
        
        // create the collection view using the provided layout or default
		if let layout = layout {
            collectionView = Self.makeCollectionView(with: layout, delegate: self, backgroundColor: backgroundColor)
		}
		else {
            collectionView = Self.makeCollectionView(with: defaultListLayout, delegate: self, backgroundColor: backgroundColor)
		}
        
        self.collectionDataSource = .init(collectionView: collectionView, cellProvider: { [unowned self] (collectionView, indexPath, item) -> SContentCell? in
            
            // create registration
            let cellRegistration = UICollectionView.CellRegistration<SContentCell, ItemID> { cell, indexPath, item in
                
                // prepare cell to update itself with content when state changes
                cell.onConfigurationStateChange { configState in
                    // subscribe to special content types
                    self.subscribeToDynamicSizeNotifier(cell)
                    self.subscribeToResponderNotifier(cell)
                    
                    return rowContentProvider(self.sectionInSnapshot(with: indexPath),
                                              item,
                                              listState,
                                              configState)
                }
                // tell cell to update for initial state
                cell.setNeedsUpdateConfiguration()
            }
            
            // dequeue cell
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            return cell
        })
        
        subscribeToStateChanges()
        
        // connect snapshot pipeline
        self.listModel
            .snapshotSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] (updatedSnapshot: Snapshot) in
                assert(self != nil, "Attempt to apply updated snapshot while self is nil.")
                self?.applySnapshot(updatedSnapshot)
            }
            .store(in: &cancellables)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }
    
	// MARK: - view lifecycle
	
    override func viewDidLoad() {
		super.viewDidLoad()
		
		embedView(collectionView)
		applySnapshot(self.snapshot)
	}
	
    override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if !viewHasAppeared,
		   let initialFirstResponderItem = configuration.initialFirstResponder() {
			updateFirstResponderToItem(initialFirstResponderItem)
		}
	}
	
	// MARK: collection delegate

    // -- highlight
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        shouldSelect(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        
    }
    
	// -- selection
	
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        shouldSelect(indexPath)
	}

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        handleSelection(at: indexPath)
	}
	
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		if mode == .editing {
			let itemID = itemInSnapshot(with: indexPath)
			editingSelections.remove(itemID)
		}
	}
	
	// -- drag
	
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
		guard mode != .editing else { return [] }
		
		let draggedItem = itemInSnapshot(with: indexPath)
		
		guard configuration
                .canReorder(item: itemInSnapshot(with: indexPath))
		else { return [] }
		
		let sourceSection = sectionInSnapshot(with: indexPath)
		
		if snapshot.itemIsHeader(draggedItem) {
			// Reorder section by creating drag items for all items IDs in the section.
			dragItems = DragItems(sections: [sourceSection], items: snapshot.itemsIn(sourceSection))
			return dragItems.items.map { _ in UIDragItem(itemProvider: NSItemProvider()) }
		}
		else {
			// Reorder only single row by creating a drag item.
			dragItems = .init(items: [draggedItem])
			return [UIDragItem(itemProvider: NSItemProvider())]
		}
	}
	
    func collectionView(_ collectionView: UICollectionView, dragSessionIsRestrictedToDraggingApplication session: UIDragSession) -> Bool {
		true
	}
	
    func collectionView(_ collectionView: UICollectionView, dragSessionWillBegin session: UIDragSession) {
		mode = .reordering
		if dragItems.containsSection {
			var dragSnapshot = snapshot
			dragSnapshot.deleteSections(dragItems.sections)
			let items = snapshot.items().filter { !snapshot.itemIsHeader($0) }
			dragSnapshot.deleteItems(items)
			applySnapshot(dragSnapshot)
		}
	}
	
	// -- drop

    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
		collectionView.hasActiveDrag
	}
	
	/// - Note: The drop proposal provided by this method is not guaranteed to be accurate when the performDrop method is subsequentally called.
    /// destinationIndexPath will be nil when the drag location is not over any cells. If the drag location is at the end of a section, it might be equal to the count of items in the section.
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        debugPrint(destinationIndexPath as Any)

		// drag session is from external source which is not currently supported.
		guard session.localDragSession != nil else {
			return .init(operation: .cancel, intent: .unspecified) }
		// drag originated from an object that isn't the table view which isn't currently supported.
		guard collectionView.hasActiveDrag else {
			return .init(operation: .cancel, intent: .unspecified) }
		// destination is indeterminate, cancel drop until user finds a certain spot.
		guard let destinationIndexPath = destinationIndexPath else {
			return .init(operation: .cancel, intent: .unspecified) }
		
		// -- preconditions passed. determine proposal:

		// reordering section
		if dragItems.containsSection {
			#warning("bug in section drag and drop")
			// TODO: Bug occurs when attempting to drop a section into the last position. table view returns a position for the last row in the last section rather than a new section. In order to eliminate most positions that aren't relevent in section reordering, a move is proposed only for 0 indexed rows. This means that section cannot be dropped into the last position.
			if destinationIndexPath.row == 0 {
				return .init(operation: .move, intent: .insertAtDestinationIndexPath)
			}
			else {
				return .init(operation: .cancel)
			}
		}
		// reordering item(s) only
		else {
			// determine destination section
			let destinationSection = collectionDataSource.snapshot().sectionIdentifiers[destinationIndexPath.section]
			guard let draggedItem = dragItems.items.first else {
				// this was decreased from an assertion: the table seems to frequently call this method before calling the items for beginning drag session method, leaving drag item state empty.
				debugPrint("expected dragged item: \(dragItems).\n\(#line)")
				return .init(operation: .forbidden)
			}
			guard configuration
                    .canInsertItemIntoSection(item: draggedItem, section: destinationSection)
			else { return .init(operation: .forbidden, intent: .unspecified) }

			// destination item exists at position
			if let destinationItem = collectionDataSource.itemIdentifier(for: destinationIndexPath) {
				// the destination is a header position
				if snapshot.itemIsHeader(destinationItem) {
					return .init(operation: .move, intent: .insertIntoDestinationIndexPath)
				}
				// the destination is not a header position
				else {
					return .init(operation: .move, intent: .insertAtDestinationIndexPath)
				}
			}
			// destination in table is a new position
			else {
				// new index is being created in section == must be end of section
				return .init(operation: .move, intent: .insertAtDestinationIndexPath)
			}
		}
	}
	
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
		// drag session is from external source which is not currently supported.
		guard coordinator.session.localDragSession != nil else { return }
		// drag originated from an object that isn't the table view which isn't currently supported.
		guard collectionView.hasActiveDrag else { return }
		// destination is indeterminate, cancel drop until user finds a certain spot.
		guard let destinationIndexPath = coordinator.destinationIndexPath else { return }
		
		// -- preconditions passed.
		// -- update snapshot and perform drop:
		
		// reordering section
		if dragItems.containsSection {
			// NOTE: The dragged sections have been removed from the table snapshot for visual purpose.
			guard let draggedSection = dragItems.sections.first else {
				debugPrint("expected dragged section.\n\(#line)")
				return
			}
			assert(!collectionDataSource.snapshot().sectionIdentifiers.contains(draggedSection), "Dragged section was not removed from table snapshot")
			let destinationSection = sectionInSnapshot(with: destinationIndexPath)
			
			// update snapshot
			let oldSnapshot = snapshot
			var newSnapshot = snapshot
			// determine the destination index. Since the dragged sections have been removed from the table snapshot, simply insert before the section of the reported index. If the reported index is outside the count of sections in the table, append instead.
			if destinationIndexPath.section >= collectionDataSource.snapshot().sectionIdentifiers.endIndex {
				// append
				newSnapshot.appendSections(dragItems.sections)
			}
			else {
				newSnapshot.move(dragItems.sections, before: destinationSection)
			}
			snapshot = newSnapshot
			
            configuration.didReorder(
                with: ListReorderingTransaction(initialSnapshot: oldSnapshot, finalSnapshot: newSnapshot))
        }
        // reordering item(s) only
		else {
			guard let sourceItem = dragItems.items.first else {
				debugPrint("expected drag items: \(dragItems)\n\(#line)")
				return
			}
			// determine destination section
			let destinationSection = sectionInSnapshot(with: destinationIndexPath)
			
			guard configuration
                    .canInsertItemIntoSection(item: sourceItem, section: destinationSection)
			else { return }
			
			// destination item exists at position
			if let destinationItem = collectionDataSource.itemIdentifier(for: destinationIndexPath) {
				
				if snapshot.itemIsHeader(destinationItem) {
					// update snapshot
					let oldSnapshot = snapshot
					var newSnapshot = snapshot
					// insert items at beginning of section (after header item)
					newSnapshot.moveItems(dragItems.items, after: destinationItem)
					snapshot = newSnapshot

                    configuration.didReorder(
                        with: ListReorderingTransaction(initialSnapshot: oldSnapshot, finalSnapshot: newSnapshot))
				}
				// the destination is not a header position
				else {
					guard let draggedItem = dragItems.items.first else {
						debugPrint("expected drag item: \(coordinator.items).\n\(#line)")
						return
					}
					let sourceIndexPath = indexPath(for: draggedItem)
					let sourceSection = sectionInSnapshot(with: sourceIndexPath)

					// update snapshot
					let oldSnapshot = snapshot
					var newSnapshot = snapshot
					// dragged item position is the same
					if sourceIndexPath == destinationIndexPath {
						// relocate only trailing drop items after the first
						let trailingDropItems = Array(dragItems.items.dropFirst())
						newSnapshot.moveItems(trailingDropItems, after: destinationItem)
					}
					else {
						let insertAfter = destinationIndexPath.row > sourceIndexPath.row &&
							sourceSection == destinationSection
						insertAfter ?
							newSnapshot.moveItems(dragItems.items, after: destinationItem) :
							newSnapshot.moveItems(dragItems.items, before: destinationItem)
					}
					snapshot = newSnapshot

                    configuration.didReorder(
                        with: ListReorderingTransaction(initialSnapshot: oldSnapshot, finalSnapshot: newSnapshot))
				}
			}
			// destination in table is a new position
			// new index is being created in section == must be end of section
			else {
				// update snapshot
				let oldSnapshot = snapshot
				var newSnapshot = snapshot
				newSnapshot.deleteItems(dragItems.items)
				newSnapshot.appendItems(dragItems.items, to: destinationSection)
				snapshot = newSnapshot

                configuration.didReorder(
                    with: ListReorderingTransaction(initialSnapshot: oldSnapshot, finalSnapshot: newSnapshot))
			}
			
            configuration.didInsertItemIntoSection(item: sourceItem, section: destinationSection)
		}
		
		// perform drop
		// all drag items are dropped in order starting with and following the destination index
		let coordinatorDragItems = coordinator.items.map { $0.dragItem }
		for (index, dragItem) in coordinatorDragItems.enumerated() {
			coordinator.drop(dragItem, toItemAt: IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section))
		}
	}
	
    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnd session: UIDropSession) {
		if dragItems.containsSection {
			applySnapshot(snapshot)
		}
		dragItems = .init()
		mode = .normal
	}
    
    // -- multiselection
    
    func collectionView(_ collectionView: UICollectionView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        false
    }
    
    // MARK: - multiselection
    
    /// Creates and embeds gesture recognizers needed for multiselection interactions. Current configuration state is used for setup.
    func startMultiselectionGestureRecognizers() {
        guard panGesture == nil else {
            assertionFailure("Found existing pan gesture recognizer when attempting to embed a new one.")
            return
        }
        guard panRegionView == nil else {
            assertionFailure("Found existing pan region view when attempting to embed a new one.")
            return
        }
        
        // Create pan region view
        panRegionView = .init()
        guard let panRegionView = self.panRegionView else { fatalError() }
        view.addSubview(panRegionView)
        panRegionView.translatesAutoresizingMaskIntoConstraints = false
        panRegionView.backgroundColor = .clear
        NSLayoutConstraint.activate([
            panRegionView.topAnchor.constraint(equalTo: view.topAnchor),
            panRegionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            panRegionView.widthAnchor.constraint(equalToConstant: CGFloat(configuration.multiselectionConfiguration.multiselectionPanGestureRegionSize))
        ])
        if configuration.multiselectionConfiguration.multiselectionPanGestureEdge == .leading {
            panRegionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        }
        else {
            panRegionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        }
        
        // Add pan gesture
        panGesture = .init(target: self, action: #selector(self.multiselectionPanGestureDidUpdate(_:)))
        guard let panGesture = self.panGesture else { fatalError() }
        panGesture.delegate = gestureRecognizerDelegate
        panGesture.maximumNumberOfTouches = 1
        panGesture.minimumNumberOfTouches = 1
        panRegionView.addGestureRecognizer(panGesture)
        
        // Add tap gesture
        tapGesture = .init(target: self, action: #selector(self.multiselectionTapGestureDidUpdate(_:)))
        guard let tapGesture = self.tapGesture else { fatalError() }
        tapGesture.delegate = gestureRecognizerDelegate
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.numberOfTapsRequired = 1
        panRegionView.addGestureRecognizer(tapGesture)
        
        // touch gesture
        /* Suspened until further dev. Needs advanced delegation to coordinate with taps.
         touchGesture = .init(target: self, action: #selector(self.multiselectionTouchGestureDidUpdate(_:)))
         guard let touchGesture = self.touchGesture else { fatalError() }
         touchGesture.delegate = gestureRecognizerDelegate
         panRegionView.addGestureRecognizer(touchGesture)
         */
    }
    
    /// Removes gesture recognizers which were added by `startMultiselectionGestureRecognizers()`, if existing.
    func removeMultiselectionGestureRecognizers() {
        guard let panRegionView = self.panRegionView else { return }
        panRegionView.removeFromSuperview()
        self.panRegionView = nil
        self.panGesture = nil
        self.tapGesture = nil
        self.touchGesture = nil
    }
    
    /// Handles gesture interactions for the multiselection pan.
    @objc
    private
    func multiselectionPanGestureDidUpdate(_ panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
            case .began, .changed:
                let location = panGesture.location(in: collectionView)
                handleContinuousSelectionAt(collectionViewLocation: location)
            
            case .ended, .cancelled, .failed:
                // end continuous session
                multiselectSessionData = nil
            
            default:
                break
        }
    }
    
    /// Handles gesture interactions for the multiselection tap.
    @objc
    private
    func multiselectionTapGestureDidUpdate(_ gesture: UITapGestureRecognizer) {
        // When the gesture ends, determine the location within the collection view and call the appropriate update method.
        if gesture.state == .ended {
            handleDiscreteSelectionAt(collectionViewLocation:
                                        gesture.location(in: collectionView))
        }
    }
    
    /// Handles gesture interactions for the multiselection touch.
    @objc
    private
    func multiselectionTouchGestureDidUpdate(_ gesture: TouchGestureRecognizer) {
        // When the gesture ends, determine the location within the collection view and call the appropriate update method.
        if gesture.state == .ended {
            handleDiscreteSelectionAt(collectionViewLocation:
                                        gesture.location(in: collectionView))
        }
    }
    
    /// This method handles a selection at the collectionView location and performs updates if needed.
    /// - Parameter collectionViewLocation: A location within the collection view's coordinate system.
    private
    func handleDiscreteSelectionAt(collectionViewLocation location: CGPoint) {
        if let indexPath = collectionView.indexPathForItem(at: location) {
            if shouldSelect(indexPath) {
                handleSelection(at: indexPath)
            }
        }
    }
    
    /// This method handles a selection at the collectionView location and performs updates if needed.
    private
    func handleContinuousSelectionAt(collectionViewLocation location: CGPoint) {
        // determine if a row has been selected
        guard let indexPath = collectionView.indexPathForItem(at: location) else { return }
        
        if shouldSelect(indexPath) {
            handleSelection(at: indexPath, isContinuous: true)
        }
    }
}

// MARK: - init helpers
private
extension ListViewController {
    
    func subscribeToStateChanges() {
        listState.$mode
            .removeDuplicates()
            // Get the current value on the publisher's thread before switching to the main thread.
            .map { [unowned self] (newMode) -> (currentMode: ListMode, newMode: ListMode) in
                (self.listState.mode, newMode)
            }
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] (currentMode, newMode) in
                UIView.performWithoutAnimation {
                    self.updateFrom(currentMode, to: newMode)
                }
            }
            .store(in: &cancellables)
        
        listState.$editingSelections
            .removeDuplicates()
            .map { [unowned self] (newEditingSelections) -> (currentEditingSelections: Set<ItemID>, newEditingSelections: Set<ItemID>) in
                (self.listState.editingSelections, newEditingSelections)
            }
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] (currentSelections, newSelections) in
                self.updateSelections(from: currentSelections, to: newSelections)
            }
            .store(in: &cancellables)
    }
    
    static
    func makeCollectionView(with layout: UICollectionViewLayout, delegate: UICollectionViewDelegate & UICollectionViewDragDelegate & UICollectionViewDropDelegate, backgroundColor: UIColor) -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.isPrefetchingEnabled = false
        
        collectionView.allowsMultipleSelectionDuringEditing = true
        
        collectionView.keyboardDismissMode = .interactive
        
        collectionView.delegate = delegate
        collectionView.dragDelegate = delegate
        collectionView.dropDelegate = delegate
        // support on iphone
        collectionView.dragInteractionEnabled = true
        
        collectionView.backgroundColor = backgroundColor
        
        return collectionView
    }
    
    func subscribeToResponderNotifier<Cell>(_ cell: Cell)
    where Cell: SRespondable {
        cell.responderStatusPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] (responderNotifierState: ResponderState) in
                switch responderNotifierState.status {
                    case .responding:
                        let nextRespondingItem = self.itemForResponder(responderNotifierState.sendingResponder)
                        self.firstResponderItem = nextRespondingItem
                    case .resigned:
                        guard let currentResponderItem = self.firstResponderItem else {
                            assertionFailure("Expected cached item id for first responder.")
                            return
                        }
                        if let nextResponderItem =
                            self.configuration.subsequentFirstResponder(following: currentResponderItem) {
                            self.updateFirstResponderToItem(nextResponderItem)
                        }
                        else {
                            self.firstResponderItem = nil
                        }
                }
            }
            .store(in: &cancellables)
    }
    
    func subscribeToDynamicSizeNotifier<Cell>(_ cell: Cell)
    where Cell: UICollectionViewCell, Cell: SDynamicSizeNotifier {
        cell.sizeDidChangePublisher
            .receive(on: DispatchQueue.main)
            .map { $0 as! Cell }
            .sink(receiveValue: { [unowned self] cell in
                self.updateForCellSizeChanges(cell)
            })
            .store(in: &cancellables)
    }
}

// MARK: - selection handlers
private
extension ListViewController {
    
    /// Determines whether the index path should be selected.
    func shouldSelect(_ indexPath: IndexPath) -> Bool {
        guard mode != .reordering else {
            debugPrint(#function)
            assertionFailure("Selection made during list reordering - this is  unexpected behavior.")
            return false
        }
        guard let cell = cellFor(indexPath) else {
            assertionFailure("Could not retrieve cell.")
            return false
        }
        
        if mode == .editing {
            return cell.canSelect()
        }
        else {
            return cell.canTap()
        }
    }
    
    /// Handles a selection by performing needed updates.
    /// - Parameter isContinuous: Whether the selection is part of a continuous multiselection gesture. If true, selections will be updated according to the multiselection session data. If false, selections will simply be toggled using current selection state.
    func handleSelection(at indexPath: IndexPath, isContinuous continuous: Bool = false) {
        guard mode != .reordering else {
            debugPrint(#function)
            assertionFailure("Selection made during list reordering - this is  unexpected behavior.")
            return
        }
        let item = itemInSnapshot(with: indexPath)
        let section = sectionInSnapshot(with: indexPath)
        let isSectionHeader = (snapshot.headerForSection(section) == item)
        guard let cell = cellFor(indexPath) else {
            assertionFailure("Could not retrieve cell.")
            return
        }
        
        // if editing, process as selection
        if mode == .editing {
            if continuous {
                // Update the selection according to multiselection session.
                // begin a new session if needed
                if self.multiselectSessionData == nil {
                    multiselectSessionData = .init(isSelecting: !listState.editingSelections.contains(item))
                }
                
                guard let sessionData = self.multiselectSessionData else { fatalError("Session should exist") }
                // Check if button has already been updated.
                guard !sessionData.updatedItems.contains(item) else { return }
                
                // update selections
                if sessionData.isSelecting {
                    listState.editingSelections.insert(item)
                }
                else {
                    listState.editingSelections.remove(item)
                }
                
                self.multiselectSessionData?.updatedItems.insert(item)
            }
            else {
                editingSelections.toggle(item)
            }
        }
        // if not editing, process as tap (normal mode)
        else {
            // if section header, process as expand/collapse behavior
            if isSectionHeader {
                let isCollapsed = snapshot.isSectionCollapsed(section)
                if isCollapsed {
                    if configuration.canExpand(section: section, withHeader: item) {
                        var updatedSnapshot = snapshot
                        updatedSnapshot.expandSection(section)
                        snapshot = updatedSnapshot
                    }
                }
                else {
                    if configuration.canCollapse(section: section, withHeader: item) {
                        assert(editingSelections.isEmpty, "\(#function): editing selections exist in normal mode during a tap. state: \(listState).")
                        var updatedSnapshot = snapshot
                        updatedSnapshot.collapseSection(section)
                        snapshot = updatedSnapshot
                    }
                }
            }
            // otherwise process as regular tap
            else {
                cell.didTap()
            }
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
}

// MARK: - convenience methods
private
extension ListViewController {
	
	func itemInSnapshot(with indexPath: IndexPath) -> ItemID {
		guard let itemID = collectionDataSource.itemIdentifier(for: indexPath) else {
			debugPrint("Item identifier does not exist in collection view for index path: \(indexPath),")
            debugPrint("collection view: \(collectionView.debugDescription)")
            debugPrint("data source: \(collectionDataSource.debugDescription)")
			fatalError()
		}
		return itemID
	}
	
	/// Determines the item identifier corresponding to the responder. The responder must be a collection cell instance.
	/// - Returns: The corresponding item ID or nil if it cannot be retrieved for some reason.
	func itemForResponder(_ sender: Any) -> ItemID? {
		guard let cell = sender as? UICollectionViewCell else {
            assertionFailure("Expected collection cell instance. Instead sender is \(sender.self).")
			return nil
		}
		if let indexPath = collectionView.indexPath(for: cell) {
			self.firstResponderItem = self.itemInSnapshot(with: indexPath)
		}
		else {
			debugPrint(self)
			debugPrint("Could not retrieve index path of first responder cell:")
			debugPrint("collection view: \(collectionView.debugDescription)")
			debugPrint("cell: \(cell)")
		}
		return nil
	}
	
	func sectionInSnapshot(with indexPath: IndexPath) -> SectionID {
		guard collectionDataSource.snapshot().sectionIdentifiers.indices.contains(indexPath.section) else {
			debugPrint("Section identifier does not exist in the snapshot for the indexPath: \(indexPath)")
			debugPrint("snapshot: \(collectionDataSource.snapshot())")
			fatalError()
		}
		return collectionDataSource.snapshot().sectionIdentifiers[indexPath.section]
	}
	
	func headerItemForSection(_ sectionID: SectionID) -> ItemID? {
		snapshot.headerForSection(sectionID)
	}
	
	func indexPath(for itemID: ItemID) -> IndexPath {
		guard let indexPath = collectionDataSource.indexPath(for: itemID) else {
			debugPrint("The item identifier does not exist in the collection view snapshot: \(itemID)")
			debugPrint("snapshot: \(collectionDataSource.snapshot())")
			fatalError()
		}
		return indexPath
	}
	
	/// A helper which consolidates bridging behavior for ListSwipeAction.
	func dataForSwipeAction(_ action: ListSwipeAction) -> (ListMode, ListSwipeAction.CompletionHandler) {
		(mode, { actionPerformed in })
	}
    
    /// Retrieves the cell instance for the index path from the collection view.
    func cellFor(_ indexPath: IndexPath) -> SContentCell? {
        if let cell = collectionView.cellForItem(at: indexPath) {
            guard let cellType = cell as? SContentCell else {
                assertionFailure("Unexpected cell type: \(cell)")
                return nil
            }
            return cellType
        }
        else { return nil }
    }
}

// MARK: - view updates
private
extension ListViewController {
	
    // -- modes
    
	/// Handles a transition from a mode to a new mode.
	func updateFrom(_ listMode: ListMode, to newMode: ListMode) {
		validateModeTransition(from: listMode, to: newMode)
		applyListMode(newMode)
	}
	
	/// Updates view state using the mode.
	func applyListMode(_ mode: ListMode) {
		switch mode {
			case .normal:
				collectionView.isEditing = false
				removeMultiselectionGestureRecognizers()
                
			case .editing:
				collectionView.isEditing = true
                if configuration.multiselectionConfiguration.useMultiselectionPanGesture {
                    startMultiselectionGestureRecognizers()
                }
                updateSelections(from: .init(), to: listState.editingSelections)
                
			default:
				removeMultiselectionGestureRecognizers()
		}
	}
	
	/// Checks if a transition is valid.
	func validateModeTransition(from currentMode: ListMode, to newMode: ListMode) {
		switch currentMode {
		case .reordering:
			if newMode == .editing {
				assertionFailure("Cannot transition to editing mode while reordering.")
			}
		case .editing:
			if newMode == .reordering {
				assertionFailure("Reordering while in editing mode is not supported.")
			}
		default:
			break
		}
	}
	
    // -- cells and subviews
    
	/// Updates views using the selections.
    func updateSelections(from currentSelections: Set<ItemID>, to newSelections: Set<ItemID>, withAnimation animated: Bool = false) {
		let removedSelections = currentSelections.subtracting(newSelections)
		removedSelections.forEach { (item) in
			if let indexPath = collectionDataSource.indexPath(for: item) {
				collectionView.deselectItem(at: indexPath, animated: animated)
			}
			else {
				assertionFailure("Cannot deselect, could not retrieve index path for item ID: \(item).")
			}
		}
		let addedSelections = newSelections.subtracting(currentSelections)
		addedSelections.forEach { (item) in
			if let indexPath = collectionDataSource.indexPath(for: item) {
				collectionView.selectItem(at: indexPath, animated: animated, scrollPosition: .init())
			}
			else {
				assertionFailure("Cannot select, could not retrieve index path for item ID: \(item).")
			}
		}
	}
	
	/// Updates the visible cells after size changes.
	func updateForCellSizeChanges(_ cell: UICollectionViewCell) {
		if collectionView.visibleCells.contains(cell) {
			// i attempted this with an invalidation context both using the changed cell and all visible cells; neither were successful.
			collectionView.collectionViewLayout.invalidateLayout()
		}
	}
	
	/// Makes the cell corresponding to the item identifier the first responder.
	/// - Note: If the cell is not currently visible this method will quietly fail.
	func updateFirstResponderToItem(_ respondingItem: ItemID) {
		if let cell = collectionView.cellForItem(at: indexPath(for: respondingItem)) {
			guard cell.canBecomeFirstResponder else {
				debugPrint("\(self):")
				debugPrint("Cannot make cell first responder for intial item ID:")
				debugPrint("item identifier: \(respondingItem)")
				debugPrint("cell: \(cell)")
				assertionFailure()
				return
			}
			cell.becomeFirstResponder()
		}
		else {
			debugPrint("Could not retrieve cell for item ID: \(respondingItem)")
		}
	}
}

// MARK: - snapshot updates
private
extension ListViewController {

	/** Applies the provided snapshot to the table data source which updates the table.
	*/
	func applySnapshot(_ snapshot: Snapshot) {
		collectionDataSource.apply(
			snapshot.makeNSSnapshot(),
			animatingDifferences: shouldAnimateDifferences,
			completion: nil)
	}
	
	/// Determines whether the view is in an appropriate state for animating differences from an applied snapshot.
	var shouldAnimateDifferences: Bool {
		if let view = viewIfLoaded {
			return !view.isHidden
		}
		else { return false }
	}
}
