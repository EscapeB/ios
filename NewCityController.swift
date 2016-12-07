//
//  NewCityController.swift
//  WeatherDemo
//
//  Created by TYP on 16/11/29.
//  Copyright © 2016年 ChenZhelong. All rights reserved.
//

import UIKit

class NewCityController: UIViewController,UISearchBarDelegate{
    var selectedCellIndexPaths:[NSIndexPath] = []
    var city11: City?
    var citys=[City]()
    var tableView: UITableView!
    
    //搜索控制器
    var countrySearchController = UISearchController()
    
    //todo原始数据集
    let schoolArray = ["北京","上海","深圳","杭州","苏州","温州","九江","广州","武汉"]
    
    //搜索过滤后的结果集
    var searchArray:[String] = [String](){
        didSet  {self.tableView.reloadData()}
    }

    //
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            
            if let fetchedList = appDelegate.fetchContext() {
                citys+=fetchedList }
        }
        //创建表视图
        let tableViewFrame = CGRect(x: 0, y: 20, width: self.view.frame.width,
                                    height: self.view.frame.height-20)
        self.tableView = UITableView(frame: tableViewFrame, style:.plain)
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        //创建一个重用的单元格
        self.tableView!.register(UITableViewCell.self,
                                 forCellReuseIdentifier: "MyCell")
        //self.tableView!.register
        self.view.addSubview(self.tableView!)
        self.tableView!.allowsSelection = true
        //配置搜索控制器
        self.countrySearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self   //两个样例使用不同的代理
            controller.hidesNavigationBarDuringPresentation = false
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.searchBarStyle = .minimal
            controller.searchBar.sizeToFit()
            self.tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()

    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        print("print一下")
        self.tableView!.deselectRow(at: indexPath as IndexPath, animated: false)
        selectedCellIndexPaths = [indexPath]
        // Forces the table view to call heightForRowAtIndexPath
        tableView.reloadRows(at: [indexPath as IndexPath], with: .automatic)
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tableView.reloadData()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
