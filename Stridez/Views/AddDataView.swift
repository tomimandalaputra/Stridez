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

	@State private var viewModel = AddDataViewModel()
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
			.alert(isPresented: $viewModel.isShowingAlert, error: viewModel.writeError) { fetchError in
				// Actions
				switch fetchError {
					case .noData, .authNotDetermined, .unableToCompleteRequest:
						EmptyView()
					case .sharingDenied(let quantityType):
						Button("Settings", action: {
							UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
						})

						Button("Cancel", role: .cancel, action: {})
				}
			} message: { fetchError in
				Text(fetchError.failureReason)
			}
		}
	}

	private func addData() async {
		if metric == .steps {
			do {
				try await hkManager.addStepData(for: addDataDate, value: Double(valueToAdd)!)
				try await hkManager.fetchStepCount()
				dismiss()
			} catch CustomError.sharingDenied(let quantityType) {
				viewModel.writeError = .sharingDenied(quantityType: quantityType)
				viewModel.isShowingAlert = true
			} catch {
				viewModel.writeError = .unableToCompleteRequest
				viewModel.isShowingAlert = true
			}
		} else {
			do {
				try await hkManager.addWeightData(for: addDataDate, value: Double(valueToAdd)!)
				try await hkManager.fetchWeights()
				try await hkManager.fetchWeightForDifferentials()
				dismiss()
			} catch CustomError.sharingDenied(let quantityType) {
				viewModel.writeError = .sharingDenied(quantityType: quantityType)
				viewModel.isShowingAlert = true
			} catch {
				viewModel.writeError = .unableToCompleteRequest
				viewModel.isShowingAlert = true
			}
		}
	}
}

#Preview {
	NavigationStack {
		AddDataView(metric: .steps)
			.environment(HealthKitManager())
	}
}
