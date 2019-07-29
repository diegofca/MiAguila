//  HomeSheetViewController.swift
//  MiAguilaTransport
//
//  Created by Diego Fernando Cuesta on 7/27/19.
//  Copyright © 2019 Diego Fernando Cuesta. All rights reserved.

import Foundation
import UIKit
import GoogleMaps

enum SheetLevel{
    case top, bottom, middle
}

protocol BottomSheetDelegate {
    func updateBottomSheet(frame: CGRect)
    func selectedTrip(_ trip: Trip)
    func goRoute(_ trip: Trip)
}

class HomeSheetViewController : UIViewController {
    
    @IBOutlet weak var panView: UIView!
    @IBOutlet weak var loaderListView: UIView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    private var lastY: CGFloat = 0
    private var pan: UIPanGestureRecognizer!
    
    var bottomSheetDelegate: BottomSheetDelegate?
    var parentView: UIView!
    
    private var initalFrame: CGRect!
    private var constants = Constants()

    struct Constants {
        var topY: CGFloat = 140
        var middleY: CGFloat = 300
        var bottomY: CGFloat = 680
        let bottomOffset: CGFloat = 100
        var bottomPadding: CGFloat = 0
        var lastLevel: SheetLevel = .bottom
        var disableTableScroll = false
        var didTapDeleteKey = false
    }
    
    var tripList: [Trip] = [] {
        didSet { tableView.reloadData() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGestures()
    }
    
    func setGestures(){
        pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pan.delegate = self
        self.panView.addGestureRecognizer(pan)
        self.tableView.panGestureRecognizer.addTarget(self, action: #selector(handlePan(_:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let window = UIApplication.shared.keyWindow
        
        if #available(iOS 12.0, *) {
            self.constants.bottomPadding = (window?.safeAreaInsets.bottom)!
        }
        self.initalFrame = UIScreen.main.bounds
        self.constants.middleY = initalFrame.height * 0.6
        self.constants.bottomY = initalFrame.height - constants.bottomOffset - self.constants.bottomPadding
        self.lastY = self.constants.middleY
        bottomSheetDelegate?.updateBottomSheet(frame: self.initalFrame.offsetBy(dx: 0, dy: self.constants.bottomY))
        setSheetState(.middle)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == tableView else { return }
        if (self.parentView.frame.minY > constants.topY){
            self.tableView.contentOffset.y = 0
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard scrollView == tableView else { return }
        if constants.disableTableScroll {
            targetContentOffset.pointee = scrollView.contentOffset
            constants.disableTableScroll = false
        }
    }
    
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer){
        
        if self.tableView.contentOffset.y > 0 { return }
        
        let dy = recognizer.translation(in: self.parentView).y
        switch recognizer.state {
        case .changed:
            if self.tableView.contentOffset.y <= 0 {
                let maxY = max(constants.topY, lastY + dy)
                let y = min(constants.bottomY, maxY)
                bottomSheetDelegate?.updateBottomSheet(frame: self.initalFrame.offsetBy(dx: 0, dy: y))
            }
            if self.parentView.frame.minY > constants.topY {
                self.tableView.contentOffset.y = 0
            }
        case .failed, .ended, .cancelled:
            self.panView.isUserInteractionEnabled = false
            self.constants.disableTableScroll = self.constants.lastLevel != .top
            self.lastY = self.parentView.frame.minY
            self.constants.lastLevel = self.nextLevel(recognizer: recognizer)
            self.changeAnimStateLevel()
        default:
            break
        }
    }
    
    func changeAnimStateLevel( ) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9, options: .curveEaseOut, animations: {
            switch self.constants.lastLevel {
            case .top:
                self.bottomSheetDelegate?.updateBottomSheet(frame: self.initalFrame.offsetBy(dx: 0, dy: self.constants.topY))
                self.tableView.contentInset.bottom = self.constants.topY + 50
            case .middle:
                self.bottomSheetDelegate?.updateBottomSheet(frame: self.initalFrame.offsetBy(dx: 0, dy: self.constants.middleY))
            case .bottom:
                self.tableView.contentOffset.y = 0
                self.bottomSheetDelegate?.updateBottomSheet(frame: self.initalFrame.offsetBy(dx: 0, dy: self.constants.bottomY))
            }
        }) { (_) in
            self.panView.isUserInteractionEnabled = true
            self.lastY = self.parentView.frame.minY
        }
    }
    
    func setSheetState(_ state: SheetLevel){
        constants.lastLevel = state
        if self.tableView.contentOffset.y <= 0{
            let maxY = max(constants.topY, lastY )
            let y = min(constants.bottomY, maxY)
            bottomSheetDelegate?.updateBottomSheet(frame: self.initalFrame.offsetBy(dx: 0, dy: y))
        }
        self.changeAnimStateLevel()
        self.constants.disableTableScroll = self.constants.lastLevel != .top
    }
    
    func nextLevel(recognizer: UIPanGestureRecognizer) -> SheetLevel {
        let y = self.lastY
        let velY = recognizer.velocity(in: self.view).y
        if velY < -200 {
            return y > constants.middleY ? .middle : .top
        } else if velY > 200 {
            return y < (constants.middleY + 1) ? .middle : .bottom
        } else {
            if y > constants.middleY {
                return (y - constants.middleY) < (constants.bottomY - y) ? .middle : .bottom
            } else {
                return (y - constants.topY) < (constants.middleY - y) ? .top : .middle
            }
        }
    }
}

// Delegados de tabla
extension HomeSheetViewController : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tripList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.tableView.contentOffset.y = 0
        let trip = tripList[indexPath.row]
        bottomSheetDelegate?.selectedTrip(trip)
        setSheetState(.bottom)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BottomSheetCell", for: indexPath) as! HomeSheetCell
        let trip = tripList[indexPath.row]
        cell.setData(trip: trip)
        cell.goRouteBtn.deleteActions()
        cell.goRouteBtn.addAction(for: .touchUpInside) {
            self.bottomSheetDelegate?.goRoute(trip)
        }
        return cell
    }
}

extension HomeSheetViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
