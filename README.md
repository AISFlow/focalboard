# focalboard

---

### ✅ `FOCALBOARD_` 환경변수 목록

| 환경변수 이름                          | 설명                                            | 기본값                             | 예시 값                        |
| -------------------------------------- | ----------------------------------------------- | ---------------------------------- | ------------------------------ |
| `FOCALBOARD_SERVERROOT`                | 서버 루트 URL                                   | `http://localhost:8000`            | `https://myboard.example.com`  |
| `FOCALBOARD_PORT`                      | 서버 포트                                       | `8000`                             | `8080`                         |
| `FOCALBOARD_DBTYPE`                    | 사용할 DB 종류 (`sqlite3`, `postgres`, `mysql`) | `sqlite3`                          | `postgres`                     |
| `FOCALBOARD_DBCONFIG`                  | DB 연결 문자열                                  | `./focalboard.db`                  | `postgres://user:pass@host/db` |
| `FOCALBOARD_DBPINGATTEMPTS`            | DB 연결 재시도 횟수                             | `5`                                | `10`                           |
| `FOCALBOARD_DBTABLEPREFIX`             | DB 테이블 prefix                                | `""`                               | `fb_`                          |
| `FOCALBOARD_USESSL`                    | HTTPS 사용 여부                                 | `false`                            | `true`                         |
| `FOCALBOARD_SECURECOOKIE`              | Secure 쿠키 설정                                | `false`                            | `true`                         |
| `FOCALBOARD_WEBPATH`                   | 정적 웹 자산 경로                               | `./pack`                           | `/app/static`                  |
| `FOCALBOARD_FILESDRIVER`               | 파일 저장 방식 (`local`, `amazons3`)            | `local`                            | `amazons3`                     |
| `FOCALBOARD_FILESPATH`                 | 로컬 파일 저장 경로                             | `./files`                          | `/mnt/data`                    |
| `FOCALBOARD_MAXFILESIZE`               | 업로드 최대 파일 크기 (바이트)                  | 제한 없음                          | `10485760` (10MB)              |
| `FOCALBOARD_TELEMETRY`                 | Telemetry 전송 여부                             | `true`                             | `false`                        |
| `FOCALBOARD_TELEMETRYID`               | Telemetry 식별 ID                               | `""`                               | `random-uuid`                  |
| `FOCALBOARD_PROMETHEUSADDRESS`         | Prometheus exporter 주소                        | `""`                               | `:9090`                        |
| `FOCALBOARD_SECRET`                    | 세션 암호화용 비밀 키                           | `""`                               | `some-secret-string`           |
| `FOCALBOARD_SESSION_EXPIRE_TIME`       | 세션 만료 시간 (초)                             | `2592000` (30일)                   | `86400`                        |
| `FOCALBOARD_SESSION_REFRESH_TIME`      | 세션 갱신 주기 (초)                             | `18000` (5시간)                    | `3600`                         |
| `FOCALBOARD_LOCALONLY`                 | 외부 접근 제한                                  | `false`                            | `true`                         |
| `FOCALBOARD_ENABLELOCALMODE`           | 로컬 모드 소켓 활성화                           | `false`                            | `true`                         |
| `FOCALBOARD_LOCALMODESOCKETLOCATION`   | 로컬 소켓 위치                                  | `/var/tmp/focalboard_local.socket` | `/tmp/fb.sock`                 |
| `FOCALBOARD_ENABLEPUBLICSHAREDBOARDS`  | 공개 링크로 보드 공유 허용                      | `false`                            | `true`                         |
| `FOCALBOARD_ENABLE_DATA_RETENTION`     | 데이터 자동 삭제 기능 활성화                    | `false`                            | `true`                         |
| `FOCALBOARD_DATA_RETENTION_DAYS`       | 데이터 보존 일수                                | `365`                              | `90`                           |
| `FOCALBOARD_AUTHMODE`                  | 인증 모드 (`native`, `ldap`, `sso` 등)          | `native`                           | `ldap`                         |
| `FOCALBOARD_NOTIFY_FREQ_CARD_SECONDS`  | 카드 수정 후 알림 주기 (초)                     | `120`                              | `300`                          |
| `FOCALBOARD_NOTIFY_FREQ_BOARD_SECONDS` | 보드 수정 후 알림 주기 (초)                     | `86400`                            | `43200`                        |

---

### 🔐 S3 관련 환경변수

| 환경변수 이름                              | 설명                   |
| ------------------------------------------ | ---------------------- |
| `FOCALBOARD_FILESDRIVER`                   | `amazons3`             |
| `FOCALBOARD_FILESS3CONFIG_ACCESSKEYID`     | S3 액세스 키 ID        |
| `FOCALBOARD_FILESS3CONFIG_SECRETACCESSKEY` | S3 시크릿 키           |
| `FOCALBOARD_FILESS3CONFIG_BUCKET`          | S3 버킷 이름           |
| `FOCALBOARD_FILESS3CONFIG_PATHPREFIX`      | 경로 prefix            |
| `FOCALBOARD_FILESS3CONFIG_REGION`          | S3 지역                |
| `FOCALBOARD_FILESS3CONFIG_ENDPOINT`        | S3 호환 endpoint       |
| `FOCALBOARD_FILESS3CONFIG_SSL`             | S3 SSL 사용 여부       |
| `FOCALBOARD_FILESS3CONFIG_SIGNV2`          | S3 SignV2 사용 여부    |
| `FOCALBOARD_FILESS3CONFIG_SSE`             | 서버 사이드 암호화     |
| `FOCALBOARD_FILESS3CONFIG_TRACE`           | 디버그 트레이스 활성화 |
| `FOCALBOARD_FILESS3CONFIG_TIMEOUT`         | S3 연결 타임아웃 (초)  |

---

### 🔐 DB 보안 관련 환경변수

| 환경변수 이름               | 설명                                 | 기본값    |
| --------------------------- | ------------------------------------ | --------- |
| `FOCALBOARD_DB_SSLMODE`     | PostgreSQL `sslmode`                 | `disable` |
| `FOCALBOARD_DB_SSLROOTCERT` | PostgreSQL `sslrootcert` 경로        | 없음      |
| `FOCALBOARD_DB_SSLCERT`     | PostgreSQL `sslcert` 경로            | 없음      |
| `FOCALBOARD_DB_SSLKEY`      | PostgreSQL `sslkey` 경로             | 없음      |
| `FOCALBOARD_DB_TLS`         | MySQL TLS 연결 모드 (`preferred`) 등 | `disable` |

> 💡 위 변수들은 내부적으로 `DBConfigString` 에 자동으로 병합됩니다.
