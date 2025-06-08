//
//  Date+Ext.swift
//  Stridez
//
//  Created by tukucode on 08/06/25.
//

import Foundation

extension Date {
	var weekDayInt: Int {
		Calendar.current.component(.weekday, from: self)
	}

	var weekdayTitle: String {
		self.formatted(.dateTime.weekday(.wide))
	}
}
