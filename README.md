# Implement image caching and purging

## Bring the environment up
>$ docker-compose up --build

## Test result
```bash
docker-compose exec test sh /scripts/test_web-proxy.sh
```
```text
First request:
HTTP/1.1 200 OK
Accept-Ranges: bytes
Connection: keep-alive
Content-Length: 243553
Content-Type: image/jpeg
Date: Mon, 20 Jan 2025 03:53:30 GMT
ETag: "6788873d-3b761"
Last-Modified: Thu, 16 Jan 2025 04:12:45 GMT
Server: nginx/1.25.3
X-Cache-Status: MISS
X-Debug-Cache-Key: http://web-proxy/images/img1.jpg


Second request:
HTTP/1.1 200 OK
Accept-Ranges: bytes
Connection: keep-alive
Content-Length: 243553
Content-Type: image/jpeg
Date: Mon, 20 Jan 2025 03:53:30 GMT
ETag: "6788873d-3b761"
Last-Modified: Thu, 16 Jan 2025 04:12:45 GMT
Server: nginx/1.25.3
X-Cache-Status: MISS
X-Debug-Cache-Key: http://web-proxy/images/img1.jpg


Third request:
HTTP/1.1 200 OK
Accept-Ranges: bytes
Connection: keep-alive
Content-Length: 243553
Content-Type: image/jpeg
Date: Mon, 20 Jan 2025 03:53:31 GMT
ETag: "6788873d-3b761"
Last-Modified: Thu, 16 Jan 2025 04:12:45 GMT
Server: nginx/1.25.3
X-Cache-Status: HIT
X-Debug-Cache-Key: http://web-proxy/images/img1.jpg
```
```bash
docker-compose exec test sh /scripts/purge_image1.sh
```
```text
HTTP/1.1 200 OK
Connection: keep-alive
Content-Length: 173
Content-Type: text/html
Date: Mon, 20 Jan 2025 04:05:03 GMT
Server: nginx/1.25.3
X-Debug-Full-Uri: /purge/images/img1.jpg
X-Debug-Purge-Key: http://web-proxy/images/img1.jpg

<html><head><title>Successful purge</title></head><body bgcolor="white"><center><h1>Successful purge</h1><p>Key : http://web-proxy/images/img1.jpg</p></center></body></html>
```

Request the same resource soon after purging:
```bash
docker-compose exec test sh /scripts/test_web-proxy.sh
```
```text
First request:
HTTP/1.1 200 OK
Accept-Ranges: bytes
Connection: keep-alive
Content-Length: 243553
Content-Type: image/jpeg
Date: Mon, 20 Jan 2025 03:54:32 GMT
ETag: "6788873d-3b761"
Last-Modified: Thu, 16 Jan 2025 04:12:45 GMT
Server: nginx/1.25.3
X-Cache-Status: MISS
X-Debug-Cache-Key: http://web-proxy/images/img1.jpg


Second request:
HTTP/1.1 200 OK
Accept-Ranges: bytes
Connection: keep-alive
Content-Length: 243553
Content-Type: image/jpeg
Date: Mon, 20 Jan 2025 03:54:33 GMT
ETag: "6788873d-3b761"
Last-Modified: Thu, 16 Jan 2025 04:12:45 GMT
Server: nginx/1.25.3
X-Cache-Status: HIT
X-Debug-Cache-Key: http://web-proxy/images/img1.jpg


Third request:
HTTP/1.1 200 OK
Accept-Ranges: bytes
Connection: keep-alive
Content-Length: 243553
Content-Type: image/jpeg
Date: Mon, 20 Jan 2025 03:54:33 GMT
ETag: "6788873d-3b761"
Last-Modified: Thu, 16 Jan 2025 04:12:45 GMT
Server: nginx/1.25.3
X-Cache-Status: HIT
X-Debug-Cache-Key: http://web-proxy/images/img1.jpg
```
Note that MISS happened only once. This is because memory still contains the old counter event though there's no cached file on the disk.

```bash
docker-compose exec test sh /scripts/purge_image1.sh
```

After waiting more than 10s (cache parameter `inactive=10s`) we again see 2 misses:
```bash
docker-compose exec test sh /scripts/test_web-proxy.sh
```
```text
First request:
HTTP/1.1 200 OK
Accept-Ranges: bytes
Connection: keep-alive
Content-Length: 243553
Content-Type: image/jpeg
Date: Mon, 20 Jan 2025 03:55:11 GMT
ETag: "6788873d-3b761"
Last-Modified: Thu, 16 Jan 2025 04:12:45 GMT
Server: nginx/1.25.3
X-Cache-Status: MISS
X-Debug-Cache-Key: http://web-proxy/images/img1.jpg


Second request:
HTTP/1.1 200 OK
Accept-Ranges: bytes
Connection: keep-alive
Content-Length: 243553
Content-Type: image/jpeg
Date: Mon, 20 Jan 2025 03:55:11 GMT
ETag: "6788873d-3b761"
Last-Modified: Thu, 16 Jan 2025 04:12:45 GMT
Server: nginx/1.25.3
X-Cache-Status: MISS
X-Debug-Cache-Key: http://web-proxy/images/img1.jpg


Third request:
HTTP/1.1 200 OK
Accept-Ranges: bytes
Connection: keep-alive
Content-Length: 243553
Content-Type: image/jpeg
Date: Mon, 20 Jan 2025 03:55:12 GMT
ETag: "6788873d-3b761"
Last-Modified: Thu, 16 Jan 2025 04:12:45 GMT
Server: nginx/1.25.3
X-Cache-Status: HIT
X-Debug-Cache-Key: http://web-proxy/images/img1.jpg
```
