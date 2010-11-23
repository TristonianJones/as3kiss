/**
 * Copyright (c) 2010 Tribal Crossing. Some Rights Reserved
 *
 * Licensed under the CREATIVE COMMONS Attribution-Share Alike 3.0
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at: 
 *      http://creativecommons.org/licenses/by-sa/3.0/us/
 */
package com.tribalcrossing.metrics.impl {    
    
    import com.tribalcrossing.metrics.IKissMetrics;
    
    import mx.rpc.http.HTTPMultiService;
    import mx.rpc.http.Operation;
    import mx.rpc.mxml.Concurrency;

    /**
     * A simple class for making KISS API calls. 
     * This implementation is intended to be used in Flex projects
     * 
     * @example Common usage
     * <listing version="3.0"> 
     * // setup
     * KissMetrics.setFactory( FlexMetrics, "kissApiKey" );
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
    public class FlexMetrics extends AbstractMetrics implements IKissMetrics
    {
        private var service:HTTPMultiService;
        
        public function FlexMetrics( key:String = null,
                                     debug:Boolean = false ) 
        {
            super( key, debug );
            
            this.service = new HTTPMultiService( KISS_URL );
            this.service.concurrency = Concurrency.SINGLE;
            this.service.makeObjectsBindable = false;
            this.service.resultFormat = "text";
            
            this.service.operationList = [
                kissOperation( TRACK ), 
                kissOperation( ALIAS ), 
                kissOperation( SET )
            ];
        }
   
        /**
         * @inheritDoc
         */        
        public function track( event:String, properties:Object = null ) : void
        {
            service.getOperation( TRACK ).send( 
                kissAction(properties, event) 
            ); 
        }
        
        /**
         * @inheritDoc
         */        
        public function alias( alias:String, properties:Object = null ) : void
        {
            service.getOperation( ALIAS ).send(
                kissAction(properties, alias)
            );
        }
                
        /**
         * @inheritDoc
         */        
        public function set( properties:Object ) : void
        {
            service.getOperation( SET ).send( 
                kissAction(properties) 
            ); 
        }                
       
        // create an operation that can be used with the HTTPMultiService object
        private function kissOperation( name:String ) : Operation
        {
            var op:Operation = new Operation();
            op.name = name;
            op.url = name;
            op.makeObjectsBindable = false;
            op.concurrency = Concurrency.SINGLE;
            op.resultFormat = "text";
            return op;
        }               
    }    
}