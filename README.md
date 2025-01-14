# verify-wiremock
WireMockの検証

# 起動方法

```
$ docker build -t verify-wiremock:test .
$ docker run -it -p 8888:8080 verify-wiremock:test

██     ██ ██ ██████  ███████ ███    ███  ██████   ██████ ██   ██
██     ██ ██ ██   ██ ██      ████  ████ ██    ██ ██      ██  ██
██  █  ██ ██ ██████  █████   ██ ████ ██ ██    ██ ██      █████
██ ███ ██ ██ ██   ██ ██      ██  ██  ██ ██    ██ ██      ██  ██
 ███ ███  ██ ██   ██ ███████ ██      ██  ██████   ██████ ██   ██

----------------------------------------------------------------
|               Cloud: https://wiremock.io/cloud               |
|                                                              |
|               Slack: https://slack.wiremock.org              |
----------------------------------------------------------------

version:                      3.10.0
port:                         8080
enable-browser-proxying:      false
disable-banner:               false
no-request-journal:           false
verbose:                      false

extensions:                   response-template,webhook

```

# 登録されているモックを確認する

http://localhost:8888/__admin/mappings

# 動作確認

RESTAPI(`/v1/test/{id}`)のモックが登録されている状態での動作検証

## モック登録されていないパスパラメーター

モックデータ: [mappings/2.json](https://github.com/shigihara-oisix/verify-wiremock/blob/main/mappings/2.json)

```
curl -X GET http://localhost:8888/v1/test/9999
{"name":"test-other","age":1}

```

## パスパラメータの完全一致

モックデータ: [mappings/3.json](https://github.com/shigihara-oisix/verify-wiremock/blob/main/mappings/3.json)

```
> curl -X GET http://localhost:8888/v1/test/1111
{"name":"test1111","age":1}
```

## パスパラメータの後方一致

モックデータ: [mappings/4.json](https://github.com/shigihara-oisix/verify-wiremock/blob/main/mappings/4.json)

```
> curl -X GET http://localhost:8888/v1/test/4441
{"name":"suffix-1","age":1}
```

## パスパラメータの内容をレスポンスボディに含める

モックデータ: [mappings/5.json](https://github.com/shigihara-oisix/verify-wiremock/blob/main/mappings/5.json)

```
> curl -X GET http://localhost:8888/v2/test/3331
{"name":"test1111","age":2,"id1":"/v2/test/3331","id2":"3331"}⏎


```
## リクエストボディの内容をレスポンスボディに含める

モックデータ: [mappings/6.json](https://github.com/shigihara-oisix/verify-wiremock/blob/main/mappings/6.json)

```
> curl -i -X POST -H "Content-Type:application/json"  -d \
'{
  "customerId": "000001",
  "id": "ABCD",
  "age": 1,
  "memo": "abcdefg"
}' 'http://localhost:8888/v2/submit'

HTTP/1.1 200 OK
Content-Type: application/json
Matched-Stub-Id: ba2bdf78-91f5-4c24-9135-9ebb6a5b3678
Transfer-Encoding: chunked

 {
      "name": "mock json file",
      "age": 1,
      "customerId": "000001",
      "id": "ABCD"
}

```




