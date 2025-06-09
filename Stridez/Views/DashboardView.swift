//
//  DashboardView.swift
//  Stridez
//
//  Created by tukucode on 07/06/25.
//

import SwiftUI

struct DashboardView: View {
	@Environment(HealthKitData.self) private var hkData
	@Environment(HealthKitManager.self) private var hkManager
	@State private var viewModel = DashboardViewModel()
	@State private var selectedTab: HealthMetricContext = .steps

	var body: some View {
		NavigationStack {
			ScrollView {
				VStack(spacing: 24) {
					Picker("Selected Tab", selection: $selectedTab) {
						ForEach(HealthMetricContext.allCases) {
							Text($0.title).tag($0)
						}
					}
					.pickerStyle(.segmented)

					switch selectedTab {
						case .steps:
							StepBarChart(
								selectedTab: selectedTab,
								chartData: hkData.stepData
							)

							StepPieChart(chartData: ChartMath.averageWeekdayCount(for: hkData.stepData))
						case .weight:
							WeightLineChart(
								selectedTab: selectedTab,
								chartData: hkData.weightData
							)

							WeightDiffBarChart(chartData: ChartMath.averageDailyWeightDiffs(for: hkData.weightDiffData))
					}
				}
			}
			.padding()
			.task { fetchHealthData() }
			.navigationTitle("Dashboard")
			.navigationDestination(for: HealthMetricContext.self) { metric in
				HealthDataListView(metric: metric)
			}
			.fullScreenCover(isPresented: $viewModel.isShowingPermissionPrimingSheet, onDismiss: {
				fetchHealthData()
			}, content: {
				HealthKitPermissionPrimingView()
			})
			.alert(isPresented: $viewModel.isShowingAlert, error: viewModel.fetchError) { _ in
				// Actions
			} message: { fetchError in
				Text(fetchError.failureReason)
			}
		}
		.tint(selectedTab == .steps ? Color.pink : Color.indigo)
	}

	private func fetchHealthData() {
		Task {
			do {
				async let steps = hkManager.fetchStepCount()
				async let weightsForLineChart = hkManager.fetchWeights(daysBack: 28)
				async let weightForDiffBarChart = hkManager.fetchWeights(daysBack: 29)

				hkData.stepData = try await steps
				hkData.weightData = try await weightsForLineChart
				hkData.weightDiffData = try await weightForDiffBarChart
			} catch CustomError.authNotDetermined {
				viewModel.isShowingPermissionPrimingSheet = true
			} catch CustomError.noData {
				viewModel.fetchError = .noData
				viewModel.isShowingAlert = true
			} catch {
				viewModel.fetchError = .unableToCompleteRequest
				viewModel.isShowingAlert = true
			}
		}
	}
}

#Preview {
	DashboardView()
		.environment(HealthKitData())
		.environment(HealthKitManager())
}
