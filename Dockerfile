FROM wiremock/wiremock:3.10.0-1

COPY __files/ /home/wiremock/__files/
COPY mappings/ /home/wiremock/mappings/
