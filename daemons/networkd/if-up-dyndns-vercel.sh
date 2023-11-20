#!/bin/bash

IP=$(dig TXT +short o-o.myaddr.l.google.com @ns1.google.com | awk -F'"' '{ print $2}')
vercel dns add georgesplancke.com ssh A "${IP}" > /dev/null 2>&1 
vercel dns add georgesplancke.com lab A "${IP}" > /dev/null 2>&1
