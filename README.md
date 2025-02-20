### UDP flood
```bash
docker exec -it kali /kali/scripts/udp_flood.sh
```
![UDP flood](image.png)
- kali CPU usage is much higher than nginx
- Network load is equal for kali and nginx (126k packets/sec)
- UDP ports were opened in docker image
- Limiting nginx container to 10% didn't make problem
- Seems like single machine can't make DDoS of this kind
