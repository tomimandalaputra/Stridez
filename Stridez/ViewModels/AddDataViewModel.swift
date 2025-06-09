//
//  AddDataViewModel.swift
//  Stridez
//
//  Created by tukucode on 09/06/25.
//

import Foundation

@Observable
class AddDataViewModel {
	var isShowingAlert: Bool = false
	var writeError: CustomError = .noData
}
