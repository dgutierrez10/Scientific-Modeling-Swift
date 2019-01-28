//
//  RootFindingMethods.swift
//  FissionSimulation
//
//  Created by Diego Gutierrez Coronel on 4/20/18.
//  Copyright © 2018 Diego Gutierrez Coronel. All rights reserved.
//

import Cocoa

class RootFindingMethods: NSObject {
    
    var functions = Functions()
    
    func CentralDifference(x: [Double], f: [Double], i: Int) -> Double{
        
        let h = x[i + 1] - x[i]
        
        return (f[i + 1] - f[i])/(2 * (h))
        
    }

    
    
    /// Calculates roots of bare criticality condition function
    ///
    ///
    /// - Parameters:
    ///   - Rmin and Rmax values: interval to look for roots
    ///   - transport_mfp: transport mean free path of core
    ///   - fission_mfp: transport mean free path of core
    ///   - secondary_n_per_fission: neutrons generated in fission
    ///   - dR: delta R
    /// - Returns: root
     func findRoot(Rmin: Double, Rmax: Double, dR: Double, transport_mfp: Double, fission_mfp: Double, secondary_n_per_fission: Double) -> Double{
     
     var root = 0.0
     var Ri = Rmin
     var functional_prime = 1.0
     var fadvance = 0.0
     var fdelay = 0.0
     var count = 0
     
     var root_fvalue = 1.0
     let h = 0.0001
     
     while (count <= 10){
     
     
     
     //// use newtons ranphson method
     //// First calculate the slope at Ri and then find Rf and then
     //// update condition for criticality and update
     
        fadvance = functions.Condition_Criticality_function(transport_mfp: transport_mfp, fission_mfp: fission_mfp, secondary_n_per_fission: secondary_n_per_fission, Radius_core: Ri + h)
        
     fdelay = functions.Condition_Criticality_function(transport_mfp: transport_mfp, fission_mfp: fission_mfp, secondary_n_per_fission: secondary_n_per_fission, Radius_core: Ri - h)
     functional_prime = (fadvance - fdelay)/(2.0 * h)
     
     /*CentralDifference(E: Ei, h: h, x_Values: x_Values, Potential_Values: Potential_Values, function: shoot.psi_at_boundary)*/
        root = Ri - functions.Condition_Criticality_function(transport_mfp: transport_mfp, fission_mfp: fission_mfp, secondary_n_per_fission: secondary_n_per_fission, Radius_core: Ri)/functional_prime
     
     root_fvalue = functions.Condition_Criticality_function(transport_mfp: transport_mfp, fission_mfp: fission_mfp, secondary_n_per_fission: secondary_n_per_fission, Radius_core: root)
     
        if(abs(root_fvalue) < 0.0001 && abs(Rmin - root) <= dR){
        
     return root
     
        }
     
     Ri = root
     count = count + 1
     }
     return 0.0
     
     
     }
    
    
    //Finds the root of the tampered configuration
    /// Calculates roots of bare criticality condition function
    ///
    ///
    /// - Parameters:
    ///   - Rmin and Rmax values: interval to look for roots
    ///   - transport_mfp: transport mean free path of core
    ///   - fission_mfp: transport mean free path of core
    ///   - tampered_transport_mfp: transport mean free path of tamper material
    /// epsilon_parameter: parameter for calculations found in functions class
    ///   - secondary_n_per_fission: neutrons generated in fission
    ///   - dR: delta R
    /// - Returns: root
    func findRoot_Tampered_Configuration(Rmin: Double, Rmax: Double, dR: Double, transport_mfp: Double, fission_mfp: Double,tampered_transport_mfp: Double, secondary_n_per_fission: Double, epsilon_parameter: Double, R_ratio: Double) -> Double{
        
        var root = 0.0
        var Ri = Rmin
        var functional_prime = 1.0
        var fadvance = 0.0
        var fdelay = 0.0
        var count = 0
        
        var root_fvalue = 1.0
        let h = 0.0001
        
        while (count <= 10){
            
            
            
            //// use newtons ranphson method
            //// First calculate the slope at Ei and then find Ef and then
            //// update PsiBoundary_Value and update
            
            fadvance = functions.Condition_Tampered_Criticality_function(transport_mfp: transport_mfp, fission_mfp: fission_mfp, tampered_transport_mfp: tampered_transport_mfp, secondary_n_per_fission: secondary_n_per_fission, epsilon_parameter: epsilon_parameter, Radius_core: Ri + h, R_ratio: R_ratio)
            
            fdelay = functions.Condition_Tampered_Criticality_function(transport_mfp: transport_mfp, fission_mfp: fission_mfp, tampered_transport_mfp: tampered_transport_mfp, secondary_n_per_fission: secondary_n_per_fission, epsilon_parameter: epsilon_parameter, Radius_core: Ri - h, R_ratio: R_ratio)
            functional_prime = (fadvance - fdelay)/(2.0 * h)
            
            /*CentralDifference(E: Ei, h: h, x_Values: x_Values, Potential_Values: Potential_Values, function: shoot.psi_at_boundary)*/
            root = Ri - functions.Condition_Tampered_Criticality_function(transport_mfp: transport_mfp, fission_mfp: fission_mfp, tampered_transport_mfp: tampered_transport_mfp, secondary_n_per_fission: secondary_n_per_fission, epsilon_parameter: epsilon_parameter, Radius_core: Ri, R_ratio: R_ratio)/functional_prime
            
            root_fvalue = functions.Condition_Tampered_Criticality_function(transport_mfp: transport_mfp, fission_mfp: fission_mfp, tampered_transport_mfp: tampered_transport_mfp, secondary_n_per_fission: secondary_n_per_fission, epsilon_parameter: epsilon_parameter, Radius_core: Ri, R_ratio: R_ratio)
            
            if(abs(root_fvalue) < 0.0001 && abs(Rmin - root) <= dR){
                
                return root
                
            }
            
            Ri = root
            count = count + 1
        }
        return 0.0
        
        
    }
    
    
    
    
    
    

}
