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
     * A common interface for the KISS Metrics Client implementations included 
     * in this package. 
     * 
     * @author Tristan Swadell - tristan@tribalcrossing.com
     */
    public interface IKissMetrics
    {
        /**
         * The KISS API key. This must be the first attribute set,
         * preferably in the constructor if using dependency injection. 
         */        
        function get key() : String;
        
        function set key(value:String) : void;

        /**
         * The id of the person who's actions are being tracked.
         * Similar to the "identify" method provided in the KISS JS API,
         * although no calls are made to alias the person to an anonymous id.
         * To alias an anonymous id, please refer to the "alias" method.  
         */        
        function get person() : String;
        
        function set person(value:String) : void;
        
        /**
         * Whether the KISS calls are being debugged.  If true, 
         * then a timestamp will be added to each recorded action.
         */ 
        function get debug() : Boolean;
        
        function set debug(value:Boolean) : void;
        
        /**
         * Record an event for the user.  Optionally, you may send key-value
         * pairs to be associated with the event.
         * 
         * @param event String description of what you want to track. 
         * @param properties Optional key-value pairs to be associated
         *  with the event.
         */        
        function track( event:String, properties:Object = null ) : void;
        
        /**
         * Associate two user ids together.  The id set in the person attribute
         * and the alias.
         * 
         * @param alias String id to alias with the current user. 
         * @param properties Optional key-value pairs to be associated
         *  with the person/alias.
         */        
        function alias( name:String, properties:Object = null ) : void;
        
        /**
         * Set a group of properties on the current person being tracked.
         * 
         * @param properties Key-value pairs to be associated
         *  with the current person being tracked.
         */        
        function set( properties:Object ) : void;
    }
}