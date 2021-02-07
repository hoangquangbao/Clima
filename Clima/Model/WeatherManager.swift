//
//  WeatherManager.swift
//  Clima
//
//  Created by Boboli on 06/12/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//
import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weathermanager: WeatherManager, weather: WeatherModel)
//    func didFailWithError(error: Error)
    func didFailWithError(_ error: Error)
}

struct WeatherManager {
    let weatherURL = "http://api.openweathermap.org/data/2.5/weather?appid=711e6911a265cd8103e594f6a31abe2b&units=metric"
//   let A:String = "A"
    var selectDelegate: WeatherManagerDelegate?
    
    func fetWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        //print(urlString)
        //Sử dụng tên theo kiểu bên ngoài bên trong
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        //1. Create a URL
        if let url = URL(string: urlString) {
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            //3. Give URLSession a task
            //let task = session.dataTask(with: url, completionHandler: handle(data:urlResponse:error:))
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
//                    selectDelegate?.didFailWithError(error: error!)
//                    print(error!)
                    selectDelegate?.didFailWithError(error!)
                    return
                }
                if let safeData = data {
                    if let weather = parseJSON(safeData) {
                        selectDelegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            //4. Run task for function to do something
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodeData.weather[0].id
            let temp = decodeData.main.temp
            let name = decodeData.name
            
            let weather = WeatherModel(conditionId: id, temperature: temp, cityName: name)
            return weather
        } catch {
//            print(error)
            selectDelegate?.didFailWithError(error)
            //Nếu trả về nil thì phải thêm ? để chuyển sang kiểu dữ liệu WeatherModel tuỳ chọn
            return nil
        }
    }
    
//    func getCityName() -> String {
//        return  decodeData.name
//    }
    
//    func getTemp() -> Double {
//        return decodeData.main.temp
//    }
    
//    func getResult() -> WeatherData {
//        return decodeData
//    }
    

    //Ta sẽ tạo một hàm chức năng tương tự với "<#T##(Data?, URLResponse?, Error?) -> Void#>" để thay thế nhằm get hết data thì trả về một lần luôn, không gọi lấy lắt nhắt ảnh hưởng đến tốc độ xử lí của app và đường truyền data.
    //    func handle(data: Data?, urlResponse: URLResponse?, error: Error?) -> Void {
    //        //Press "Alt + completionHandler" to know if the request was succesfull that get what value (result I know is !=nil)
    //        if error != nil {
    //            print(error!)
    //            return
    //        }
    //
    //        if let safeData = data {
    //            //Muốn thấy data lấy được ta cần đưa nó về kiểu chuỗi
    //            let dataString = String(data: safeData, encoding: .utf8)
    //            print(dataString!)
    //        }
    //    }
}
