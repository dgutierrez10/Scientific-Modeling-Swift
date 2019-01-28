////
//  ViewController.swift
//  NeutronScattering
//
//  Created by Diego Gutierrez Coronel on 2/15/18.
//  Copyright © 2018 Diego Gutierrez Coronel. All rights reserved.
//


//ViewController2 is connected to the second tab of the
//Main.storyboard
//
 


import Cocoa

class ViewController2: NSViewController {
    
    
    //Weak vars for display of second tab in main storyboard
    @IBOutlet weak var displayView: DrawingView!
    
    @IBOutlet weak var initial_number_particles: NSTextField!
    
    @IBOutlet weak var EnergyLoss: NSTextField!
    
    @IBOutlet weak var percentageEscape: NSTextField!
    
    
    @IBOutlet weak var number_of_iterations: NSTextField!
    
    @IBOutlet weak var iterateButton: NSButton!
    
    
    @IBOutlet weak var Select_Source2: NSPopUpButton!
    
    @IBOutlet weak var Tamper_Material2: NSPopUpButton!
    
    
    @IBOutlet weak var output_time: NSTextField!
    
    @IBOutlet weak var output_number_green_fission: NSTextField!
    
    @IBOutlet weak var output_number_red_escape:NSTextField!
    
    @IBOutlet weak var output_rate_escape: NSTextField!
    
    @IBOutlet weak var output_rate_fission: NSTextField!
    
    @IBOutlet weak var Total_neutrons: NSTextField!
    
    
    @IBOutlet weak var secondary_n_input: NSTextField!
    
    
    @IBOutlet weak var coefficient_proportionality_sampling: NSTextField!
    
    //PopUp Buttons
    
    var animateTimer: Timer!
    
    var current_time = 0.0
    
    var position_neutrons: [(Double,Double)] = []
    
    var r_position_green_array: [(Double,Double)] = []
    
    var r_position_red_array: [(Double,Double)] = []
    
    var radius = 2.0
    
    var cross_section_fission = 0.0
    
    var cross_section_scat = 0.0
    
    var cross_section_total = 0.0
    
    var points_red = 0.0
    
    var points_green = 0.0
    
    var rate_green = 0.0
    
    var rate_red = 0.0
    
    var rate_continue = 0.0
    
    var points_continue = 0.0
    
    var ratio_radius_mean_f_path = 0.0
    
    var new_number_particles = 0
    
    var secondary_neutrons_generated = 0.0
    
    var random_r_range = 0.5
    
    var time_between_fission = 0.0
    
    var coefficient_radii = 1.0
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Select_Source2.removeAllItems()
        
        
        
        
        
        Select_Source2.addItems(withTitles: ["Uranium - 235", "Plutonium - 239", "User Defined"])
        
        
        
        
        // Do any additional setup after loading the view.
        let source_selected2: String = Select_Source2.selectedItem!.title
        
        
        switch source_selected2 {
            
        case "Uranium - 235":
            cross_section_scat = elastics_c_section_U_235
            cross_section_fission = fission_c_section_U_235
            
            //ratio of radius that a neutrons travels on average in an Uranium core
            ratio_radius_mean_f_path = transport_mfp_U_235 / R_bare_critical_Pu_239
            cross_section_total = cross_section_fission + cross_section_fission
            //ratio of radius that a neutron travels on average in a Plutonium core
            ratio_radius_mean_f_path = transport_mfp_Pu_239 / R_bare_critical_Pu_239
            secondary_neutrons_generated = 3
            time_between_fission = 8.35
            
            
            
            
        case "Plutonium - 239":
            
            cross_section_scat = elastics_c_section_Pu_239
            cross_section_fission = fission_c_section_Pu_239
            
            cross_section_total = cross_section_fission + cross_section_fission
            secondary_neutrons_generated = 3
            time_between_fission = 7.227
            
        default: break
        }
        
        secondary_n_input.doubleValue = 3
        
        
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    //
    
    
    
    //Clear button
    @IBAction func clearDisplay(_ sender: Any) {
        
        displayView.angle = 0.0
        displayView.shouldIClear = true
        displayView.shouldIDrawline = false
        displayView.shouldIrandomwalk = false
        displayView.shouldIrandomwalkNOlines = false
        displayView.shouldIDrawPoints = false
        displayView.allThePoints.removeAll()
        displayView.tellGuiToDisplay()
        
        initial_number_particles.doubleValue = 10
        r_position_green_array.removeAll()
        r_position_red_array.removeAll()
        rate_red = 0.0
        rate_green = 0.0
        points_green = 0.0
        points_red = 0.0
        points_continue = 0.0
        rate_continue = 0.0
        new_number_particles = 0
        random_r_range = 0.5
        coefficient_radii = 1.0
        
        
    }
    
    
    
    
    func animation(total_time: Double){
        
        //Stores the clock time by interval chuncks as a double to calculate compression as a function
        //of time
        
        //Clears the display at every instance in interval and re-draws at the new time
        displayView.shouldIClear = true
        
        //radius for particles escape if statement
        radius = 1.0
        
        //radius for display comparisson
        var radius_dis = sqrt(pow(Double(displayView.frame.width)/3.0,2.0) + pow(Double(displayView.frame.height)/3.0,2.0))
        
        var angle = 0
        
        
        var point = (xPoint: 0.0, yPoint: 0.0, radiusPoint: 0.0, color: "Red", cross_section_determination: 0.0)
        
        var point2 = (xPoint: 0.0, yPoint: 0.0, radiusPoint: 0.0, color: "Red", cross_section_determination: 0.0)
        
        random_r_range = random_r_range * coefficient_radii
        
        
        
        
        
        
        //add saved neutrons from previous calculation to display
        //        for i in 0 ..< r_position_red_array.count  {
        //
        //            displayView.addPoint(xPointa:r_position_red_array[i].0, yPointb: r_position_red_array[i].1, radiusPointc: point.radiusPoint, colord: "Red")
        //
        //        }
        //
        //        for i in 0 ..< r_position_green_array.count {
        //            displayView.addPoint(xPointa:r_position_green_array[i].0, yPointb: r_position_green_array[i].1, radiusPointc: point.radiusPoint, colord: "Green")
        //
        //
        //        }
        
        //Routine that calculates number and position of fission and escaping of neutrons
        
        //For loop for random sampling of events
        for i in 1 ..< new_number_particles{
            
           
            point.xPoint = Double.getRandomNumber(lower: -radius-random_r_range, upper: radius+random_r_range)
            point.yPoint = Double.getRandomNumber(lower: -radius-random_r_range, upper: radius+random_r_range)
            point.cross_section_determination = Double.getRandomNumber(lower: 0.0, upper: 1.0)
            point.radiusPoint = sqrt(pow(point.xPoint,2.0) + pow(point.yPoint,2.0))
            
            
            
            
            //if particle outside core mark as if it escaped
            if((radius - point.radiusPoint) <= 0.0){
                points_red += 1.0
                rate_red += 1.0
                
                point.xPoint = point.xPoint * Double(displayView.frame.width)/3.0 + Double(displayView.frame.width)/2.0
                point.yPoint = point.yPoint * Double(displayView.frame.height)/3.0 + Double(displayView.frame.height)/2.0
                
                
                
                //append to red array
                r_position_red_array.append((point.xPoint,point.yPoint))
                
                point.color = "Red"
                displayView.addPoint(xPointa:point.xPoint, yPointb: point.yPoint, radiusPointc: point.radiusPoint, colord: point.color)
                
            } //if x <= fission/total particles generates fission
            else if(point.cross_section_determination <= cross_section_fission/cross_section_total){
                
                points_green += 1.0
                
                rate_green += 1.0
                
                point.xPoint = point.xPoint * Double(displayView.frame.width)/3.0 + Double(displayView.frame.width)/2.0
                point.yPoint = point.yPoint * Double(displayView.frame.height)/3.0 + Double(displayView.frame.height)/2.0
                
                //append to green
                r_position_green_array.append((point.xPoint,point.yPoint))
                point.color = "Green"
                displayView.addPoint(xPointa:point.xPoint, yPointb: point.yPoint, radiusPointc: point.radiusPoint, colord: point.color)
                
            } //if x <= scatter/total neutron scatters and program calculates probaility of escape gives for next time step
            else if(point.cross_section_determination >= cross_section_fission/cross_section_total){
                
                
                // this routine calculates if electron will escape in the next time step
                point.xPoint = point.xPoint * Double(displayView.frame.width)/3.0 + Double(displayView.frame.width)/2.0
                point.yPoint = point.yPoint * Double(displayView.frame.height)/3.0 + Double(displayView.frame.height)/2.0
                angle = Int.getRandomNumber(lower: 0, upper: 360)
                point2.xPoint += (Double(displayView.frame.size.width/2.0) * cos(Double(angle) * pi / 180) * ratio_radius_mean_f_path)
                point2.yPoint += (Double(displayView.frame.size.width/2.0) * sin(Double(angle) * pi / 180) * ratio_radius_mean_f_path)
                point2.radiusPoint = sqrt(pow(point.xPoint,2.0) + pow(point.yPoint,2.0))
                
                
                //neutron will not escape - outside
                if(abs(radius_dis   - point.radiusPoint) >= 0.0){
                    
                    points_continue += 1.0
                    
                    rate_continue += 1.0
                    
                    point.color = "Blue"
                    
                    
                }
                else{//neutron will escape
                    
                    points_red += 1.0
                    rate_red += 1.0
                    
                    point.color = "Red"
                    
                    //append to red array
                    r_position_red_array.append((point.xPoint,point.yPoint))
                    
                    
                }
                
                displayView.addPoint(xPointa:point.xPoint, yPointb: point.yPoint, radiusPointc: point.radiusPoint, colord: point.color)
                
            }
            
            
            
        }
        
        (output_time.doubleValue) = current_time * time_between_fission / total_time * number_of_iterations.doubleValue
        (output_number_red_escape.doubleValue) = points_red
        (output_number_green_fission.doubleValue) = points_green
        output_rate_escape.doubleValue = rate_red / time_between_fission
        
        output_rate_fission.doubleValue = rate_green / time_between_fission
        
        Total_neutrons.doubleValue = points_green + points_red
        
        new_number_particles = Int(rate_green * secondary_neutrons_generated + points_continue)
        //
        rate_green = 0.0
        rate_red = 0.0
        rate_continue = 0.0
        
        
        displayView.shouldIDrawCircle = true
        displayView.shouldIrandomwalk = false
        displayView.shouldIDrawPoints = true
        //displayView.shouldIrandomwalkNOlines = true
        displayView.tellGuiToDisplay()
        
        
        print(new_number_particles)
        //displayView.allThePoints.removeAll()
        
        //stops clock as soon as time surpasses the total
        if current_time >= total_time || new_number_particles == 0{
            self.animateTimer.invalidate()
            new_number_particles = 0
        }
        current_time += animateTimer.timeInterval
        
        
        
    }
    
    
    
    //Start button
    @IBAction func start_animation(_ sender: Any) {
        
        
        let total_time = 20.0
        
        let timeInterval = total_time/(number_of_iterations.doubleValue)
        
        new_number_particles = Int(initial_number_particles.intValue)
        
        secondary_neutrons_generated = secondary_n_input.doubleValue
        
        coefficient_radii = 1.0
        
        
        
        if iterateButton.title == "Start" {
            current_time = 0.0
            
            iterateButton.title = "Pause"
            
            
            
            displayView.circle()
            
            // Starts the clock with the timer interval of total over the iterations
            
            // Each timestep the function animation()
            animateTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(timeInterval), repeats: true, block: { (Timer) in self.animation(total_time: total_time)})
            
        }
            
            //stops clock
        else {
            
            self.animateTimer.invalidate()
            iterateButton.title = "Start"
            
            
        }
        
    }
    
    //Reset button to re-start timer
    @IBAction func reset_animation(_ sender: Any) {
        current_time = 0.0
        new_number_particles = Int(initial_number_particles.intValue)
        
        
        displayView.allThePoints.removeAll()
        
        
        (output_time.doubleValue) = 0.0
        
        if iterateButton.title == "Pause"{
            
            iterateButton.title = "Start"
            iterateButton.setNextState()
        }
        
    }
    
    
    
    
}



