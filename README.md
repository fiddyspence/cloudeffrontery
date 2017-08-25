# Gem to download and parse AWS or Azure CDN ranges

[![Build Status](https://travis-ci.org/fiddyspence/cloudeffrontery.png?branch=master)](https://travis-ci.org/fiddyspence/cloudeffrontery)

Use the cloudeffrontery program to output them into nginx or Apache to allow real remote IPs to be reflected in the log

```
Usage: cloudeffrontery [options]
    -c, --cloud CLOUD                Which cloud - aws or azure (default: aws)
    -s, --service SERVICE            Which service (only applies to Amazon) (default: CLOUDFRONT)
    -d, --debug                      Some debug
    -a, --action ACTION              What to output - nginx, apache or print (an array of addresses) (default: nginx)
    -r, --region REGION              Which region (only applies to Amazon) (default: .*)
    -u, --url URL                    Custom URL to download the source from
```

```
cloudeffrontery -u https://ibroketheinternet.co.uk/ipsv4 -c azure -a print
["103.21.244.0/22", "103.22.200.0/22", "103.31.4.0/22", "104.16.0.0/12", "108.162.192.0/18", "131.0.72.0/22", "141.101.64.0/18", "162.158.0.0/15", "172.64.0.0/13", "173.245.48.0/20", "188.114.96.0/20", "190.93.240.0/20", "197.234.240.0/22", "198.41.128.0/17"]
```


