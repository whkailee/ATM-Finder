//
//  ASBBaseModelExtensions.swift
//  ASBMobile
//
//  Created by Rhys Walden on 26/06/15.
//  Copyright (c) 2015 ASB. All rights reserved.
//

import Foundation


public class BaseModelHelper<T: BaseModel>
{
    class func transformToArrayFromValue(value:AnyObject?) -> (succeeded:Bool, result:Array<T>)
    {
        var succeeded = false;
        var result: Array<T> = Array<T>();
        
        
        if let odjcArray = value as? NSArray!
        {
            for valueMember in odjcArray
            {
                let member = valueMember as! [NSObject : AnyObject];
                
                let obj = T.instanceFromDictionary(member);
                
                //var obj = T()
                //obj.setAttributesFromDictionary(member);
                
                result.append(obj)
            }
            succeeded = true;
        }
        
        return (succeeded:succeeded, result:result);
    }
}

