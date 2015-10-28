//
//  KeyPad.swift
//  stats-football
//
//  Created by grobinson on 10/19/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

protocol KeyPadPTC {
    
    func enterTPD(number _number: Int)
    
}

class KeyPad: UIView {
    
    var delegate: KeyPadPTC?
    
}