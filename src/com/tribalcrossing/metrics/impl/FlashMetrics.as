/**
 * Copyright (c) 2010 Tribal Crossing. All Rights Reserved
 *
 * Licensed under the CREATIVE COMMONS Attribution-Share Alike 3.0
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at: 
 *      http://creativecommons.org/licenses/by-sa/3.0/us/
 */
package com.tribalcrossing.metrics.impl
{
    import com.tribalcrossing.metrics.IKissMetrics;
    import com.tribalcrossing.services.RestCall;
    import com.tribalcrossing.services.RestCallQueue;
    
    /**
     * A simple class for making KISS API calls. 
     * This implementation is intended to be used in Flash projects
     * 
     * @example Common usage
     * <listing version="3.0">
     * // setup
     * KissMetrics.setFactory( FlashMetrics, "kissApiKey" );
     * var kiss:IKissMetrics = KissMetrics.getInstance();
     * kiss.person = "myid";
     * 
     * // recording metrics
     * kiss.track( "event 1" );
     * kiss.track( "event 2", {gender:"male"} );
     * </listing>
     * 
     * @author Tristan Swadell - tristan@tribalcrossing.com
     */
    public class FlashMetrics extends AbstractMetrics implements IKissMetrics
    {
        private var service:RestCallQueue = new RestCallQueue();
        
        public function FlashMetrics( key:String = null,
                                      debug:Boolean = false ) 
        {
            super( key, debug );            
        }
            
        /**
         * @inheritDoc
         */        
        public function track( event:String, properties:Object = null ) : void
        {
            service.send( 
                getRequest( TRACK ).params( 
                    kissAction( properties, event ) 
                ) 
            );
        }
        
        /**
         * @inheritDoc
         */        
        public function alias( alias:String, properties:Object = null ) : void
        {
            service.send( 
                getRequest( ALIAS ).params( 
                    kissAction(properties, alias) 
                ) 
            );
        }
        
        /**
         * @inheritDoc
         */        
        public function set( properties:Object ) : void
        {
            service.send( 
                getRequest( SET ).params( 
                    kissAction(properties) 
                ) 
            );
        }
        
        private function getRequest( path:String ) : RestCall
        {            
            // construct a URLRequest for making the call
            var request:RestCall = new RestCall();            
            return request.get( KISS_URL + path );
        }
    }    
}