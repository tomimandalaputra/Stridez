//
//  DailyWeightData.swift
//  Stridez
//
//  Created by tukucode on 08/06/25.
//

import Foundation

struct DailyWeightData: Identifiable {
	let id = UUID()
	let date: Date
	let value: Double
}
