//
//  HealthMetricContext.swift
//  Stridez
//
//  Created by tukucode on 07/06/25.
//

import Foundation

enum HealthMetricContext: String, CaseIterable, Identifiable {
	case steps, weight

	var id: Self {
		self
	}

	var title: String {
		switch self {
			case .steps:
				return "Steps"
			case .weight:
				return "Weight"
		}
	}
}
