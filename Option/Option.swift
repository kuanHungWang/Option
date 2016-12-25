//
//  File.swift
//  BSOption
//
//  Created by K.H.Wang on 2016/12/10.
//  Copyright © 2016年 KH. All rights reserved.
//

import Foundation

/**
 The root finding method for implied volatility.
 -  return:
 The root of the function to find
 -  parameters:
    - lowerLimit: the lower initial guess
    - upperLimit: the upper initial guess
    - f: the block representing the function
    - errorTolL error tollorence
    - maxiter: max number of trying
 */
func brentMethod(lowerLimit:Double, upperLimit:Double, f:(Double)->Double, errorTol:Double,maxiter:Int)->Double{
    var a=lowerLimit
    var b=upperLimit
    var c:Double=0.0
    var d:Double = DBL_MAX
    var fa = f(a)
    var fb = f(b)
    var fc:Double=0
    var s:Double=0
    var fs:Double=0
    // if f(a) f(b) >= 0 then error-exit
    if fa*fb>=0 {
        if (fa < fb){
            print("fa=\(fa)")
            print("fb=\(fb)")
            
            return a;
        }else{
            print("fa=\(fa)")
            print("fb=\(fb)")
            
            return b;
        }
    }
    // if |f(a)| < |f(b)| then swap (a,b) end if
    if fabs(fa) < fabs(fb) {
        var temp=a
        a=b
        b=temp
        temp=fa
        fa=fb
        fb=temp
    }
    c=a
    fc=fa
    var mflag=true
    var i=0
    
    
    
    while !(fb==0) && (fabs(a-b) > errorTol){
        if (fa != fc) && (fb != fc) {
            // Inverse quadratic interpolation
            s = a * fb * fc / (fa - fb) / (fa - fc) + b * fa * fc / (fb - fa) / (fb - fc) + c * fa * fb / (fc - fa) / (fc - fb)
            
        }else{
            // Secant Rule
            s = b - fb * (b - a) / (fb - fa)
        }
        var tmp2 = (3 * a + b) / 4
        
        if (!(((s > tmp2) && (s < b)) || ((s < tmp2) && (s > b)))) ||
            (mflag && (fabs(s - b) >= (fabs(b - c) / 2))) ||
            (!mflag && (fabs(s - b) >= (fabs(c - d) / 2))) {
            s = (a + b) / 2
            mflag=true
        }else{
            if (mflag && (fabs(b - c) < errorTol)) || (!mflag && (fabs(c - d) < errorTol))
            {
                s = (a + b) / 2
                mflag = true
            }else{
                mflag = false
            }
        }
        fs=f(s)
        d = c
        c = b
        fc = fb
        if fa * fs < 0 {
            b = s
            fb = fs
        }else {
            a = s
            fa = fs
        }
        // if |f(a)| < |f(b)| then swap (a,b) end if
        if fabs(fa) < fabs(fb){
            var tmp = a
            a = b
            b = tmp
            tmp = fa
            fa = fb
            fb = tmp
        }
        i+=1
        if (i > maxiter){
            print("Error is\(fb) \n");
            break
        }
    }
    print("number of iteration: \(i)")
    return b
}

public func normalDistribution(x: Double, μ: Double = 0, σ: Double = 1) -> Double {
    //if σ <= 0 { return nil }
    let z = (x - μ) / σ
    return  0.5 * erfc(-z * M_SQRT1_2)
}
public func normalDensity(x: Double, μ: Double = 0, σ: Double = 1) -> Double  {
    //if σ <= 0 { return nil }
    return (1 / sqrt(2 * pow(σ,2) * M_PI)) * pow(M_E, (-( pow(x - μ, 2) / (2 * pow(σ, 2)) )))
}

private func D1(type:OptionType,tenor:Double, strike:Double, underlying:Double, sigma:Double, interestRate:Double)->Double{
    return (log(underlying/strike)+(interestRate+pow(sigma,2.0)/2.0)*tenor)/(sigma*sqrt(tenor))
}


public enum OptionType{
    case Call
    case Put
}

public class Option{
    //MARK type method:
    /**
     The black-scholes price of a vanilla option with its parameters
     -  return:
     The black-scholes price of a vanilla option:
     -  parameters:
     - tenor: tenor(year) of the option
     - strike: strike price of the option
     - underlying: underlying price
     - sigma: volatility of the option
     - interestRate: interestRate of the option
     */
    public static func vanilla(type:OptionType,tenor:Double, strike:Double, underlying:Double, sigma:Double, interestRate:Double)->Double{
        let d1=(log(underlying/strike)+(interestRate+pow(sigma,2.0)/2.0)*tenor)/(sigma*sqrt(tenor))
        let d2=d1-sigma*sqrt(tenor)
        if type==OptionType.Call {
            let call=normalDistribution(x: d1)*underlying - normalDistribution(x: d2)*strike*exp(-1*interestRate*tenor)
            return call
        }else{
            let put = normalDistribution(x: -1*d2)*strike*exp(-1*interestRate*tenor) - normalDistribution(x: -1*d1)*underlying
            return put
        }
        
    }
    /**
     The delta a vanilla option.
     -  return:
        The delta a vanilla option.
     -  parameters:
     - tenor: tenor(year) of the option
     - strike: strike price of the option
     - underlying: underlying price
     - sigma: volatility of the option
     - interestRate: interestRate of the option
     */
    public static func delta(type:OptionType,tenor:Double, strike:Double, underlying:Double, sigma:Double, interestRate:Double)->Double{
        let d1:Double = D1(type:type,tenor:tenor, strike:strike, underlying:underlying, sigma:sigma, interestRate:interestRate)
        if type == OptionType.Call {
            return normalDistribution(x: d1)
        }else{
            return normalDistribution(x: d1)-1.0
        }
    }
    /**
     The gamma a vanilla option.
     -  return:
     The gamma a vanilla option.
     -  parameters:
     - tenor: tenor(year) of the option
     - strike: strike price of the option
     - underlying: underlying price
     - sigma: volatility of the option
     - interestRate: interestRate of the option
     */
    public static func gamma(type:OptionType,tenor:Double, strike:Double, underlying:Double, sigma:Double, interestRate:Double)->Double{
        let d1:Double = D1(type: type, tenor: tenor, strike: strike, underlying: underlying, sigma: sigma, interestRate: interestRate)
        return normalDensity(x: d1)/(underlying*sigma*sqrt(tenor))
    }
    /**
     The vega a vanilla option.
     -  return:
     The vega a vanilla option.
     -  parameters:
     - tenor: tenor(year) of the option
     - strike: strike price of the option
     - underlying: underlying price
     - sigma: volatility of the option
     - interestRate: interestRate of the option
     */
    public static func vega(type:OptionType,tenor:Double, strike:Double, underlying:Double, sigma:Double, interestRate:Double)->Double{
        let d1:Double = D1(type: type, tenor: tenor, strike: strike, underlying: underlying, sigma: sigma, interestRate: interestRate)
        return underlying * normalDensity(x: d1)*sqrt(tenor)
    }
    /**
     The theta a vanilla option.
     -  return:
     The theta a vanilla option.
     -  parameters:
     - tenor: tenor(year) of the option
     - strike: strike price of the option
     - underlying: underlying price
     - sigma: volatility of the option
     - interestRate: interestRate of the option
     */
    public static func theta(type:OptionType,tenor:Double, strike:Double, underlying:Double, sigma:Double, interestRate:Double)->Double{
        let d1:Double = D1(type: type, tenor: tenor, strike: strike, underlying: underlying, sigma: sigma, interestRate: interestRate)
        let d2=d1-sigma*sqrt(tenor)
        let FirstPart:Double = underlying * normalDensity(x: d1) * sigma / (2*sqrt(tenor))
        let SecondPart:Double = interestRate * strike * exp(-1*interestRate*tenor) * normalDistribution(x: d2)
        if type==OptionType.Call {
            return -1 * FirstPart - SecondPart
        }else{
            return -1 * FirstPart + SecondPart
        }
    }
    /**
     The rho a vanilla option.
     -  return:
     The rho a vanilla option.
     -  parameters:
     - tenor: tenor(year) of the option
     - strike: strike price of the option
     - underlying: underlying price
     - sigma: volatility of the option
     - interestRate: interestRate of the option
     */
    public static func rho(type:OptionType,tenor:Double, strike:Double, underlying:Double, sigma:Double, interestRate:Double)->Double{
        let d1:Double = D1(type: type, tenor: tenor, strike: strike, underlying: underlying, sigma: sigma, interestRate: interestRate)
        let d2=d1-sigma*sqrt(tenor)
        if type==OptionType.Call {
            return strike * tenor * exp(-1*interestRate*tenor)*normalDistribution(x: d2)
        }else{
            return -1 * strike * tenor * exp(-1*interestRate*tenor)*normalDistribution(x: -1*d2)
        }
    }
   
    
    public var type:OptionType
    public var Expire:Date
    public var strike:Double
    public var underlying:Double
    public var interestRate:Double
    // value date by default is today.
    public var valueDate:Date=Date()
    // when the price is changed, the volatility will recalculate.
    public var price:Double{
        didSet{
            self._volatility=IV(price: self.price)
        }
    }
    // the internal property to store calculated implied volatility, by default is nil, and after the first time calculation of implied vol, the value will be stored.
    private var _volatility:Double?
    /**
     // the implied volatilit of the option. If the implied volatility has never been calculated before, it call the IV() method and store it to _volatility and return the value. Otherwise return the _volatility.

     */
    public var volatility:Double{
        get{
            if let v:Double=self._volatility {
                return v
            }else{
                let v=self.IV(price: self.price)
                self._volatility=v
                return v
            }
        }
    }

    public init(price:Double, expire:Date, strike:Double, type:OptionType, underlying:Double, interestRate:Double){
        self.price=price
        self.Expire=expire
        self.strike=strike
        self.type=type
        self.underlying=underlying
        self.interestRate=interestRate
    }
    /**
     The tenor a the option.
     -  return:
     The tenor a the option.
     */
    public func tenor()->Double{
        return self.Expire.timeIntervalSince(self.valueDate)/365/24/60/60
    }
    /**
     The price a the option with overriden strike value, other properties remain the same.
     -  return:
     The price a the option.
     -  parameters:
     - strike: strike price of the option
     */
    public func price(overrideStrike strike:Double)->Double{
        let tenor=self.tenor()
        return Option.vanilla(type: self.type, tenor: tenor, strike: strike, underlying: self.underlying, sigma: self.volatility, interestRate: self.interestRate)
    }
    /**
     The price a the option with overriden value date, other properties remain the same.
     -  return:
     The price a the option.
     -  parameters:
     - date: the overriden date.
     */
    public func price(overrideValueDate date:Date)->Double{
        let tenor=self.Expire.timeIntervalSince(date)/365/24/60/60
        return Option.vanilla(type: self.type, tenor: tenor, strike: self.strike, underlying: self.underlying, sigma: self.volatility, interestRate: self.interestRate)
    }
    /**
     The price a the option with overriden underlying, other properties remain the same.
     -  return:
     The price a the option.
     -  parameters:
     - underlying: the overriden underlying.
     */
    public func price(overrideUnderlying underlying:Double)->Double{
        let tenor=self.tenor()
        return Option.vanilla(type: self.type, tenor: tenor, strike: self.strike, underlying: underlying, sigma: self.volatility, interestRate: self.interestRate)
    }
    /**
     The price a the option with overriden volatility, other properties remain the same.
     -  return:
     The price a the option.
     -  parameters:
     - volatility: the overriden volatility.
     */
    public func price(overrideVolatility volatility:Double)->Double{
        let tenor=self.tenor()
        return Option.vanilla(type: self.type, tenor: tenor, strike: self.strike, underlying: self.underlying, sigma: volatility, interestRate: self.interestRate)
    }
    /**
     The price a the option with overriden arguments in a dictionary, other properties remain the same. the keys of strings are: "type", "strike", "underlying", "volatility", "interestRate", "valueDate".
     -  return:
     The price a the option.
     -  parameters:
     - arguments: the dictionary cotaining what to override.
     */
    public func price(override arguments:[String:Any])->Double{
        var type:OptionType = self.type
        if let override=arguments["type"]{
            type=override as! OptionType
        }
        var strike:Double = self.strike
        if let override=arguments["strike"]{
            strike=override as! Double
        }
        var underlying:Double = self.underlying
        if let override=arguments["underlying"]{
            underlying=override as! Double
        }
        var volatility:Double = self.volatility
        if let override=arguments["volatility"]{
            volatility=override as! Double
        }
        var interestRate:Double = self.interestRate
        if let override=arguments["interestRate"]{
            interestRate=override as! Double
        }
        var valueDate:Date = self.valueDate
        if let override=arguments["valueDate"]{
            valueDate=override as! Date
        }
        return Option.vanilla(type: type, tenor: self.Expire.timeIntervalSince(valueDate), strike: strike, underlying: underlying, sigma: volatility, interestRate: interestRate)
    }
    
    private func IV(price:Double)->Double{
        let BSfunction={(x:Double)->Double in
            let tenor=self.tenor()
            let calculatedPrice = Option.vanilla(type: self.type, tenor: tenor, strike: self.strike, underlying: self.underlying, sigma: x, interestRate: self.interestRate)
            return calculatedPrice-self.price
        }
        let vol=brentMethod(lowerLimit: 0.001, upperLimit: 2, f: BSfunction, errorTol: 0.0001, maxiter: 100)
        return  vol
    }

    // MARK: greeks
    /**
     The delta a the option.
     -  return:
     The delta a the option.
     */
    public func delta()->Double{
        return Option.delta(type: self.type, tenor: self.tenor(), strike: self.strike, underlying: self.underlying, sigma: self.volatility, interestRate: self.interestRate)
    }
    /**
     The gamma a the option.
     -  return:
     The gamma a the option.
     */
    public func gamma()->Double{
        return Option.gamma(type: self.type, tenor: self.tenor(), strike: self.strike, underlying: self.underlying, sigma: self.volatility, interestRate: self.interestRate)
    }
    /**
     The vega a the option.
     -  return:
     The vega a the option.
     */
    public func vega()->Double{
        return Option.vega(type: self.type, tenor: self.tenor(), strike: self.strike, underlying: self.underlying, sigma: self.volatility, interestRate: self.interestRate)
    }
    /**
     The theta a the option.
     -  return:
     The theta a the option.
     */
    public func theta()->Double{
        return Option.theta(type: self.type, tenor: self.tenor(), strike: self.strike, underlying: self.underlying, sigma: self.volatility, interestRate: self.interestRate)
    }
    /**
     The rho a the option.
     -  return:
     The rho a the option.
     */
    public func rho()->Double{
        return Option.rho(type: self.type, tenor: self.tenor(), strike: self.strike, underlying: self.underlying, sigma: self.volatility, interestRate: self.interestRate)
    }
}
