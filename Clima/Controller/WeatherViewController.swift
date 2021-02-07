//
//  ViewController.swift
//  Clima
//
//  Created by Boboli on 01/10/2020.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
//    var result: WeatherData
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherManager.selectDelegate = self
        searchTextField.delegate = self
    }
    

}

//MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Typing somthing"
            return false
        }
    }
    
    @IBAction func searchPress(_ sender: UIButton) {
        //Lệnh này cho biết user đã nhập xong, hãy ẩn bàn phím đi
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }

    //Người dùng đã hoàn tất nhập, sử dụng searchTextFiled.text để tìm kiếm thời tiết cho thành phố đó, ta sẽ trả ô Search Box về rỗng
    //Nó liên hệ với câu lệnh "searchTextField.endEditing(true)" ở trên.
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetWeather(cityName: city)
        }
        searchTextField.text = ""
    }
}

//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weathermanager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
}

