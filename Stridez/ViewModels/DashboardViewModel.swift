//
//  DashboardViewModel.swift
//  Stridez
//
//  Created by tukucode on 09/06/25.
//

import Foundation

@Observable
class DashboardViewModel {
	var isShowingPermissionPrimingSheet: Bool = false
	var isShowingAlert: Bool = false
	var fetchError: CustomError = .noData
}
