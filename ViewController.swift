//
//  ViewController.swift
//  WeatherDemo
//
//  Created by TYP on 16/11/26.
//  Copyright © 2016年 ChenZhelong. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation

class ViewController: UIViewController,CitySelectControllerDelegate,CLLocationManagerDelegate{
    
    let locationManager:CLLocationManager = CLLocationManager()
    var weatherUrl: String = "http://api.openweathermap.org/data/2.5/forecast"
    @IBOutlet weak var weatherBackground: UIImageView!
    @IBOutlet weak var timaLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var timeLabel_1: UILabel!
    @IBOutlet weak var timeLabel_2: UILabel!
    @IBOutlet weak var timeLabel_3: UILabel!
    @IBOutlet weak var timeLabel_4: UILabel!
    @IBOutlet weak var temLabel_1: UILabel!
    @IBOutlet weak var weatherImage_1: UIImageView!
    @IBOutlet weak var temLabel_3: UILabel!
    @IBOutlet weak var temLabel_2: UILabel!
    @IBOutlet weak var weatherImage_2: UIImageView!
    @IBOutlet weak var weatherImage_4: UIImageView!
    @IBOutlet weak var weatherImage_3: UIImageView!
    @IBOutlet weak var temLabel_4: UILabel!
    
    var city:City?
    var myLocation:CLLocation?
    var cityCode=["beijing","shanghai","shenzhen","hangzhou","suzhou","wenzhou","jiujiang","guangzhou","wuhan"]
    var cityList=["北京","上海","深圳","杭州","苏州","温州","九江","广州","武汉"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //weatherImage.image=UIImage(named:"1")
        locationManager.delegate = self
        locationManager.desiredAccuracy=kCLLocationAccuracyBest
        locationManager.distanceFilter=100
        locationManager.requestAlwaysAuthorization()
        if (CLLocationManager.locationServicesEnabled()&&city?.cityName==nil)
        {
            //允许使用定位服务的话，开启定位服务更新
            locationManager.startUpdatingLocation()
            print("定位开始")
        }
        //一些控件的初始化
        locationLabel.text=city?.cityName
        let date = NSDate()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        let strNowTime = timeFormatter.string(from: date as Date) as String
        self.timaLabel.text=strNowTime
        timeLabel_1.text="loading"
        timeLabel_2.text="loading"
        timeLabel_3.text="loading"
        timeLabel_4.text="loading"
        temLabel_4.text="loading"
        temLabel_3.text="loading"
        temLabel_2.text="loading"
        temLabel_1.text="loading"
        temperatureLabel.text="loading"
        locationLabel.text="loading"
        self.automaticallyAdjustsScrollViewInsets = false;
        
    }
    //
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        //
        if city?.cityName==nil{
            if myLocation==nil
            {
                print("myLocation is nil")
                return
            }
            else{
                self.updateWeatherInfo((myLocation?.coordinate.latitude)!,longitude: (myLocation?.coordinate.longitude)!)
    }
        }
        //
        else {
            print("update with cityname \(city?.cityName)")
            //
            var index=0
            for i in 0 ..< cityList.count
            {
                if(cityList[i]==self.city?.cityName){
                    index=i
                    break
                }
            }
            //
            self.updateWeatherInfo(self.cityCode[index])
        }
    }
    //更新天气信息(根据经纬度)----------------------------------------------------
    func updateWeatherInfo(_ latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        //拼接URL请求字符串
        let urlString = self.weatherUrl+"?lat=\(latitude)&lon=\(longitude)&mode=json&appid=75864ebbead3e0e31fcd106c67f7b078&lang=zh_cn&cnt=0"
        //生成url对象
        let url=URL(string:urlString)
        let request = URLRequest(url: url!)
        //
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request,
                                        completionHandler: {(data, response, error) -> Void in
                                            if error != nil{
                                                print(error.debugDescription)
                                            }else{
                                                if let result = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments){
                                                    //
                                                    DispatchQueue.main.async {
                                                        self.updateUISuccess(result as! NSDictionary)
                                                    }
                                                }
                                            }
        }) as URLSessionTask
        
        //使用resume方法启动任务
        dataTask.resume()
        
    }
    
    func updateWeatherInfo(_ cityName: String){
        //print(cityName)
        let urlString = self.weatherUrl+"?q=\(cityName)&mode=json&appid=75864ebbead3e0e31fcd106c67f7b078&lang=zh_cn&cnt=0"
        let url = URL(string:urlString)
        //创建请求对象
        print(url)
        let request = URLRequest(url: url!)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request,
                                        completionHandler: {(data, response, error) -> Void in
                                            if error != nil{
                                                print(error.debugDescription)
                                            }else{
                                                if let result = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments){
                                                    DispatchQueue.main.async {
                                                        self.updateUISuccess(result as! NSDictionary)
                                                    }
                                                }
                                                else
                                                {
                                                    DispatchQueue.main.async {
                                                        let alertController=UIAlertController(title: "Network error!", message: "无法连接到服务器", preferredStyle: .alert)
                                                        alertController.addAction(UIAlertAction(title: "ok", style:.cancel, handler:nil))
                                                        self.present(alertController, animated: true, completion: nil)
                                                    }
                                                }
                                            }
        }) as URLSessionTask
        //使用resume方法启动任务
        dataTask.resume()
    }
    
    func updateUISuccess(_ jsonResult: NSDictionary) {
        //
        if let tempResult = (((jsonResult["list"] as! NSArray)[0] as! NSDictionary)["main"] as! NSDictionary)["temp"] as? Double {
            var temperature: Double
            var cntry: String
            cntry = ""
            //
            if let city = (jsonResult["city"] as? NSDictionary) {
                if let country = (city["country"] as? String) {
                    cntry = country
                    if (country == "US") {
                        //
                        temperature = round(((tempResult - 273.15) * 1.8) + 32)
                    }
                    else {
                        //
                        temperature = round(tempResult - 273.15)
                    }
                    self.temperatureLabel.font = UIFont.boldSystemFont(ofSize: 60)
                    self.temperatureLabel.text = "\(temperature)°"
                }
                
                if let name = (city["name"] as? String) {
                    self.locationLabel.font = UIFont.boldSystemFont(ofSize: 25)
                    self.locationLabel.text = name
                }
            }
            if let weatherArray = (jsonResult["list"] as? NSArray) {
                let limit = weatherArray.count >= 5 ? 5 : weatherArray.count
                for index in 0..<limit {
                    if let perTime = (weatherArray[index] as? NSDictionary) {
                        if let main = (perTime["main"] as? NSDictionary) {
                            let temp = (main["temp"] as! Double)
                            if (cntry == "US") {
                                //
                                temperature = round(((temp - 273.15) * 1.8) + 32)
                            }
                            else {
                                //
                                temperature = round(temp - 273.15)
                            }
                            if (index == 1) {
                                self.temLabel_1.text = "\(temperature)°"
                            }
                            if (index == 2) {
                                self.temLabel_2.text = "\(temperature)°"
                            }
                            if (index == 3) {
                                self.temLabel_3.text = "\(temperature)°"
                            }
                            if (index == 4) {
                                self.temLabel_4.text = "\(temperature)°"
                            }
                        }
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "HH:mm"
                        if let date = (perTime["dt"] as? Double) {
                            let thisDate = Date(timeIntervalSince1970: date)
                            let forecastTime = dateFormatter.string(from: thisDate)
                            if (index==1) {
                                self.timeLabel_1.text = forecastTime
                            }
                            if (index==2) {
                                self.timeLabel_2.text = forecastTime
                            }
                            if (index==3) {
                                self.timeLabel_3.text = forecastTime
                            }
                            if (index==4) {
                                self.timeLabel_4.text = forecastTime
                            }
                        }
                        if let weather = (perTime["weather"] as? NSArray) {
                            let condition = (weather[0] as! NSDictionary)["id"] as! Int
                            let icon = (weather[0] as! NSDictionary)["icon"] as! String
                            var nightTime = false
                            if icon.range(of: "n") != nil{
                                nightTime = true
                            }
                            self.updateWeatherIcon(condition, nightTime: nightTime, index: index)
                            if (index == 4) {
                                return
                            }
                        }
                    }
                }
            }
        }
    }
    
    func updateWeatherIcon(_ condition: Int, nightTime: Bool, index: Int) {
        var images = [self.weatherImage.image, self.weatherImage_1.image, self.weatherImage_2.image, self.weatherImage_3.image, self.weatherImage_4.image]
        
        if (condition < 300) {
            if nightTime {
                self.updatePictures(index, name: "tstorm1_night")
            } else {
                self.updatePictures(index, name: "tstorm1")
            }
        }
            // Drizzle
        else if (condition < 500) {
            self.updatePictures(index, name: "light_rain")
            
        }
            // Rain / Freezing rain / Shower rain
        else if (condition < 600) {
            self.updatePictures(index, name: "shower3")
        }
            // Snow
        else if (condition < 700) {
            self.updatePictures(index, name: "snow4")
        }
            // Fog / Mist / Haze / etc.
        else if (condition < 771) {
            if nightTime {
                self.updatePictures(index, name: "fog_night")
            } else {
                self.updatePictures(index, name: "fog")
            }
        }
            // Tornado / Squalls
        else if (condition < 800) {
            self.updatePictures(index, name: "tstorm3")
        }
            // Sky is clear
        else if (condition == 800) {
            if (nightTime){
                self.updatePictures(index, name: "sunny_night")
            }
            else {
                self.updatePictures(index, name: "sunny")
            }
        }
            // few / scattered / broken clouds
        else if (condition < 804) {
            if (nightTime){
                self.updatePictures(index, name: "cloudy2_night")
            }
            else{
                self.updatePictures(index, name: "cloudy2")
            }
        }
            // overcast clouds
        else if (condition == 804) {
            self.updatePictures(index, name: "overcast")
        }
            // Extreme
        else if ((condition >= 900 && condition < 903) || (condition > 904 && condition < 1000)) {
            self.updatePictures(index, name: "tstorm3")
        }
            // Cold
        else if (condition == 903) {
            self.updatePictures(index, name: "snow5")
        }
            // Hot
        else if (condition == 904) {
            self.updatePictures(index, name: "sunny")
        }
            // Weather condition is not available
        else {
            self.updatePictures(index, name: "dunno")
        }
    }
    
    func updatePictures(_ index: Int, name: String) {
        if (index==0) {
            self.weatherImage.image = UIImage(named: name)
        }
        if (index==1) {
            self.weatherImage_1.image = UIImage(named: name)
        }
        if (index==2) {
            self.weatherImage_2.image = UIImage(named: name)
        }
        if (index==3) {
            self.weatherImage_3.image = UIImage(named: name)
        }
        if (index==4) {
            self.weatherImage_4.image = UIImage(named: name)
        }
    }
    
    /*
     iOS 8 Utility
     */
    func ios8() -> Bool {
        if ( NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1 ) {
            return false
        } else {
            return true
        }
    }
    //
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location:CLLocation = locations[locations.count-1]
        if (location.horizontalAccuracy > 0) {
            self.locationManager.stopUpdatingLocation()
            //print(location.coordinate)
            myLocation=location
            updateWeatherInfo(location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    //MARK: city changed delegate
    func cityDidSelected(_ cityKey: String){
        print("selected city \(cityKey)")
        self.updateWeatherInfo(cityKey)
    }
    //--------------------------------------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

