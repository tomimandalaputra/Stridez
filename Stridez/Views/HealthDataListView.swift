//
//  HealthDataListView.swift
//  Stridez
//
//  Created by tukucode on 07/06/25.
//

import SwiftUI

struct HealthDataListView: View {
	@Environment(HealthKitManager.self) private var hkManager
	@State private var isShowingAddData: Bool = false

	var metric: HealthMetricContext

	private var listData: [HealthMetric] {
		metric == .steps ? hkManager.stepData : hkManager.weightData
	}

	private var fractionLengthByMetric: Int { metric == .steps ? 0 : 1 }

	var body: some View {
		List(listData.reversed()) { data in
			HStack {
				Text(data.date, format: .dateTime.month().day().year())
				Spacer()
				Text(data.value, format: .number.precision(.fractionLength(fractionLengthByMetric)))
			}
		}
		.navigationTitle(metric.title)
		.sheet(isPresented: $isShowingAddData) {
			AddDataView(metric: metric)
		}
		.toolbar {
			ToolbarItem {
				Button("Add Data", systemImage: "plus") {
					isShowingAddData = true
				}
			}
		}
	}
}

#Preview {
	NavigationStack {
		HealthDataListView(metric: .steps)
			.environment(HealthKitManager())
	}
}
