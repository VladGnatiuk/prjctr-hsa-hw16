### UDP flood
![UDP flood](image.png)
- kali CPU is high
- Network load is equal for kali and nginx (126k packets / sec)
- Had to open UDP ports in docker image
- Limiting nginx container to 10% didn't make problem
- Seems like single machine can't make DDoS
