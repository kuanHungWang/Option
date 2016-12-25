//
//  ViewController.swift
//  demo
//
//  Created by K.H.Wang on 2016/12/25.
//  Copyright © 2016年 KH. All rights reserved.
//

import UIKit
import Option
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var P:Double = 0.85
        var K:Double = 7
        var S:Double = 6.5
        var r:Double = 0.001
        let format=DateFormatter()
        format.dateFormat="yyyy/MM/dd"
        var exp=format.date(from: "2017/06/30")!
        var op=Option(price: P, expire: exp, strike: K, type: OptionType.Put, underlying: S, interestRate: r)
        var iv=op.volatility
        print(iv)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

