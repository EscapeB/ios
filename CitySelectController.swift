//
//  CitySelectController.swift
//  WeatherDemo
//
//  Created by TYP on 16/11/29.
//  Copyright © 2016年 ChenZhelong. All rights reserved.
//

import UIKit
@objc protocol CitySelectControllerDelegate{
    func cityDidSelected(_ cityKey: String)
}

class CitySelectController: UITableViewController {
    var citys=[City]()
    var cityCode=["beijing","shanghai","shenzhen","hangzhou","suzhou","wenzhou","jiujiang","guangzhou","wuhan"]
    var cityList=["北京","上海","深圳","杭州","苏州","温州","九江","广州","武汉"]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            
            if let fetchedList = appDelegate.fetchContext() {
                citys+=fetchedList }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (citys.count);
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityTableCell", for: indexPath) as! CityTableCell
        cell.cityLabel.text=citys[indexPath.row].cityName

        // Configure the cell...
        

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let city=citys[indexPath.row]
            citys.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            if let appDelegate=(UIApplication.shared.delegate as? AppDelegate){
                appDelegate.deleteFromContext(city: city)
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    @IBAction func unwindToList(segue:UIStoryboardSegue)
    {
        if segue.identifier=="SaveToList",
            let detailViewContorller=segue.source as? NewCityController,
            let city = detailViewContorller.city11{
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else{
                let newIndexPath=IndexPath(row: citys.count, section: 0)
                citys.append(city)
                tableView.insertRows(at: [newIndexPath], with: .bottom)
            }
       }
    }

    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier=="showWeather",
            let indexPath=tableView.indexPathForSelectedRow,
            let weather=segue.destination as? ViewController{
            weather.city=citys[indexPath.row]
            //print(citys[indexPath.row].cityName)
            var index=0
            for i in 0 ..< cityList.count
            {
                if(cityList[i]==citys[indexPath.row].cityName){
                    index=i
                    break
                }
            }
            weather.cityDidSelected(cityCode[index])
            //weather.city?.cityName=cityCode[index]
            
            }
        
    }
    

}
