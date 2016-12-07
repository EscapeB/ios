//
//  ExtensionNewCityController.swift
//  WeatherDemo
//
//  Created by TYP on 16/11/29.
//  Copyright © 2016年 ChenZhelong. All rights reserved.
//

import UIKit
import Foundation

extension NewCityController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.countrySearchController.isActive {
            return self.searchArray.count
        } else {
            return self.schoolArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            //为了提供表格显示性能，已创建完成的单元需重复使用
            let identify:String = "MyCell"
            //同一形式的单元格重复使用，在声明时已注册
            let cell = tableView.dequeueReusableCell(withIdentifier: identify,
                                                     for: indexPath)
            
            if self.countrySearchController.isActive {
                cell.textLabel?.text = self.searchArray[indexPath.row]
                return cell
            } else {
                cell.textLabel?.text = self.schoolArray[indexPath.row]
                return cell
            }
    }
}

extension NewCityController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let city = self.schoolArray[indexPath.row]
        var flag=false
        for c in citys{
            if(c.cityName==city){
                flag=true
                break
            }
        }
        if flag
        {
            let alertController=UIAlertController(title: "Invalid Data!", message: "您已经添加过该城市", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "ok", style:.cancel, handler:nil))
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            self.performSegue(withIdentifier: "SaveToList", sender: city)
        }
        
        
        
    }
    
    //在这个方法中给新页面传递参数
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SaveToList"{
            print(sender as! String)
            city11?.cityName=sender as? String
            let appDelegate=(UIApplication.shared.delegate as? AppDelegate)
            //将新城市加入数据库
            self.city11=appDelegate?.addToContext(name: sender as! String)
        }
    }
}

extension NewCityController: UISearchResultsUpdating
{
    //实时进行搜索
    func updateSearchResults(for searchController: UISearchController) {
        self.searchArray = self.schoolArray.filter { (school) -> Bool in
            return school.contains(searchController.searchBar.text!)
        }
    }
}
