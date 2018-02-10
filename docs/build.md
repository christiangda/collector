# how-to build

```
docker build --no-cache --rm \
  --tag christiangda/binary-collector:1.0.0 \
  --tag christiangda/binary-collector:latest .

docker run --tty --interactive --rm --name binary-collector \
  --publish 12345:12345 \
  christiangda/binary-collector:latest

docker push christiangda/binary-collector:latest 
```