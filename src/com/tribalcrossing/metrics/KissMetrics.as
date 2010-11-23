/**
 * Copyright (c) 2010 Tribal Crossing. All Rights Reserved
 *
 * Licensed under the CREATIVE COMMONS Attribution-Share Alike 3.0
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at: 
 *      http://creativecommons.org/licenses/by-sa/3.0/us/
 */
package com.tribalcrossing.metrics
{
    /**
     * A helper class designed to help ease the burden of setting
     * up the appropriate metrics class for your project.
     * 
     * @example Common Usage
     * <listing version="3.0">
     * KissMetrics.setFactory( FlashMetrics, "kissApiKey", "myId" );
     * var kiss:IKissMetrics = KissMetrics.getInstance();
     * kiss.track("loaded game");
     * </listing>
     * 
     * @author Tristan Swadell - tristan@tribalcrossing.com
     */
    public class KissMetrics
    {
        private static var kiss:IKissMetrics;
        private static var kissKey:String;
        private static var kissPerson:String;
        private static var KissInstance:Class;
        
        public function KissMetrics()
        {
        }
        
        static public function setFactory( factory:Class,
                                           apiKey:String = null,
                                           person:String = null ) : void
        {
            kissKey = apiKey;
            kissPerson = person;
            KissInstance = factory;
        }
        
        static public function getInstance() : IKissMetrics
        {
           if (!kiss) 
           {
               if (!kissKey && !KissInstance)
               {
                   throw new Error(
                       "[Metrics] IKissMetrics class or kiss API key not set via setFactory() method"
                   );
               }
               kiss = new KissInstance( kissKey ) as IKissMetrics;
               kiss.person = kissPerson;
           }
           return kiss;
        }
    }
}