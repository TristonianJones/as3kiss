/**
 * Copyright (c) 2010 Tribal Crossing. Some Rights Reserved
 *
 * Licensed under the CREATIVE COMMONS Attribution-Share Alike 3.0
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at: 
 *      http://creativecommons.org/licenses/by-sa/3.0/us/
 */
package com.tribalcrossing.services
{
    import flash.events.ErrorEvent;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.net.URLVariables;
    
    /**
     * A command object capable of performing a GET or POST against
     * a RESTful service.  Best if used in conjunction with RestCallQueue.
     * 
     * @author Tristan Swadell - tristan@tribalcrossing.com 
     */
    public class RestCall
    {
        private var _request:URLRequest;
        private var _result:Function;
        private var _fault:Function;
        private var _loader:URLLoader;
        private var _dataFormat:String = URLLoaderDataFormat.TEXT;
        private var _complete:Function;
        
        /**
         * Create a RestCall  
         * 
         * @param request Optional URLRequest to be sent to the RESTful endpoint
         */        
        public function RestCall( request:URLRequest = null )
        {
            this._request = request;
        }
        
        /**
         * @private
         */
        protected function destroy() : void
        {
            this._loader.removeEventListener(
                Event.COMPLETE, successHandler
            );
            this._loader.removeEventListener(
                IOErrorEvent.IO_ERROR, faultHandler
            );
            this._loader.removeEventListener(
                SecurityErrorEvent.SECURITY_ERROR, faultHandler
            );
            
            this._loader = null;
            this._request = null;
            this._result = null;
            this._fault = null;
            this._pages = null;
            this._dataFormat = null;
            
            var finished:Function = _complete;
            this._complete = null;
            
            if (finished != null)
            {
                finished();
            }
        }        

        /**
         * Configure a GET call against the optional url.  
         * 
         * @param name Url endpoint of the RESTful service. If not specified
         *   the URLRequest passed into the constructor will be used.
         *  
         * @return RestCall instance for call chaining 
         */        
        public function get( name:String = null ) : RestCall
        {
            this.setUrl( name ).method = URLRequestMethod.GET; 
            return this;
        }
        
        /**
         * Configure a POST call against the optional url.
         * 
         * @param name Url endpoint of the RESTful service. If not specified
         *   the URLRequest passed into the constructor will be used.
         * 
         * @return RestCall instance for call chaining 
         */        
        public function post( name:String = null ) : RestCall
        {
            this.setUrl( name ).method = URLRequestMethod.POST; 
            return this;            
        }

        /**
         * Specify a set of parameters to send with the request
         * 
         * @param parameters A set of key-value pairs to send with the request.
         * URLVariables, Objects, and Strings (in FlashVars format) are all
         * acceptable inputs
         * 
         * @return RestCall instance for call chaining
         */        
        public function params( parameters:Object ) : RestCall
        {
            var variables:URLVariables;
            if (parameters is URLVariables)
            {
                variables = parameters as URLVariables;
            }
            else if (parameters is String)
            {
                variables = new URLVariables(parameters as String);
            }
            else
            {
                variables = new URLVariables();
                for (var property:String in parameters)                    
                {
                    variables[property] = parameters[property];
                }
            }
            
            if (!_request)
            {
                this._request = new URLRequest();
            }
            this._request.data = variables;
            return this;
        }
        
        /**
         * @private
         */        
        public function set dataFormat(value:String) : void
        {
            this._dataFormat = value;
        }
        
        /**
         * The expected dataFormat.  
         * 
         * @default text
         * @see flash.net.URLLoaderDataFormat
         */
        public function get dataFormat() : String
        {
            return this._dataFormat;
        }
        
        /**
         * Execute the request
         *  
         * @return RestCall for call chaining 
         */        
        public function execute() : RestCall
        {
            this._loader = new URLLoader();
            this._loader.addEventListener(
                Event.COMPLETE, successHandler
            );
            this._loader.addEventListener(
                IOErrorEvent.IO_ERROR, faultHandler
            );
            this._loader.addEventListener(
                SecurityErrorEvent.SECURITY_ERROR, faultHandler
            );
            
            if (_dataFormat)
            {
                this._loader.dataFormat = _dataFormat;
            }
            
            this._loader.load( _request );
            
            return this;
        }
        
        /**
         * Add a result callback to this RestCall. The callback must expect
         * to receive the body of the HTTP response.  Typically text data.
         *  
         * @return RestCall for call chaining 
         */       
        public function onResult(value:Function) : RestCall
        {
            _result = value;
            return this;
        }
        
        /**
         * @private
         */
        protected function successHandler(event:Event) : void
        {            
            if (_result != null)
            {
                var data:Object = _loader.data;
                this._result(data);
            }
            this.destroy();
        }
        
        /**
         * Add a fault callback to this RestCall. The callback must expect
         * to receive the error event of the HTTP fault. 
         *  
         * @return RestCall for call chaining 
         */       
        public function onFault(value:Function) : RestCall
        {
            _fault = value;
            return this;
        }
        
        /**
         * @private
         */
        protected function faultHandler(event:Event) : void
        {
            if (event is ErrorEvent)
            {
                trace(ErrorEvent(event).text);
            }
            if (_fault != null)
            {
                _fault(event);
            }
            this.destroy();
        }
        
        /**
         * @private
         */
        internal function onComplete( value:Function ) : RestCall
        {
            _complete = value;
            return this;
        }
        
        private function setUrl( name:String ) : URLRequest
        {
            if (name)
            {
                if (_request)
                {
                    this._request.url = name;
                }
                else
                {
                    this._request = new URLRequest(name);
                }
            }
            return this._request;
        }        
    }    
}