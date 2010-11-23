/**
 * Copyright (c) 2010 Tribal Crossing. Some Rights Reserved
 *
 * Licensed under the CREATIVE COMMONS Attribution-Share Alike 3.0
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at: 
 *      http://creativecommons.org/licenses/by-sa/3.0/us/
 */
package com.tribalcrossing.metrics
{   
    /**
     * A convenience method to send an event to KISS. You will need to set
     * the KISS API Key and person you're trying to track before calling
     * this method.  
     *  
     * @param event Descriptive event
     * @param properties Optional key-value pairs to be associated
     *      with the event.
     * 
     * @see com.tribalcrossing.metrics.IKissMetrics 
     * @see com.tribalcrossing.metrics.KissMetrics 
     */
    public function track( event:String, properties:Object = null ) : void
    {
        var metrics:IKissMetrics = KissMetrics.getInstance();
        metrics.track( event, properties );
    }
}