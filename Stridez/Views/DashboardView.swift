//
//  DashboardView.swift
//  Stridez
//
//  Created by tukucode on 07/06/25.
//

import Charts
import SwiftUI

struct DashboardView: View {
	@Environment(HealthKitManager.self) private var hkManager
	@AppStorage("hasSeenPermissionPriming") private var hasSeenPermissionPriming = false
	@State private var isShowingPermissionPrimingSheet = false
	@State private var selectedTab: HealthMetricContext = .steps

	private var colorNavigationStack: Color {
		selectedTab == .steps ? Color.pink : Color.indigo
	}

	var avgStepCount: Double {
		guard !hkManager.stepData.isEmpty else {
			return 0
		}

		let totalSteps = hkManager.stepData.reduce(0) { $0 + $1.value }
		return totalSteps / Double(hkManager.stepData.count)
	}

	fileprivate var StepsView: some View {
		VStack {
			NavigationLink(value: selectedTab) {
				HStack {
					VStack(alignment: .leading) {
						Label("Steps", systemImage: "figure.walk")
							.font(.title3.bold())
							.foregroundStyle(.pink)

						Text("Avg: \(Int(avgStepCount)) steps")
							.font(.caption)
					}

					Spacer()

					Image(systemName: "chevron.right")
				}
			}
			.foregroundStyle(.secondary)
			.padding(.bottom, 12)

			Chart {
				ForEach(hkManager.stepData) { steps in
					RuleMark(y: .value("Average", avgStepCount))
						.foregroundStyle(Color.secondary)
						.lineStyle(.init(lineWidth: 1, dash: [5]))

					BarMark(
						x: .value("Date", steps.date, unit: .day),
						y: .value("Steps", steps.value)
					)
					.foregroundStyle(Color.pink.gradient)
				}
			}
			.frame(height: 150)
			.chartXAxis {
				AxisMarks {
					AxisValueLabel(format: .dateTime.month(.defaultDigits).day())
				}
			}
			.chartYAxis {
				AxisMarks { value in
					AxisGridLine().foregroundStyle(Color.secondary.opacity(0.3))
					AxisValueLabel((value.as(Double.self) ?? 0).formatted(.number.notation(.compactName)))
				}
			}
		}
		.padding()
		.background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemFill)))
	}

	fileprivate var AveragesView: some View {
		VStack(alignment: .leading) {
			VStack(alignment: .leading) {
				Label("Averages", systemImage: "calendar")
					.font(.title3.bold())
					.foregroundStyle(.pink)

				Text("Last 10 Days")
					.font(.caption)
					.foregroundStyle(.secondary)
			}
			.padding(.bottom, 12)

			RoundedRectangle(cornerRadius: 12)
				.foregroundStyle(.secondary)
				.frame(height: 240)
		}
		.padding()
		.background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemFill)))
	}

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

					StepsView
					AveragesView
				}
			}
			.padding()
			.task {
				await hkManager.fetchStepCount()
				isShowingPermissionPrimingSheet = !hasSeenPermissionPriming
			}
			.navigationTitle("Dashboard")
			.navigationDestination(for: HealthMetricContext.self) { metric in
				HealthDataListView(metric: metric)
			}
			.sheet(isPresented: $isShowingPermissionPrimingSheet, onDismiss: {
				// fetch health data
			}, content: {
				HealthKitPermissionPrimingView(hasSeen: $hasSeenPermissionPriming)
			})
		}
		.tint(colorNavigationStack)
	}
}

#Preview {
	DashboardView()
		.environment(HealthKitManager())
}
