## HTTP 헤더 {#HTTPHeader}
CEK가 extension으로 분석된 사용자의 발화 정보를 보낼 때 HTTPS 요청을 사용합니다. 이때 HTTPS 요청 헤더는 다음과 같이 구성됩니다.

{% raw %}

```
POST /APIpath HTTP/1.1
Host: your.extension.endpoint
Content-Type: application/json;charset-UTF-8
Accept:  application/json
Accept-Charset : utf-8
```
{% endraw %}

* HTTP/1.1 버전으로 HTTPS 통신을 수행하며, method로 POST 방식을 사용합니다.
* Host와 요청 대상 path는 extension 개발자가 미리 정의해 둔 URI로 채워집니다.
* 본문의 데이터 형식은 JSON 포맷으로 되어 있으며, UTF-8 인코딩을 사용합니다.


이와 반대로 extension이 CEK로 처리 결과를 보낼 때 HTTPS 응답을 사용합니다. 이때 HTTPS 응답 헤더는 다음과 같이 기본적인 것만 구성하면 됩니다.
{% raw %}

```
HTTP/1.1 200 OK
Content-Type: application/json;charset-UTF-8
```
{% endraw %}
* CEK가 보낸 HTTPS 요청에 대한 응답으로 처리 결과를 전달합니다.
* 본문의 데이터 형식은 JSON 포맷으로 되어 있으며, UTF-8 인코딩을 사용합니다.

## HTTP 본문 {#HTTPBody}
HTTPS 요청 메시지와 응답 메시지의 본문은 JSON 포맷이며, 분석된 사용자의 발화 정보나 extension의 처리 결과가 담긴 정보입니다.
