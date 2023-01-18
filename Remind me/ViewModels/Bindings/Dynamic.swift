//
//  Dynamic.swift
//  Remind me
//
//  Created by Andrey Versta on 05.08.2022.
//

class Dynamic<T> {
    typealias Listener = (T) -> ()
    private var listener: Listener?
    
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ v: T) {
        value = v
    }
}
