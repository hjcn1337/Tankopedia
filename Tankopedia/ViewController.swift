//
//  ViewController.swift
//  Tankopedia
//
//  Created by Rostislav Ermachenkov on 11.03.2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let apiClient = APIClient()
        apiClient.getVehicles { [weak self] (result)  in
            switch result {
            case .success(let result):
                for res in result {
                    print(res.description)
                }
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }


}

