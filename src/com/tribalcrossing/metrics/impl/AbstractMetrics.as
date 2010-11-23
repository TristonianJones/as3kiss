/**
 * Copyright (c) 2010 Tribal Crossing. Some Rights Reserved
 *
 * Licensed under the CREATIVE COMMONS Attribution-Share Alike 3.0
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at: 
 *      http://creativecommons.org/licenses/by-sa/3.0/us/
 */
package com.tribalcrossing.metrics.impl
{
    import flash.net.URLVariables;

    /**
     * Base class for the Flex and Flash implementations of 
     * the KISS API
     * 
     * @author Tristan Swadell - tristan@tribalcrossing.com
     */
    public class AbstractMetrics
    {
        static protected const KISS_URL:String  = "http://trk.kissmetrics.com/";
        static protected const TRACK:String     = "e";
        static protected const SET:String       = "s";   
        static protected const ALIAS:String     = "a";
        static protected const KEY:String       = "_k";
        static protected const PERSON:String    = "_p";
        static protected const NAME:String      = "_n";
        static protected const DEBUG:String     = "_d";
        static protected const TIMESTAMP:String = "_t";
        static protected const RESERVED_WORDS:Array = [
            KEY, PERSON, NAME, DEBUG, TIMESTAMP
        ];
        
        static protected const IN_SECONDS:Number = 1/1000;
        
        protected var variables:URLVariables = new URLVariables();
        
        public function AbstractMetrics( key:String,
                                         debug:Boolean )
        {
            this.key = key;
            this.debug = debug;
        }
        
        /**
         * @inheritDoc 
         */
        public function get key() : String
        {
            return variables[KEY];
        }
        
        /**
         * @private      
         */        
        public function set key(value:String) : void
        {
            variables[KEY] = value;
        }
        
        /**
         * @inheritDoc 
         */
        public function get person() : String
        {
            return variables[PERSON];
        }
        
        /**
         * @private   
         */ 
        public function set person(value:String) : void
        {      
            variables[PERSON] = value;
        }      
        
        /**
         * @inheritDoc
         */
        public function get debug() : Boolean
        {
            return (variables[DEBUG] == 1);
        }
        
        /**
         * @private 
         */   
        public function set debug(value:Boolean) : void
        {
            variables[DEBUG] = (value) ? 1 : 0;
        }
        
        protected function kissAction( properties:Object,
                                       value:Object = null ) : URLVariables
        {
            // create a fresh set of url variables to store the request in                        
            var parameters:URLVariables = new URLVariables();   
            
            if (this.key)
            {
                // copy the existing parameters from the variables member 
                // and the input properties
                copy( variables,  parameters, true  );
                copy( properties, parameters, false );
                
                // if debugging set the timestamp
                if (value)      parameters[NAME]      = value;
                if (this.debug) parameters[TIMESTAMP] = utcSeconds;
            }
            else
            {
                throw new Error("[KissMetrics] API key not set");
            }
            
            return parameters;
        }

        private function copy( from:Object, 
                               to:Object, 
                               allowReserved:Boolean ) : void
        {
            if (from)
            {
                for (var propName:String in from)
                {
                    if (allowReserved || !isReserved(propName))
                    {
                        to[propName] = from[propName];
                    }  
                    else
                    {
                        throw new Error(
                            "[KissMetrics] Cannot send parameter with the reserved name: '" + propName
                        );
                    }
                }
            }
        }
        
        private function isReserved( propertyName:String ) : Boolean
        {
            return (RESERVED_WORDS.indexOf(propertyName) >= 0);
        }
        
        private function utcSeconds() : Number
        {
            return (new Date()).getTime() * IN_SECONDS;
        }
    }
}