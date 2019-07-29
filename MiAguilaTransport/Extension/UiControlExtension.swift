//  UiControlExtension.swift
//  MiAguilaTransport
//
//  Created by Diego Fernando Cuesta on 7/28/19.
//  Copyright © 2019 Diego Fernando Cuesta. All rights reserved.

import Foundation
import UIKit

// UICONTROL EXTENSION

class ClosureSleeve {
    let closure: ()->()
    
    init (_ closure: @escaping ()->()) {
        self.closure = closure
    }
    
    @objc func invoke () {
        closure()
    }
}

extension UIControl {
    
    func deleteActions(){
        self.removeTarget(nil, action: nil, for: .allEvents)
    }
    
    func addAction(for controlEvents: UIControl.Event, _ closure: @escaping ()->()) {
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, String(format: "[%d]", arc4random()), sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}
