//
//  ViewController.swift
//  UNATCapp
//
//  Created by Andrei Antal on 06/02/15.
//  Copyright (c) 2015 Andrei Antal. All rights reserved.
//

import UIKit
import Darwin

class ViewController: UIViewController {

    @IBOutlet weak var topEventsContainerView: UIView!
    @IBOutlet weak var theatreView: UIView!
    @IBOutlet weak var filmsView: UIView!
    @IBOutlet weak var eventsView: UIView!
    @IBOutlet weak var cinemaWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var filmsWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var eventsWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var theatreTitleLabel: UILabel!
    @IBOutlet weak var theatreTitleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var theatreTitleLabelLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var theatreDetailsView: UIView!
    
    
    @IBOutlet weak var filmsTitleLabel: UILabel!
    @IBOutlet weak var filmsTitleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var filmsTitleLabelLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var filmsDetailsView: UIView!
    
    
    @IBOutlet weak var eventsTitleLabel: UILabel!
    @IBOutlet weak var eventsTitleLabelLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var eventsTitleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var eventdDetailsView: UIView!
    
    
    var topEventsFrame:CGRect?;
    
    let openConstraintWidth:CGFloat = 120;
    let closedConstraintWidth:CGFloat = 60;
    
    var previousSelectedView = -1;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        
        topEventsFrame = topEventsContainerView.frame;
        initEventViewSizes()
        
        rotateEventsTitle(theatreTitleLabel, constraints: [theatreTitleLabelTopConstraint, theatreTitleLabelLeftConstraint], isRotated: true);
        rotateEventsTitle(filmsTitleLabel, constraints: [filmsTitleLabelTopConstraint, filmsTitleLabelLeftConstraint], isRotated: true);
        rotateEventsTitle(eventsTitleLabel, constraints: [eventsTitleLabelTopConstraint, eventsTitleLabelLeftConstraint], isRotated: true);
        
        view.layoutIfNeeded()
    }
    
    var openStates = [false, false, false]
    
    @IBAction func tapView(sender: UITapGestureRecognizer)
    {
        var size = CGSize(width: topEventsFrame!.size.width/3, height: topEventsFrame!.size.height)
        
        if sender.view!.isEqual(theatreView)
        {
            animateEventViews(0, withConstraintsSizes: [size.width + openConstraintWidth, size.width - closedConstraintWidth, size.width - closedConstraintWidth],animateElements: [theatreTitleLabel, theatreDetailsView])
        }
        else if sender.view!.isEqual(filmsView)
        {
            animateEventViews(1, withConstraintsSizes: [size.width - closedConstraintWidth, size.width + openConstraintWidth, size.width - closedConstraintWidth],animateElements: [filmsTitleLabel, filmsDetailsView])
        }
        else if sender.view!.isEqual(eventsView)
        {
            animateEventViews(2, withConstraintsSizes: [size.width - closedConstraintWidth, size.width - closedConstraintWidth, size.width + openConstraintWidth],animateElements: [eventsTitleLabel, eventdDetailsView])
        }
        
    }
    
    func rotateEventsTitle(label: UILabel,constraints : [NSLayoutConstraint], isRotated: Bool)
    {
        let rotateAngle : CGFloat = isRotated ? CGFloat(-M_PI/2) : 0,
            topConstraint : CGFloat = isRotated ? label.frame.size.width/2-5 : 8,
            leftConstraint : CGFloat = isRotated ? -label.frame.size.width/2+20 : 8
        
        label.transform = CGAffineTransformMakeRotation(rotateAngle)
        constraints[0].constant = topConstraint
        constraints[1].constant = leftConstraint
        
    }
    
    func initEventViewSizes()
    {
        var size = CGSize(width: topEventsFrame!.size.width/3, height: topEventsFrame!.size.height)
        cinemaWidthConstraint.constant = floor(size.width)+1
        filmsWidthConstraint.constant = floor(size.width)
        eventsWidthConstraint.constant = floor(size.width)+1
    }
    
    func setNewEventViewConstrains(constrainst: [CGFloat])
    {
        cinemaWidthConstraint.constant = constrainst[0]
        filmsWidthConstraint.constant = constrainst[1]
        eventsWidthConstraint.constant = constrainst[2]
    }
    
    func animateEventViews(viewIndex: Int, withConstraintsSizes constraints: [CGFloat], animateElements elements: [UIView])
    {
        UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseOut, animations: {
            
            // close
            if self.openStates[viewIndex] == true
            {
                self.openStates[viewIndex] = false
                
                self.initEventViewSizes()
                self.animateTitle(viewIndex, isRotated: true)
                
                self.previousSelectedView = -1;
                
                self.showDetailEvent(elements[1], isVisible: false);
                //elements[1].alpha = 0;
            }
            // open
            else
            {
                
                self.openStates = [false,false,false]
                self.openStates[viewIndex] = true;
                
                if(self.previousSelectedView != -1)
                {
                    self.animateTitle(self.previousSelectedView, isRotated: true)
                }
                self.previousSelectedView = viewIndex
                
                self.setNewEventViewConstrains(constraints)
                self.animateTitle(viewIndex, isRotated: false)
                
                
                self.showDetailEvent(elements[1], isVisible: true);
                //elements[1].alpha = 1;
                
            }
            
            self.view.layoutIfNeeded()
            
            }, completion: { finished in
                println("slide \(viewIndex+1) was \(self.openStates[viewIndex])")
        })
    }
    
    func showDetailEvent(detailView: UIView, isVisible: Bool)
    {
        theatreDetailsView.alpha = 0;
        filmsDetailsView.alpha = 0;
        eventdDetailsView.alpha = 0;
        
        detailView.alpha = isVisible ? 1 : 0;
    }
    
    func animateTitle(index: Int, isRotated: Bool)
    {
        switch index
        {
            case 0:
                rotateEventsTitle(theatreTitleLabel, constraints: [theatreTitleLabelTopConstraint, theatreTitleLabelLeftConstraint], isRotated: isRotated)
            case 1:
                rotateEventsTitle(filmsTitleLabel, constraints: [filmsTitleLabelTopConstraint, filmsTitleLabelLeftConstraint], isRotated: isRotated);
            case 2:
                rotateEventsTitle(eventsTitleLabel, constraints: [eventsTitleLabelTopConstraint, eventsTitleLabelLeftConstraint], isRotated: isRotated);
            default:
                return;
        }
    }

}

