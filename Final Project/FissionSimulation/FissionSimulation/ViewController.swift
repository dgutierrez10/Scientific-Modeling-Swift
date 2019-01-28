//
//  ViewController.swift
//  FissionSimulation
//
//  Created by Diego Gutierrez Coronel on 4/13/18.
//  Copyright © 2018 Diego Gutierrez Coronel. All rights reserved.
//
//ViewController is connected to the first tab of the Main.storyboard
//
//

import Cocoa
import CorePlot

// Global constants
//
let pi = Double.pi

//conversion factors or relevant constants
let Avogadro_Number = 6.022140857 * pow(10.0, 23.0)
let kiloton = 4.2e12 // 1kt = 4.2e12 J
let Joule_Ev = 1.6021765e-13  // Joule/MeV
let neutron_mass = 1.674927E-27



// U-235
let atomic_weigth_U_235 = 235.04 // g mol^-1
let density_U_235 = 18.71 // g cm^-3
let fission_c_section_U_235 = 1.235 // bn
let elastics_c_section_U_235 = 4.566 // bn
let second_neutrons_per_fission_U_235 = 2.637
let nuclear_number_density_U_235 = 4.793 // 10^28 nuclei m^-3
let fission_mfp_U_235 = 16.89 // cm
let transport_mfp_U_235 = 3.596 // -
let time_bn_fission_U_235 = 8.635 // 1e-9 s
let characteristic_core_size_U_235 = 3.517 //
let nu_U_235 = 0.6817
let epsilon_U_235 = 0.3408
let R_bare_critical_U_235 = 8.366 // cm
let M_bare_critical_U_235 = 45.9 // kg


// Pu-239 (Pu_239)
let atomic_weigth_Pu_239 = 239.04 // g mol^-1
let density_Pu_239 = 15.6 // g cm^-3
let fission_c_section_Pu_239 = 1.8 // bn
let elastics_c_section_Pu_239 = 4.394 // bn
let second_neutrons_per_fission_Pu_239 = 3.172
let nuclear_number_density_Pu_239 = 3.930 // 10^28 nuclei m^-3
let fission_mfp_Pu_239 = 14.14 // cm
let transport_mfp_Pu_239 = 4.108 // -
let time_bn_fission_Pu_239 = 7.227 // 1e-9 s
let characteristic_core_size_Pu_239 = 2.985 //
let nu_Pu_239 = 0.9174
let epsilon_Pu_239 = 0.4587
let R_bare_critical_Pu_239 = 6.345 // cm
let M_bare_critical_Pu_239 = 16.7 // kg

//Tamper materials
//Aluminum
let aluminum_transport_mfp = 5.595
let aluminum_atomic_weigth = 26.982 //g mol^-1
let aluminum_density = 2.699    //g cm^-3
let aluminum_elastic_scat_csection = 2.967 //bn


//Beryllium oxide

let Beryllium_oxide_transport_mfp = 2.549
let Beryllium_oxide_atomic_weigth = 25.01 //g mol^-1
let Beryllium_oxide_density = 3.02    //g cm^-3
let Beryllium_oxide_elastic_scat_csection = 5.412 //bn

//Lead
let lead_transport_mfp = 5.426
let lead_atomic_weigth = 207.2 //g mol^-1
let lead_density = 11.35    //g cm^-3
let lead_elastic_scat_csection = 5.587 //bn


//Tungsten Carbide
let tungsten_carbide_transport_mfp = 3.159
let tungsten_carbide_atomic_weigth = 195.85 //g mol^-1
let tungsten_carbide_density = 15.63    //g cm^-3
let tungsten_carbide_elastic_scat_csection = 6.587 //bn

//Depleted Uranium U-238
let depleted_U_transport_mnf = 4.342
let depleted_U_atomic_weigth = 238.05 //g mol^-1
let depleted_U_density = 18.95    //g cm^-3
let depleted_U_elastic_scat_csection = 4.804 //bn



class ViewController : NSViewController, CPTScatterPlotDataSource, CPTAxisDelegate {
    private var scatterGraph : CPTXYGraph? = nil
    
    
    
    @IBOutlet weak var hostingView: CPTGraphHostingView!
    
//Display weak variables
    
    @IBOutlet weak var Select_Source: NSPopUpButton!
    
    
    
    @IBOutlet weak var Select_Bare_Tamper: NSPopUpButton!
    
    
    @IBOutlet weak var Tamper_Material: NSPopUpButton!
    
    
    @IBOutlet weak var Plot_type: NSPopUpButton!
    
    
    @IBOutlet weak var R_ratio_tampered_configuration: NSTextField!
    
    
    @IBOutlet weak var criticalradiusb: NSTextField!
    
    
    @IBOutlet weak var critical_massb: NSTextField!
    
    @IBOutlet weak var Critical_masses_in_core: NSTextField!
    
    @IBOutlet weak var Efficiency_Display: NSTextField!
    
    
    @IBOutlet weak var Yield_Display: NSTextField!
    
    
    @IBOutlet weak var mass_core_display: NSTextField!
    
    
    @IBOutlet weak var mass_tamper_display: NSTextField!
    
    
    @IBOutlet weak var delta_R_display: NSTextField!
    
    @IBOutlet weak var user_density: NSTextField!
    
    @IBOutlet weak var user_atomic_weight: NSTextField!
    
    @IBOutlet weak var user_elastic_scat_cross_section: NSTextField!
    
    @IBOutlet weak var user_fission_cross_section: NSTextField!

    @IBOutlet weak var user_secondary_neutrons: NSTextField!
    
    
    
    
    typealias plotDataType = [CPTScatterPlotField : Double]
    private var dataForPlot = [plotDataType]()
    
    // Instances
    var functions = Functions()
    var root = RootFindingMethods()
   
    override func viewDidLoad() {
        
        
        super.viewDidLoad()

        
        Select_Source.removeAllItems()
        
        Select_Bare_Tamper.removeAllItems()
        
        Tamper_Material.removeAllItems()
        
        Plot_type.removeAllItems()
        /*
         */
        
        //Titles of PopUpButtons
        Select_Source.addItems(withTitles: ["Uranium - 235", "Plutonium - 239", "User Defined"])
        
        Select_Bare_Tamper.addItems(withTitles: ["Bare Core Configuration", "Tamper Core Configuration"])
        
        Tamper_Material.addItems(withTitles: ["Aluminum", "Berylium Oxide", "Lead", "Tungsten-carbide","Depleted Uranium U-238"])
        
        Plot_type.addItems(withTitles: ["Condition for Criticality", "Yield vs Tamper Mass"])
        
        
    
        
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


    @IBAction func Plot(_ sender: Any) {
        
        var axisLabelX = "X"
        var axisLabelY = "Y"
        var MinXDisplayCoord = -0.5
        var MaxXDisplayCoord = 1.5
        var MinYDisplayCoord = -0.25
        var MaxYDisplayCoord = 1.25
        
        // calculate exp(-x)
        
        
        var functional: [Double] = []
        var R_list_given: [Double] = []
        var zeros: [Double] = []
        dataForPlot = []
        
        //
        
        var Energy_neutron = 2.0 // MeV
        var neutron_speed = 100.0 * sqrt(2.0 * Energy_neutron * Joule_Ev / neutron_mass)
        var W_parameted = 7.14e13
        
        
        var transport_mfp = 0.0
        var fission_mfp = 0.0
        
        var secondary_n_per_fission = 0.0
        var density_source = 18.71
        var fission_cross_section = 0.0
        var elastic_cross_section = 0.0
        var nuclear_number_density = 0.0
        var time_between_fissions = 0.0
        var atomic_weight_source = 0.0
        // var Radius_core = 0.0
        var Rmin = 0.0
        var Rmax = 10.0
        var dR = 0.01
        let velocity_neutrons = 1.9565 // cm s^-9
        
        let source_selected: String = Select_Source.selectedItem!.title
        
        //Switch for Sources
        switch source_selected {
            
        case "Uranium - 235":
            transport_mfp = transport_mfp_U_235
            fission_mfp = fission_mfp_U_235
            secondary_n_per_fission = second_neutrons_per_fission_U_235
            density_source = density_U_235
            fission_cross_section = fission_c_section_U_235
            elastic_cross_section = elastics_c_section_U_235
            nuclear_number_density = nuclear_number_density_U_235
            time_between_fissions = time_bn_fission_U_235
            
        case "Plutonium - 239":
            transport_mfp = transport_mfp_Pu_239
            fission_mfp = fission_mfp_Pu_239
            secondary_n_per_fission = second_neutrons_per_fission_Pu_239
            density_source = density_Pu_239
            fission_cross_section = fission_c_section_Pu_239
            elastic_cross_section = elastics_c_section_Pu_239
            nuclear_number_density = nuclear_number_density_Pu_239
            time_between_fissions = time_bn_fission_U_235
            
        case "User Defined":
            
            secondary_n_per_fission = user_secondary_neutrons.doubleValue
            density_source = user_density.doubleValue
            atomic_weight_source = user_atomic_weight.doubleValue
            
            nuclear_number_density = 10.0e6 * density_source * Avogadro_Number / (atomic_weight_source * 10.0e28)
            
            
            transport_mfp = 1.0 / (nuclear_number_density * user_fission_cross_section.doubleValue + user_elastic_scat_cross_section.doubleValue) * 100
            
            fission_mfp = 1.0 / (nuclear_number_density * user_fission_cross_section.doubleValue) * 100
            
            time_between_fissions = transport_mfp / velocity_neutrons
            
            
            
        default: break
            
        }
        
        // transport cross section defined
        var transport_cross_section = fission_cross_section + elastic_cross_section
        
        
        //Switch to Select Configuration
        let bare_tamper_selected: String = Select_Bare_Tamper.selectedItem!.title
        var Do_bare_or_tamper: Bool = true
        
        //Switch for Sources
        switch bare_tamper_selected {
            
        case "Bare Core Configuration":
            
            Do_bare_or_tamper = true
            
        case "Tamper Core Configuration":
            
            Do_bare_or_tamper = false
            
        default: break
            
        }
        /*
         "Aluminum", "Berylium Oxide", "Lead", "Tungsten-carbide","Depleted Uranium U-238"
         */
        
        //
        
        var tampered_transport_mfp = 0.0
        var tamper_atomic_weigth = 0.0 //g mol^-1
        var tamper_density = 0.0    //g cm^-3
        var tamper_elastic_scat_csection = 0.0 //bn
        
        //Switch to Select Tampering Material
        let tamper_material_selected: String = Tamper_Material.selectedItem!.title
        
        switch tamper_material_selected {
            
        case "Aluminum":
            
            tampered_transport_mfp = aluminum_transport_mfp
            tamper_atomic_weigth = aluminum_atomic_weigth
            tamper_density = aluminum_density
            tamper_elastic_scat_csection = aluminum_elastic_scat_csection
            
        case "Berylium Oxide":
            
            tampered_transport_mfp = Beryllium_oxide_transport_mfp
            tamper_atomic_weigth = Beryllium_oxide_atomic_weigth
            tamper_density = Beryllium_oxide_density
            tamper_elastic_scat_csection = Beryllium_oxide_elastic_scat_csection
            
        case "Lead":
            
            tampered_transport_mfp = lead_transport_mfp
            tamper_atomic_weigth = lead_atomic_weigth
            tamper_density = lead_density
            tamper_elastic_scat_csection = lead_elastic_scat_csection
            
        case "Tungsten-carbide":
            
            
            tampered_transport_mfp = tungsten_carbide_transport_mfp
            tamper_atomic_weigth = tungsten_carbide_atomic_weigth
            tamper_density = tungsten_carbide_density
            tamper_elastic_scat_csection = tungsten_carbide_elastic_scat_csection
            
        case "Depleted Uranium U-238":
            
            tampered_transport_mfp = depleted_U_transport_mnf
            tamper_atomic_weigth = depleted_U_atomic_weigth
            tamper_density = depleted_U_density
            tamper_elastic_scat_csection = depleted_U_elastic_scat_csection
            
        default: break
            
        }
        
        
        //Parameters needed for criticality condition
        let epsilon_pameter = sqrt((secondary_n_per_fission - 1) * fission_cross_section / (3 * transport_cross_section))
        
        let R_tamp = functions.R_tamp(mass_core: mass_core_display.doubleValue, mass_tamp: mass_tamper_display.doubleValue, density_source: density_source, density_tamp: tamper_density)
        
        let R_core_cal = functions.R_core(mass_core: mass_core_display.doubleValue, density_source: density_source)
        
        var R_ratio = R_tamp / R_core_cal
        
        
        R_ratio_tampered_configuration.doubleValue = R_ratio
        
        if(R_ratio_tampered_configuration.doubleValue == 0.0)
        {
            R_ratio_tampered_configuration.doubleValue = 1.5
            
            R_ratio = 1.5
        }
    
        
        
        
        
      
        
        
        
        
        ///Bare Configuration
        ///
        ///
        if(Do_bare_or_tamper == true){
        
        // List of Rcore values
        for Rthere in stride(from: Rmin, to: Rmax, by: dR){
            R_list_given.append(Rthere)
        }
        // function values of the condition to achieve
        // criticality
        //
        //
        for i in 0 ..< R_list_given.count{
            
            
            functional.append(functions.Condition_Criticality_function(transport_mfp: transport_mfp, fission_mfp: fission_mfp, secondary_n_per_fission: secondary_n_per_fission, Radius_core: R_list_given[i]))
            
        }
        
        // Root Finding routine
        var Rmincal: Double = 0.0
        var Rmaxcal: Double = 0.0
        
        for i in 1 ..< (R_list_given.count){
            
            if(functional[i] * functional[i-1] < 0.0){
                
                Rmincal = R_list_given[i-1]
                Rmaxcal = R_list_given[i]
                let Ri = root.findRoot(Rmin: Rmincal, Rmax: Rmaxcal, dR: dR, transport_mfp: transport_mfp, fission_mfp: fission_mfp, secondary_n_per_fission: secondary_n_per_fission)
                zeros.append(Ri)
                
                
                
                
            }
            
        }
        
        print("Zeros")
        print(zeros)
        
            let critical_radius_to_show = zeros[0]
        criticalradiusb.doubleValue = critical_radius_to_show
        critical_massb.doubleValue = 4.0 /  3.0 * pi * pow(critical_radius_to_show, 3.0) * density_source / 1000
        
        
        
            let mass_in_core_calc =  mass_core_display.doubleValue
            
            Critical_masses_in_core.doubleValue = mass_in_core_calc/critical_massb.doubleValue
        
        
            if(Critical_masses_in_core.doubleValue == 0.0){
                
                Critical_masses_in_core.doubleValue = 1
            }
        
        for i in 0 ..< R_list_given.count {
            
            let x = R_list_given[i]
            let y = functional[i]
            
            
            let dataPoint: plotDataType = [.X: x, .Y: y]
            dataForPlot.append(dataPoint)
        }
            
            //Efficiency & Yield Calculation
            //
            //
            
            let delta_R = functions.delta_R(numbers_of_critical_masses: Critical_masses_in_core.doubleValue, Bare_Radius: critical_radius_to_show)
            
            
            let tau = time_between_fissions
            //let tau  = functions.average_time_neutron_travel(fission_mfp: fission_mfp, average_n_speed: <#T##Double#>)
            
            let alpha = functions.alpha_parameter(secondary_n_per_fission: secondary_n_per_fission, number_of_critical_masses: Critical_masses_in_core.doubleValue)
            
            let efficiency_bare = functions.Efficiency_Bare_Core(alpha: alpha, density_material: density_source, tau: tau, nuclear_number_density: nuclear_number_density, delta_R: delta_R)
            
            let r_core_cal_bare = pow(Critical_masses_in_core.doubleValue, 1.0 / 3.0) * critical_radius_to_show
            
            let yield_bare = functions.Yield_Bare_Core(alpha: alpha, density_material: density_source, tau: tau, nuclear_number_density: nuclear_number_density, delta_R: delta_R, R_core: r_core_cal_bare)
            
            //let m_core_display = critical_massb.doubleValue * Critical_masses_in_core.doubleValue
            
            
            
            print(alpha)
            print(critical_radius_to_show)
            print(delta_R)
            
            Efficiency_Display.doubleValue = efficiency_bare
            Yield_Display.doubleValue = yield_bare
            
            delta_R_display.doubleValue = delta_R
            
            
            
            // Plot
            //
            //
            
            
            
            axisLabelX = "Core Radius"
            axisLabelY = "F(R) Condition for Criticality"
            MinXDisplayCoord = -0.5
            MaxXDisplayCoord = zeros[0] + 1
            MinYDisplayCoord = -0.5
            MaxYDisplayCoord = 1.5
        
        
        makePlot(xLabel: axisLabelX, yLabel: axisLabelY, xMin: MinXDisplayCoord, xMax: MaxXDisplayCoord, yMin: MinYDisplayCoord, yMax: MaxYDisplayCoord)
            
        }
        ///
        ///Tamper Core configuration
        ///
        ///
        else if(Do_bare_or_tamper == false){ //Tamper Core configuration
            
            
            let Mass_core = 65800.0
            let Mass_tamp = 55250.0
            let Cinit = 1.0
            transport_cross_section = fission_cross_section + elastic_cross_section
            let tamper_nuclear_number_density = tamper_density * Avogadro_Number / tamper_atomic_weigth
            let core_initial_radii = (3.0 * Mass_core) / (4.0 * pi * Cinit * density_source)
            let tamp_initial_radii = (3 * Mass_tamp) / (4.0 * pi * Cinit * tamper_density)
            
            
            
            // List of Rcore values
            for Rthere in stride(from: Rmin, to: Rmax, by: dR){
                R_list_given.append(Rthere)
            }
            // function values of the condition to achieve
            // criticality
            //
            //
            for i in 0 ..< R_list_given.count{
                
                
                functional.append(functions.Condition_Tampered_Criticality_function(transport_mfp: transport_mfp, fission_mfp: fission_mfp, tampered_transport_mfp: tampered_transport_mfp, secondary_n_per_fission: secondary_n_per_fission, epsilon_parameter: epsilon_pameter, Radius_core: R_list_given[i], R_ratio: R_ratio))
                
            }
            
            // Root Finding routine
            var Rmincal: Double = 0.0
            var Rmaxcal: Double = 0.0
            
            for i in 1 ..< (R_list_given.count){
                
                if(functional[i] * functional[i-1] < 0.0){
                    
                    Rmincal = R_list_given[i-1]
                    Rmaxcal = R_list_given[i]
                    let Ri = root.findRoot_Tampered_Configuration(Rmin: Rmincal, Rmax: Rmaxcal, dR: dR, transport_mfp: transport_mfp, fission_mfp: fission_mfp, tampered_transport_mfp: tampered_transport_mfp, secondary_n_per_fission: secondary_n_per_fission, epsilon_parameter: epsilon_pameter, R_ratio: R_ratio)
                    zeros.append(Ri)
                    
                    
                    
                    
                }
                
                if (zeros.count < 1){
                    zeros.append(0.0)
                }
                
            }
            
            print("Zeros")
            print(zeros)
            
            let critical_radius_to_show = zeros[1]
            criticalradiusb.doubleValue = critical_radius_to_show
            critical_massb.doubleValue = 4.0 /  3.0 * pi * pow(critical_radius_to_show, 3.0) * density_source / 1000 //to show in kg
            
            let mass_in_core_calc =  mass_core_display.doubleValue
            
            Critical_masses_in_core.doubleValue = mass_in_core_calc/critical_massb.doubleValue
            
            /*
             
             
             */
            
            ///
            
            
            for i in 0 ..< R_list_given.count {
                
                let x = R_list_given[i]
                let y = functional[i]
                
                
                let dataPoint: plotDataType = [.X: x, .Y: y]
                dataForPlot.append(dataPoint)
            }
            
            
            
            
            let delta_R_tamp = functions.delta_R(numbers_of_critical_masses: Critical_masses_in_core.doubleValue, Bare_Radius: critical_radius_to_show)
            
            // Initial compressed radius
            let r_core_cal_tamp = pow(Critical_masses_in_core.doubleValue, 1.0 / 3.0) * critical_radius_to_show
            
            let mass_core = functions.Mcore(R_core: r_core_cal_tamp, density_core: density_source)
            
            let mass_total = functions.Mtotal_tamper_core(R_core: r_core_cal_tamp, R_ratio: R_ratio, density_core: density_source, density_tamp: tamper_density)
            //Final Radius
            let r_core_cal_tamp_final = pow(Critical_masses_in_core.doubleValue, 1.0 / 3.0) * critical_radius_to_show + delta_R_tamp
            let Compression_ratio = pow(r_core_cal_tamp / r_core_cal_tamp_final, 3.0)
            
            let tau = time_between_fissions / Compression_ratio
            
            
            
            
            let efficiency_tamp = functions.Efficiency_Tampered_Core(Mtotal: mass_total, Mcore: mass_core, tau: tau, secondary_neutrons_per_fission: secondary_n_per_fission, delta_R: delta_R_tamp)
            
            let yield_tamp = functions.Yield_Tampered_Core(Mtotal: mass_total,tau: tau, secondary_neutrons_per_fission: secondary_n_per_fission, delta_R: delta_R_tamp)
            
            Efficiency_Display.doubleValue = efficiency_tamp
            Yield_Display.doubleValue = yield_tamp
            delta_R_display.doubleValue = delta_R_tamp
            
            let mtamp = functions.Mtamp(R_core: r_core_cal_tamp, density_tamp: tamper_density, R_ratio: R_ratio)
            
            let m_disp = Critical_masses_in_core.doubleValue
            
            let m_1 = critical_massb.doubleValue
            
            //mass_core_display.doubleValue = m_disp * m_1
            
            mass_tamper_display.doubleValue = mtamp
            
            
            
            print(r_core_cal_tamp)
            print(Compression_ratio)
            print(tau)
            print(delta_R_tamp)
            print(mtamp)
            print(mass_core)
            
            
            let Plot_selected: String = Plot_type.selectedItem!.title
            
            switch Plot_selected {
                
            case "Condition for Criticality":
                
                axisLabelX = "Core Radius"
                axisLabelY = "F(R) Condition for Criticality"
                MinXDisplayCoord = -0.5
                MaxXDisplayCoord = zeros[1] + 1
                MinYDisplayCoord = -0.5
                MaxYDisplayCoord = functional[1] + 0.5
                
                
                
                makePlot(xLabel: axisLabelX, yLabel: axisLabelY, xMin: MinXDisplayCoord, xMax: MaxXDisplayCoord, yMin: MinYDisplayCoord, yMax: MaxYDisplayCoord)
                
            case "Yield vs Tamper Mass":
                
                dataForPlot.removeAll()
                var M_list: [Double] = []
                var Y_list: [Double] = []
                
                
                
                for Mthere in stride(from: 50, to: 800, by: 10.0){
                    M_list.append(Mthere)
                    Y_list.append(functions.Yield_Tampered_Core(Mtotal: (Mthere + mass_core_display.doubleValue) * 1000, tau: time_between_fissions, secondary_neutrons_per_fission: secondary_n_per_fission, delta_R: delta_R_tamp))
                    print(functions.Yield_Tampered_Core(Mtotal: (Mthere + mass_core_display.doubleValue) * 1000, tau: time_between_fissions, secondary_neutrons_per_fission: secondary_n_per_fission, delta_R: delta_R_tamp))
                    
                }
                
                axisLabelX = "Tamper mass (kg)"
                axisLabelY = "Yield (kt)"
                MinXDisplayCoord = 100
                MaxXDisplayCoord = 700
                MinYDisplayCoord = Y_list.min()!
                MaxYDisplayCoord = Y_list.max()!
                // function values of the condition to achieve
                // criticality
                //
                //
                
                for i in 0 ..< M_list.count {
                    
                    let x = M_list[i]
                    let y = Y_list[i]
                    
                    
                    let dataPoint: plotDataType = [.X: x, .Y: y]
                    dataForPlot.append(dataPoint)
                }
                
                makePlot(xLabel: axisLabelX, yLabel: axisLabelY, xMin: MinXDisplayCoord, xMax: MaxXDisplayCoord, yMin: MinYDisplayCoord, yMax: MaxYDisplayCoord)
                
                
            default: break
                
            }
            
            
        
            
            
            
        }
        
    }
    
    
    
    
    
    
    /************** Functions for Plotting **************/
    
    
    /// makePlot sets up the default plotting conditions and displays the data
    func makePlot(xLabel: String, yLabel: String, xMin: Double, xMax: Double, yMin: Double, yMax: Double){
        
        // Create graph from theme
        let newGraph = CPTXYGraph(frame: .zero)
        newGraph.apply(CPTTheme(named: .darkGradientTheme))
        
        hostingView.hostedGraph = newGraph
        
        // Paddings
        newGraph.paddingLeft   = 10.0
        newGraph.paddingRight  = 10.0
        newGraph.paddingTop    = 10.0
        newGraph.paddingBottom = 10.0
        
        // Plot space
        let plotSpace = newGraph.defaultPlotSpace as! CPTXYPlotSpace
        plotSpace.allowsUserInteraction = true
        
        
        
        plotSpace.yRange = CPTPlotRange(location: NSNumber(value: yMin), length: NSNumber(value: (yMax-yMin)))
        plotSpace.xRange = CPTPlotRange(location: NSNumber(value: xMin), length: NSNumber(value: (xMax-xMin)))
        
        
        //Anotation
        
        let theTextStyle :CPTMutableTextStyle = CPTMutableTextStyle()
        
        theTextStyle.color =  CPTColor.white()
        
        let ann = CPTLayerAnnotation.init(anchorLayer: hostingView.hostedGraph!.plotAreaFrame!)
        
        ann.rectAnchor = CPTRectAnchor.bottom; //to make it the top centre of the plotFrame
        ann.displacement = CGPoint(x: 20.0, y: 20.0) //To move it down, below the title
        
        let textLayer = CPTTextLayer.init(text: xLabel, style: theTextStyle)
        
        ann.contentLayer = textLayer
        
        hostingView.hostedGraph?.plotAreaFrame?.addAnnotation(ann)
        
        let annY = CPTLayerAnnotation.init(anchorLayer: hostingView.hostedGraph!.plotAreaFrame!)
        
        annY.rectAnchor = CPTRectAnchor.left; //to make it the top centre of the plotFrame
        annY.displacement = CGPoint(x: 50.0, y: 30.0) //To move it down, below the title
        
        let textLayerY = CPTTextLayer.init(text: yLabel, style: theTextStyle)
        
        annY.contentLayer = textLayerY
        
        hostingView.hostedGraph?.plotAreaFrame?.addAnnotation(annY)
        
        
        
        
        // Axes
        let axisSet = newGraph.axisSet as! CPTXYAxisSet
        
        if let x = axisSet.xAxis {
            x.majorIntervalLength   = 1.0
            x.orthogonalPosition    = 0.0
            x.minorTicksPerInterval = 3
        }
        
        if let y = axisSet.yAxis {
            y.majorIntervalLength   = 0.5
            y.minorTicksPerInterval = 5
            y.orthogonalPosition    = 0.0
            y.delegate = self
        }
        
        // Create a blue plot area
        let boundLinePlot = CPTScatterPlot(frame: .zero)
        let blueLineStyle = CPTMutableLineStyle()
        blueLineStyle.miterLimit    = 1.0
        blueLineStyle.lineWidth     = 3.0
        blueLineStyle.lineColor     = .blue()
        boundLinePlot.dataLineStyle = blueLineStyle
        boundLinePlot.identifier    = NSString.init(string: "Blue Plot")
        boundLinePlot.dataSource    = self
        newGraph.add(boundLinePlot)
        
        let fillImage = CPTImage(named:"BlueTexture")
        fillImage.isTiled = true
        boundLinePlot.areaFill      = CPTFill(image: fillImage)
        boundLinePlot.areaBaseValue = 0.0
        
        // Add plot symbols
        let symbolLineStyle = CPTMutableLineStyle()
        symbolLineStyle.lineColor = .blue()
        let plotSymbol = CPTPlotSymbol.ellipse()
        plotSymbol.fill          = CPTFill(color: .blue())
        plotSymbol.lineStyle     = symbolLineStyle
        plotSymbol.size          = CGSize(width: 10.0, height: 10.0)
        boundLinePlot.plotSymbol = plotSymbol
        
        //self.dataForPlot = contentArray
        
        self.scatterGraph = newGraph
    }
    
    // MARK: - Plot Data Source Methods
    func numberOfRecords(for plot: CPTPlot) -> UInt
    {
        return UInt(self.dataForPlot.count)
    }
    
    func number(for plot: CPTPlot, field: UInt, record: UInt) -> Any?
    {
        let plotField = CPTScatterPlotField(rawValue: Int(field))
        
        if let num = self.dataForPlot[Int(record)][plotField!] {
            let plotID = plot.identifier as! String
            if (plotField! == .Y) && (plotID == "Green Plot") {
                return (num + 0.0) as NSNumber
            }
            else {
                return num as NSNumber
            }
        }
        else {
            return nil
        }
    }
    
    // MARK: - Axis Delegate Methods
    private func axis(_ axis: CPTAxis, shouldUpdateAxisLabelsAtLocations locations: NSSet!) -> Bool
    {
        if let formatter = axis.labelFormatter {
            let labelOffset = axis.labelOffset
            
            var newLabels = Set<CPTAxisLabel>()
            
            if let labelTextStyle = axis.labelTextStyle?.mutableCopy() as? CPTMutableTextStyle {
                for location in locations {
                    if let tickLocation = location as? NSNumber {
                        if tickLocation.doubleValue >= 0.0 {
                            labelTextStyle.color = .green()
                        }
                        else {
                            labelTextStyle.color = .red()
                        }
                        
                        let labelString   = formatter.string(for:tickLocation)
                        let newLabelLayer = CPTTextLayer(text: labelString, style: labelTextStyle)
                        
                        let newLabel = CPTAxisLabel(contentLayer: newLabelLayer)
                        newLabel.tickLocation = tickLocation
                        newLabel.offset       = labelOffset
                        
                        newLabels.insert(newLabel)
                    }
                }
                
                axis.axisLabels = newLabels
            }
        }
        
        return false
    }
}












