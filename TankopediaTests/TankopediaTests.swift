//
//  TankopediaTests.swift
//  TankopediaTests
//
//  Created by Rostislav Ermachenkov on 11.03.2022.
//

import XCTest
@testable import Tankopedia

class TankopediaTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_GetVehicles_WhenPageIsFirst_ShouldReturnVehicles() throws {
        var vehicles: [VehiclesItem]?
        var err: APIError?
        
        let promise = expectation(description: "Got some vehicles")
        
        let vehiclesService = VehiclesService()
        vehiclesService.getVehicles(page: 1, completion: { result in
            switch result {
            case .success(let result):
                vehicles = result
                promise.fulfill()
            case .failure(let error):
                err = error
                XCTFail("\(String(describing: err?.errorDescription))")
            }
        })
        
        wait(for: [promise], timeout: 5)

        XCTAssertNotNil(vehicles)
        XCTAssertNil(err)
    }
    
    func test_GetVehicles_WhenPageIsZero_ShouldReturnError() throws {
        var vehicles: [VehiclesItem]?
        var err = APIError.paramsNotFound
        
        let promise = expectation(description: err.errorDescription ?? "")
        
        let vehiclesService = VehiclesService()
        vehiclesService.getVehicles(page: 0, completion: { result in
            switch result {
            case .success(let result):
                vehicles = result
                XCTFail("Got some vehicles")
            case .failure(let error):
                err = error
                promise.fulfill()
            }
        })
        
        wait(for: [promise], timeout: 5)

        XCTAssertNil(vehicles)
        XCTAssertNotNil(err)
        XCTAssert(err.errorDescription == promise.description)
    }

}
