//
//  AddDataView.swift
//  Stridez
//
//  Created by tukucode on 07/06/25.
//

import SwiftUI

struct AddDataView: View {
	@Environment(\.dismiss) private var dismiss
	@Environment(HealthKitManager.self) private var hkManager

	@State private var addDataDate: Date = .now
	@State private var valueToAdd: String = ""

	var metric: HealthMetricContext
	private var keyboardTypeByMetric: UIKeyboardType {
		metric == .steps ? .numberPad : .decimalPad
	}

	var body: some View {
		NavigationStack {
			Form {
				DatePicker("Date", selection: $addDataDate, displayedComponents: .date)

				HStack {
					Text(metric.title)
					TextField("Value", text: $valueToAdd)
						.multilineTextAlignment(.trailing)
						.keyboardType(keyboardTypeByMetric)
				}
			}
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button(action: {
						Task {
							await addData()
						}
					}, label: {
						Text("Add Data")
					})
				}

				ToolbarItem(placement: .principal) {
					Text(metric.title)
						.fontWeight(.bold)
				}

				ToolbarItem(placement: .topBarLeading) {
					Button(action: {
						dismiss()
					}, label: {
						Text("Dismiss")
					})
				}
			}
		}
	}

	private func addData() async {
		if metric == .steps {
			await hkManager.addStepData(for: addDataDate, value: Double(valueToAdd)!)
			await hkManager.fetchStepCount()
		} else {
			await hkManager.addWeightData(for: addDataDate, value: Double(valueToAdd)!)
			await hkManager.fetchWeights()
			await hkManager.fetchWeightForDifferentials()
		}
		dismiss()
	}
}

#Preview {
	NavigationStack {
		AddDataView(metric: .steps)
			.environment(HealthKitManager())
	}
}
