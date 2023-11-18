---
title: 5t1. VPC Endpoint Gateway
---
VPC Endpoint에는 interface 타입과 gateway 타입이 있다. interface는 월 $7정도 비용이 나가지만 gateway는 비용이 들지 않음.

gateway는 s3와 dynamodb에만 사용 가능하다. VPC 내부의 ec2, lambda등에서 s3와 dynamod에 접근할 때 발생하는 NAT 트래픽 비용을 아껴줄 수 있으므로 기본으로 사용하는게 좋다.

### 참조

- https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/vpc-endpoints-dynamodb.html
- https://ngoyal16.medium.com/vpc-endpoints-or-nat-gateway-d78430b15b1e#:~:text=A%20Gateway%20Endpoints%20is%20free,services%20with%20a%20public%20API.