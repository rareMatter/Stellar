//
//  DateSelectionView.swift
//  life-tool-1
//
//  Created by Jesse Spencer on 2/10/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import SwiftUI
import Foundation
import SwiftDate

public
struct DateSelectionView: View {
	
	@Binding public var date: Date
	@Binding public var hasTime: Bool
	@Binding public var duration: TimeInterval
	@Binding public var reminder: TimeInterval?
    public let region: Region
    public var removeDate: () -> Void
	
	@State private var showingTimePicker = false
	@State private var showingReminderPicker = false
	
    public init(date: Binding<Date>, hasTime: Binding<Bool>, duration: Binding<TimeInterval>, reminder: Binding<TimeInterval?>, region: Region, removeDate: @escaping () -> Void = { }) {
        self._date = date
        self._hasTime = hasTime
        self._duration = duration
        self._reminder = reminder
        self.region = region
        self.removeDate = removeDate
    }
    
    public var body: some View {
        Text("This view needs to be replaced.")
        /* Dependencies archived.
		VStack {
			DatePicker(selection: self.$date, in: PartialRangeFrom<Date>(Date()), displayedComponents: DatePickerComponents.date) {
				Text("Date Picker")
			}
			.labelsHidden()
			
			Group {
			NavigationLink(destination: self.timePicker, isActive: self.$showingTimePicker) {
				self.hasTime ? Text(verbatim: "\(time: self.date)") :
					Text("Add Time")
			}
			
			NavigationLink(destination: self.reminderPicker, isActive: self.$showingReminderPicker) {
				if !self.hasTime {
					Text("Add Time To Choose A Reminder")
				}
				else {
					if self.reminder != nil {
						if self.reminder! != 0 {
							Text(Item.reminderDescription(self.reminder!))
						}
						else {
							Text("When the to-do starts.")
						}
					}
					else {
						Text("Add Reminder")
					}
				}
			}
			.disabled(!self.hasTime)
			
			Divider()
			
			Button(action: {
				self.removeDate()
			}) {
				Text("Remove Date")
			}
			}
			.padding()
			
			Spacer()
		}
         */
	}
	
	private var timePicker: some View {
		VStack {
			DatePicker(selection: self.$date, displayedComponents: .hourAndMinute) {
				Text("Starting Time")
			}
			.labelsHidden()
			.navigationBarTitle(Text("Starting Time"))
			
			Divider()
				.padding(.bottom)
			
			Button(action: {
				self.hasTime = false
				self.date = self.date.dateAtEndOf(.day)
				// Remove reminder.
				self.reminder = nil
				self.showingTimePicker = false
			}) {
				Text("Remove")
			}
			.frame(width: 140, height: 35)
			.background(RoundedRectangle(cornerRadius: 8).fill(Color.red))
			
			Spacer()
		}
		.onAppear {
			self.hasTime = true
			self.date = self.date.dateBySet(hour: 12, min: 0, secs: nil)!
		}
	}
	
	private var reminderPicker: some View {
        EmptyView()
        /* Archived.
		ReminderPickerView(date: DateInRegion(self.date, region: self.region), reminderInterval: self.$reminder)
			.navigationBarTitle(Text("Reminder"))
         */
	}
}

struct DateSelectionView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationView {
            EmptyView()
//			DateSelectionView(date: .constant(Date()), hasTime: .constant(false), duration: .constant(.init(0)), reminder: .constant(nil), region: SwiftDate.defaultRegion)
		}
	}
}
