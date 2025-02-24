# UDP flood
```bash
docker exec -it kali /kali/scripts/udp_flood.sh
```
![UDP flood](image.png)
- kali CPU usage is much higher than nginx
- Network load is equal for kali and nginx (126k packets/sec)
- UDP ports were opened in docker image
- Limiting nginx container to 10% didn't make problem
- Seems like single machine can't make DDoS of this kind


# ICMP flood
```bash
docker compose exec kali bash -c "ping web"

    PING web (172.26.0.5) 56(84) bytes of data.
    64 bytes from web.prctr-hsa-hw16_network1 (172.26.0.5): icmp_seq=1 ttl=64 time=0.075 ms
    64 bytes from web.prctr-hsa-hw16_network1 (172.26.0.5): icmp_seq=2 ttl=64 time=0.092 ms
```

```bash
docker-compose exec --user root web sh -c "iptables -A INPUT -p icmp --icmp-type echo-request -j DROP"
docker-compose exec --user root web sh -c "iptables -L -v -n"

    Chain INPUT (policy ACCEPT 6 packets, 419 bytes)
    pkts bytes target     prot opt in     out     source               destination
        0     0 DROP       icmp --  *      *       0.0.0.0/0            0.0.0.0/0            icmptype 8

    Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
    pkts bytes target     prot opt in     out     source               destination

    Chain OUTPUT (policy ACCEPT 4 packets, 524 bytes)
    pkts bytes target     prot opt in     out     source               destination
```

```bash
docker compose exec kali bash -c "ping web"
    PING web (172.26.0.5) 56(84) bytes of data.
```

- ICMP flood makes no effect on the target

![ICMP flood](image-1.png)

# HTTP flood
- HTTP flood actually made the site unavaialble
- applying the following protection made target partially avaialble, defenitely increased the number of successfull client requets but fail requests were still present.
```
    limit_conn_zone $binary_remote_addr zone=addr:10m;
    limit_req_zone $binary_remote_addr zone=req:10m rate=5r/s;

    limit_conn addr 10;
    limit_req zone=req burst=5 nodelay;
```
- error from blocked requests were written into the log taking resources, that made some legit client requests fail. Changing logging settings helped:
```
    # Set log level to warn to avoid logging blocked requests
    limit_conn_log_level warn;
    limit_conn_log_level warn;
    
    error_page 503 = @limit_req;

    location @limit_req {
        internal;
        access_log off;
        return 503;
    }
```
- at the beginning of the attack resource was unavaialble for a short period of time regardles of all the protection.
![alt text](image-2.png)


# slowloris
- slowloris worked
- adding the following protection made target partially avaialble, defenitely increased the number of successfull client requets but fail requests were still present.
```
    client_body_timeout 2s;
    client_header_timeout 1s;
    keepalive_timeout 2s 2s;
    send_timeout 2s;
```
- in addition to the limits above we need to reduce logging of the failed requests, otherwisew it saturates resources anyway:
```
    map $status $loggable {
        default 1;
        408     0;  # Do not log 408 status codes
    }
    access_log /var/log/nginx/access.log combined if=$loggable;
```
- only after applying limits AND reducing logging nginx was able to serve clients while being attacked.
![alt text](image-3.png)


# SYN flood
- Didn't affect the target


# Ping of Death
- Ping of Death made no affect
