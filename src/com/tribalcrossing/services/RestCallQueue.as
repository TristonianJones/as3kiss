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
    /**
     * @author Tristan Swadell - tristan@tribalcrossing.com
     * 
     * This class queues RestCall instances and executes them
     * one at a time.  
     */
    public class RestCallQueue
    {     
        private var head:QueuedRequest;
        private var tail:QueuedRequest;
        
        public function RestCallQueue()
        {
        }
        
        /**
         * Queue a RestCall instance.  If there are no calls on
         * the queue, then start the RestCall immediately. 
         * 
         * @param call RestCall instance to be queued.
         * @return RestCall instance that was added to the queue.
         * 
         * @see com.tribalcrossing.services.RestCall
         */        
        public function send( call:RestCall ) : RestCall
        {
            var node:QueuedRequest = new QueuedRequest();
            node.call = call.onComplete( executeNext );
            
            if (!head)
            {
                head = node;
                tail = node;
                call.execute();
            }
            else
            {
                tail.next = node;
                tail = node;
            }
            
            return call;
        }
        
        private function executeNext() : void
        {
            var node:QueuedRequest = head;
            head = head.next;
            if (head)
            {
                head.call.execute();
            }
            else
            {
                head = null;
                tail = null;
            }
        }
    }
}
import com.tribalcrossing.services.RestCall;

internal class QueuedRequest
{
    public var next:QueuedRequest;
    public var call:RestCall;
}