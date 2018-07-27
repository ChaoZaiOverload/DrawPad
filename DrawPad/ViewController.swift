//
//  ViewController.swift
//  DrawPad
//
//  Created by Yu, Huiting on 7/27/18.
//  Copyright © 2018 Yu, Huiting. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var currentPath: UIBezierPath? = nil
    var currentLayer: CAShapeLayer? = nil
    
    var removedLines: [CAShapeLayer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func redo() {
        guard let removed = removedLines.last else { return }
        view.layer.addSublayer(removed)
        removedLines.removeLast()
    }
    
    @IBAction func undo() {
        guard let lastLayer = view.layer.sublayers?.last as? CAShapeLayer else { return }
        lastLayer.removeFromSuperlayer()
        removedLines.append(lastLayer)
    }
    
    @IBAction func clear() {
        view.layer.sublayers?.forEach {
            $0.removeFromSuperlayer()
        }
        removedLines.removeAll()
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.count == 1, let touch = touches.first else {
            print("multi-touches, ignore")
            return
        }
        let loc = touch.location(in: view)
        let p = UIBezierPath()
        p.lineWidth = 0.5
        p.lineCapStyle = .round
        p.lineJoinStyle = .round
        p.move(to: loc)
        currentPath = p
        
        let slayer = CAShapeLayer()
        slayer.path = p.cgPath
        slayer.backgroundColor = UIColor.clear.cgColor
        slayer.strokeColor = UIColor.blue.cgColor
        slayer.fillColor = UIColor.clear.cgColor
        slayer.lineWidth = p.lineWidth
        view.layer.addSublayer(slayer)
        currentLayer = slayer
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let cp = currentPath, let touch = touches.first, touches.count == 1 else {
            print("invalid moving, return")
            return
        }
        cp.addLine(to: touch.location(in: view))
        currentLayer?.path = cp.cgPath
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.count == 1, let touch = touches.first else {
            print("invalid touches ended")
            return
        }
        currentLayer = nil
        currentPath = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentLayer = nil
        currentPath = nil
    }
}

