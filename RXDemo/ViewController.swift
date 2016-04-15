//
//  ViewController.swift
//  RXDemo
//
//  Created by Manuel Zoderer on 13/04/16.
//  Copyright © 2016 Codefluegel. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var label: UILabel!
    @IBOutlet var button: UIButton!
    
    private let disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let combinedObservable = Observable.combineLatest(textField.rx_text, button.rx_tap, resultSelector:{return $0})
        
        combinedObservable
            .subscribeNext{print("\($0)")}
            .addDisposableTo(disposebag)
        
        button
            .rx_tap
            .subscribeNext{print("Button")}
            .addDisposableTo(disposebag)
        
                
        textField
            .rx_text
            .bindTo(label.rx_text)
            .addDisposableTo(disposebag)
        
        textField
            .rx_text
            .map{text in self.textLongerThan(text, length: 10)}
            .subscribeNext{
                textLongerThanTEN in
                if textLongerThanTEN{
                    self.textField.backgroundColor = UIColor.redColor()
                }else {
                    self.textField.backgroundColor = UIColor.greenColor()
                }
            }.addDisposableTo(disposebag)
        
        
        textField
            .rx_text
            .map
            { text in
                return (CGFloat(text.characters.count)/10)
            }
            .bindTo(button.rx_alpha)
            .addDisposableTo(disposebag)
    }
    
    func textLongerThan(text: String, length: Int) -> Bool {
        return  text.characters.count >= 10
    }
    
}

