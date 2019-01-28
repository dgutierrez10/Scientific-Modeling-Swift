//
//  Functions.swift
//  FissionSimulation
//
//  Created by Diego Gutierrez Coronel on 4/20/18.
//  Copyright © 2018 Diego Gutierrez Coronel. All rights reserved.
//

import Cocoa



class Functions: NSObject {
    
    func d_parameter(transport_mfp: Double, fission_mfp: Double, secondary_n_per_fission: Double) -> Double{
        
       let d = sqrt(transport_mfp * fission_mfp / (3.0 * (secondary_n_per_fission - 1)))
        
        return d
        
    }

    func Nu_parameter(d_parameter: Double, transport_mfp: Double){
        
        let Nu = 2.0 * transport_mfp / (3.0 * d_parameter)
        
    }
    
    
    /// Calculates Condition for Criticality for bare configuration
    /// find root sof
    ///
    /// - Parameters:
    ///   - transport_mfp: transport mean free path
    ///   - fission_mfp: fission mean free path
    ///   - secondary_n_per_fission: secondary neutrons per fission
    ///   -Radius_core:
    ///   - Emax: Maximum range of energy considered for finding eigen values
    /// - Returns: function to be rooted
    func Condition_Criticality_function(transport_mfp: Double, fission_mfp: Double, secondary_n_per_fission: Double, Radius_core: Double) -> Double{
        
        let d = sqrt(transport_mfp * fission_mfp / (3.0 * (secondary_n_per_fission - 1)))
        
        let Nu = 2.0 * transport_mfp / (3.0 * d)
        
        let function = (Radius_core / d) * (1/tan(Radius_core / d)) + 1 / Nu * (Radius_core / d) - 1
        
        return function
        
    }
    
    /// Calculates Condition for Tampered Criticality for bare configuration
    /// find root sof
    ///
    /// - Parameters:
    ///   - transport_mfp: transport mean free path
    ///   - fission_mfp: fission mean free path
    ///   - secondary_n_per_fission: secondary neutrons per fission
    ///   -Radius_core:
    ///   - Emax: Maximum range of energy considered for finding eigen values
    /// - Returns: function to be rooted
   
    func Condition_Tampered_Criticality_function(transport_mfp: Double, fission_mfp: Double, tampered_transport_mfp: Double, secondary_n_per_fission: Double, epsilon_parameter: Double, Radius_core: Double, R_ratio: Double) -> Double{
        
        let lambda = tampered_transport_mfp / transport_mfp
        
        let d = sqrt(transport_mfp * fission_mfp / (3.0 * (secondary_n_per_fission - 1.0)))
        
        
        
        let function1 = (Radius_core / d) * (1.0 / tan(Radius_core / d)) - 1
        let function2 = 1.0 + (2.0 * lambda * epsilon_parameter * (d / Radius_core) * pow(1.0 / R_ratio, 2.0)) - 1.0 / R_ratio
        let function = function2 * function1 + lambda
        
        return function
        
    }
    
    //****************//
    //Efficiency and Yield Calculations
    
    //** Bare Core **//
    
    /// Calculates distance core expands from its initial radius
    /// find root sof
    ///
    /// - Parameters:
    ///
    ///   - Bare_radius: critical radius
    ///   - number_of_critical_masses: Critical masses of source used for fission
    /// - Returns: distance core expands from its initial radius
    func delta_R(numbers_of_critical_masses: Double, Bare_Radius: Double) -> Double{
        
        let delta_R = pow(numbers_of_critical_masses, 1.0 / 3.0) * Bare_Radius * (sqrt(pow(numbers_of_critical_masses, 1.0 / 3.0)) - 1)
        
        return delta_R
        
    }
    
    
    /// Calculates alpha parameter of efficiency for bare core configuration
    /// find root sof
    ///
    /// - Parameters:
    ///     - secondary_n_per_fission: secondary neutrons per fission
    ///   - density_material: density gm/cm^3
    ///   - number_of_critical_masses: Critical masses of source used for fission
    /// - Returns: alpha parameter
    func alpha_parameter(secondary_n_per_fission: Double, number_of_critical_masses: Double) -> Double{
        
        let alpha = (secondary_n_per_fission - 1) * (1 - pow(1.0 / number_of_critical_masses, 2.0 / 3.0))
        
        return alpha
        
    
    }
    
    func average_time_neutron_travel(fission_mfp: Double, average_n_speed: Double) -> Double{
        
        let tau = fission_mfp / average_n_speed
        
        return tau
    }
    
    
    /// Calculates expression of efficiency for bare core configuration
    /// find root sof
    ///
    /// - Parameters:
    ///   - tau: average time of travel of neutrons
    ///   - density_material: density gm/cm^3
    ///   - delta_R: distance core expands from initial radius
    ///  - nuclear_number_density
    /// - Returns: efficiency for bare core

    func Efficiency_Bare_Core(alpha: Double, density_material: Double, tau: Double, nuclear_number_density: Double, delta_R: Double) -> Double{
        
        let Energy_per_fission = 2.723e-11
        
        let eff = (pow(alpha, 2.0) * density_material * pow(delta_R, 2.0)) / (8 * pow(tau, 2.0) * nuclear_number_density * Energy_per_fission) * 10e-12
    
    
        return eff * 100
    }
    
    /// Calculates expression of yield for bare core configuration
    ///
    ///
    /// - Parameters:
    ///   - tau: average time of travel of neutrons
    ///   - density_material: density gm/cm^3
    ///   - delta_R: distance core expands from initial radius
    ///  - nuclear_number_density
    /// - Returns: efficiency for bare core
    func Yield_Bare_Core(alpha: Double, density_material: Double, tau: Double, nuclear_number_density: Double, delta_R: Double, R_core: Double) -> Double{
        
        let volume = 4.0 / 3.0 * pow(R_core, 3.0) * pi
        
        let yield = (pow(alpha, 2.0) * volume * density_material * pow(delta_R, 2.0)) / (8 * pow(tau, 2.0)) * 10e11 / kiloton
        
        // / 4.2 * 10e5
        return yield
        
    }
    /// Calculates R_tamp
    /// find root sof
    ///
    /// - Parameters:
    ///   - masses core and tamper material
    ///   - density_materials: density gm/cm^3
    ///
    /// - Returns: efficiency for bare core
    func R_core(mass_core:Double, density_source: Double) -> Double{
        
        let inside = 3.0 / (4.0 * pi) * (mass_core / density_source)
        
        let R_core = pow(inside, 1.0 / 3.0)
        
        return R_core
    }
    
    
   
        //** Tampered Core Configuration **//
    /// Calculates R_tamp
    ///
    ///
    /// - Parameters:
    ///   - masses core and tamper material
    ///   - density_materials: density gm/cm^3
    ///
    /// - Returns: efficiency for bare core
    func R_tamp(mass_core:Double, mass_tamp: Double, density_source: Double, density_tamp: Double) -> Double{
        
        let inside = 3.0 / (4.0 * pi) * (mass_core / density_source + mass_tamp / density_tamp)
        
        let R_tamp = pow(inside, 1.0 / 3.0)
        
        return R_tamp
    }
    
    /// Calculates M_total
    ///
    ///
    /// - Parameters:
    ///   - radii core and tamper material
    ///   - density_materials: density gm/cm^3
    ///
    /// - Returns: mass tamper
    func Mtotal_tamper_core(R_core: Double, R_ratio: Double, density_core: Double, density_tamp: Double) -> Double {
        
        let Mcore = 4.0 / 3.0 * pi * pow(R_core, 3.0) * density_core
        
        let Mtamp = 4.0 / 3.0 * pi  * density_tamp * (pow(R_core * R_ratio, 3.0) - pow(R_core, 3.0))
        
        let Mtotal = Mcore + Mtamp
        
        return Mtotal
    }
    /// Calculates M_core
    ///
    ///
    /// - Parameters:
    ///   - Radius
    ///   - density_material: density gm/cm^3
    ///
    /// - Returns: mass core
    func Mcore(R_core: Double, density_core: Double) -> Double{
        
        let Mcore = 4.0 / 3.0 * pi * pow(R_core, 3.0) * density_core
        
        return Mcore
        
    }
    
    func Mtamp(R_core: Double, density_tamp: Double, R_ratio: Double) -> Double{
        
        let Mtamp = 4.0 / 3.0 * pi  * density_tamp * (pow(R_ratio * R_core, 3.0) - pow(R_core, 3.0)) / 1000.0
        
        return Mtamp
        
    }
    /// Calculates expression of efficiency for bare core configuration
    /// find root sof
    ///
    /// - Parameters:
    ///   - tau: average time of travel of neutrons
    ///   - Mtotal: total mass
    ///   - Mcore: mass of core
    ///   - delta_R: distance core expands from initial radius
    ///  -secondary_neutrons_per_fission: neutrons generated in fission
    /// - Returns: efficiency for bare core
    func Efficiency_Tampered_Core(Mtotal: Double, Mcore: Double, tau: Double, secondary_neutrons_per_fission: Double, delta_R: Double) -> Double{
        
        let W = 17.0
        
//        let inside_square_term = delta_R * log(secondary_neutrons_per_fission) / tau
//
//        let yield = (Mtotal / 8) * pow( inside_square_term, 2.0) * 10e11 / kiloton
        
        let yield = Yield_Tampered_Core(Mtotal: Mtotal, tau: tau, secondary_neutrons_per_fission: secondary_neutrons_per_fission, delta_R: delta_R)
        
        let eff = yield / (W * Mcore / 1000)
        
        return eff * 100
    }
    /// Calculates expression of yield for bare core configuration
    ///
    /// Parameters:
    /// - tau: average time of travel of neutrons
    ///   - Mtotal: total mass
    ///   - Mcore: mass of core
    ///   - delta_R: distance core expands from initial radius
    ///  -secondary_neutrons_per_fission: neutrons generated in fission
    ///
    /// - Returns: yield
    func Yield_Tampered_Core(Mtotal: Double, tau: Double, secondary_neutrons_per_fission: Double, delta_R: Double) -> Double{
        
        let inside_square_term = 0.01 * delta_R * log(secondary_neutrons_per_fission) / (tau * 10e-9)
        
        let yield = (Mtotal / 8000) * pow( inside_square_term, 2.0) / kiloton * 100
        
        return yield
        
    }
    
    

    
    
    

}
