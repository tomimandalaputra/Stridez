//
//  HealthDataListView.swift
//  Stridez
//
//  Created by tukucode on 07/06/25.
//

import SwiftUI

struct HealthDataListView: View {
	@State private var isShowingAddData: Bool = false

	var metric: HealthMetricContext
	private var fractionLengthByMetric: Int {
		metric == .steps ? 0 : 1
	}

	var body: some View {
		List(0 ..< 10) { _ in
			HStack {
				Text(Date(), format: .dateTime.month().day().year())
				Spacer()
				Text(1000, format: .number.precision(.fractionLength(fractionLengthByMetric)))
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
	}
}
